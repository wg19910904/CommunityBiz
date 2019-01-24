//
//  UITableView+XHTool.h
//  JHRoomServiceStaff
//
//  Created by xixixi on 2017/10/11.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MJRefresh.h>

@interface UITableView (XHTool)
//添加一个背景属性
@property(nonatomic,strong)UIView *bgView;

//展示没有订单
- (void)showNoOrder;
//展示数据
- (void)showData;
//展示没有数据
- (void)showNoData;
//展示断网
- (void)showNoInternet;
//展示未认证
- (void)showNoVerify;

//绑定下拉刷新
- (void)downToRefreshWithBlock:(MJRefreshComponentRefreshingBlock) downAction;
//绑定上拉加载
- (void)upToLoadWithBlock:(MJRefreshComponentRefreshingBlock) upAtion;

@end
