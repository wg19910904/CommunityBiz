//
//  JHWithDrawCellThree.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/20.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHWithDrawCellThree.h"
@implementation JHWithDrawCellThree

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if(self.mytextField == nil){
        UIView * view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        view.frame = FRAME(0, 0, WIDTH, 40);
        [self addSubview:view];
        UILabel * label_psd = [[UILabel alloc]init];
        label_psd.frame = FRAME(10, 10, 60, 20);
        label_psd.text = NSLocalizedString(@"支付密码", nil);
        label_psd.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        label_psd.font = [UIFont systemFontOfSize:14];
        [view addSubview:label_psd];
        self.mytextField = [[UITextField alloc]init];
        self.mytextField.frame = FRAME(75, 5, WIDTH - 215, 30);
        self.mytextField.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
        self.mytextField.placeholder = NSLocalizedString(@"请输入支付密码", nil);
        self.mytextField.secureTextEntry = YES;
        self.mytextField.textColor = THEME_COLOR;
        self.mytextField.layer.borderColor = [UIColor colorWithWhite:0.95 alpha:1].CGColor;
        self.mytextField.layer.borderWidth = 0.5;
        self.mytextField.font = [UIFont systemFontOfSize:12];
        [view addSubview:self.mytextField];
        UILabel * label_tixing = [[UILabel alloc]init];
        label_tixing.frame = FRAME(WIDTH - 130, 10, 120, 20);
        label_tixing.text = NSLocalizedString(@"登录密码即支付密码", nil);
        label_tixing.adjustsFontSizeToFitWidth = YES;
        label_tixing.textColor = THEME_COLOR;
        label_tixing.font = [UIFont systemFontOfSize:13];
        [view addSubview:label_tixing];
        //忘记密码的按钮
        self.btn_forgetter = [[UIButton alloc]init];
        self.btn_forgetter.frame = FRAME(0, 50, 100, 30);
        [self.btn_forgetter setTitle:[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"忘记密码", nil),@"?"] forState:UIControlStateNormal];
        [self.btn_forgetter setTitleColor:[UIColor colorWithWhite:0.4 alpha:1] forState:UIControlStateNormal];
        self.btn_forgetter.titleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.btn_forgetter];
        //确认提现的按钮
        self.btn_ture = [[UIButton alloc]init];
        self.btn_ture.frame = FRAME(10, 110, WIDTH - 20, 45);
        [self.btn_ture setBackgroundColor:[UIColor colorWithRed:250/255.0 green:177/255.0 blue:17/255.0 alpha:1] forState:UIControlStateNormal];
       [self.btn_ture setBackgroundColor:[UIColor colorWithRed:250/255.0 green:177/255.0 blue:17/255.0 alpha:0.5] forState:UIControlStateHighlighted];
        [self.btn_ture setTitle:NSLocalizedString(@"确认提现", nil) forState:UIControlStateNormal];
        self.btn_ture.layer.cornerRadius = 3;
        self.btn_ture.clipsToBounds = YES;
        [self addSubview:self.btn_ture];
        //每日只能提现一次的提醒
        UILabel * label_zhu = [[UILabel alloc]init];
        label_zhu.frame = FRAME(0, 165, WIDTH, 20);
        label_zhu.text = NSLocalizedString(@"注:每日只可提现一次", nil);
        label_zhu.textColor = [UIColor colorWithWhite:0.6 alpha:1];
        label_zhu.textAlignment = NSTextAlignmentCenter;
        label_zhu.font = [UIFont systemFontOfSize:15];
        [self addSubview:label_zhu];
        
    }
    
}

@end
