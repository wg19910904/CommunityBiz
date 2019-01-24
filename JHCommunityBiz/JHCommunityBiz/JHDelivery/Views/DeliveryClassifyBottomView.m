//
//  DeliveryClassifyBottomView.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/23.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "DeliveryClassifyBottomView.h"

@implementation DeliveryClassifyBottomView
{
    UIButton *_selectedAllBtn,*_deleteBtn;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        self = [super initWithFrame:frame];
    }
    self.backgroundColor = [UIColor whiteColor];
    //添加子视图
    [self makeUI];
    return self;
}
#pragma mark - 添加子控件
- (void)makeUI
{
    _selectedAllBtn = [[UIButton alloc] initWithFrame:FRAME(0, 0, 100, 50)];
    UILabel *titleLabel  = [[UILabel alloc] initWithFrame:FRAME(40, 0, 60, 50)];
    titleLabel.text = NSLocalizedString(@"全选", nil);
    titleLabel.font = FONT(16);
    titleLabel.textColor = HEX(@"666666", 1.0f);
    [_selectedAllBtn addSubview:titleLabel];
    [_selectedAllBtn setImage:IMAGE(@"Delivery_Not-selecte") forState:(UIControlStateNormal)];
    [_selectedAllBtn setImage:IMAGE(@"Delivery_selectedAll") forState:(UIControlStateSelected)];
    _selectedAllBtn.imageEdgeInsets = UIEdgeInsetsMake(15, 10, 15, 70);
    
    _deleteBtn = [[UIButton alloc] initWithFrame:FRAME(WIDTH - 110, 0, 110, 50)];
    [_deleteBtn setTitle:NSLocalizedString(@"删除", nil) forState:(UIControlStateNormal)];
    _deleteBtn.titleLabel.font = FONT(16);
    [_deleteBtn setBackgroundColor:HEX(@"bbbbbb", 1.0f) forState:UIControlStateNormal];
//    [_deleteBtn setBackgroundColor:HEX(@"bbbbbb", 1.0f) forState:UIControlStateHighlighted];
    [_deleteBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
//    [_deleteBtn setBackgroundColor:HEX(@"fa4535", 1.0f) forState:(UIControlStateSelected)];
    
    [self addSubview:_selectedAllBtn];
    [self addSubview:_deleteBtn];
}
@end
