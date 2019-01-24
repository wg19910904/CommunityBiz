//
//  DeliveryProductAllModifyBottomView.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/27.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "DeliveryProductAllModifyBottomView.h"

@implementation DeliveryProductAllModifyBottomView
{
    UIButton *_selectAllBtn;
    UIButton *_shelfBtn;
    UIButton *_outShelfBtn;
    UIButton *_delayBtn;
    CALayer *line;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        self = [super initWithFrame:frame];
    }
    self.backgroundColor = [UIColor whiteColor];
    //添加控件
    [self makeUI];
    return self;
}
#pragma mark - 添加控件
- (void)makeUI
{
    _selectAllBtn = [UIButton new];
    [_selectAllBtn setTitle:NSLocalizedString(@"全选", nil) forState:(UIControlStateNormal)];
    [_selectAllBtn setTitleColor:HEX(@"333333", 1.0f) forState:(UIControlStateNormal)];
    _selectAllBtn.titleLabel.font = FONT(14);
    [_selectAllBtn setImage:IMAGE(@"Delivery_Not-selecte") forState:(UIControlStateNormal)];
    [_selectAllBtn setImage:IMAGE(@"Delivery_selectedAll") forState:(UIControlStateSelected)];
    _selectAllBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [self addSubview:_selectAllBtn];
    
    _shelfBtn = [UIButton new];
    [_shelfBtn setTitle:NSLocalizedString(@"上架", nil) forState:(UIControlStateNormal)];
    [_shelfBtn setTitleColor:HEX(@"faaf19", 1.0f) forState:(UIControlStateNormal)];
    _shelfBtn.titleLabel.font = FONT(15);
    [_shelfBtn setImage:IMAGE(@"Delivery_on-the-shelf") forState:(UIControlStateNormal)];
    _shelfBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [self addSubview:_shelfBtn];
    
    _outShelfBtn = [UIButton new];
    [_outShelfBtn setTitle:NSLocalizedString(@"下架", nil) forState:(UIControlStateNormal)];
    [_outShelfBtn setTitleColor:HEX(@"f70000", 1.0) forState:(UIControlStateNormal)];
    _outShelfBtn.titleLabel.font = FONT(15);
    [_outShelfBtn setImage:IMAGE(@"Delivery_Off-the-shelf") forState:(UIControlStateNormal)];
    _outShelfBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [self addSubview:_outShelfBtn];
    
    _delayBtn = [UIButton new];
    [_delayBtn setTitle:NSLocalizedString(@"延期", nil) forState:(UIControlStateNormal)];
    [_delayBtn setTitleColor:HEX(@"faaf19", 1.0) forState:(UIControlStateNormal)];
    _delayBtn.titleLabel.font = FONT(15);
    [_delayBtn setImage:IMAGE(@"Delivery_delay-the-shelf") forState:(UIControlStateNormal)];
    _delayBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [self addSubview:_delayBtn];
    
}

- (void)setBottomViewType:(EDeliveryProductAllModifyType)bottomViewType
{
    switch (bottomViewType) {
        case EStatusShelf: //已上架
        {
            _shelfBtn.hidden = YES;
            _selectAllBtn.hidden = NO;
            _delayBtn.hidden = YES;
            _outShelfBtn.hidden = NO;
            //布局
            _selectAllBtn.frame = FRAME(0, 0, WIDTH / 3, 50);
//            _delayBtn.frame = FRAME(WIDTH/3, 0, WIDTH/3, 50);
            _outShelfBtn.frame = FRAME(WIDTH/3*2, 0, WIDTH/3, 50);
        }
            break;
        case EStatusNotShelf: //未上架
        {
            _shelfBtn.hidden = NO;
            _selectAllBtn.hidden = NO;
            _delayBtn.hidden = YES;
            _outShelfBtn.hidden = YES;
            //布局
            _selectAllBtn.frame = FRAME(0, 0, WIDTH / 3, 50);
            _shelfBtn.frame = FRAME(WIDTH/3*2, 0, WIDTH/3, 50);
        }
            break;
        default: //已过期
        {
            _shelfBtn.hidden = YES;
            _selectAllBtn.hidden = NO;
            _delayBtn.hidden = NO;
            _outShelfBtn.hidden = YES;
            //布局
            _selectAllBtn.frame = FRAME(0, 0, WIDTH / 3, 50);
            _delayBtn.frame = FRAME(WIDTH/3*2, 0, WIDTH/3, 50);
        }
            break;
    }
}
@end
