//
//  GetMoneyInputCell.m
//  JHCommunityBiz
//
//  Created by ijianghu on 2017/11/10.
//  Copyright © 2017年 com.jianghu. All rights reserved.
//

#import "GetMoneyInputCell.h"
@interface GetMoneyInputCell()

@end
@implementation GetMoneyInputCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle =  UITableViewCellSelectionStyleNone;
        [self creatTitleL];
        [self moneyTextF];
        [self rensonTextF];
        [self creatLine];
    }
    return self;
}
-(void)creatTitleL{
    UILabel *label = [UILabel new];
    label.text = NSLocalizedString(@"收款金额", NSStringFromClass([self class]));
    label.textColor = HEX(@"666666", 1);
    label.font = FONT(14);
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 15;
        make.top.offset = 16;
        make.height.offset = 16;
    }];
}
-(UITextField *)moneyTextF{
    if (!_moneyTextF) {
        _moneyTextF = [UITextField new];
        _moneyTextF.placeholder =  NSLocalizedString(@"请输入金额", NSStringFromClass([self class]));
        _moneyTextF.font = FONT(17);
        _moneyTextF.textColor = HEX(@"666666", 1);
        _moneyTextF.keyboardType = UIKeyboardTypeDecimalPad;
        _moneyTextF.leftViewMode = UITextFieldViewModeAlways;
        UILabel *label = [[UILabel alloc]initWithFrame:FRAME(0, 0, 30, 44)];
        label.text = MS;
        label.textColor = HEX(@"333333", 1);
        label.font = FONT(20);
        label.textAlignment = NSTextAlignmentCenter;
        _moneyTextF.leftView = label;
        [self addSubview:_moneyTextF];
        [_moneyTextF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 0;
            make.top.offset = 36;
            make.right.offset = 0;
            make.height.offset = 44;
        }];
    }
    return _moneyTextF;
}
-(void)creatLine{
    UIView *line = [UIView new];
    line.backgroundColor = LINE_COLOR;
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset = 0;
        make.height.offset = 0.5;
        make.top.mas_equalTo(_moneyTextF.mas_bottom).offset = 1;
    }];
}
-(UITextField *)rensonTextF{
    if (!_rensonTextF) {
        _rensonTextF = [UITextField new];
        _rensonTextF.placeholder = NSLocalizedString(@"添加收款理由", NSStringFromClass([self class]));
        _rensonTextF.font = FONT(12);
        _rensonTextF.textColor = HEX(@"666666", 1);
        [self addSubview:_rensonTextF];
        [_rensonTextF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_moneyTextF.mas_bottom).offset = 2;
            make.bottom.offset = 0;
            make.left.offset = 15;
            make.right.offset = 0;
        }];
    }
    return _rensonTextF;
}
@end
