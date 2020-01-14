//
//  UIScrollView+MJRefreshExtension.m
//  RefreshTool
//
//  Created by apple on 2019/9/16.
//  Copyright © 2019 Jean. All rights reserved.
//

#import "UIScrollView+MJRefreshExtension.h"
#import <objc/runtime.h>
#import <MJRefresh/MJRefresh.h>
#import "YJRefreshHeader.h"
#import "YJRefreshFooter.h"

#define StartIndex     1
typedef void (^HeaderRefreshBlock) (NSInteger pageIndex);
typedef void (^FooterRefreshBlock) (NSInteger pageIndex);

@interface UIScrollView()
/* 当前页码 */
@property (nonatomic,assign) NSInteger pageIndex;
/* 下拉回调 */
@property (nonatomic,copy) HeaderRefreshBlock headerBlock;
/* 上拉回调 */
@property (nonatomic,copy) FooterRefreshBlock footerBlock;
@end

@implementation UIScrollView (MJRefreshExtension)

#pragma mark - public methods

/**
 ! 下拉刷新
 */
- (void)headerBeginRefreshWithPageIndexBlock:(void(^)(NSInteger pageIndex))headerBlock
{
    __weak typeof(self) weakSelf = self;
    self.headerBlock = headerBlock;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.footerRefreshing = NO;
        weakSelf.headerRefreshing = self.mj_header.isRefreshing;
        weakSelf.pageIndex = StartIndex;
        if (weakSelf.headerBlock) {
            weakSelf.headerBlock(weakSelf.pageIndex);
        }
    }];

    self.mj_header = header;
}

/**
 ! 带Gif 下拉
 */
- (void)gifHeaderBeginRefreshWithPageIndexBlock:(void(^)(NSInteger pageIndex))headerBlock
{
    __weak typeof(self) weakSelf = self;
    self.headerBlock = headerBlock;
    YJRefreshHeader *header = [YJRefreshHeader headerWithRefreshingBlock:^{
        weakSelf.footerRefreshing = NO;
        weakSelf.headerRefreshing = self.mj_header.isRefreshing;
        weakSelf.pageIndex = StartIndex;
        if (weakSelf.headerBlock) {
            weakSelf.headerBlock(weakSelf.pageIndex);
        }
    }];
    
    self.mj_header = header;
}

/**
 ! 上拉加载
 */
- (void)footerBeginRefreshWithAutomaticallyRefresh:(BOOL)automatically footerBlock:(void(^)(NSInteger pageIndex))footerBlock
{
    __weak typeof(self) weakSelf = self;
    self.footerBlock = footerBlock;
    
    if (automatically) {
        /* 自动刷新 */
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            weakSelf.headerRefreshing = NO;
            weakSelf.footerRefreshing = self.mj_footer.isRefreshing;
            weakSelf.pageIndex += 1;
            if (weakSelf.footerBlock) {
                weakSelf.footerBlock(weakSelf.pageIndex);
            }
        }];
        
        footer.automaticallyRefresh = automatically;
        
        footer.stateLabel.font = [UIFont systemFontOfSize:13.0];
        footer.stateLabel.textColor = [UIColor colorWithWhite:0.400 alpha:1];
        [footer setTitle:@"loading" forState:MJRefreshStateRefreshing];
        [footer setTitle:@"refresh_no_data" forState:MJRefreshStateNoMoreData];
        
        self.mj_footer = footer;
    } else {
        /* 回弹到底部 */
        MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            weakSelf.headerRefreshing = NO;
            weakSelf.footerRefreshing = self.mj_footer.isRefreshing;
            weakSelf.pageIndex += 1;
            if (weakSelf.footerBlock) {
                weakSelf.footerBlock(weakSelf.pageIndex);
            }
        }];
        
        footer.stateLabel.font = [UIFont systemFontOfSize:13.0];
        footer.stateLabel.textColor = [UIColor colorWithWhite:0.400 alpha:1];
        [footer setTitle:@"loading" forState:MJRefreshStateRefreshing];
        [footer setTitle:@"No data" forState:MJRefreshStateNoMoreData];
        
        self.mj_footer = footer;
    }
}

/**
 ! 带Gif 上拉
 */
- (void)gifFooterBeginRefreshWithPageIndexBlock:(void(^)(NSInteger pageIndex))footerBlock
{
    __weak typeof(self) weakSelf = self;
    self.footerBlock = footerBlock;
    YJRefreshFooter *footer = [YJRefreshFooter footerWithRefreshingBlock:^{
        weakSelf.headerRefreshing = NO;
        weakSelf.footerRefreshing = self.mj_footer.isRefreshing;
        weakSelf.pageIndex += 1;
        if (weakSelf.footerBlock) {
            weakSelf.footerBlock(weakSelf.pageIndex);
        }
    }];
    self.mj_footer = footer;
}

/**
 ! 刷新失败
 */
- (void)faliedToRefresh
{
    if (self.footerRefreshing) {
        [self.mj_footer endRefreshing];
        self.pageIndex = self.pageIndex - 1;
    } else{
        [self.mj_header endRefreshing];
    }
}
 
/**
 ! 结束所有的刷新类型
 */
- (void)refreshFinished
{
    if (self.headerRefreshing) {
        /* 头部刷新 */
        [self endHeaderRefresh];
        NSInteger itemsCount = self.currentSize;
        if (itemsCount==0) {
            //无数据，不显示footer提示
            self.mj_footer = nil;
        } else if (itemsCount<self.pageSize) {
            //第一包数据未超过指定包数，不允许上拉
            [self endFooterWithNoData];
        }
    }else {
        /* 尾部刷新 */
        NSInteger itemsCount = self.currentSize;
        if (itemsCount<self.pageSize) {
            //已加载完所有数据
            [self endFooterWithNoData];
        }else {
            //有可能还有未加载的数据
            [self.mj_footer endRefreshing];
        }
    }
}

- (void)beginRefresh
{
    [self.mj_header beginRefreshing];
}

#pragma mark - private methods

- (void)endHeaderRefresh
{
    [self.mj_header endRefreshing];
    [self resetNoMoreData];
}

-  (void)endFooterWithNoData
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.mj_footer endRefreshingWithNoMoreData];
    });
}

- (void)resetNoMoreData
{
    [self.mj_footer resetNoMoreData];
}

#pragma mark - runtime 实现属性set & get 方法

/**
 ! 当前页码
 */
static void *pageIndexKey = &pageIndexKey;
- (void)setPageIndex:(NSInteger)pageIndex
{
    objc_setAssociatedObject(self, &pageIndexKey, @(pageIndex), OBJC_ASSOCIATION_ASSIGN);
}

- (NSInteger)pageIndex
{
    return [objc_getAssociatedObject(self, &pageIndexKey) integerValue];
}

/**
 ! 每页条数
 */
static void *pageSizeKey = &pageSizeKey;
- (void)setPageSize:(NSInteger)pageSize
{
    objc_setAssociatedObject(self, &pageSizeKey, @(pageSize), OBJC_ASSOCIATION_ASSIGN);
}

- (NSInteger)pageSize
{
    return [objc_getAssociatedObject(self, &pageSizeKey) integerValue];
}

/**
 ! 头部刷新中
 */
static void *headerRefreshKey = &headerRefreshKey;
- (void)setHeaderRefreshing:(BOOL)headerRefreshing
{
    objc_setAssociatedObject(self, &headerRefreshKey, @(headerRefreshing), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)headerRefreshing
{
    return [objc_getAssociatedObject(self, &headerRefreshKey) boolValue];
}

/**
 ! 尾部刷新中
 */
static void *footerRefreshKey = &footerRefreshKey;
- (void)setFooterRefreshing:(BOOL)footerRefreshing
{
    objc_setAssociatedObject(self, &footerRefreshKey, @(footerRefreshing), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)footerRefreshing
{
    return [objc_getAssociatedObject(self, &footerRefreshKey) boolValue];
}

/**
 ! 当前请求数据实际条数
 */
static void *currentNumberKey = &currentNumberKey;
- (void)setCurrentSize:(NSInteger)currentSize
{
    objc_setAssociatedObject(self, &currentNumberKey, @(currentSize), OBJC_ASSOCIATION_ASSIGN);
}

- (NSInteger)currentSize
{
    return [objc_getAssociatedObject(self, &currentNumberKey) integerValue];
}

/**
 ! 下拉回调
 */
static void *headerBlockKey = &headerBlockKey;
- (void)setHeaderBlock:(HeaderRefreshBlock)headerBlock
{
    objc_setAssociatedObject(self, &headerBlockKey, headerBlock, OBJC_ASSOCIATION_COPY);
}

- (HeaderRefreshBlock)headerBlock
{
    return objc_getAssociatedObject(self, &headerBlockKey);
}

/**
 ! 上拉回调
 */
static void *footerBlockKey = &footerBlockKey;
- (void)setFooterBlock:(FooterRefreshBlock)footerBlock
{
    objc_setAssociatedObject(self, &footerBlockKey, footerBlock, OBJC_ASSOCIATION_COPY);
}

- (FooterRefreshBlock)footerBlock
{
    return objc_getAssociatedObject(self, &footerBlockKey);
}

@end
