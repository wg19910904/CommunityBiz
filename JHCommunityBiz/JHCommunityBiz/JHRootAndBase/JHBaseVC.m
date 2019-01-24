//
//  JHBaseVC.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/9.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHBaseVC.h"
#import "DSToast.h"
#import "AppDelegate.h"
@interface JHBaseVC ()<UIGestureRecognizerDelegate>
{
    AppDelegate *_delegate;
}
@property(nonatomic,strong)DSToast *textToast;
@end

@implementation JHBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIControl * backView = [[UIControl alloc] initWithFrame:self.view.bounds];
    [backView addTarget:self action:@selector(touch_BackView) forControlEvents:UIControlEventTouchUpInside];
    self.view = backView;
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //创建左边的按纽
    [self createBackBtn];
    //判断是否需要隐藏左侧按钮
    [self judgeShowOrHidden];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"\n\n\n\n  %@ \n\n\n",NSStringFromClass(self.class));
}
//#pragma mark - 创建左边按钮
- (void)createBackBtn
{
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backBtn setFrame:CGRectMake(0, 0, 40, 40)];
    [self.backBtn addTarget:self action:@selector(clickBackBtn)
           forControlEvents:UIControlEventTouchUpInside];
    self.backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    [self.backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView: self.backBtn];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
}
#pragma mark--===用于提示信息
- (void)showToastAlertMessageWithTitle:(NSString *)title
{
    if (_textToast == nil) {
        _textToast = [[DSToast alloc] initWithText:title];
        _textToast.backgroundColor = HEX(@"000000", 0.7);
        _textToast.textColor = [UIColor whiteColor];
        __weak typeof(self) weakSelf=self;
        [_textToast showInView:_delegate.window showType:DSToastShowTypeCenter withBlock:^{
            weakSelf.textToast = nil;
        }];
    }
}
#pragma mark - 判断是否需要隐藏左侧按钮
- (void)judgeShowOrHidden
{
    UINavigationController *self_nav = self.navigationController;
    if (self_nav && self_nav.viewControllers[0] == self) {
        self.backBtn.hidden = YES;
    }
}
#pragma mark - 点击导航栏左按钮
- (void)clickBackBtn
{
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *  点击背景的事件
 */
- (void)touch_BackView
{
    //在不同界面按需执行代码
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
