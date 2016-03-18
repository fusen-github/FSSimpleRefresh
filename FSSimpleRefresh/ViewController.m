//
//  ViewController.m
//  FSSimpleRefresh
//
//  Created by 四维图新 on 16/3/15.
//  Copyright © 2016年 四维图新. All rights reserved.
//

#import "ViewController.h"
#import "FSRefreshFooter.h"
#import "FSRefreshHeader.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, strong) FSRefreshHeader *header;

@property (nonatomic, strong) FSRefreshFooter *footer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupTableView];
    
    [self setupRefreshHeader];
    
    [self setupRefreshFooter];
    
}

- (void)setupRefreshFooter
{
    FSRefreshFooter *footer = [FSRefreshFooter footerWithScrollView:self.tableView];
    
    self.footer = footer;
    
    [footer beginRefreshWithFooterBlock:^{
       
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            NSLog(@"完了");
            
            [footer endFooterRefreshing];
            
        });
        
    }];
}

- (void)setupRefreshHeader
{
    __block FSRefreshHeader *header = [FSRefreshHeader headerWithScrollView:self.tableView];
    
    self.header = header;
    
    [header beginRefreshWithHeaderBlock:^{
       
        NSLog(@"请求网络。。");
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            NSLog(@"请求结束...");
            
            [self.header endHeaderRefreshing];
        });
    }];
    
    [header beginRefreshWhenViewWillAppear];
}


- (void)setupTableView
{
    UITableView *tableView = [[UITableView alloc] init];
    
    self.tableView = tableView;
    
    tableView.frame = self.view.frame;
    
    tableView.delegate = self;
    
    tableView.dataSource = self;
    
    [self.view addSubview:tableView];
    
    tableView.tableFooterView = [UIView new];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"fs--%ld",indexPath.row+1];
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"%lf",scrollView.contentOffset.y);
}

@end
