//
//  JHShopOpenSuccessVC.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/20.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHShopOpenSuccessVC.h"
#import "OrderListMainVC.h"
#import "JHHomePageVC.h"
#import "JHNewCapitalVC.h"
#import "JHBaseNavVC.h"
@interface JHShopOpenSuccessVC ()<UITextFieldDelegate>
{
    UITextField * myTextField;
}
@end

@implementation JHShopOpenSuccessVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [UserDefaults removeObjectForKey:@"psd"];
    [UserDefaults removeObjectForKey:@"mobile"];
    //初始化一些数据
    [self initData];
    //创建子控件
    [self creatSubControl];
}
-(void)clickBackBtn{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark - 初始化一些数据
-(void)initData{
    self.view.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
   self.navigationItem.title =  NSLocalizedString(@"我要开店", NSStringFromClass([self class]));
}
#pragma mark - 这是创建子控件的方法
-(void)creatSubControl{
    //显示成功的图标的
    UIImageView * imageView = [[UIImageView alloc]init];
    imageView.frame = FRAME((WIDTH - 40)/2, 18, 40, 40);
    imageView.image = [UIImage imageNamed:@"Logon_success"];
    [self.view addSubview:imageView];
    //显示账号申请成功的提示
    UILabel * label = [[UILabel alloc]init];
    label.frame = FRAME(0, 68, WIDTH, 20);
    label.text =  NSLocalizedString(@"申请成功,您的账号为:", NSStringFromClass([self class]));
    label.textColor = [UIColor colorWithRed:102/255.0 green:204/255.0 blue:33/255.0 alpha:1];
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    //显示账号的
    UILabel * label_mobile = [[UILabel alloc]init];
    label_mobile.frame = FRAME(0, 100, WIDTH, 20);
    label_mobile.textColor = THEME_COLOR;
    label_mobile.text = self.phone;
    label_mobile.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label_mobile];
    //创建输入密码的输入框
    myTextField = [[UITextField alloc]init];
    myTextField.frame = FRAME(30, 150, WIDTH - 60, 40);
    myTextField.placeholder =  NSLocalizedString(@"请输入密码", NSStringFromClass([self class]));
    myTextField.layer.cornerRadius = 3;
    myTextField.layer.masksToBounds = YES;
    myTextField.secureTextEntry = YES;
    myTextField.delegate = self;
    myTextField.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:1].CGColor;
    myTextField.layer.borderWidth = 0.5;
    myTextField.backgroundColor = [UIColor whiteColor];
    myTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:myTextField];
    UIView * view = [UIView new];
    //view.backgroundColor = THEME_COLOR;
    view.frame = FRAME(0, 0, 40, 40);
    myTextField.leftView = view;
    UIImageView * imageV = [[UIImageView alloc]init];
    imageV.frame = FRAME(5, 5, 30, 30);
    imageV.image = [UIImage imageNamed:@"login_input_password"];
    [view addSubview:imageV];
    //创建了button
    UIButton * btn = [[UIButton alloc]init];
    btn.frame = FRAME(30, 220, WIDTH - 60, 45);
    [btn setTitle: NSLocalizedString(@"登录", NSStringFromClass([self class])) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:17];
    btn.layer.cornerRadius = 3;
    btn.layer.masksToBounds = YES;
    [btn setBackgroundColor:[UIColor colorWithRed:250/255.0 green:175/255.0 blue:25/255.0 alpha:1] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor colorWithRed:250/255.0 green:175/255.0 blue:25/255.0 alpha:0.5] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(clickToLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}
-(void)touch_BackView{
     [self.view endEditing:YES];
}
#pragma mark - 这是点击登录的方法
-(void)clickToLogin{
    NSLog(@"这是点击登录的按钮");
    if (myTextField.text.length == 0) {
        [JHShowAlert showAlertWithMsg: NSLocalizedString(@"请输入密码", NSStringFromClass([self class]))];
        return;
    }
    SHOW_HUD
    [HttpTool postWithAPI:@"biz/account/login" withParams:@{@"mobile":self.phone,@"passwd":myTextField.text,@"register_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"registrationID"]? [[NSUserDefaults standardUserDefaults] objectForKey:@"registrationID"]:@""}
                  success:^(id json) {
                      NSLog(@"%@",json);
                      if ([json[@"error"] isEqualToString:@"0"]) {
                          HIDE_HUD
                          [self jumpToTabbar];
                          //将用户信息存入沙盒
                          [UserDefaults setObject:json[@"data"][@"logo"] forKey:@"logo"];
                          [UserDefaults setObject:json[@"data"][@"mobile"] forKey:@"mobile"];
                          [UserDefaults setObject:json[@"data"][@"money"] forKey:@"money"];
                          [UserDefaults setObject:json[@"data"][@"shop_id"] forKey:@"shop_id"];
                          [UserDefaults setObject:json[@"data"][@"title"] forKey:@"title"];
                          [UserDefaults setObject:json[@"data"][@"token"] forKey:@"token"];
                          [UserDefaults setObject:myTextField.text forKey:@"psd"];
                          [UserDefaults synchronize];
                          [JHShareModel shareModel].contact = json[@"data"][@"contact"];
                      }else{
                          HIDE_HUD
                          [JHShowAlert showAlertWithTitle: NSLocalizedString(@"温馨提示", NSStringFromClass([self class])) withMessage:json[@"message"] withBtn_cancel:nil withBtn_sure: NSLocalizedString(@"知道了", NSStringFromClass([self class])) withCancelBlock:nil withSureBlock:nil];
                      }
                  } failure:^(NSError *error) {
                          HIDE_HUD
                      NSLog(@"%@",error.localizedDescription);
                      [JHShowAlert showAlertWithTitle: NSLocalizedString(@"温馨提示", NSStringFromClass([self class])) withMessage: NSLocalizedString(@"服务器繁忙,请稍后访问", NSStringFromClass([self class])) withBtn_cancel:nil withBtn_sure: NSLocalizedString(@"知道了", NSStringFromClass([self class])) withCancelBlock:nil
                                        withSureBlock:nil];
    }];
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
