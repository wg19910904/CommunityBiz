//
//  JHForgetterPsdVC.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/16.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHForgetterPsdVC.h"
#import "UIButton+BackgroundColor.h"
#import <IQKeyboardManager.h>
#import "SecurityCode.h"
#import "JHShowAlert.h"
#import "XHCodeTF.h"
@interface JHForgetterPsdVC ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

{
    XHCodeTF * textField_phone;//手机号输入框
    UITextField * textField_securityCode;//输入验证码的输入框
    UITextField * textFiled_psd;//创建密码的输入框
    UITableView * myTableView;//创建表
    UIButton * btn;//获取验证码的按钮
    NSTimer * timer;//定时器
    NSInteger num;//记录时间的
    
    NSString * result_code;//记住图形验证码的
}
@property(strong)   SecurityCode * control;//图形验证码的蒙版
@end

@implementation JHForgetterPsdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化一些数据
    [self initData];
    //创建表视图
    [self creatUITableView];
    
    _control = [[SecurityCode alloc]init];
}
#pragma mark - 这是初始化一些数据的
-(void)initData{
    self.navigationItem.title =  NSLocalizedString(@"忘记密码", NSStringFromClass([self class]));
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.view.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    num = 61;
}
#pragma mark - 创建表视图
-(void)creatUITableView{
    myTableView = [[UITableView alloc]initWithFrame:FRAME(0, 0, WIDTH, HEIGHT - 64) style:UITableViewStylePlain];
    myTableView.tableFooterView = [UIView new];
    myTableView.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    [myTableView registerClass:[UITableViewCell class]
        forCellReuseIdentifier:@"cell"];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [self.view addSubview:myTableView];
}
#pragma mark - 这是表视图的代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HEIGHT - 64;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    [self creatSubViewsWithCell:cell];
    return cell;
}
#pragma mark - 滑动表的时候让键盘下落
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([IQKeyboardManager sharedManager].enable) {
        
    }else{
        [self.view endEditing:YES];
    }
}
#pragma mark - 这是表结束减速的时候
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [IQKeyboardManager sharedManager].enable = YES;
}
#pragma mark - 这是表开始拖动的时候
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [IQKeyboardManager sharedManager].enable = NO;
}
#pragma mark - 这是textFieldd的代理方法
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [IQKeyboardManager sharedManager].enable = YES;
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    if (textField == textField_phone) {
        textField_securityCode.text = @"";
        textFiled_psd.text = @"";
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - 创建子视图
-(void)creatSubViewsWithCell:(UITableViewCell *)cell{
    //创建第一个背景
    UIView * view_phone = [UIView new];
    view_phone.frame = FRAME(25, 30, WIDTH - 50, 50);
    view_phone.layer.cornerRadius = 3;
    view_phone.layer.borderColor = [UIColor colorWithWhite:0.96 alpha:1].CGColor;
    view_phone.layer.borderWidth = 1;
    view_phone.clipsToBounds = YES;
    view_phone.backgroundColor = [UIColor whiteColor];
    [cell addSubview:view_phone];
    //创建手机号输入框
    textField_phone = [[XHCodeTF alloc]init];
    textField_phone.delegate = self;
    textField_phone.keyboardType = UIKeyboardTypeNumberPad;
    textField_phone.placeholder =  NSLocalizedString(@"请输入手机号码", NSStringFromClass([self class]));
    textField_phone.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField_phone.frame = FRAME(40, 0, WIDTH - 90, 50);
    textField_phone.textColor = [UIColor colorWithWhite:0.5 alpha:1];
    textField_phone.showCode = SHOW_COUNTRY_CODE;
    __weak typeof(self)weakself = self;
    textField_phone.fatherVC = weakself;
    [view_phone addSubview:textField_phone];
    //手机图片
    UIImageView * imageView = [[UIImageView alloc]init];
    imageView.frame = FRAME(10, 11, 25,25);
    imageView.image = [UIImage imageNamed:@"login_input_phone"];
    [view_phone addSubview:imageView];
    //创建第二个背景
    UIView * view_security = [UIView new];
    view_security.backgroundColor = [UIColor whiteColor];
    view_security.frame = FRAME(25, 95, WIDTH - 165, 50);
    view_security.layer.cornerRadius = 3;
    view_security.layer.masksToBounds = YES;
    view_security.layer.borderColor = [UIColor colorWithWhite:0.96 alpha:1].CGColor;
    view_security.layer.borderWidth = 1;
    [cell addSubview:view_security];
    //创建验证码的输入框
    textField_securityCode = [[UITextField alloc]init];
    textField_securityCode.delegate = self;
    textField_securityCode.keyboardType = UIKeyboardTypeNumberPad;
    textField_securityCode.placeholder =  NSLocalizedString(@"请输入验证码", NSStringFromClass([self class]));
    textField_securityCode.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField_securityCode.frame = FRAME(40, 0, WIDTH - 205, 50);
    textField_securityCode.textColor = [UIColor colorWithWhite:0.5 alpha:1];
    [view_security addSubview:textField_securityCode];
    //图片
    UIImageView * imageV = [[UIImageView alloc]init];
    imageV.image = [UIImage imageNamed:@"login_input_code"];
    imageV.frame = FRAME(10, 11, 25,25);
    [view_security addSubview:imageV];
    //创建获取验证码的按钮
    btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = FRAME(WIDTH -125, 96, 100, 48);
    btn.layer.cornerRadius = 3;
    btn.layer.masksToBounds = YES;
    [btn setBackgroundColor:THEME_COLOR];
    [btn setTitle: NSLocalizedString(@"获取验证码", NSStringFromClass([self class])) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickToGetSecurity) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [cell addSubview:btn];
    //创建第三个背景
    UIView * view_psd = [UIView new];
    view_psd.backgroundColor = [UIColor whiteColor];
    view_psd.frame = FRAME(25, 160, WIDTH - 50, 50);
    view_psd.layer.cornerRadius = 3;
    view_psd.layer.masksToBounds = YES;
    view_psd.layer.borderColor = [UIColor colorWithWhite:0.96 alpha:1].CGColor;
    view_psd.layer.borderWidth = 1;
    [cell addSubview:view_psd];
    //创建输入新密码的输入框
    textFiled_psd = [[UITextField alloc]init];
    textFiled_psd.delegate = self;
    textFiled_psd.placeholder =  NSLocalizedString(@"请输入新密码", NSStringFromClass([self class]));
    textFiled_psd.clearButtonMode = UITextFieldViewModeWhileEditing;
    textFiled_psd.frame = FRAME(40, 0, WIDTH - 90, 50);
    textFiled_psd.secureTextEntry = YES;
    textFiled_psd.textColor = [UIColor colorWithWhite:0.5 alpha:1];
    [view_psd addSubview:textFiled_psd];
    //创建锁的代码
    UIImageView * image_psd = [[UIImageView alloc]init];
    image_psd.frame = FRAME(10, 11, 25,25);
    image_psd.image = [UIImage imageNamed:@"login_input_password"];
    [view_psd addSubview:image_psd];
    //创建完成的按钮
    UIButton * btn_completion = [[UIButton alloc]init];
    btn_completion.frame = FRAME(25, 240, WIDTH - 50, 45);
    [btn_completion setTitle: NSLocalizedString(@"完成", NSStringFromClass([self class])) forState:UIControlStateNormal];
    [btn_completion setBackgroundColor:[UIColor colorWithRed:248/255.0 green:168/255.0 blue:37/255.0 alpha:1] forState:UIControlStateNormal];
    [btn_completion setBackgroundColor:[UIColor colorWithRed:248/255.0 green:168/255.0 blue:37/255.0 alpha:0.5] forState:UIControlStateHighlighted];
    [btn_completion addTarget:self action:@selector(clickToCompletion) forControlEvents:UIControlEventTouchUpInside];
    btn_completion.layer.cornerRadius = 3;
    btn_completion.layer.masksToBounds = YES;
    [cell addSubview:btn_completion];
}
#pragma mark - 这是点击完成的方法
-(void)clickToCompletion{
    [self.view endEditing:YES];
    if (textField_phone.text.length == 0||textField_securityCode.text.length ==0||textFiled_psd.text.length == 0) {
        [JHShowAlert showAlertWithMsg: NSLocalizedString(@"请将信息补充完整", NSStringFromClass([self class]))];
        return;
    }
    [HttpTool postWithAPI:@"biz/account/forgot" withParams:@{@"mobile":textField_phone.text,@"sms_code":textField_securityCode.text,@"new_passwd":textFiled_psd.text} success:^(id json) {
        if ([json[@"error"]isEqualToString:@"0"]) {
            [JHShowAlert showAlertWithTitle: NSLocalizedString(@"温馨提示", NSStringFromClass([self class])) withMessage: NSLocalizedString(@"修改密码成功", NSStringFromClass([self class])) withBtn_cancel:nil withBtn_sure: NSLocalizedString(@"知道了", NSStringFromClass([self class])) withCancelBlock:nil withSureBlock:^{
                [UserDefaults removeObjectForKey:@"psd"];
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }else{
            [JHShowAlert showAlertWithMsg:json[@"message"]];
        }
    } failure:^(NSError *error) {
        [JHShowAlert showAlertWithMsg: NSLocalizedString(@"服务器繁忙,请稍后再试", NSStringFromClass([self class]))];
        NSLog(@"%@",error.localizedDescription);
    }];
}
#pragma mark - 这是点击获取验证码的方法
-(void)clickToGetSecurity{
    if (textField_phone.text.length == 0) {
        [JHShowAlert showAlertWithMsg: NSLocalizedString(@"请输入手机号码", NSStringFromClass([self class]))];
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:textField_phone.text forKey:@"SECURITY_MOBILE"];
    if ([btn.titleLabel.text isEqualToString: NSLocalizedString(@"获取验证码", NSStringFromClass([self class]))]||[btn.titleLabel.text isEqualToString: NSLocalizedString(@"重新获取", NSStringFromClass([self class]))]) {
        [HttpTool postWithAPI:@"magic/sendsms" withParams:@{@"mobile":textField_phone.text} success:^(id json) {
            NSLog(@"%@",json);
            if ([json[@"error"] isEqualToString:@"0"]) {
                
                if ([json[@"data"][@"sms_code"] isEqualToString:@"1"]) {
                    
                    //获取图形验证码
                    [HttpTool postWithAPI:@"magic/verify" withParams:@{} success:^(id json) {
                        
                        if(json){
                            [_control showSecurityViewWithBlock:^(NSString *result, NSString *code) {
                                [_control removeFromSuperview];
                                if ([result isEqualToString: NSLocalizedString(@"正确", NSStringFromClass([self class]))]) {
                                    [self creatNSTimer];
                                }
                                
                                
                            }];
                            [_control refesh:json];
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
    [btn setTitle:[NSString stringWithFormat: NSLocalizedString(@"还有%ldS", NSStringFromClass([self class])),num] forState:UIControlStateNormal];
    if (num == 0) {
        [self stopNSTimer];
        num = 61;
        [btn setBackgroundColor:THEME_COLOR];
        [btn setTitle: NSLocalizedString(@"重新获取", NSStringFromClass([self class])) forState:UIControlStateNormal];
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
