//
//  BPSDWebImageViewController.m
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

#import "BPSDWebImageViewController.h"
#import <UIImageView+WebCache.h>


static CGFloat totalRetrieveTimeFromDisk        = 0.0f;
static NSInteger numberOfRetrievesFromDisk      = 0;

static CGFloat totalRetrieveTimeFromMemory      = 0.0f;
static NSInteger numberOfRetrievesFromMemory    = 0;

static CGFloat totalRetrieveTimeFromWeb         = 0.0f;
static NSInteger numberOfRetrievesFromWeb       = 0;

@interface BPSDWebImageViewController ()

@end


@implementation BPSDWebImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"SDWebImage";
    }
    return self;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BPTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kBPCellID];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%d %d", indexPath.section, indexPath.row];
    NSURL *url = [self imageUrlForIndexPath:indexPath];
    cell.imageUrl = url;
    cell.customImageView.image = nil;
    
    NSDate *initialDate = [NSDate date];
    [cell.customImageView setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        CGFloat retrieveTime = [[NSDate date] timeIntervalSinceDate:initialDate];
        
        switch (cacheType) {
            case SDImageCacheTypeNone:
                numberOfRetrievesFromWeb ++;
                totalRetrieveTimeFromWeb += retrieveTime;
                NSLog(@"[SDWebImage][Web] - retrieved image in %.4f seconds. Average is %.4f", retrieveTime, totalRetrieveTimeFromWeb/numberOfRetrievesFromWeb);
                break;
            case SDImageCacheTypeDisk:
                numberOfRetrievesFromDisk ++;
                totalRetrieveTimeFromDisk += retrieveTime;
                NSLog(@"[SDWebImage][Disk Cache] - retrieved image in %.4f seconds. Average is %.4f", retrieveTime, totalRetrieveTimeFromDisk/numberOfRetrievesFromDisk);
                break;
            case SDImageCacheTypeMemory:
                numberOfRetrievesFromMemory ++;
                totalRetrieveTimeFromMemory += retrieveTime;
                NSLog(@"[SDWebImage][Memory Cache] - retrieved image in %.4f seconds. Average is %.4f", retrieveTime, totalRetrieveTimeFromMemory/numberOfRetrievesFromMemory);
                break;
            default:
                break;
        }
    }];
    
    return cell;
}

@end
