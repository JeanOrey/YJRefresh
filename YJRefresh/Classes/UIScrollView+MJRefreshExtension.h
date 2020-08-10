//
//  UIScrollView+MJRefreshExtension.h
//  YJRefresh
//
//  Created by apple on 2019/9/16.
//  Copyright © 2019 Jean. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (MJRefreshExtension)
/* 每页数据条数 */
@property (nonatomic,assign) NSInteger pageSize;
@property (nonatomic,assign) BOOL headerRefreshing;
@property (nonatomic,assign) BOOL footerRefreshing;
/* 外部数据返回时赋值，不然无法计算是否还能上拉加载 */
@property (nonatomic,assign) NSInteger currentSize;

/**
 ! 设置开始下标
 */
- (void)setStartIndex:(NSInteger)index;

/**
 ! 下拉刷新
 */
- (void)headerBeginRefreshWithPageIndexBlock:(void(^)(NSInteger pageIndex))headerBlock;
/**
 ! 带Gif 下拉
 */
- (void)gifHeaderBeginRefreshWithPageIndexBlock:(void(^)(NSInteger pageIndex))headerBlock;

/**
 ! 上拉加载
 */
- (void)footerBeginRefreshWithAutomaticallyRefresh:(BOOL)automatically footerBlock:(void(^)(NSInteger pageIndex))footerBlock;
/**
 ! 带Gif 上拉
 */
- (void)gifFooterBeginRefreshWithPageIndexBlock:(void(^)(NSInteger pageIndex))footerBlock;

/**
 ! 开始刷新
 */
- (void)beginRefresh;

/**
 ! 结束所有的刷新类型
 */
- (void)refreshFinished;

/**
 ! 刷新失败
 */
- (void)faliedToRefresh;

@end

NS_ASSUME_NONNULL_END
