//
//  QiPeiFooterView.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/23.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "QiPeiFooterView.h"

@implementation QiPeiFooterView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        self = [super initWithFrame:frame];
    }
    self.backgroundColor = [UIColor whiteColor];
    //添加子控
    [self makeUI];
    return self;
}
#pragma mark - 添加子控件
- (void)makeUI
{
    self.addBtn = [UIButton new];
    [self addSubview:_addBtn];
    [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@90);
        make.height.equalTo(@30);
        make.center.equalTo(self);
    }];
    [_addBtn setTitle:NSLocalizedString(@"添加+", nil) forState:(UIControlStateNormal)];
    [_addBtn setBackgroundColor:HEX(@"faaf19", 1.0) forState:(UIControlStateNormal)];
    [_addBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    _addBtn.titleLabel.font = FONT(14);
    _addBtn.layer.cornerRadius = 15;
    _addBtn.layer.masksToBounds = YES;
}
@end
