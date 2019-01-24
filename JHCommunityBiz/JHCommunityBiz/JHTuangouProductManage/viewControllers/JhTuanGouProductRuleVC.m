//
//  JHPublicNotiVC.m
//  WaimaiShop
//
//  Created by xixixi on 16/1/11.
//  Copyright © 2016年 ijianghu. All rights reserved.
//

#import "JhTuanGouProductRuleVC.h"

@interface JhTuanGouProductRuleVC ()<UIAlertViewDelegate,UITextViewDelegate>
@end
@implementation JhTuanGouProductRuleVC
{
    NSDictionary  *bizInfo;
    UITextView *_ruleTV;
    UITextView * textV;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化必要信息
    [self initData];
    //添加公告视图
    [self addNotiView];
    //创建修改按钮
    [self addModifyBtn];
    
}
#pragma mark - initData
- (void)initData
{
    self.view.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
    self.title = NSLocalizedString(@"公告管理", nil);
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToEndEdeting)];
    [self.view addGestureRecognizer:tapGesture];
}
#pragma mark - 点击屏幕下落的方法
-(void)clickToEndEdeting{
    [self.view endEditing:YES];
}
#pragma mark - 添加子视图
- (void)addNotiView
{
    _ruleTV = ({
        UITextView *textTV = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, WIDTH - 20, 200)];
        textTV.textColor = [UIColor colorWithHex:@"333333" alpha:1.0];
        textTV.layer.borderColor = LINE_COLOR.CGColor;
        textTV.layer.masksToBounds = YES;
        textTV.layer.borderWidth = 1.0;
        textTV.layer.cornerRadius = 6;
        textTV.font = FONT(15);
        textTV.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
        textTV.text = NSLocalizedString(@"请输入使用规则描述", nil);
        textTV.textColor = [UIColor colorWithWhite:0.5 alpha:1];
        textV = textTV;
        textTV.delegate = self;
        textTV;
    });
    if (self.notice) {
         textV.text = self.notice;
    }
    [self.view addSubview:_ruleTV];
}
#pragma mark - 创建修改按钮
- (void)addModifyBtn
{
    UIButton *modifyBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 230, WIDTH - 20, 40)];
    [modifyBtn setBackgroundColor:HEX(@"faaf19", 1.0) forState:UIControlStateNormal];
    [modifyBtn setTitle:NSLocalizedString(@"保存", nil) forState:UIControlStateNormal];
    [modifyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [modifyBtn addTarget:self action:@selector(clickModifyBtn:) forControlEvents:UIControlEventTouchUpInside];
    modifyBtn.titleLabel.font = FONT(18);
    modifyBtn.layer.cornerRadius = 4;
    modifyBtn.layer.masksToBounds = YES;
    [self.view addSubview:modifyBtn];
}
#pragma mark - 点击底部确认添加按钮
- (void)clickModifyBtn:(UIButton *)sender
{
    [self.view endEditing:YES];
    if ([textV.text isEqualToString:NSLocalizedString(@"请输入使用规则描述", nil)]) {
        [JHShowAlert showAlertWithMsg:NSLocalizedString(@"您还没有输入规则描述", nil)];
        return;
    }
    SHOW_HUD
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        HIDE_HUD
        [self.navigationController popViewControllerAnimated:YES];
    });
    
    if (self.block) {
        self.block(textV.text);
    }
}
#pragma mark - 提醒弹窗
- (void)showAlertWithMsg:(NSString *)msg
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提醒", nil)
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
#pragma mark - 这是textView的代理方法
- (void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text  isEqualToString:NSLocalizedString(@"请输入使用规则描述", nil)]) {
        textView.text = nil;
        textView.textColor = [UIColor colorWithWhite:0.3 alpha:1];
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length == 0) {
        textView.textColor = [UIColor colorWithWhite:0.5 alpha:1];
        textView.text = NSLocalizedString(@"请输入使用规则描述", nil);
    }
}
@end
