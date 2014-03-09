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

@interface BPAppDelegate () <FICImageCacheDelegate>

@end


@implementation BPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    BPViewController *viewController = [[BPViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    
    [self configureFastImageCache];
    
    return YES;
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
