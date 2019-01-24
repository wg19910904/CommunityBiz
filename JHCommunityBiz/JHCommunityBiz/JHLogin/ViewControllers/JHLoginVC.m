//
//  JHLoginViewController.m
//  JHCommunityStaff
//
//  Created by jianghu on 2018/2/10.
//  Copyright © 2018年 jianghu2. All rights reserved.
//

#import "JHLoginVC.h"
#import "UIButton+BackgroundColor.h"
#import "JHOpenShopVC.h"
#import "JHForgetterPsdVC.h"
#import "HttpTool.h"
#import "JHShowAlert.h"
#import "OrderListMainVC.h"
#import "JHHomePageVC.h"
#import "JHNewCapitalVC.h"
#import "JHBaseNavVC.h"
#import "JHShareModel.h"
#import "JHShowAlert.h"
#import "XHCodeTF.h"
@interface JHLoginVC (){
    XHCodeTF *phoneF;
    UITextField *keyF;
    UILabel *titleL;
    UIButton *loginBtn;
    UIButton *forgetKeyBtn;
    UIButton *applyBtn;
    UIControl *_backView;
}

@end

@implementation JHLoginVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"psd"]);
    phoneF.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"mobile"];
    keyF.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"psd"]?[[NSUserDefaults standardUserDefaults]objectForKey:@"psd"]:@"";
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"登录",nil);
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.hidden = YES;
    
    if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"token"] length]) {
        [self jumpToTabbar];
    }
    [self getDefaultCode];
    [self setupUI];
}
- (void)getDefaultCode{
    SHOW_HUD
    [HttpTool postWithAPI:@"magic/get_default_code"
               withParams:@{}
                  success:^(id json) {
                      HIDE_HUD
                      NSLog(@"magic/get_default_code------------%@",json);
                      if ([json[@"error"] isEqualToString:@"0"]) {
                          NSString *def_code = json[@"data"][@"code_code"];
                          [JHShareModel shareModel].def_code = def_code;
                          [phoneF setShowCode:SHOW_COUNTRY_CODE];
                      }
                  } failure:^(NSError *error) {
                      HIDE_HUD
                  }];
}
-(void)setupUI{
    self.backBtn.hidden = YES;
    
    UIImageView * backImg =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    backImg.image = [UIImage imageNamed:@"bg_login"];
    [self.view addSubview:backImg];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEdit)];
    [backImg addGestureRecognizer:tap];
    backImg.userInteractionEnabled = YES;
    
    CGFloat origin_y ;
    [UIScreen mainScreen].currentMode.size.width >= 768 ? ({origin_y=20;}) : ({origin_y = 120;});
    
    titleL = [[UILabel alloc]initWithFrame:FRAME((WIDTH- 120)/2, origin_y, 120, 36)];
    titleL.font = [UIFont fontWithName:@"PingFangSC-Regular" size:36];
    titleL.text = NSLocalizedString(@"商户端",nil);
    titleL.textColor = HEX(@"FFFFFF", 1);
    [self.view addSubview:titleL];
    
    UIView *phoneV = [[UIView alloc] init];
    phoneV.layer.borderWidth = 1.0;
    phoneV.layer.borderColor = HEX(@"FFFFFF", 1).CGColor;
    phoneV.layer.cornerRadius = 4;
    phoneV.clipsToBounds = YES;
    [self.view addSubview:phoneV];
    [phoneV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = -30;
        make.left.offset = 30;
        make.top.equalTo(titleL.mas_bottom).offset = 80;
        make.height.offset = 50;
    }];
    phoneF = [[XHCodeTF alloc]init];
    [phoneV addSubview:phoneF];
    [phoneF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 50;
        make.right.top.bottom.offset = 0;
    }];
    phoneF.placeholder =NSLocalizedString(@"请输入手机号",nil);
    phoneF.backgroundColor = [UIColor clearColor];
    phoneF.textColor  = HEX(@"FFFFFF", 1);
    phoneF.keyboardType = UIKeyboardTypeNumberPad;
    phoneF.clipsToBounds = YES;
    phoneF.clearButtonMode = UITextFieldViewModeWhileEditing;
    phoneF.showCode = SHOW_COUNTRY_CODE;
    __weak typeof(self)weakself = self;
    phoneF.fatherVC = weakself;
    
    UIButton *phoneLeftImg = [[UIButton alloc]initWithFrame:FRAME(0, 13, 50, 24)];
    [phoneLeftImg setImage:[UIImage imageNamed:@"icon_user"] forState:0];
    phoneLeftImg.userInteractionEnabled = NO;
    [phoneV addSubview:phoneLeftImg];
   
    
    UIButton *phoneRightImg = [[UIButton alloc]initWithFrame:FRAME(phoneF.bounds.size.width - 50, 13, 50, 24)];
    [phoneRightImg setImage:[UIImage imageNamed:@"btn_reset"] forState:0];
    [phoneRightImg addTarget:self action:@selector(phoneRightImgClick) forControlEvents:UIControlEventTouchUpInside];
    phoneF.rightView = phoneRightImg;
    phoneF.rightViewMode = UITextFieldViewModeWhileEditing;
    
    keyF = [[UITextField alloc]init];
    [self.view addSubview:keyF];
    [keyF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = -30;
        make.left.offset = 30;
        make.top.equalTo(phoneF.mas_bottom).offset = 20;
        make.height.offset = 50;
    }];
    keyF.placeholder =NSLocalizedString(@"请输入登录密码",nil);
    keyF.backgroundColor = [UIColor clearColor];
    keyF.textColor = HEX(@"FFFFFF", 1);
    keyF.secureTextEntry = YES;
    keyF.layer.cornerRadius = 4;
    keyF.clipsToBounds = YES;
    keyF.layer.borderWidth = 1.0;
    keyF.layer.borderColor = HEX(@"FFFFFF", 1).CGColor;
    UIButton *keyLeftImg = [[UIButton alloc]initWithFrame:FRAME(16, 13, 50, 24)];
    [keyLeftImg setImage:[UIImage imageNamed:@"icon_password"] forState:0];
    keyLeftImg.userInteractionEnabled = NO;
    keyF.leftView = keyLeftImg;
    keyF.leftViewMode = UITextFieldViewModeAlways;
    keyF.clearButtonMode = UITextFieldViewModeWhileEditing;
    UIButton *keyRightImg = [[UIButton alloc]initWithFrame:FRAME(keyF.bounds.size.width - 50, 13, 50, 24)];
    [keyRightImg setImage:[UIImage imageNamed:@"icon_nosee"] forState:UIControlStateSelected];
    [keyRightImg setImage:[UIImage imageNamed:@"icon_see"] forState:0];
    [keyRightImg addTarget:self action:@selector(keyRightImgClick:) forControlEvents:UIControlEventTouchUpInside];
    keyF.rightView = keyRightImg;
    keyF.rightViewMode = UITextFieldViewModeWhileEditing;
    
    loginBtn = [[UIButton alloc]init];
    [self.view addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = -30;
        make.left.offset = 30;
        make.top.equalTo(keyF.mas_bottom).offset = 30;
        make.height.offset = 50;
    }];
    [loginBtn setTitle:NSLocalizedString(@"登录",nil) forState:0];
    loginBtn.layer.cornerRadius = 4;
    //    loginBtn.clipsToBounds = YES;
    loginBtn.titleLabel.font = FONT(20);
    loginBtn.backgroundColor = HEX(@"FFFFFF", 1);
    //    [loginBtn setTintColor:HEX(@"00B1F7", 1)];
    [loginBtn setTitleColor:HEX(@"00B1F7", 1) forState:0];
    [loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];

    forgetKeyBtn = [[UIButton alloc]init];
    [self.view addSubview:forgetKeyBtn];
    [forgetKeyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = -(WIDTH -100)/2;
        make.left.offset = (WIDTH -100)/2;
        make.top.equalTo(loginBtn.mas_bottom).offset = 30;
        make.height.offset = 20;
    }];
    [forgetKeyBtn setTitle:NSLocalizedString(@"忘记密码?",nil) forState:0];
    forgetKeyBtn.backgroundColor = [UIColor clearColor];
    [forgetKeyBtn setTitleColor:HEX(@"FFFFFF", 1) forState:0];
    forgetKeyBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    forgetKeyBtn.titleLabel.font = FONT(16);
    [forgetKeyBtn addTarget:self action:@selector(forgetKeyClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    applyBtn = [[UIButton alloc]init];
    [self.view addSubview:applyBtn];
    [applyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = -(WIDTH -100)/2;
        make.left.offset = (WIDTH -100)/2;
        make.bottom.offset = -48;
        make.height.offset = 20;
    }];
    [applyBtn setTitle:NSLocalizedString(@"申请入驻>>",nil) forState:0];
    applyBtn.backgroundColor = [UIColor clearColor];
    [applyBtn setTitleColor:HEX(@"FFFFFF", 1) forState:0];
    applyBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    applyBtn.titleLabel.font = FONT(18);
    [applyBtn addTarget:self action:@selector(applyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
}

#pragma mark======添加通知==========
- (void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changePassword) name:@"changePassword" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeMobile) name:@"changeMobile" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changePassword) name:@"FindPassword" object:nil];
}

#pragma mark========UITextFieldDelegate=========
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return  YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    if(textField == phoneF){
        keyF.text = @"";
    }
    return  YES;
}
#pragma mark===修改手机号======
- (void)changeMobile{
    phoneF.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
}
#pragma mark =======修改密码和找回密码========
- (void)changePassword{
    keyF.text = @"";
}

#pragma mark -点击登录
-(void)loginBtnClick{
    [self.view endEditing:YES];
    if (phoneF.text.length == 0) {
        [JHShowAlert showAlertWithMsg: NSLocalizedString(@"请输入用户名", NSStringFromClass([self class]))];
        return;
    }
    if (keyF.text.length == 0) {
        [JHShowAlert showAlertWithMsg: NSLocalizedString(@"请输入密码", NSStringFromClass([self class]))];
        return;
    }
    SHOW_HUD
    [HttpTool postWithAPI:@"biz/account/login" withParams:@{@"mobile":phoneF.text,@"passwd":keyF.text,@"register_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"registrationID"]? [[NSUserDefaults standardUserDefaults] objectForKey:@"registrationID"]:@""}
                  success:^(id json) {
                      NSLog(@"%@",json);
                      if ([json[@"error"] isEqualToString:@"0"]) {
                          HIDE_HUD
                          [self jumpToTabbar];
                          //将用户信息存入沙盒
                          [UserDefaults setObject:json[@"data"][@"logo"] forKey:@"logo"];
                          NSString *mobile = [[json[@"data"][@"mobile"] componentsSeparatedByString:@"-"] lastObject];
                          [UserDefaults setObject:mobile forKey:@"mobile"];
                          [UserDefaults setObject:json[@"data"][@"money"] forKey:@"money"];
                          [UserDefaults setObject:json[@"data"][@"shop_id"] forKey:@"shop_id"];
                          [UserDefaults setObject:json[@"data"][@"title"] forKey:@"title"];
                          [UserDefaults setObject:json[@"data"][@"token"] forKey:@"token"];
                          [UserDefaults setObject:keyF.text forKey:@"psd"];
                          [UserDefaults synchronize];
                          [JHShareModel shareModel].contact = json[@"data"][@"contact"];
                      }else{
                          HIDE_HUD
                          [JHShowAlert showAlertWithTitle: NSLocalizedString(@"温馨提示", NSStringFromClass([self class])) withMessage:json[@"message"] withBtn_cancel:nil withBtn_sure: NSLocalizedString(@"知道了", NSStringFromClass([self class])) withCancelBlock:nil withSureBlock:nil];
                      }
                  } failure:^(NSError *error) {
                      HIDE_HUD
                      NSLog(@"%@",error.localizedDescription);
                      [JHShowAlert showAlertWithTitle: NSLocalizedString(@"温馨提示", NSStringFromClass([self class])) withMessage: NSLocalizedString(@"服务器繁忙,请稍后登录", NSStringFromClass([self class])) withBtn_cancel:nil withBtn_sure: NSLocalizedString(@"知道了", NSStringFromClass([self class])) withCancelBlock:nil
                                        withSureBlock:nil];
                  }];
    
}
#pragma mark -忘记密码
-(void)forgetKeyClick{
    JHForgetterPsdVC * vc = [[JHForgetterPsdVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -申请入驻
-(void)applyBtnClick{
    JHOpenShopVC * vc = [[JHOpenShopVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -清除按钮
-(void)phoneRightImgClick{
    phoneF.text = @"";
}
-(void)keyRightImgClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    if(sender.selected){
        keyF.secureTextEntry = NO;
    }else{
        keyF.secureTextEntry = YES;
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)endEdit{
    [self.view endEditing:YES];
}

#pragma mark - 登录后需要跳转的控制器
-(void)jumpToTabbar{
    JHHomePageVC *vc1 = [[JHHomePageVC alloc]init];
    vc1.title =  NSLocalizedString(@"首页", NSStringFromClass([self class]));
    [vc1.tabBarItem setImage:RenderingImage(@"tabbar01")];
    [vc1.tabBarItem setSelectedImage:RenderingImage(@"tabbar01_pre")];
    JHBaseNavVC *nav1 = [[JHBaseNavVC alloc]initWithRootViewController:vc1];
    OrderListMainVC *vc2 = [[OrderListMainVC alloc]init];
    vc2.title =  NSLocalizedString(@"订单", NSStringFromClass([self class]));
    [vc2.tabBarItem setImage:RenderingImage(@"tabbar02")];
    [vc2.tabBarItem setSelectedImage:RenderingImage(@"tabbar02_pre")];
    JHBaseNavVC *nav2 = [[JHBaseNavVC alloc]initWithRootViewController:vc2];
    JHNewCapitalVC *vc3 = [[JHNewCapitalVC alloc]init];
    vc3.title =  NSLocalizedString(@"资金", NSStringFromClass([self class]));
    [vc3.tabBarItem setImage:RenderingImage(@"tabbar03")];
    [vc3.tabBarItem setSelectedImage:RenderingImage(@"tabbar03_pre")];
    JHBaseNavVC *nav3 = [[JHBaseNavVC alloc]initWithRootViewController:vc3];
    UITabBarController *tabbar = [[UITabBarController alloc]init];
    tabbar.viewControllers = @[nav1,nav2,nav3];
    tabbar.tabBar.tintColor = HEX(@"2f3569", 1);
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    window.rootViewController = tabbar;
}
@end

