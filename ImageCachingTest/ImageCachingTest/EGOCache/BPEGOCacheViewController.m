//
//  BPFastImageCacheViewController.m
//
//  Copyright (c) 2015 Wangjiawei
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


#import "BPEGOCacheViewController.h"
#import "EGOCache.h"

@implementation BPEGOCacheViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"EGOCache";
    }
    return self;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BPTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kBPCellID];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld %ld", (long)indexPath.section, (long)indexPath.row];
    NSURL *url = [self imageUrlForIndexPath:indexPath];
    cell.imageUrl = url;
    cell.customImageView.image = nil;
    NSDate *initialDate = [NSDate date];
    __weak typeof(cell)weakCell = cell;
    NSString* URL = [NSString stringWithFormat:@"%@",url];
    UIImage* image = [UIImage imageWithData:[[EGOCache globalCache] dataForKey:URL]];
    __strong __typeof(weakCell)strongCell = weakCell;
    
    if(image){
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([strongCell.imageUrl isEqual:url]) {
                strongCell.customImageView.image = image;
                CGFloat retrieveTime = [[NSDate date] timeIntervalSinceDate:initialDate];
                [self trackRetrieveDuration:retrieveTime forCacheType:BPCacheTypeMemory];
            }
        });
    }
    else{
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
         UIImage *sourceImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
            __strong typeof(weakCell)strongCell = weakCell;
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([strongCell.imageUrl isEqual:url]) {
                strongCell.customImageView.image = sourceImage;
                CGFloat retrieveTime = [[NSDate date] timeIntervalSinceDate:initialDate];
                [self trackRetrieveDuration:retrieveTime forCacheType:BPCacheTypeNone];
            }
            [[EGOCache globalCache] setData:UIImagePNGRepresentation(sourceImage) forKey:URL withTimeoutInterval:604800];
        });
        });
    }
    return cell;
}
@end