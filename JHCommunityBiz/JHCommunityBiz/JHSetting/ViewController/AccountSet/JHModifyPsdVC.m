//
//  JHModifyPhoneVC.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/18.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHModifyPsdVC.h"
#import <IQKeyboardManager.h>
#import "SecurityCode.h"
#import "XHCodeTF.h"
@interface JHModifyPsdVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *mainTableView;
@end

@implementation JHModifyPsdVC
{
    //新密码文本框
    UITextField *new_code_field;
    //验证码文本框
    UITextField *verifyField;
    //发送验证码按钮
    UIButton *sendVerifyBtn;
    NSTimer * timer;//定时器
    NSInteger num;//记录时间的
    SecurityCode * control;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    num = 61;
    self.navigationItem.title = NSLocalizedString(@"修改密码", nil);
    self.view.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
    //创建表视图
    [self createTableView];
    control = [[SecurityCode alloc]init];
}
#pragma mark - 创建表视图
- (void)createTableView
{
    _mainTableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, WIDTH, HEIGHT - 64)
                                                              style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:tableView];
        tableView.layoutMargins = UIEdgeInsetsZero;
        tableView.separatorInset = UIEdgeInsetsZero;
        tableView;
    });
    
}
#pragma mark - tableView delegate and dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 130;
    }
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    switch (row) {
        case 0:
        {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIImageView *phoneIV = [UIImageView new];
            [cell addSubview:phoneIV];
            [phoneIV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell).with.offset(20);
                make.width.equalTo(@60);
                make.height.equalTo(@60);
                make.centerX.equalTo(cell);
            }];
            phoneIV.image = IMAGE(@"install_phone-numbe");
            
            UILabel *contentLabel1 = [UILabel new];
            [cell addSubview:contentLabel1];
            [contentLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(phoneIV.mas_bottom).with.offset(10);
                make.width.equalTo(cell);
                make.bottom.equalTo(cell);
                make.centerX.equalTo(cell);
            }];
            contentLabel1.font = FONT(14);
            contentLabel1.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"您当前的手机号为", nil),[JHShareModel shareModel].mobile];
            contentLabel1.textAlignment = NSTextAlignmentCenter;
            contentLabel1.textColor = HEX(@"333333", 1.0);
            return cell;
            
        }
        case 1:
        {
            UITableViewCell *cell = [UITableViewCell new];
            cell.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (!verifyField) {
                verifyField = [[UITextField alloc] initWithFrame:FRAME(30, 5, WIDTH - 170, 40)];
                UIButton *leftbtn = [[UIButton alloc] initWithFrame:FRAME(0, 0, 30, 40)];
                [leftbtn setImage:IMAGE(@"login_input_password") forState:(UIControlStateNormal)];
                leftbtn.imageEdgeInsets = UIEdgeInsetsMake(10, 5, 10, 5);
                verifyField.leftViewMode = UITextFieldViewModeAlways;
                verifyField.leftView = leftbtn;
                verifyField.placeholder = NSLocalizedString(@"请输入验证码", nil);
                verifyField.layer.cornerRadius = 4;
                verifyField.layer.masksToBounds = YES;
                verifyField.layer.borderColor = LINE_COLOR.CGColor;
                verifyField.layer.borderWidth = 0.7;
                verifyField.backgroundColor = [UIColor whiteColor];
            }
            [cell addSubview:verifyField];
            //添加右侧发送验证码按钮
            if (!sendVerifyBtn) {
                sendVerifyBtn = [UIButton new];
                [sendVerifyBtn setBackgroundColor:THEME_COLOR forState:(UIControlStateNormal)];
                [sendVerifyBtn setTitle:NSLocalizedString(@"获取验证码", nil) forState:(UIControlStateNormal)];
                [sendVerifyBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
                sendVerifyBtn.titleLabel.font = FONT(15);
                sendVerifyBtn.layer.cornerRadius = 4;
                sendVerifyBtn.layer.masksToBounds = YES;
                [sendVerifyBtn addTarget:self action:@selector(sendVerifyMsg) forControlEvents:(UIControlEventTouchUpInside)];
            }
            
            [cell addSubview:sendVerifyBtn];
            [sendVerifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell).with.offset(5);
                make.bottom.equalTo(cell).with.offset(-5);
                make.width.mas_equalTo(@100);
                make.height.mas_equalTo(@40);
                make.centerX.equalTo(cell.mas_right).with.offset(-80);
            }];
            return cell;
        }
            break;
        case 2:
        {
            
            UITableViewCell *cell = [UITableViewCell new];
            cell.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //添加新手机号
            if (!new_code_field) {
                new_code_field = [[UITextField alloc] initWithFrame:FRAME(30, 5, WIDTH - 50, 40)];
                UIButton *leftbtn = [[UIButton alloc] initWithFrame:FRAME(0, 0, 30, 40)];
                [leftbtn setImage:IMAGE(@"login_input_code") forState:(UIControlStateNormal)];
                leftbtn.imageEdgeInsets = UIEdgeInsetsMake(10, 5, 10, 5);
                new_code_field.leftViewMode = UITextFieldViewModeAlways;
                new_code_field.leftView = leftbtn;
                new_code_field.placeholder = NSLocalizedString(@"请输入新密码", nil);
                new_code_field.layer.cornerRadius = 4;
                new_code_field.layer.masksToBounds = YES;
                new_code_field.layer.borderColor = LINE_COLOR.CGColor;
                new_code_field.layer.borderWidth = 0.7;
                new_code_field.backgroundColor = [UIColor whiteColor];
            }
            [cell addSubview:new_code_field];
            return cell;
        }
            break;
        default:
        {
            UITableViewCell *cell = [UITableViewCell new];
            cell.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIButton *sureBtn = [UIButton new];
            [cell addSubview:sureBtn];
            [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell).with.offset(10);
                make.bottom.equalTo(cell);
                make.left.equalTo(cell).with.offset(30);
                make.right.equalTo(cell).with.offset(-30);
                
            }];
            [sureBtn setBackgroundColor:HEX(@"faaf19", 1.0f) forState:(UIControlStateNormal)];
            [sureBtn setTitle:NSLocalizedString(@"完成", nil) forState:(UIControlStateNormal)];
            [sureBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
            sureBtn.layer.cornerRadius = 4;
            sureBtn.layer.masksToBounds = YES;
            sureBtn.titleLabel.font = FONT(15);
            [sureBtn addTarget:self action:@selector(clickSureBtn:) forControlEvents:(UIControlEventTouchUpInside)];
            return cell;
        }
            break;
    }
}
#pragma mark - 点击了发送验证码按钮
- (void)sendVerifyMsg
{
    [[NSUserDefaults standardUserDefaults] setObject:[JHShareModel shareModel].mobile forKey:@"SECURITY_MOBILE"];
    if ([sendVerifyBtn.titleLabel.text isEqualToString:NSLocalizedString(@"获取验证码", nil)]||[sendVerifyBtn.titleLabel.text isEqualToString:NSLocalizedString(@"重新获取", nil)]) {
       [HttpTool postWithAPI:@"magic/sendsms"
               withParams:@{@"mobile":[JHShareModel shareModel].mobile}
                  success:^(id json) {
                      NSLog(@"magic/sendsms---%@",json);
                      HIDE_HUD
                      if ([json[@"error"] isEqualToString:@"0"]) {
                          if ([json[@"data"][@"sms_code"] integerValue] == 1) {
                                  //获取图形验证码
                                  [HttpTool postWithAPI:@"magic/verify" withParams:@{} success:^(id json) {
                                      if(json){
                                          [control showSecurityViewWithBlock:^(NSString *result, NSString *code) {
                                              [control removeFromSuperview];
                                              if ([result isEqualToString:NSLocalizedString(@"正确", nil)]) {
                                                  [self creatNSTimer];
                                              }
                                              
                                              
                                          }];
                                          [control refesh:json];
                                      }else{
                                          [JHShowAlert showAlertWithMsg:NSLocalizedString(@"服务器繁忙,请稍后再试", nil)];
                                      }
                                      
                                      
                                  } failure:^(NSError *error) {
                                      [JHShowAlert showAlertWithMsg:NSLocalizedString(@"服务器繁忙,请稍后再试", nil)];
                                      NSLog(@"%@",error.localizedDescription);
                                  }];
                              
                             
                          }else{
                              [self creatNSTimer];
                          }
                          
                      }else{
                          [JHShowAlert showAlertWithMsg:json[@"message"]];
                      }
                      
                  } failure:^(NSError *error) {
                      HIDE_HUD
                      [JHShowAlert showAlertWithMsg:NSLocalizedString(@"服务器或网络异常", nil)];
                  }];
        }
}
#pragma mark - 点击了确认按钮
- (void)clickSureBtn:(UIButton *)sender
{
    NSString *new_passwd = new_code_field.text;
    NSString *sms_code = verifyField.text;
    if (new_passwd.length == 0 || sms_code.length == 0) {
        [JHShowAlert showAlertWithMsg:NSLocalizedString(@"请填写完整信息", nil)];
        return;
    }
    SHOW_HUD
    NSDictionary *paramsDic = @{@"new_passwd":new_passwd,
                                @"sms_code":sms_code};
    [HttpTool postWithAPI:@"biz/shop/shop/updatepasswd"
               withParams:paramsDic
                  success:^(id json) {
                      HIDE_HUD
                      if ([json[@"error"] isEqualToString:@"0"]) {
                          [[NSNotificationCenter defaultCenter] postNotificationName:@"KGetNewBizInfoNoti"
                                                                              object:nil];
                          //重新登录
                          [JHShowAlert showAlertWithTitle:NSLocalizedString(@"温馨提醒", nil)
                                              withMessage:NSLocalizedString(@"修改成功\n请使用新密码登陆", nil)
                                           withBtn_cancel:NSLocalizedString(@"确定", nil)
                                             withBtn_sure:nil
                                          withCancelBlock:^{
                                              [UserDefaults removeObjectForKey:@"token"];
                                              [UserDefaults removeObjectForKey:@"psd"];
                                              [self.navigationController popToRootViewControllerAnimated:YES];
                                          }
                                            withSureBlock:nil];
                          
                      }else{
                          
                          [JHShowAlert showAlertWithMsg:json[@"message"]];
                          
                      }
                      
                  } failure:^(NSError *error) {
                      HIDE_HUD
                      [JHShowAlert showAlertWithMsg:NSLocalizedString(@"服务器或网络异常", nil)];
                  }];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [sendVerifyBtn setTitle:[NSString stringWithFormat:@"%@%ldS",NSLocalizedString(@"还有", nil),num] forState:UIControlStateNormal];
    if (num == 0) {
        [self stopNSTimer];
        num = 61;
        [sendVerifyBtn setTitle:NSLocalizedString(@"重新获取", nil) forState:UIControlStateNormal];
        
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
