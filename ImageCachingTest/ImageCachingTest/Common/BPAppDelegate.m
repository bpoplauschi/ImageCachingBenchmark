//
//  BPAppDelegate.m
//
//  Copyright (c) 2014 Bogdan Poplauschi
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

#import "BPAppDelegate.h"
#import "BPViewController.h"
#import <FICImageCache.h>
#import "AFNetworkActivityIndicatorManager.h"
#include <mach/mach.h>

CGFloat maxCPUUsage = 0;
CGFloat totalCPUUsage = 0;
int numberOfCPUCycles = 0;

CGFloat maxMemoryUsage = 0;
CGFloat totalMemoryUsage = 0;
int numberOfMemoryCycles = 0;

@interface BPAppDelegate () <FICImageCacheDelegate>

@property (nonatomic, strong) NSTimer *updateTimer;

@end


@implementation BPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    BPViewController *viewController = [[BPViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    [self configureCPUTracking];
    [self configureFastImageCache];
  //  [self configureAFNetworking];
    return YES;
}


-(void) configureAFNetworking{
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:0 * 1024 * 1024 diskCapacity:0 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
}






-(void)configureFastImageCache {
    FICImageFormat *mediumUserThumbnailImageFormat = [[FICImageFormat alloc] init];
    mediumUserThumbnailImageFormat.name = @"32BitBGR";
    mediumUserThumbnailImageFormat.family = @"Family";
    mediumUserThumbnailImageFormat.style = FICImageFormatStyle32BitBGR;
    mediumUserThumbnailImageFormat.imageSize = CGSizeMake(200, 200);
    mediumUserThumbnailImageFormat.maximumCount = 500;
    mediumUserThumbnailImageFormat.devices = FICImageFormatDevicePhone | FICImageFormatDevicePad;
    
    FICImageCache *sharedImageCache = [FICImageCache sharedImageCache];
    sharedImageCache.delegate = self;
    [sharedImageCache setFormats:@[mediumUserThumbnailImageFormat]];
}

- (void)configureCPUTracking {
    self.updateTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                        target:self
                                                      selector:@selector(updateInfo:)
                                                      userInfo:nil
                                                       repeats:YES];
}

- (void)updateInfo:(NSTimer *)inTimer {
    CGFloat cpuUsage = cpu_usage();
    if (cpuUsage) {
        numberOfCPUCycles++;
        totalCPUUsage += cpuUsage;
        
        if (cpuUsage > maxCPUUsage) {
            maxCPUUsage = cpuUsage;
        }
        
      //  NSLog(@"* CPU Usage: %.4f, average %.4f, max %.4f", cpuUsage, totalCPUUsage/numberOfCPUCycles, maxCPUUsage);
    }
    
    CGFloat memoryUsage = memory_usage_in_megabytes();
    if (memoryUsage) {
        numberOfMemoryCycles++;
        totalMemoryUsage += memoryUsage;
        
        if (memoryUsage > maxMemoryUsage) {
            maxMemoryUsage = memoryUsage;
        }
        
       // NSLog(@"* Memory Usage: %.4F, average %.4f, max %.4f", memoryUsage, totalMemoryUsage/numberOfMemoryCycles, maxMemoryUsage);
    }
}

// from http://www.g8production.com/post/68155681673/get-cpu-usage-in-ios
float cpu_usage() {
    kern_return_t kr;
    task_info_data_t tinfo;
    mach_msg_type_number_t task_info_count;
    
    task_info_count = TASK_INFO_MAX;
    kr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    
    task_basic_info_t      basic_info;
    thread_array_t         thread_list;
    mach_msg_type_number_t thread_count;
    
    thread_info_data_t     thinfo;
    mach_msg_type_number_t thread_info_count;
    
    thread_basic_info_t basic_info_th;
    uint32_t stat_thread = 0;
    
    basic_info = (task_basic_info_t)tinfo;
    
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS) {
        return -1;
    }
    if (thread_count > 0)
        stat_thread += thread_count;
    
    long tot_sec = 0;
    long tot_usec = 0;
    float tot_cpu = 0;
    int j;
    
    for (j = 0; j < thread_count; j++)
    {
        thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[j], THREAD_BASIC_INFO,
                         (thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS) {
            return -1;
        }
        
        basic_info_th = (thread_basic_info_t)thinfo;
        
        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
            tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
            tot_usec = tot_usec + basic_info_th->system_time.microseconds + basic_info_th->system_time.microseconds;
            tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE * 100.0;
        }
        
    }
    
    kr = vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    assert(kr == KERN_SUCCESS);
    
    return tot_cpu;
}

// http://stackoverflow.com/questions/787160/programmatically-retrieve-memory-usage-on-iphone
CGFloat memory_usage_in_megabytes() {
    struct task_basic_info info;
    mach_msg_type_number_t size = sizeof(info);
    kern_return_t kerr = task_info(mach_task_self(),
                                   TASK_BASIC_INFO,
                                   (task_info_t)&info,
                                   &size);
    if( kerr == KERN_SUCCESS ) {
        return info.resident_size / (1024 * 1024);
    } else {
        NSLog(@"Error with task_info(): %s", mach_error_string(kerr));
    }
    return 0;
}

#pragma mark FICImageCacheDelegate
- (void)imageCache:(FICImageCache *)imageCache wantsSourceImageForEntity:(id<FICEntity>)entity withFormatName:(NSString *)formatName completionBlock:(FICImageRequestCompletionBlock)completionBlock {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Fetch the desired source image by making a network request
        NSURL *requestURL = [entity sourceImageURLWithFormatName:formatName];
        UIImage *sourceImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:requestURL]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(sourceImage);
        });
    });
}

@end
