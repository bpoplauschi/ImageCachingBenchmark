//
//  BPViewController.m
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

#import "BPViewController.h"
#import <Masonry.h>
#import "BPNoCacheViewController.h"
#import "BPSDWebImageViewController.h"
#import "BPFastImageCacheViewController.h"
#import "BPAFNetworkingViewController.h"
#import "BPTMCacheViewController.h"


@interface BPViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *controllers;

@end


@implementation BPViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self setupTableView];
        
        BPNoCacheViewController *noCacheVC = [BPNoCacheViewController new];
        BPSDWebImageViewController *sdWebImageVC = [BPSDWebImageViewController new];
        BPFastImageCacheViewController *fastImageCacheVC = [BPFastImageCacheViewController new];
        BPAFNetworkingViewController *afNetworkingVC = [BPAFNetworkingViewController new];
        BPTMCacheViewController *tmCacheVC = [BPTMCacheViewController new];
        
        self.controllers = @[noCacheVC, sdWebImageVC, fastImageCacheVC, afNetworkingVC, tmCacheVC];
        
        self.title = @"Menu";
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    
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
    return [self.controllers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kBPCellID];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kBPCellID];
    }
    
    UIViewController *controller = nil;
    if (indexPath.row < self.controllers.count) {
        controller = self.controllers[indexPath.row];
    }
    
    NSString *className = NSStringFromClass([controller class]);
    
    if ([className hasPrefix:@"BP"]) {
        className = [className stringByReplacingCharactersInRange:NSMakeRange(0, 2) withString:@""];
    }
    
    if ([className hasSuffix:@"ViewController"]) {
        className = [className stringByReplacingOccurrencesOfString:@"ViewController" withString:@""];
    }
    
    cell.textLabel.text = className;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.controllers.count) {
        UIViewController *controller = self.controllers[indexPath.row];
        [self.navigationController pushViewController:controller animated:YES];
    }
    [tableView cellForRowAtIndexPath:indexPath].selected = NO;
}

@end
