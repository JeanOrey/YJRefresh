//
//  YJViewController.m
//  YJRefresh
//
//  Created by 517576002@qq.com on 01/13/2020.
//  Copyright (c) 2020 517576002@qq.com. All rights reserved.
//

#import "YJViewController.h"
#import <YJRefresh/UIScrollView+MJRefreshExtension.h>

@interface YJViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger count;
}
@property (nonatomic,retain) UITableView *tableView;
@end

@implementation YJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    __weak typeof(self) weakSelf = self;
    count = 10;
//    [self.tableView headerBeginRefreshWithPageIndexBlock:^(NSInteger pageIndex) {
//        count += 10;
//        [weakSelf.tableView reloadData];
//        [weakSelf.tableView refreshFinished];
//    }];
    [self.tableView gifHeaderBeginRefreshWithPageIndexBlock:^(NSInteger pageIndex) {
        count += 10;
        [weakSelf.tableView reloadData];
        [weakSelf.tableView refreshFinished];
    }];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGRect tableFrame = self.view.bounds;
    if (CGRectEqualToRect(tableFrame, self.tableView.frame)==NO) {
        self.tableView.frame = tableFrame;
    }
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return count;
}

-  (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"uitablecell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"---%ld",indexPath.row];
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
