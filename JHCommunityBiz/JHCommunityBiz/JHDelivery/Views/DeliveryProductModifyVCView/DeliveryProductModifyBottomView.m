//
//  DeliveryProductModifyBottomView.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/30.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "DeliveryProductModifyBottomView.h"

@implementation DeliveryProductModifyBottomView
{
    UIButton *_shelfB;//上架
    UIButton *_outShelfB;//下架
    UIButton *_delayB;//延期
    UIButton *_deleteB;//删除
    
    CALayer *line1;
    CALayer *line2;
    CALayer *line3;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        self = [super initWithFrame:frame];
    }
    //添加子控件
    [self makeUI];
    return self;
}
#pragma mark - 添加子控件
- (void)makeUI
{
    _shelfB = [UIButton new];
    [_shelfB setTitle:NSLocalizedString(@"上架", nil) forState:(UIControlStateNormal)];
    [_shelfB setTitleColor:HEX(@"faaf19", 1.0f) forState:(UIControlStateNormal)];
    _shelfB.titleLabel.font = FONT(15);
    [_shelfB setImage:IMAGE(@"Delivery_on-the-shelf") forState:(UIControlStateNormal)];
    _shelfB.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    
    _outShelfB = [UIButton new];
    [_outShelfB setTitle:NSLocalizedString(@"下架", nil) forState:(UIControlStateNormal)];
    [_outShelfB setTitleColor:HEX(@"f70000", 1.0) forState:(UIControlStateNormal)];
    _outShelfB.titleLabel.font = FONT(15);
    [_outShelfB setImage:IMAGE(@"Delivery_Off-the-shelf") forState:(UIControlStateNormal)];
    _outShelfB.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    
    _delayB = [UIButton new];
    [_delayB setTitle:NSLocalizedString(@"延期", nil) forState:(UIControlStateNormal)];
    [_delayB setTitleColor:HEX(@"faaf19", 1.0) forState:(UIControlStateNormal)];
    _delayB.titleLabel.font = FONT(15);
    [_delayB setImage:IMAGE(@"Delivery_delay-the-shelf") forState:(UIControlStateNormal)];
    _delayB.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);

    _deleteB = [UIButton new];
    [_deleteB setTitle:NSLocalizedString(@"删除", nil) forState:(UIControlStateNormal)];
    [_deleteB setTitleColor:HEX(@"999999", 1.0) forState:(UIControlStateNormal)];
    _deleteB.titleLabel.font = FONT(15);
    [_deleteB setImage:IMAGE(@"Delivery_delete") forState:(UIControlStateNormal)];
    _deleteB.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    
    [self addSubview:_shelfB];
    [self addSubview:_outShelfB];
    [self addSubview:_delayB];
    [self addSubview:_deleteB];
    
    line1 = [CALayer layer];
    line1.frame = FRAME(WIDTH/3, 10, 0.5, 30);
    line1.backgroundColor = LINE_COLOR.CGColor;
    
    line2 = [CALayer layer];
    line2.frame = FRAME(WIDTH/3*2, 10, 0.5, 30);
    line2.backgroundColor = LINE_COLOR.CGColor;
    
    line3 = [CALayer layer];
    line3.frame = FRAME(WIDTH/2, 10, 0.5, 30);
    line3.backgroundColor = LINE_COLOR.CGColor;
    
    [self.layer addSublayer:line1];
    [self.layer addSublayer:line2];
    [self.layer addSublayer:line3];
    
    CALayer *line4 = [CALayer layer];
    line4.frame = FRAME(0, 0, WIDTH, 0.5);
    line4.backgroundColor = LINE_COLOR.CGColor;
    [self.layer addSublayer:line4];
}

- (void)setBottomType:(EDeliveryProductModifyBottomViewType)BottomType
{
    switch (BottomType) {
        case EBottomTypeShelf: //已上架
        {
            _shelfB.hidden = YES;
            _outShelfB.hidden = NO;
            _delayB.hidden = NO;
            _deleteB.hidden = NO;
            line1.hidden = NO;
            line2.hidden = NO;
            line3.hidden = YES;
            
            
            _outShelfB.frame = FRAME(0, 0, WIDTH / 3, 50);
            _delayB.frame = FRAME(WIDTH/3, 0, WIDTH/3, 50);
            _deleteB.frame = FRAME(WIDTH/3*2, 0, WIDTH/3, 50);
        }
            break;
        case EBottomTypeNotShelf: //未上架
        {
            _shelfB.hidden = NO;
            _outShelfB.hidden = YES;
            _delayB.hidden = YES;
            _deleteB.hidden = NO;
            line1.hidden = YES;
            line2.hidden = YES;
            line3.hidden = NO;
            
            _shelfB.frame = FRAME(0, 0, WIDTH/2, 50);
            _deleteB.frame = FRAME(WIDTH/2, 0, WIDTH/2, 50);
        }
            break;
            
        default:                   //已过期
        {
            _shelfB.hidden = YES;
            _outShelfB.hidden = YES;
            _delayB.hidden = NO;
            _deleteB.hidden = NO;
            line1.hidden = YES;
            line2.hidden = YES;
            line3.hidden = NO;
            
            _delayB.frame = FRAME(0, 0, WIDTH/2, 50);
            _deleteB.frame = FRAME(WIDTH/2, 0, WIDTH/2, 50);
            
        }
            break;
    }
}
@end
