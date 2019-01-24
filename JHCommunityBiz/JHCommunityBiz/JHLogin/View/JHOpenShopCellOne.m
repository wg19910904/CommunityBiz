//
//  JHOpenShopCellOne.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/17.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHOpenShopCellOne.h"
#import "JHShowAlert.h"
#import "SecurityCode.h"
#import "XHCodeTF.h"
@implementation JHOpenShopCellOne
{
    NSMutableArray * titleArray;//四个标题
    NSTimer * timer;//定时器
    NSInteger num;//记录时间的
    SecurityCode * control;
    NSString * result_code;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    if (titleArray == nil) {
        num = 61;
        titleArray = [NSMutableArray arrayWithObjects:
                      NSLocalizedString(@"申请人", NSStringFromClass([self class])),
                      NSLocalizedString(@"联系电话", NSStringFromClass([self class])),
                       NSLocalizedString(@"验证码", NSStringFromClass([self class])),
                       NSLocalizedString(@"密码", NSStringFromClass([self class])),
                       NSLocalizedString(@"请输入姓名", NSStringFromClass([self class])),
                       NSLocalizedString(@"请输入电话号码", NSStringFromClass([self class])),
                       NSLocalizedString(@"请输入验证码", NSStringFromClass([self class])),
                       NSLocalizedString(@"请设置密码(6-20位字符)", NSStringFromClass([self class])), nil];
        self.textFieldArray = [NSMutableArray array];
        for (int i = 0; i < 4; i ++) {
            UIView * view = [[UIView alloc]init];
            view.frame = FRAME(10, 10+40*i, WIDTH - 20, 40);
            view.backgroundColor = [UIColor whiteColor];
            view.layer.borderColor = [UIColor colorWithWhite:0.95 alpha:1].CGColor;
            view.layer.borderWidth = 0.5;
            [self addSubview:view];
            UILabel * label = [[UILabel alloc]init];
            label.frame = FRAME(10, 10, 70, 20);
            label.text = titleArray[i];
            label.textColor = [UIColor colorWithWhite:0.4 alpha:1];
            label.font = [UIFont systemFontOfSize:15];
            [view addSubview:label];
            UILabel * label_line = [[UILabel alloc]init];
            label_line.frame = FRAME(81, 2, 1, 36);
            label_line.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
            [view addSubview:label_line];

            UITextField * textField = [[UITextField alloc]init];
            if (i == 1) {
                textField = [[XHCodeTF alloc] init];
            }
            if (i == 2) {
                textField.frame = FRAME(85, 5, WIDTH - 105 - 85, 30);
                self.btn_getSecurity = [UIButton buttonWithType:UIButtonTypeCustom];
                self.btn_getSecurity.frame = FRAME(WIDTH - 105, 5, 80, 30);
                self.btn_getSecurity.layer.borderColor = THEME_COLOR.CGColor;
                self.btn_getSecurity.layer.borderWidth = 0.5;
                self.btn_getSecurity.layer.cornerRadius = 3;
                self.btn_getSecurity.clipsToBounds = YES;
                [self.btn_getSecurity setTitle: NSLocalizedString(@"获取验证码", NSStringFromClass([self class])) forState:UIControlStateNormal];
                [self.btn_getSecurity setTitleColor:THEME_COLOR forState:UIControlStateNormal];
                self.btn_getSecurity.titleLabel.font = [UIFont systemFontOfSize:13];
                [self.btn_getSecurity addTarget:self action:@selector(clickToGetSecurity) forControlEvents:UIControlEventTouchUpInside];
                [view addSubview:self.btn_getSecurity];
                
            }else{
                textField.frame = FRAME(85, 5, WIDTH - 105, 30);
            }
            if (i == 1 || i == 2) {
                textField.keyboardType = UIKeyboardTypeNumberPad;
            }
            textField.placeholder = titleArray[i+4];
            textField.textColor = [UIColor colorWithWhite:0.4 alpha:1];
            [view addSubview:textField];
            textField.font = [UIFont systemFontOfSize:15];
            [self.textFieldArray addObject:textField];
            control = [[SecurityCode alloc]init];
            
        }
    }
}
#pragma mark - 这是点击获取验证码的方法
-(void)clickToGetSecurity{
    UITextField * textField_phone = self.textFieldArray[1];
    if (textField_phone.text.length == 0) {
        [JHShowAlert showAlertWithMsg: NSLocalizedString(@"请输入电话号码", NSStringFromClass([self class]))];
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:textField_phone.text forKey:@"SECURITY_MOBILE"];
    [textField_phone resignFirstResponder];
    if ([self.btn_getSecurity.titleLabel.text isEqualToString: NSLocalizedString(@"获取验证码", NSStringFromClass([self class]))]||[self.btn_getSecurity.titleLabel.text isEqualToString: NSLocalizedString(@"重新获取", NSStringFromClass([self class]))]) {
        [HttpTool postWithAPI:@"magic/sendsms" withParams:@{@"mobile":textField_phone.text} success:^(id json) {
            NSLog(@"%@",json);
            if ([json[@"error"] isEqualToString:@"0"]) {
                if ([json[@"data"][@"sms_code"] isEqualToString:@"1"]) {
                    //获取图形验证码
                    [HttpTool postWithAPI:@"magic/verify" withParams:@{} success:^(id json) {
                        
                        if(json){
                            [control showSecurityViewWithBlock:^(NSString *result, NSString *code) {
                                [control removeFromSuperview];
                                if ([result isEqualToString: NSLocalizedString(@"正确", NSStringFromClass([self class]))]) {
                                    [self creatNSTimer];
                                }
                                
                                
                            }];
                            [control refesh:json];
                            
                        }else{
                            [JHShowAlert showAlertWithMsg: NSLocalizedString(@"服务器繁忙,请稍后再试", NSStringFromClass([self class]))];
                        }
                        
                        
                    } failure:^(NSError *error) {
                        [JHShowAlert showAlertWithMsg: NSLocalizedString(@"服务器繁忙,请稍后再试", NSStringFromClass([self class]))];
                        NSLog(@"%@",error.localizedDescription);
                    }];
                    
                }else{
                    [self creatNSTimer];
                }
            }else{
                [JHShowAlert showAlertWithMsg:json[@"message"]];
            }
        } failure:^(NSError *error) {
            [JHShowAlert showAlertWithMsg: NSLocalizedString(@"服务器繁忙,请稍后再试", NSStringFromClass([self class]))];
            NSLog(@"%@",error.localizedDescription);
        }];
        //[self creatNSTimer];
    }
    
}
#pragma mark - 创建定时器
-(void)creatNSTimer{
    if (timer == nil) {
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
        [timer fire];
    }
}
-(void)onTimer{
    num --;
    [self.btn_getSecurity setTitle:[NSString stringWithFormat:@"%@%ldS", NSLocalizedString(@"还有", NSStringFromClass([self class])),num] forState:UIControlStateNormal];
    if (num == 0) {
        [self stopNSTimer];
        num = 61;
        [self.btn_getSecurity setTitle: NSLocalizedString(@"重新获取", NSStringFromClass([self class])) forState:UIControlStateNormal];
        
    }
}
#pragma mark - 停止定时器
-(void)stopNSTimer{
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}

@end
