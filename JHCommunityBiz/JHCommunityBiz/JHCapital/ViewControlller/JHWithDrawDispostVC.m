//
//  JHWithDrawDispostVC.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/20.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHWithDrawDispostVC.h"
#import "JHWithDrawCellOne.h"
#import "JHWithDrawCellTwo.h"
#import "JHWithDrawCellThree.h"
#import <IQKeyboardManager.h>
#import "JHForgetterPsdVC.h" 
#import "JHBankSettingVC.h"
@interface JHWithDrawDispostVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITableView * myTableView;//创建的表视图
    UITextField * textField_money;//输入金额的输入框
    UITextField * textField_psd;//输入密码的输入框
    UILabel * label_serve;//展示收取服务费百分比的
    UILabel * label_bank;//显示银行账号的
    NSString * balance;//余额
    NSString * percent;//百分比
    NSString * info_percent;
    NSString * account;//提现账户
}
@end

@implementation JHWithDrawDispostVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //这是初始化一些数据的方法
    [self initData];
    //这是创建表视图的方法
    [self creatUITableView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //请求一些基本信息的方法
    SHOW_HUD
    [self postHttp];
}
#pragma mark - 这是请求一些信息的方法
-(void)postHttp{
    [HttpTool postWithAPI:@"biz/shop/money/info" withParams:@{} success:^(id json) {
        NSLog(@"%@",json);
        if ([json[@"error"] isEqualToString:@"0"]) {
            balance = json[@"data"][@"info"][@"money"];
            percent = json[@"data"][@"info"][@"tixian_percent"];
            if ([percent integerValue] == 100) {
                info_percent = NSLocalizedString(@"平台不收取服务费", nil);
            }else{
                NSInteger a = 100 - [percent integerValue];
                info_percent = [NSString stringWithFormat:@"%@%ld%@",NSLocalizedString(@"平台收取服务费", nil),a,@"％"];
            }
            if (!json[@"data"][@"info"][@"bank"][@"account_type"]||!json[@"data"][@"info"][@"bank"][@"account_number"]) {
              account = @"";
            }else{
            account = [NSString stringWithFormat:@"%@(%@,%@)",
                       json[@"data"][@"info"][@"bank"][@"account_type"],
                       json[@"data"][@"info"][@"bank"][@"account_name"],
                       json[@"data"][@"info"][@"bank"][@"account_number"]];
            }
            if (account.length == 0) {
                [JHShowAlert showAlertWithTitle:NSLocalizedString(@"温馨提示", nil) withMessage:NSLocalizedString(@"您还没有提现账户,请先去添加账户", nil) withBtn_cancel:NSLocalizedString(@"取消", nil) withBtn_sure:NSLocalizedString(@"确定", nil) withCancelBlock:nil withSureBlock:^{
                    JHBankSettingVC * vc = [[JHBankSettingVC alloc]init];
                    [self.navigationController pushViewController:vc animated:YES];
                }];
            }
            [myTableView reloadData];
        }else{
            [JHShowAlert showAlertWithMsg:json[@"message"]];
        }
        HIDE_HUD
    } failure:^(NSError *error) {
        HIDE_HUD
        [JHShowAlert showAlertWithMsg:NSLocalizedString(@"服务器繁忙,请稍后访问", nil)];
         NSLog(@"%@",error.localizedDescription);
    }];
}
#pragma mark - 这是初始化一些数据的方法
-(void)initData{
    balance = @"0";
    self.navigationItem.title = NSLocalizedString(@"资金提现", nil);
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    //注册一个通知监听textField的文本发生改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextChange:) name:UITextFieldTextDidChangeNotification object:textField_money];
}
#pragma mark - 这是创建表视图的方法
-(void)creatUITableView{
    myTableView = [[UITableView alloc]initWithFrame:FRAME(0, 0, WIDTH, HEIGHT - 64) style:UITableViewStylePlain];
    myTableView.tableFooterView = [UIView new];
    myTableView.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:myTableView];
    [myTableView registerClass:[JHWithDrawCellOne class] forCellReuseIdentifier:@"cell1"];
    [myTableView registerClass:[JHWithDrawCellTwo class] forCellReuseIdentifier:@"cell2"];
    [myTableView registerClass:[JHWithDrawCellThree class] forCellReuseIdentifier:@"cell3"];
    myTableView.delegate = self;
    myTableView.dataSource = self;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 50;
    }else if (indexPath.row == 1 || indexPath.row == 4) {
        return 10;
    }else if(indexPath.row == 5){
        return 200;
    }else{
        return 40;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        }
        cell.textLabel.text = NSLocalizedString(@"当前可提现的余额", nil);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1];
        cell.detailTextLabel.textColor = [UIColor colorWithRed:250/255.0 green:177/255.0 blue:17/255.0 alpha:1];
        cell.detailTextLabel.text = balance;
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
        return cell;
    }else if (indexPath.row == 1 ||indexPath.row == 4){
        static NSString * str = @"cell4";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (cell==nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
        return cell;
    }else if (indexPath.row == 2){
        JHWithDrawCellOne * cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        cell.label_bank.text = account;
        label_bank = cell.label_bank;
        return cell;
    }else if (indexPath.row == 3){
        JHWithDrawCellTwo * cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
        textField_money = cell.mytextField;
        cell.label_serve.text = info_percent;
        label_serve = cell.label_serve;
        textField_money.delegate = self;
        return cell;
    }else {
        JHWithDrawCellThree * cell = [tableView dequeueReusableCellWithIdentifier:@"cell3" forIndexPath:indexPath];
        textField_psd = cell.mytextField;
        [cell.btn_forgetter addTarget:self action:@selector(clickToFindPsd:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn_ture addTarget:self action:@selector(clickToTrue:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        JHBankSettingVC * vc = [[JHBankSettingVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];

    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([IQKeyboardManager sharedManager].enable) {
        
    }else{
        [self.view endEditing:YES];
    }
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [IQKeyboardManager sharedManager].enable = NO;
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [IQKeyboardManager sharedManager].enable = YES;
}
#pragma mark - 这是点击忘记密码的方法
-(void)clickToFindPsd:(UIButton *)sender{
    NSLog(@"点击了忘记密码");
    JHForgetterPsdVC * vc = [[JHForgetterPsdVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 这是点击确定提现的方法
-(void)clickToTrue:(UIButton *)sender{
    [self.view endEditing:YES];
    NSLog(@"点击了确定提现的方法");
    SHOW_HUD
    [HttpTool postWithAPI:@"biz/shop/money/reg_cash" withParams:@{@"money":textField_money.text,@"passwd":textField_psd.text} success:^(id json) {
        NSLog(@"%@",json);
        if ([json[@"error"] isEqualToString:@"0"]) {
            [self postHttp];
            [JHShowAlert showAlertWithMsg:NSLocalizedString(@"您已提现成功,请查看您账户明细", nil) withBtnTitle:NSLocalizedString(@"知道了", nil) withBtnBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }else{
            [JHShowAlert showAlertWithMsg:json[@"message"]];
        }
        HIDE_HUD
    } failure:^(NSError *error) {
        HIDE_HUD
        [JHShowAlert showAlertWithMsg:NSLocalizedString(@"服务器繁忙,请稍后访问", nil)];
        NSLog(@"%@",error.localizedDescription);

    }];
}
#pragma mark - 这是UITextField的代理方法
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [IQKeyboardManager sharedManager].enable = YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}
#pragma mark - 通知
-(void)textFieldTextChange:(NSNotification *)noti{
    if ([textField_money.text doubleValue] > [balance floatValue]*((100 - [percent integerValue])==0?1:100 - [percent integerValue])) {
        label_serve.text = NSLocalizedString(@"余额不足,无法提现", nil);
    }else{
        label_serve.text = info_percent;
    }
}
@end
