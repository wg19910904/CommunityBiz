//
//  JHGroupScanControl.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/25.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHGroupScanControl.h"
#import "QRCodeReaderViewController.h"
 UINavigationController * myNav;
@implementation JHGroupScanControl{
    JHGroupScanControl * groupControl;
    UITextField * mytextField;
    UIButton * btn_sweep;
    UILabel * label_error;
   
}
+(void)showJHGroupScanControlWithNav:(UINavigationController *)nav withBlock:(void(^)(NSDictionary * dic))myBlock withSweepBlock:(void(^)(NSDictionary * dic))sweepBlock{
    myNav = nav;
    JHGroupScanControl * control = [[JHGroupScanControl alloc]init];
    [control creatJHGroupScanControlWith:control];
    [control setResultBlock:^(NSDictionary * dictionary){
        myBlock(dictionary);
    }];
    [control setSweepBlock:^(NSDictionary * dictionary){
        sweepBlock(dictionary);
    }];
}
-(void)creatJHGroupScanControlWith:(JHGroupScanControl *)control{
    control.frame = FRAME(0, 0, WIDTH, HEIGHT);
    control.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.7];
    groupControl = control;
    [control addTarget:self action:@selector(clickToCancel) forControlEvents:UIControlEventTouchUpInside];
    UIWindow * window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:control];
    //创建白色的背景
    UIView * view_bj = [[UIView alloc]init];
    view_bj.frame = FRAME(30, 85, WIDTH - 60, 225);
    view_bj.backgroundColor = [UIColor whiteColor];
    view_bj.layer.cornerRadius = 3;
    view_bj.layer.masksToBounds = YES;
    [control addSubview:view_bj];
    //创建提示
    UILabel * label_one = [[UILabel alloc]init];
    label_one.frame = FRAME((WIDTH - 130)/2, 15, 70, 20);
    label_one.text =  NSLocalizedString(@"验证提示", NSStringFromClass([self class]));
    label_one.textColor = [UIColor colorWithWhite:0.2 alpha:1];
    label_one.font = [UIFont systemFontOfSize:15];
    [view_bj addSubview:label_one];
    //创建显示选择什么方式的提示
    UILabel * label_two = [[UILabel alloc]init];
    label_two.frame = FRAME(0, 40, WIDTH - 60, 20);
    label_two.font = [UIFont systemFontOfSize:13];
    label_two.textAlignment = NSTextAlignmentCenter;
    label_two.textColor = [UIColor colorWithWhite:0.2 alpha:1];
    NSString * str =  NSLocalizedString(@"选择扫描二维码或输入密码进行验证", NSStringFromClass([self class]));
    NSRange range1 = [str rangeOfString: NSLocalizedString(@"扫描二维码", NSStringFromClass([self class]))];
    NSRange range2 = [str rangeOfString: NSLocalizedString(@"输入密码", NSStringFromClass([self class]))];
    NSMutableAttributedString * attributed = [[NSMutableAttributedString alloc]initWithString:str];
    [attributed addAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:250/255.0 green:175/255.0 blue:25/255.0 alpha:1]} range:range1];
    [attributed addAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:250/255.0 green:175/255.0 blue:25/255.0 alpha:1]} range:range2];
    label_two.attributedText = attributed;
    [view_bj addSubview:label_two];
    //创建显示的输入框
    mytextField = [[UITextField alloc]init];
    mytextField.frame = FRAME(10, 65, WIDTH - 80, 40);
    mytextField.placeholder =  NSLocalizedString(@"请输入密码", NSStringFromClass([self class]));
    mytextField.delegate = self;
    mytextField.font = [UIFont systemFontOfSize:14];
    mytextField.tintColor = [UIColor colorWithRed:90/255.0 green:192/255.0 blue:237/255.0 alpha:1];
    mytextField.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    mytextField.layer.cornerRadius =  3;
    mytextField.clipsToBounds = YES;
    mytextField.keyboardType = UIKeyboardTypeNumberPad;
    mytextField.leftViewMode = UITextFieldViewModeAlways;
    [view_bj addSubview:mytextField];
    UILabel * label_left = [[UILabel alloc]init];
    label_left.frame = FRAME(0, 0, 10, 40);
    label_left.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    mytextField.leftView = label_left;
    //创建点击进行二维码扫描的按钮
    btn_sweep = [[UIButton alloc]init];
    btn_sweep.frame = FRAME(10, 125, WIDTH - 80, 40);
    btn_sweep.layer.cornerRadius = 3;
    btn_sweep.layer.masksToBounds = YES;
    btn_sweep.layer.borderColor = [UIColor colorWithWhite:0.95 alpha:1].CGColor;
    btn_sweep.layer.borderWidth = 1;
    [btn_sweep setTitle: NSLocalizedString(@"扫描二维码", NSStringFromClass([self class])) forState:UIControlStateNormal];
    [btn_sweep setTitleColor:[UIColor colorWithRed:250/255.0 green:175/255.0 blue:25/255.0 alpha:1] forState:UIControlStateNormal];
    btn_sweep.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn_sweep addTarget:self action:@selector(clickToSweep) forControlEvents:UIControlEventTouchUpInside];
    [view_bj addSubview:btn_sweep];
    //创建点击扫描二维码的图片
    UIImageView * imageV = [[UIImageView alloc]init];
    imageV.frame = FRAME(55, 5, 30, 30);
    imageV.image = [UIImage imageNamed:@"Group-purchase_QR-code"];
    [btn_sweep addSubview:imageV];
    //创建取消和确定的按钮
    for(int i = 0;i < 2;i ++){
        UIButton * btn = [[UIButton alloc]init];
        btn.frame = FRAME(WIDTH-60 - 60*(i + 1), 175, 50, 35);
        btn.tag = i;
        [btn setTitleColor:THEME_COLOR forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        if (i == 0) {
            [btn setTitle: NSLocalizedString(@"确定", NSStringFromClass([self class])) forState:UIControlStateNormal];
        }else{
            [btn setTitle: NSLocalizedString(@"取消", NSStringFromClass([self class])) forState:UIControlStateNormal];
        }
        [view_bj addSubview:btn];
        [btn addTarget:self action:@selector(clickToBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    //创建显示错误信息的label
    label_error = [[UILabel alloc]init];
    label_error.frame = FRAME(10, 185, WIDTH - 190, 20);
    label_error.textColor = [UIColor redColor];
    label_error.font = [UIFont systemFontOfSize:12];
    [view_bj addSubview:label_error];
}
#pragma mark - 点击取消或者确定调用的方法
-(void)clickToBtn:(UIButton *)sender{
    if (sender.tag == 0) {
        NSLog(@"点击的是确定");
        if (mytextField.text.length == 0) {
            [self endEditing:YES];
            label_error.text =  NSLocalizedString(@"请先输入您的密码!", NSStringFromClass([self class]));
            return;
        }else{
            SHOW_HUD_IN_SELF
            [HttpTool postWithAPI:@"biz/quan/get" withParams:@{@"code":[NSString stringWithFormat:@"%@",mytextField.text]} success:^(id json) {
                NSLog(@"%@",json);
                if ([json[@"error"] isEqualToString:@"0"]) {
                    self.resultBlock(json[@"data"]);
                }else{
                    [JHShowAlert showAlertWithMsg:json[@"message"]];
                }
                HIDE_HUD_IN_SELF
                 [groupControl removeFromSuperview];
                 groupControl = nil;
            } failure:^(NSError *error) {
                HIDE_HUD_IN_SELF
                [groupControl removeFromSuperview];
                 groupControl = nil;
                [JHShowAlert showAlertWithMsg: NSLocalizedString(@"服务器繁忙,请稍后访问", NSStringFromClass([self class]))];
                 NSLog(@"%@",error.localizedDescription);
            }];
        }
    }else{
         [groupControl removeFromSuperview];
         groupControl = nil;
    }
}
#pragma mark - 点击取消蒙版
-(void)clickToCancel{
    if ([mytextField isFirstResponder]) {
        [self endEditing:YES];
        return;
    }
    [groupControl removeFromSuperview];
     groupControl = nil;
}
#pragma mark - 这是点击进行扫一扫的方法
-(void)clickToSweep{
    [groupControl removeFromSuperview];
    groupControl = nil;
    QRCodeReaderViewController * code = [QRCodeReaderViewController new];
    code.modalPresentationStyle = UIModalPresentationFormSheet;
    code.navigationItem.title =  NSLocalizedString(@"扫一扫", NSStringFromClass([self class]));
    [code setCompletionWithBlock:^(NSString *resultAsString) {
        //暂时的处理
        [myNav popViewControllerAnimated:YES];
        [HttpTool postWithAPI:@"biz/quan/get" withParams:@{@"code":resultAsString} success:^(id json) {
            NSLog(@"%@",json);
            if ([json[@"error"] isEqualToString:@"0"]) {
                self.sweepBlock(json[@"data"]);
            }else{
                [JHShowAlert showAlertWithMsg:json[@"message"]];
            }
        } failure:^(NSError *error) {
            [JHShowAlert showAlertWithMsg: NSLocalizedString(@"服务器繁忙,请稍后访问", NSStringFromClass([self class]))];
            NSLog(@"%@",error.localizedDescription);
        }];
    }];
    [myNav pushViewController:code animated:YES];
}
#pragma mark - 这是UITextField的代理方法
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    label_error.text = @"";
}
@end
