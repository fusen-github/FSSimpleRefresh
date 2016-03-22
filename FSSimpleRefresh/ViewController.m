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

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.dataArray = [NSMutableArray array];
    
    [self setupTableView];
    
//    [self setupRefreshHeader];
    
    [self setupRefreshFooter];
    
}

- (void)setupRefreshFooter
{
    FSRefreshFooter *footer = [FSRefreshFooter footerWithScrollView:self.tableView];
    
    self.footer = footer;
    
    __weak typeof(self) weakSelf = self;
    
    [footer beginRefreshWithFooterBlock:^{
       
        [weakSelf requestData];
        
    }];
}

- (void)setupRefreshHeader
{
    __block FSRefreshHeader *header = [FSRefreshHeader headerWithScrollView:self.tableView];
    
    self.header = header;
    
     __weak typeof(self) weakSelf = self;
    
    [header beginRefreshWithHeaderBlock:^{
       
        [weakSelf requestData];
        
    }];
    
    [header beginRefreshWhenViewWillAppear];
}


- (void)requestData
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            
//            
//            
//        });
        
        [NSThread sleepForTimeInterval:5];
        
        for (int i = 0; i < 5; i++)
        {
            [self.dataArray addObject:@"fusen"];
        }
        
        dispatch_sync(dispatch_get_main_queue(), ^{
           
            [self.tableView reloadData];
            
            [self.header endHeaderRefreshing];
            
            [self.footer endFooterRefreshing];
        });
        
    });
    
    
    
    
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
    return self.dataArray.count;
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
