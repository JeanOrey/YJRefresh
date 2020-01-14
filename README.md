# YJRefresh

[![CI Status](https://img.shields.io/travis/JeanOrey_302941048@163.com/YJRefresh.svg?style=flat)](https://travis-ci.org/JeanOrey_302941048@163.com/YJRefresh)
[![Version](https://img.shields.io/cocoapods/v/YJRefresh.svg?style=flat)](https://cocoapods.org/pods/YJRefresh)
[![License](https://img.shields.io/cocoapods/l/YJRefresh.svg?style=flat)](https://cocoapods.org/pods/YJRefresh)
[![Platform](https://img.shields.io/cocoapods/p/YJRefresh.svg?style=flat)](https://cocoapods.org/pods/YJRefresh)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

YJRefresh is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'YJRefresh'
```

## Author

JeanOrey, JeanOrey_302941048@163.com

## License

YJRefresh is available under the MIT license. See the LICENSE file for more info.
# YJRefresh

# 事例
##  引用
#import "UIScrollView+MJRefreshExtension.h"

## 设置每页条数
self.tableView.pageSize = 10;//此时设置的是每页10条数据

## 下拉刷新

[self.tableView gifHeaderBeginRefreshWithPageIndexBlock:^(NSInteger pageIndex) {
### 网络请求,默认pageNo从1开始
    [self fetchData:pageIndex];
}];

## 上拉加载

[self.tableView gifFooterBeginRefreshWithPageIndexBlock:^(NSInteger pageIndex) {
 ### 网络请求,默认pageNo从1开始       
        [self fetchData:pageIndex];
}];

## 开始刷新 

[self.tableView beginRefresh];

## 结束刷新

[self.tableView refreshFinished];

## ⚠️ 注意 在结束刷新前赋值当次请求的数据条数，方便内部计算是否允许上拉加载

[self.tableView setCurrentSize:data.count];//data.count 为当前数据条数，假如当前请求数据条数为5，则data.count替换为5


