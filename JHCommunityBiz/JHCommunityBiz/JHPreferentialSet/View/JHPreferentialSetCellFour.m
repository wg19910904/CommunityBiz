//
//  JHPreferentialSetCellFour.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/27.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHPreferentialSetCellFour.h"

@implementation JHPreferentialSetCellFour
-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:YES];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.myTextField == nil) {
        UIView * label_line = [[UIView alloc]init];
        label_line.frame = FRAME(0, 39.5, WIDTH, 0.5);
        label_line.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        [self addSubview:label_line];
        UIView * label_l = [[UIView alloc]init];
        label_l.frame = FRAME(0, 0.5, WIDTH, 0.5);
        label_l.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        [self addSubview:label_l];
        UILabel * label = [[UILabel alloc]init];
        label.frame  = FRAME(10, 10, 80, 20);
        label.text =  NSLocalizedString(@"折扣比例:", NSStringFromClass([self class]));
        label.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        label.font = [UIFont systemFontOfSize:15];
        [self addSubview:label];
        self.myTextField = [[UITextField alloc]init];
        self.myTextField.frame = FRAME(90, 5, WIDTH - 100, 30);
        self.myTextField.rightViewMode = UITextFieldViewModeAlways;
        self.myTextField.keyboardType = UIKeyboardTypeNumberPad;
        self.myTextField.tintColor = [UIColor orangeColor];
        self.myTextField.textColor = [UIColor orangeColor];
        [self addSubview:self.myTextField];
        UILabel * lab = [[UILabel alloc]init];
        lab.frame = FRAME(0, 5, 20, 20);
        lab.text = @"%";
        lab.font = [UIFont systemFontOfSize:15];
        lab.textColor = THEME_COLOR;
        self.myTextField.rightView = lab;
    }
}

@end
