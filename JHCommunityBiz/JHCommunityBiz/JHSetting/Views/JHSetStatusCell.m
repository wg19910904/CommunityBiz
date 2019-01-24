//
//  JHSetStatusCell.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/17.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHSetStatusCell.h"

@implementation JHSetStatusCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //创建三个按钮
        self.on_btn = [UIButton new];
        //        self.busy_btn = [UIButton new];
        self.off_btn = [UIButton new];
        [self addSubview:_on_btn];
        //        [self addSubview:_busy_btn];
        [self addSubview:_off_btn];
        
        [self makeUI];
    }
    return self;
}
- (void)makeUI
{
    //布局
    [self.on_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(WIDTH/2));
        make.height.equalTo(@(44));
        make.center.equalTo(self).centerOffset(CGPointMake(-WIDTH/4, 0));
        
    }];
    //    [self.busy_btn mas_makeConstraints:^(MASConstraintMaker *make) {
    //         make.center.equalTo(self);
    //    }];
    [self.off_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self).centerOffset(CGPointMake(WIDTH/4, 0));
        make.width.equalTo(@[self.on_btn]);
        make.height.equalTo(@[self.on_btn]);
    }];
    //设置
    [_on_btn setTitle:NSLocalizedString(@"营业", nil) forState:(UIControlStateNormal)];
    [_on_btn setImage:IMAGE(@"DeliveryNotselected") forState:(UIControlStateNormal)];
    [_on_btn setImage:IMAGE(@"Deliveryselected") forState:(UIControlStateSelected)];
    _on_btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, WIDTH/4);
    _on_btn.imageEdgeInsets = UIEdgeInsetsMake(5, WIDTH/5, 5,0);
    _on_btn.titleLabel.font = FONT(14);
    [_on_btn setTitleColor:HEX(@"333333", 1.0) forState:(UIControlStateNormal)];
    [_on_btn setTitleColor:HEX(@"66cd1c", 1.0) forState:(UIControlStateSelected)];
    _on_btn.tag = 101;
    [_on_btn addTarget:self action:@selector(cilckBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    
//    [_busy_btn setTitle:NSLocalizedString(@"繁忙", nil) forState:(UIControlStateNormal)];
//    [_busy_btn setImage:IMAGE(@"DeliveryNotselected") forState:(UIControlStateNormal)];
//    [_busy_btn setImage:IMAGE(@"Deliveryselected") forState:(UIControlStateSelected)];
//    _busy_btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, WIDTH/2/2*1.5);
//    _busy_btn.imageEdgeInsets = UIEdgeInsetsMake(5, WIDTH/2/5 *2, 5,0);
//    _busy_btn.titleLabel.font = FONT(14);
//    [_busy_btn setTitleColor:HEX(@"333333", 1.0) forState:(UIControlStateNormal)];
//    [_busy_btn setTitleColor:HEX(@"66cd1c", 1.0) forState:(UIControlStateSelected)];
//    _busy_btn.tag = 102;
//    [_busy_btn addTarget:self action:@selector(cilckBtn:) forControlEvents:(UIControlEventTouchUpInside)];

    [_off_btn setTitle:NSLocalizedString(@"打烊", nil) forState:(UIControlStateNormal)];
    _off_btn.titleLabel.font = FONT(14);
    [_off_btn setImage:IMAGE(@"DeliveryNotselected") forState:(UIControlStateNormal)];
    [_off_btn setImage:IMAGE(@"Deliveryselected") forState:(UIControlStateSelected)];
    _off_btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, WIDTH/4);
    _off_btn.imageEdgeInsets = UIEdgeInsetsMake(5, WIDTH/5, 5,0);
    [_off_btn setTitleColor:HEX(@"333333", 1.0) forState:(UIControlStateNormal)];
    [_off_btn setTitleColor:HEX(@"66cd1c", 1.0) forState:(UIControlStateSelected)];
    _off_btn.tag = 100;
    [_off_btn addTarget:self action:@selector(cilckBtn:) forControlEvents:(UIControlEventTouchUpInside)];
}
- (void)cilckBtn:(UIButton *)sender
{
    _on_btn.selected = NO;
    //    _busy_btn.selected = NO;
    _off_btn.selected = NO;
    sender.selected = YES;
    NSInteger index = sender.tag - 100;
    self.statusCode = index;
    if (_statusBlock) {
        _statusBlock(index);
    }
}
@end

