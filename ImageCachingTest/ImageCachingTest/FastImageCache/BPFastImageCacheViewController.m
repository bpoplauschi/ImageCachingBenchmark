//
//  BPFastImageCacheViewController.m
//  ImageCachingTest
//
//  Created by Bogdan on 09/03/14.
//  Copyright (c) 2014 bpoplauschi. All rights reserved.
//

#import "BPFastImageCacheViewController.h"
#import "BPTableViewCell.h"
#import "FICDPhoto.h"
#import <FICImageCache.h>


static CGFloat totalRetrieveTimeFromWeb        = 0.0f;
static NSInteger numberOfRetrievesFromWeb      = 0;

static CGFloat totalRetrieveTimeFromCache      = 0.0f;
static NSInteger numberOfRetrievesFromCache    = 0;


@interface BPFastImageCacheViewController ()

@end


@implementation BPFastImageCacheViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"FastImageCache";
    }
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BPTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kBPCellID];
    cell.textLabel.text = [NSString stringWithFormat:@"%d %d", indexPath.section, indexPath.row];
    NSURL *url = [self imageUrlForIndexPath:indexPath];
    cell.imageUrl = url;
    cell.customImageView.image = nil;
    
    FICDPhoto *photo = [[FICDPhoto alloc] init];
    
    [photo setSourceImageURL:url];
    
    NSDate *initialDate = [NSDate date];
    __weak typeof(cell)weakCell = cell;
    [[FICImageCache sharedImageCache] asynchronouslyRetrieveImageForEntity:photo withFormatName:@"32BitBGR" completionBlock:^(id<FICEntity> entity, NSString *formatName, UIImage *image, FICCacheType cacheType) {
        __strong __typeof(weakCell)strongCell = weakCell;
        if ([strongCell.imageUrl isEqual:url]) {
            strongCell.customImageView.image = image;
            
            CGFloat retrieveTime = [[NSDate date] timeIntervalSinceDate:initialDate];
            
            switch (cacheType) {
                case FICCacheTypeNone:
                    numberOfRetrievesFromWeb ++;
                    totalRetrieveTimeFromWeb += retrieveTime;
                    NSLog(@"[FastImageCache][Web] - retrieved image in %.4f seconds. Average is %.4f", retrieveTime, totalRetrieveTimeFromWeb/numberOfRetrievesFromWeb);
                    break;
                case FICCacheTypeCache:
                    numberOfRetrievesFromCache ++;
                    totalRetrieveTimeFromCache += retrieveTime;
                    NSLog(@"[FastImageCache][Disk Cache] - retrieved image in %.4f seconds. Average is %.4f", retrieveTime, totalRetrieveTimeFromCache/numberOfRetrievesFromCache);
                    break;
                default:
                    break;
            }
        }
    }];
    
    return cell;
}


@end
