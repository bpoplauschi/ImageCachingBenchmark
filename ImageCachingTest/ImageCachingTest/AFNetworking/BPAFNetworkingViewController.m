//
//  BPAFNetworkingViewController.m
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

#import "BPAFNetworkingViewController.h"
#import <UIImageView+AFNetworking.h>


static CGFloat totalRetrieveTimeFromWeb        = 0.0f;
static NSInteger numberOfRetrievesFromWeb      = 0;

static CGFloat totalRetrieveTimeFromCache      = 0.0f;
static NSInteger numberOfRetrievesFromCache    = 0;


@interface BPAFNetworkingViewController ()

@end

@implementation BPAFNetworkingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"AFNetworking";
    }
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BPTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kBPCellID];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%d %d", indexPath.section, indexPath.row];
    NSURL *url = [self imageUrlForIndexPath:indexPath];
    cell.imageUrl = url;
    cell.customImageView.image = nil;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    
    NSDate *initialDate = [NSDate date];
    __weak typeof(cell)weakCell = cell;
    [cell.customImageView setImageWithURLRequest:request
                                placeholderImage:nil
                                         success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                             __strong __typeof(weakCell)strongCell = weakCell;
                                             if ([strongCell.imageUrl isEqual:url]) {
                                                 strongCell.customImageView.image = image;
                                             
                                                 CGFloat retrieveTime = [[NSDate date] timeIntervalSinceDate:initialDate];
                                                 
                                                 if (!request && !response) {
                                                     // cache
                                                     numberOfRetrievesFromCache ++;
                                                     totalRetrieveTimeFromCache += retrieveTime;
                                                     NSLog(@"[AFNetworking][Disk Cache] - retrieved image in %.4f seconds. Average is %.4f", retrieveTime, totalRetrieveTimeFromCache/numberOfRetrievesFromCache);
                                                 } else {
                                                     // web
                                                     numberOfRetrievesFromWeb ++;
                                                     totalRetrieveTimeFromWeb += retrieveTime;
                                                     NSLog(@"[AFNetworking][Web] - retrieved image in %.4f seconds. Average is %.4f", retrieveTime, totalRetrieveTimeFromWeb/numberOfRetrievesFromWeb);
                                                 }
                                             }
                                         }
                                         failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                             // ignore failure for benchmark
                                         }];
    return cell;
}

@end
