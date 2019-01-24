//
//  JHWithDrawCellTwo.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/20.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHWithDrawCellTwo.h"

@implementation JHWithDrawCellTwo

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.mytextField == nil) {
        UILabel * label = [[UILabel alloc]init];
        label.frame = FRAME(10, 10, 60, 20);
        label.text = NSLocalizedString(@"提现金额", nil);
        label.textColor = [UIColor colorWithWhite:0.4 alpha:1];
        label.font = [UIFont systemFontOfSize:14];
        [self addSubview:label];
        self.mytextField = [[UITextField alloc]init];
        self.mytextField.frame = FRAME(75, 5, WIDTH - 215, 30);
        self.mytextField.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
        self.mytextField.placeholder = NSLocalizedString(@"请输入提现金额", nil);
        self.mytextField.textColor = THEME_COLOR;
        self.mytextField.layer.borderColor = [UIColor colorWithWhite:0.95 alpha:1].CGColor;
        self.mytextField.layer.borderWidth = 0.5;
        self.mytextField.font = [UIFont systemFontOfSize:12];
        //self.mytextField.keyboardType = UIKeyboardTypeNumberPad;
        self.mytextField.rightViewMode = UITextFieldViewModeAlways;
        [self addSubview:self.mytextField];
        UILabel * label_yuan = [[UILabel alloc]init];
        label_yuan.frame = FRAME(0, 0, 30, 30);
        label_yuan.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        label_yuan.font = [UIFont systemFontOfSize:14];
        label_yuan.textAlignment = NSTextAlignmentCenter;
        label_yuan.backgroundColor = [UIColor whiteColor];
        label_yuan.text = NSLocalizedString(@"元", nil);
        self.mytextField.rightView = label_yuan;
        self.label_serve = [[UILabel alloc]init];
        self.label_serve.frame = FRAME(WIDTH - 130, 10, 120, 20);
//        self.label_serve.text = NSLocalizedString(@"平台收取服务费2%", nil);
        self.label_serve.adjustsFontSizeToFitWidth = YES;
        self.label_serve.textColor = THEME_COLOR;
        self.label_serve.font = [UIFont systemFontOfSize:13];
        [self addSubview:self.label_serve];
    }
}

@end
