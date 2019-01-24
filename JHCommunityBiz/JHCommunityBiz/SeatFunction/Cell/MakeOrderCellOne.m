//
//  MakeOrderCellOne.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/9/30.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "MakeOrderCellOne.h"

@implementation MakeOrderCellOne

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
-(void)setIsPaidui:(BOOL)isPaidui{
    _isPaidui = isPaidui;
    if (_isPaidui) {
        [self addSubview:self.myTextField];
    }else{
        [_myTextField removeFromSuperview];
        _myTextField = nil;
        self.textLabel.text =  NSLocalizedString(@"订座就餐位置选择", NSStringFromClass([self class]));
        self.textLabel.font = FONT(15);
    }
}
-(UITextField *)myTextField{
    if (!_myTextField) {
        _myTextField = [[UITextField alloc]init];
        _myTextField.frame = FRAME(10, 0, WIDTH - 20, 40);
        _myTextField.placeholder =  NSLocalizedString(@"请输入等待时间", NSStringFromClass([self class]));
        _myTextField.keyboardType = UIKeyboardTypeNumberPad;
        _myTextField.leftViewMode = UITextFieldViewModeAlways;
        _myTextField.rightViewMode = UITextFieldViewModeAlways;
        _myTextField.textAlignment = NSTextAlignmentCenter;
        UILabel * label = [[UILabel alloc]init];
        label.text = NSLocalizedString(@"预计等待", NSStringFromClass([self class]));
        label.textColor = HEX(@"333333", 1.0);
        label.font = FONT(14);
        label.frame = FRAME(0, 0, 60, 20);
        _myTextField.leftView = label;
        UILabel * _label = [[UILabel alloc]init];
        _label.text = NSLocalizedString(@"分钟", NSStringFromClass([self class]));
        _label.textColor = HEX(@"333333", 1.0);
        _label.font = FONT(14);
        _label.frame = FRAME(0, 0, 30, 20);
        _myTextField.rightView = _label;
    }
    return _myTextField;
}
@end
