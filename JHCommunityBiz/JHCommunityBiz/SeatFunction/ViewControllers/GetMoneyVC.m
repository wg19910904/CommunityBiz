//
//  GetMoneyVC.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/9/29.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "GetMoneyVC.h"
#import "MoneyRecordVC.h"
#import "PayWithQRCodeVC.h"
#import "UILabel+XHTool.h"
#import "XHQRCodeVC.h"
#import "PayResultVC.h"
#import "GetMoneyInputCell.h"
#import <IQKeyboardManager.h>
#import "QRNewCodeVC.h"
#import "QRCodeListVC.h"
/*
@interface GetMoneyVC ()
@property(nonatomic,retain)UIBarButtonItem * rightButton;//收款记录
@property(nonatomic,strong)UITextField  *moneyF;//输入收款金额
@property(nonatomic,strong)UITextField  *noteF;//输入收款金额
@end

@implementation GetMoneyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //这是初始化一些数据的方法
    [self initData];
    //添加输入金额的输入框
    [self.view addSubview:self.moneyF];
    [self.view addSubview:self.noteF];
    [self addPayWayBtn];
}

#pragma mark - 这是初始化一些数据的方法
-(void)initData{
    self.navigationItem.title = NSLocalizedString(@"收款", nil);
    self.view.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
    self.navigationItem.rightBarButtonItem = self.rightButton;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}
-(void)touch_BackView{
    [self.view endEditing:YES];
}
#pragma mark - 这是创建右边的查看记录的按钮
-(UIBarButtonItem *)rightButton{
    if (!_rightButton) {
        _rightButton = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"收款记录", nil) style:UIBarButtonItemStylePlain target:self action:@selector(clickGetMoneyRecorder)];
    }
    return _rightButton;
}
#pragma mark - 这是点击右边的按钮的方法
-(void)clickGetMoneyRecorder{
    //点击的是收款记录
    MoneyRecordVC * vc = [[MoneyRecordVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 这是创建输入金额的输入框
-(UITextField *)moneyF{
    if (!_moneyF) {
        _moneyF = [[UITextField alloc]init];
        _moneyF.frame = FRAME(0, 10, WIDTH, 44);
        _moneyF.backgroundColor = [UIColor whiteColor];
        _moneyF.placeholder = NSLocalizedString(@"请输入收款金额", nil);
        _moneyF.font = FONT(14);
        _moneyF.keyboardType =  UIKeyboardTypeDecimalPad;
        _moneyF.leftViewMode = UITextFieldViewModeAlways;
        UILabel * label_title = [[UILabel alloc]init];
        label_title.frame = FRAME(5, 0, 50, 44);
        label_title.text = @"*金额";
        label_title.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        [label_title setColor:HEX(@"ff0000", 1.0) string:@"*"];
        label_title.font = FONT(14);
        label_title.textAlignment = NSTextAlignmentCenter;
        _moneyF.leftView = label_title;
    }
    return _moneyF;
}
#pragma mark - 这是创建输入金额的输入框
-(UITextField *)noteF{
    if (!_noteF) {
        _noteF = [[UITextField alloc]init];
        _noteF.frame = FRAME(0, 54, WIDTH, 44);
        _noteF.backgroundColor = [UIColor whiteColor];
        _noteF.placeholder = NSLocalizedString(@"请添加备注信息", nil);
        _noteF.font = FONT(14);
        _noteF.leftViewMode = UITextFieldViewModeAlways;
        UILabel * label_title = [[UILabel alloc]init];
        label_title.frame = FRAME(5, 0, 50, 44);
        label_title.text = NSLocalizedString(@"备注", nil);
        label_title.font = FONT(14);
        label_title.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        label_title.textAlignment = NSTextAlignmentCenter;
        _noteF.leftView = label_title;
    }
    return _noteF;
}

- (void)addPayWayBtn{
    NSArray *imgArr = @[IMAGE(@"pay01"),IMAGE(@"pay02")];
    NSArray *titleArr = @[NSLocalizedString(@"支付宝支付", nil),NSLocalizedString(@"微信支付", nil)];
    for (int i = 0; i < 2; i++) {
        UIButton *btn = [[UIButton alloc ] initWithFrame:FRAME(10+((WIDTH-30)/2+10)*i,109,(WIDTH-30)/2,120)];
        [btn setBackgroundColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [btn setBackgroundColor:HEX(@"e6e6e6", 0.5) forState:(UIControlStateHighlighted)];
        [btn setImage:imgArr[i] forState:(UIControlStateNormal)];
        [btn setTitle:titleArr[i] forState:(UIControlStateNormal)];
        [btn setTitleColor:HEX(@"333333", 1.0) forState:(UIControlStateNormal)];
        btn.titleLabel.font = FONT(14);
        // 按钮图片和标题总高度
        CGFloat totalHeight = (btn.imageView.frame.size.height + btn.titleLabel.frame.size.height) + 15;
        // 设置按钮图片偏移
        [btn setImageEdgeInsets:UIEdgeInsetsMake(-(totalHeight - btn.imageView.frame.size.height), 0.0, 0.0, -btn.titleLabel.frame.size.width)];
        // 设置按钮标题偏移
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -btn.imageView.frame.size.width, -(totalHeight - btn.titleLabel.frame.size.height),0.0)];
        [self.view addSubview:btn];
        
        btn.tag = 100+i;
        [btn addTarget:self action:@selector(clickToBecomeQRRcode:) forControlEvents:(UIControlEventTouchUpInside)];
    }
}

-(void)clickToBecomeQRRcode:(UIButton *)sender{
    if (self.moneyF.text.length == 0) {
        [JHShowAlert showAlertWithMsg:NSLocalizedString(@"请先输入支付金额", nil)];
        return;
    }
    [self.view endEditing:YES];
    [self postHttpGetAlipayOrWeiChatWithMoney:_moneyF.text withTag:sender.tag];
}


#pragma mark - 获取支付宝和微信的支付信息
-(void)postHttpGetAlipayOrWeiChatWithMoney:(NSString *)money withTag:(NSUInteger)tag {
    SHOW_HUD
    NSUInteger type = tag - 100;
    [HttpTool postWithAPI:@"biz/cashier/create" withParams:@{@"amount":money,
                                                             @"note":_noteF.text?_noteF.text:@""}
     
                  success:^(id json) {
        NSLog(@"json:%@",json);
        HIDE_HUD
        [self.view endEditing:YES];
        if ([json[@"error"] isEqualToString:@"0"]) {
            _moneyF.text = @"";
            XHQRCodeVC * vc = [[XHQRCodeVC alloc]init];
            vc.type = (type == 0)?@"alipay":@"wxpay";
            vc.weiChat_str = json[@"data"][@"wx_url"];
            vc.alipay_str = json[@"data"][@"ali_url"];
            vc.trade_no = json[@"data"][@"trade_no"];
            vc.amout = money;
            [vc setCompletionWithBlock:^(NSString *resultAsString,NSString *type) {
                NSLog(@"%@",resultAsString);
                PayResultVC *vc = [[PayResultVC alloc]init];
                vc.amount = money;
                vc.auth_code = resultAsString;
                vc.trade_no = json[@"data"][@"trade_no"];
                vc.type = type;
                [self.navigationController pushViewController:vc animated:YES];
            }];

            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [JHShowAlert showAlertWithMsg:json[@"message"]];
        }
    } failure:^(NSError *error) {
        HIDE_HUD
        [JHShowAlert showAlertWithMsg:NSLocalizedString(@"网络连接有问题,请检查网络连接", nil)];
        [self.view endEditing:YES];
         NSLog(@"error:%@",error.localizedDescription);
    }];
}
@end
 */
@interface GetMoneyVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property(nonatomic,retain)UIBarButtonItem * rightButton;//收款记录
@property(nonatomic,strong)UIButton *buttomBtn;//底部的按钮
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,weak)UITextField *moneyT;//金额的输入框
@property(nonatomic,weak)UITextField *rensonT;//原因的输入框
@end
@implementation GetMoneyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //这是初始化一些数据的方法
    [self initData];
    //添加底部的按钮
    [self buttomBtn];
    //添加表的方法
    [self tableView];
}
#pragma mark - 这是初始化一些数据的方法
-(void)initData{
    self.navigationItem.title =  NSLocalizedString(@"收款", NSStringFromClass([self class]));
    self.view.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
    self.navigationItem.rightBarButtonItem = self.rightButton;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}
-(void)touch_BackView{
    [self.view endEditing:YES];
}
#pragma mark - 这是创建右边的查看记录的按钮
-(UIBarButtonItem *)rightButton{
    if (!_rightButton) {
        _rightButton = [[UIBarButtonItem alloc]initWithTitle: NSLocalizedString(@"收款记录", NSStringFromClass([self class])) style:UIBarButtonItemStylePlain target:self action:@selector(clickGetMoneyRecorder)];
    }
    return _rightButton;
}
#pragma mark - 这是点击右边的按钮的方法
-(void)clickGetMoneyRecorder{
    //点击的是收款记录
    MoneyRecordVC * vc = [[MoneyRecordVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 底部的按钮
-(UIButton *)buttomBtn{
    if (!_buttomBtn) {
        _buttomBtn = [[UIButton alloc]init];
        [_buttomBtn setTitle: NSLocalizedString(@"二维码收款", NSStringFromClass([self class])) forState:UIControlStateNormal];
        [_buttomBtn setTitleColor:HEX(@"07a0f8", 1) forState:UIControlStateNormal];
        _buttomBtn.titleLabel.font = FONT(16);
        [_buttomBtn setImage:IMAGE(@"icon_ma") forState:UIControlStateNormal];
        [self.view addSubview:_buttomBtn];
        _buttomBtn.backgroundColor = [UIColor whiteColor];
        [_buttomBtn addTarget:self action:@selector(clickButtomBtn) forControlEvents:UIControlEventTouchUpInside];
        _buttomBtn.layer.cornerRadius = 3;
        _buttomBtn.layer.masksToBounds = YES;
        _buttomBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        [_buttomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 15;
            make.right.offset = -15;
            make.height.offset = 44;
            make.bottom.offset = -10;
        }];
    }
    return _buttomBtn;
}
#pragma mark - 点击底部的按钮
-(void)clickButtomBtn{
    NSLog(@"点击底部的按钮");
    QRCodeListVC *vc = [[QRCodeListVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 这是创建表视图的方法
-(UITableView * )tableView{
    if(_tableView == nil){
        _tableView = ({
            UITableView * table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64-70) style:UITableViewStylePlain];
            table.delegate = self;
            table.dataSource = self;
            table.tableFooterView = [UIView new];
            table.showsVerticalScrollIndicator = NO;
            table.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
            table.separatorStyle = UITableViewCellSeparatorStyleNone;
            [self.view addSubview:table];
            table;
        });
    }
    return _tableView;
}
#pragma mark - 这是UITableView的代理和方法和数据方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 64;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view =[UIView new];
    view.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
    UIButton *btn = [[UIButton alloc]init];
    [btn setTitle: NSLocalizedString(@"立即收款", NSStringFromClass([self class])) forState:UIControlStateNormal];
    [btn setTitleColor:HEX(@"ffffff", 1) forState:UIControlStateNormal];
    btn.titleLabel.font = FONT(16);
    [btn setImage:IMAGE(@"icon_saoma") forState:UIControlStateNormal];
    [view addSubview:btn];
    btn.backgroundColor = HEX(@"ff9900", 1);
    [btn addTarget:self action:@selector(clickFastGetMoney) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = 3;
    btn.layer.masksToBounds = YES;
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 15;
        make.right.offset = -15;
        make.height.offset = 44;
        make.top.offset = 20;
    }];
    return view;
}
#pragma mark - 点击立即收款的方法
-(void)clickFastGetMoney{
    NSLog(@"点击了立即收款的方法");
    if (_moneyT.text.length == 0) {
        [self showToastAlertMessageWithTitle: NSLocalizedString(@"请先输入金额", NSStringFromClass([self class]))];
        return;
    }
    QRNewCodeVC * code = [QRNewCodeVC new];
    code.modalPresentationStyle = UIModalPresentationFormSheet;
    code.navigationItem.title =  NSLocalizedString(@"扫码收款", NSStringFromClass([self class]));
    code.money = _moneyT.text;
    [code setCompletionWithBlock:^(NSString *resultAsString) {
        [self.navigationController popViewControllerAnimated:YES];
        NSLog(@"%@",resultAsString);
        [self postTopay:resultAsString];

    }];
    [self.navigationController pushViewController:code animated:YES];
}
-(void)postTopay:(NSString *)str{
    SHOW_HUD
    [HttpTool postWithAPI:@"biz/cashier/codepay" withParams:@{@"amount":_moneyT.text,@"pay_desc":_rensonT.text,@"auth_code":str} success:^(id json) {
        if ([json[@"error"] integerValue]  == 0) {
            [self showToastAlertMessageWithTitle: NSLocalizedString(@"收款成功,请注意查收!", NSStringFromClass([self class]))];
            [self clickGetMoneyRecorder];
        }else{
            [self showToastAlertMessageWithTitle:json[@"message"]];
        }
        HIDE_HUD
    } failure:^(NSError *error) {
        HIDE_HUD
        [self showToastAlertMessageWithTitle: NSLocalizedString(@"支付失败", NSStringFromClass([self class]))];
        NSLog(@"%@",error);
    }];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = @"GetMoneyInputCell";
    GetMoneyInputCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[GetMoneyInputCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    cell.moneyTextF.delegate = self;
    cell.rensonTextF.delegate = self;
    _moneyT = cell.moneyTextF;
    _rensonT = cell.rensonTextF;
    return cell;
}
#pragma mark - 这是UITextField的代理方法
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [IQKeyboardManager sharedManager].enable = YES;
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"."] && [textField.text containsString:@"."] && textField == _moneyT) {
        [self showToastAlertMessageWithTitle: NSLocalizedString(@"请输入数字", NSStringFromClass([self class]))];
        return NO;
    }
    return YES;
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
@end
