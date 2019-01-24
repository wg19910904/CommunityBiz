//
//  JHPublicNotiVC.m
//  WaimaiShop
//
//  Created by xixixi on 16/1/11.
//  Copyright © 2016年 ijianghu. All rights reserved.
//

#import "JHPublicNotiVC.h"
@interface JHPublicNotiVC ()<UIAlertViewDelegate>
@end
@implementation JHPublicNotiVC
{
    NSDictionary  * bizInfo;
    UITextView * _notiTV;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化必要信息
    [self initData];
    //添加公告视图
    [self addNotiView];
    //创建修改按钮
    [self addModifyBtn];
    [self getNotiInfo];
    
}
#pragma mark - initData
- (void)initData
{
    self.view.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
    self.title = NSLocalizedString(@"公告管理", nil);

}
#pragma mark - 添加子视图
- (void)addNotiView

{   NSString * str = [JHShareModel shareModel].infoDictionary[@"info"];
    _notiTV = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, WIDTH - 20, 150)];
    _notiTV.textColor = [UIColor colorWithHex:@"333333" alpha:1.0];
    _notiTV.layer.borderColor = LINE_COLOR.CGColor;
    _notiTV.layer.masksToBounds = YES;
    _notiTV.layer.borderWidth = 1.0;
    _notiTV.layer.cornerRadius = 6;
    _notiTV.font = FONT(15);
    _notiTV.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    if (str.length > 0) {
        _notiTV.text = str;
    }
    [self.view addSubview:_notiTV];
}
#pragma mark - 创建修改按钮
- (void)addModifyBtn
{
    UIButton *modifyBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 180, WIDTH - 20, 40)];
    [modifyBtn setBackgroundColor:HEX(@"faaf19", 1.0) forState:UIControlStateNormal];
    [modifyBtn setTitle:NSLocalizedString(@"保存", nil) forState:UIControlStateNormal];
    [modifyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [modifyBtn addTarget:self action:@selector(clickModifyBtn:) forControlEvents:UIControlEventTouchUpInside];
    modifyBtn.titleLabel.font = FONT(18);
    modifyBtn.layer.cornerRadius = 4;
    modifyBtn.layer.masksToBounds = YES;
    [self.view addSubview:modifyBtn];
}
- (void)getNotiInfo
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
    });
}
#pragma mark - 点击底部确认添加按钮
- (void)clickModifyBtn:(UIButton *)sender
{
    if (_notiTV.text.length == 0) {
        [JHShowAlert showAlertWithMsg:NSLocalizedString(@"请输入公告", nil)];
        return;
    }
    [self.view endEditing:YES];
    SHOW_HUD
    [HttpTool postWithAPI:@"biz/shop/shop/set_info" withParams:@{@"info":_notiTV.text} success:^(id json) {
        if ([json[@"error"] isEqualToString:@"0"]) {
            [JHShowAlert showAlertWithMsg:NSLocalizedString(@"设置成功", nil) withBtnTitle:NSLocalizedString(@"知道了", nil) withBtnBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }else{
            [JHShowAlert showAlertWithMsg:json[@"message"]];
        }
        HIDE_HUD
    } failure:^(NSError *error) {
        HIDE_HUD
        [JHShowAlert showAlertWithMsg:NSLocalizedString(@"服务器繁忙,请稍后再试", nil)];
        NSLog(@"%@",error.localizedDescription);
    }];
}
#pragma mark - 提醒弹窗
- (void)showAlertWithMsg:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"温馨提示", nil)
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                          otherButtonTitles:nil];
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.message isEqualToString:NSLocalizedString(@"修改成功", nil)]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
