//
//  DeliveryProductBottomView.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/26.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHTuangouProductBottimView.h"

@implementation JHTuangouProductBottimView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        self = [super initWithFrame:frame];
    }
    self.backgroundColor = [UIColor whiteColor];
    //添加子控件
    [self makeUI];
    return self;
}
#pragma mark - 添加子控件
- (void)makeUI
{
    self.addBtn = [[UIButton alloc] initWithFrame:FRAME(0, 0, WIDTH / 2, 50)];
    [_addBtn setTitle:NSLocalizedString(@"添加新商品", nil) forState:(UIControlStateNormal)];
    [_addBtn setImage:IMAGE(@"Delivery_add-to") forState:(UIControlStateNormal)];
    [_addBtn setTitleColor:HEX(@"333333", 1.0f) forState:(UIControlStateNormal)];
    _addBtn.titleLabel.font = FONT(15);
    
    self.manageBtn = [[UIButton alloc] initWithFrame:FRAME(WIDTH / 2, 0, WIDTH / 2, 50)];
    [_manageBtn setTitle:NSLocalizedString(@"批量管理", nil) forState:(UIControlStateNormal)];
    [_manageBtn setImage:IMAGE(@"Delivery_manage") forState:(UIControlStateNormal)];
    [_manageBtn setTitleColor:HEX(@"333333", 1.0f) forState:(UIControlStateNormal)];
    _manageBtn.titleLabel.font = FONT(15);
    [self addSubview:_addBtn];
    [self addSubview:_manageBtn];
    CALayer *line = [CALayer layer];
    line.frame = FRAME(0, 0, WIDTH, 0.5);
    line.backgroundColor = LINE_COLOR.CGColor; 
    CALayer *line2 = [CALayer layer];
    line2.frame = FRAME(WIDTH/2, 10, 0.5, 30);
    line2.backgroundColor = LINE_COLOR.CGColor;
    
    [self.layer addSublayer:line];
    [self.layer addSublayer:line2];
}

@end
