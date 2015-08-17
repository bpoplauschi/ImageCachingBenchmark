//
//  BPImagesTableViewController.m
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

#import "BPImagesTableViewController.h"
#import "FICDTableView.h"
#import <Masonry.h>
#import "BPFullScreenImageViewController.h"


NSString *kBPCellID = @"cellID";

CGFloat totalRetrieveDuration[3];
CGFloat minRetrieveDuration[3];
CGFloat maxRetrieveDuration[3];
int     numberOfRetrieves[3];

@interface BPImagesTableViewController ()

@end


@implementation BPImagesTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        totalRetrieveDuration[0] = 0;
        totalRetrieveDuration[1] = 0;
        totalRetrieveDuration[2] = 0;
        
        minRetrieveDuration[0] = 0;
        minRetrieveDuration[1] = 0;
        minRetrieveDuration[2] = 0;
        
        maxRetrieveDuration[0] = 0;
        maxRetrieveDuration[1] = 0;
        maxRetrieveDuration[2] = 0;
        
        minRetrieveDuration[0] = UINT16_MAX;
        minRetrieveDuration[1] = UINT16_MAX;
        minRetrieveDuration[2] = UINT16_MAX;
    }
    return self;
}

- (NSURL*)imageUrlForIndexPath:(NSIndexPath *)inIndexPath {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://s3.amazonaws.com/fast-image-cache/demo-images/FICDDemoImage%03ld.jpg", (long)inIndexPath.row]];
        return url;
}

- (void)trackRetrieveDuration:(CGFloat)inDuration forCacheType:(BPCacheType)inCacheType {
    numberOfRetrieves[inCacheType] ++;
    totalRetrieveDuration[inCacheType] +=inDuration;
    
    if (inDuration < minRetrieveDuration[inCacheType]) {
        minRetrieveDuration[inCacheType] = inDuration;
    }
    
    if (inDuration > maxRetrieveDuration[inCacheType]) {
        maxRetrieveDuration[inCacheType] = inDuration;
    }
    
    NSString *cacheTypeString = nil;
    switch (inCacheType) {
        case BPCacheTypeNone:
            cacheTypeString = @"Web";
            break;
        case BPCacheTypeMemory:
            cacheTypeString = @"Memory";
            break;
        case BPCacheTypeDisk:
            cacheTypeString = @"Disk";
            break;
    }
    
    NSLog(@"[%@][%@] retrieved in %.4f, average %.4f, min %.4f, max %.4f",
          self.title,
          cacheTypeString,
          inDuration,
          totalRetrieveDuration[inCacheType] / numberOfRetrieves[inCacheType],
          minRetrieveDuration[inCacheType],
          maxRetrieveDuration[inCacheType]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self setupTableView];
}

- (void)setupTableView {
    self.tableView = [[FICDTableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    
    [self.tableView registerClass:[BPTableViewCell class] forCellReuseIdentifier:kBPCellID];
    
    self.tableView.backgroundView = nil;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view.mas_width);
        make.height.equalTo(self.view.mas_height);
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
    }];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BPTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kBPCellID];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld %ld", (long)indexPath.section, (long)indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BPTableViewCell *cell = (BPTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.customImageView.image) {
        BPFullScreenImageViewController *fullScreenImageVC = [[BPFullScreenImageViewController alloc] initWithImage:cell.customImageView.image];
        [self.navigationController pushViewController:fullScreenImageVC animated:YES];
    }
    cell.selected = NO;
}

@end
