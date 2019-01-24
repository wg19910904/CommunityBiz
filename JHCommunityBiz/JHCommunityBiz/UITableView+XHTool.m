//
//  UITableView+XHTool.m
//  JHRoomServiceStaff
//
//  Created by xixixi on 2017/10/11.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "UITableView+XHTool.h"
#import <objc/runtime.h>

static char UITableView_XHTool_bgView;

@implementation UITableView (XHTool)

//适配iOS11
+(void)load{
    Method systemMethod = class_getInstanceMethod(self, @selector(initWithFrame:style:));
    Method customMethod = class_getInstanceMethod(self, @selector(xh_initWithFrame:style:));
    method_exchangeImplementations(systemMethod, customMethod);
}

- (instancetype)xh_initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    UITableView *table = [self xh_initWithFrame:frame style:style];
    if (@available(iOS 11.0, *)) {
        table.estimatedRowHeight = 0;
        table.estimatedSectionHeaderHeight = 0;
        table.estimatedSectionFooterHeight = 0;
        
    }else{
        
        
    }
    return table;
}

//添加背景属性
- (UIView *)bgView{
    return objc_getAssociatedObject(self, &UITableView_XHTool_bgView);
}

-(void)setBgView:(UIView *)bgView{
    objc_setAssociatedObject(self, &UITableView_XHTool_bgView, bgView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showData{
    [self.bgView removeFromSuperview];
    self.bgView = nil;
}
//展示没有订单
- (void)showNoOrder{
    [self.bgView removeFromSuperview];
    self.bgView = nil;
    self.bgView = [[UIView alloc] initWithFrame:self.bounds];
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(self.center.x-87, 132, 174, 148)];
    imgV.image = [UIImage imageNamed:@"icon_none_order"];
    UILabel *textL = [[UILabel alloc] initWithFrame:CGRectMake(self.center.x-150, 300, 300, 20)];
    textL.font = FONT(16);
    textL.text = NSLocalizedString(@"暂时没有订单", nil);
    textL.textColor = HEX(@"333333", 1.0);
    textL.textAlignment = NSTextAlignmentCenter;
    [self.bgView addSubview:imgV];
    [self.bgView addSubview:textL];
    [self addSubview:self.bgView];
}

//展示没有数据
- (void)showNoData{
    [self.bgView removeFromSuperview];
    self.bgView = nil;
    self.bgView = [[UIView alloc] initWithFrame:self.bounds];
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(self.center.x-87, 132, 174, 148)];
    imgV.image = [UIImage imageNamed:@"icon_none_msg"];
    UILabel *textL = [[UILabel alloc] initWithFrame:CGRectMake(self.center.x-150, 300, 300, 20)];
    textL.font = FONT(16);
    textL.text = NSLocalizedString(@"无数据", nil);
    textL.textColor = HEX(@"333333", 1.0);
    textL.textAlignment = NSTextAlignmentCenter;
    [self.bgView addSubview:imgV];
    [self.bgView addSubview:textL];
    [self addSubview:self.bgView];
}

//展示断网
- (void)showNoInternet{
    [self.bgView removeFromSuperview];
    self.bgView = nil;
    self.bgView = [[UIView alloc] initWithFrame:self.bounds];
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(self.center.x-87, 132, 174, 148)];
    imgV.image = [UIImage imageNamed:@"icon_none_network"];
    UILabel *textL = [[UILabel alloc] initWithFrame:CGRectMake(self.center.x-150, 300, 300, 20)];
    textL.font = FONT(16);
    textL.text = NSLocalizedString(@"断网了~T_T~请检查网络", nil);
    textL.textColor = HEX(@"333333", 1.0);
    textL.textAlignment = NSTextAlignmentCenter;
    [self.bgView addSubview:imgV];
    [self.bgView addSubview:textL];
    [self addSubview:self.bgView];
}
//展示未认证
- (void)showNoVerify{
    [self.bgView removeFromSuperview];
    self.bgView = nil;
    self.bgView = [[UIView alloc] initWithFrame:self.bounds];
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(self.center.x-87, 132, 174, 148)];
    imgV.image = [UIImage imageNamed:@"icon_none_msg"];
    UILabel *textL = [[UILabel alloc] initWithFrame:CGRectMake(self.center.x-150, 300, 300, 20)];
    textL.font = FONT(16);
    textL.text = NSLocalizedString(@"请先通过认证", nil);
    textL.textColor = HEX(@"333333", 1.0);
    textL.textAlignment = NSTextAlignmentCenter;
    [self.bgView addSubview:imgV];
    [self.bgView addSubview:textL];
    [self addSubview:self.bgView];
}

//绑定上拉和下拉方法
- (void)downToRefreshWithBlock:(MJRefreshComponentRefreshingBlock)downAction{
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:downAction];
    MJRefreshNormalHeader *refresh = (MJRefreshNormalHeader *)self.mj_header;
    refresh.lastUpdatedTimeLabel.hidden = YES;
}

- (void)upToLoadWithBlock:(MJRefreshComponentRefreshingBlock)upAtion{
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:upAtion];
    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"" forState:MJRefreshStateWillRefresh];
    self.mj_footer=footer;
    self.mj_footer.automaticallyHidden=YES;
}

@end
