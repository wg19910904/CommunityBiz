//
//  DeliveryOrderNavView.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/24.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "DeliveryOrderNavView.h"

@implementation DeliveryOrderNavView
- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSArray<NSString *>*)titleArray
{
    self = [super initWithFrame:frame];
    if (!self) {
       self = [super initWithFrame:frame];
    }
    //添加view
    [self makeUI:titleArray];
    return self;
}

#pragma mark - 添加view
- (void)makeUI:(NSArray<NSString *>*)titleArray{
    NSInteger count = titleArray.count;
    //添加两个按钮
    self.btn1 = [[UIButton alloc] initWithFrame:FRAME(0, 0, WIDTH / count, 40)];
    [_btn1 setTitle:titleArray[0] forState:(UIControlStateNormal)];
    [_btn1 setTitleColor:THEME_COLOR forState:(UIControlStateSelected)];
    [_btn1 setTitleColor:HEX(@"666666", 1.0f) forState:(UIControlStateNormal)];
    _btn1.titleLabel.font = FONT(15);
    self.btn2 = [[UIButton alloc] initWithFrame:FRAME( WIDTH / count,0, WIDTH / count, 40)];
    [_btn2 setTitle:titleArray[1] forState:(UIControlStateNormal)];
    [_btn2 setTitleColor:THEME_COLOR forState:(UIControlStateSelected)];
    [_btn2 setTitleColor:HEX(@"666666", 1.0f) forState:(UIControlStateNormal)];
    _btn2.titleLabel.font = FONT(15);
    [self addSubview:_btn1];
    [self addSubview:_btn2];
    if (count == 4) {
        self.btn3 = [[UIButton alloc] initWithFrame:FRAME( WIDTH / count * 2,0, WIDTH / count, 40)];
        [_btn3 setTitle:titleArray[2] forState:(UIControlStateNormal)];
        [_btn3 setTitleColor:THEME_COLOR forState:(UIControlStateSelected)];
        [_btn3 setTitleColor:HEX(@"666666", 1.0f) forState:(UIControlStateNormal)];
        _btn3.titleLabel.font = FONT(15);
        self.btn4 = [[UIButton alloc] initWithFrame:FRAME( WIDTH / count * 3,0, WIDTH / count, 40)];
        [_btn4 setTitle:titleArray[3] forState:(UIControlStateNormal)];
        [_btn4 setTitleColor:THEME_COLOR forState:(UIControlStateSelected)];
        [_btn4 setTitleColor:HEX(@"666666", 1.0f) forState:(UIControlStateNormal)];
        _btn4.titleLabel.font = FONT(15);
        [self addSubview:self.btn3];
        [self addSubview:self.btn4];
    }
    //添加分割线
    CALayer *lineLayer = [CALayer layer];
    lineLayer.frame = FRAME(0, CGRectGetHeight(self.frame)- 1, WIDTH, 0.5);
    lineLayer.backgroundColor = LINE_COLOR.CGColor;
    [self.layer addSublayer:lineLayer];
    //添加指示view
    self.indicateView = [[UIView alloc] initWithFrame:FRAME(0, CGRectGetHeight(self.frame) - 2, WIDTH/count, 2)];
    _indicateView.backgroundColor = THEME_COLOR;
    [self addSubview:_indicateView];
}
@end
