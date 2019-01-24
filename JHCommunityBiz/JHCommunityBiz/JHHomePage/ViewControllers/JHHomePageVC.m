//
//  JHHomePage.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/9.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHHomePageVC.h"
#import "JHMainMessageVC.h"
#import "JHStatisticalMainVC.h"
#import "JHEvaluateMainVC.h"
#import "MainSettingVC.h"
#import "JHCustomerMainVC.h"
#import "JHHomePageCellOne.h"
#import "JHHomePageCellTwo.h"
#import "JHHomePageCellThree.h"
#import "JHHomePageModel.h"
#import <MJRefresh.h>
#import <IQKeyboardManager.h>
#import "JHCapitalMainVC.h"
#import "JHDeliveryMainVC.h"
#import "JHAttestationVC.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "QRCodeReaderViewController.h"
#import "JHShopEvaluateMainVC.h"
#import "JHGroupChitRecordVC.h"
#import "JHTrueToConsumeVC.h"
#import "JHTakeTheirMsgVC.h"
#import "JHPreferentiaListVC.h"
#import "JHPreferentialSetVC.h"
#import "JHGroupOrderListMainVC.h"
#import "HttpTool.h"
#import "JHShowAlert.h"
#import "JHShareModel.h"
#import <MessageUI/MessageUI.h>
#import "JHMyButton.h"
#import "JHFfunctionVC.h"
#import "DeliveryOrderVC.h"
#import "XTPopView.h"
#import "GetMoneyVC.h"
#import "addSeatMainVC.h"
#import "JHHomeMoneyCell.h"
#import "JHStatementVC.h"
#import "JHBaseNavVC.h"
#import "JHLoginVC.h"
#import "JHWebVC.h"
@interface JHHomePageVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,QRCodeReaderDelegate,selectIndexPathDelegate>
{
    UILabel * label_msg;//在有消息的时候显示的小红点
    UITableView * myTableView;//创建表格的方法
    BOOL isYes;//模拟数据用的
    UITextField * myTextField;//输入江湖劵密码的
    MJRefreshNormalHeader * _header;//这是下拉刷新的
    JHHomePageModel * infoModel;
    NSString * type;//认证时的状态
    BOOL isFirst;
    XTPopView *view1;
    UIControl * control;
    NSString *shenheURL;
}
@property (nonatomic, strong) UIButton *customBtn;
@end
@implementation JHHomePageVC
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [JHShareModel shareModel].tag = 0;
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    
}
//界面将要出现的时候调用的方法
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //隐藏tabbar
    self.tabBarController.tabBar.hidden = NO;
    if (isFirst) {
        //请求商户信息
        [self postHttpForBizInfo];
    }else{
        isFirst = YES;
    }
    [self version];
}
-(void)version{
    if (![JHShareModel shareModel].isNotUpdate) {
        [self postToSureThatIsNeedUpgradeVersion];
    }
}
-(void)postToSureThatIsNeedUpgradeVersion{
    [HttpTool postWithAPI:@"client/v2/data/appver" withParams:@{} success:^(id json) {
        NSLog(@"更新版本的信息%@",json);
        if ([json[@"error"] isEqualToString:@"0"]) {
            if ([json[@"data"][@"ios_biz_version"] compare:[JHShareModel shareModel].version] != NSOrderedDescending) {
                return;
            }
            if ([[json[@"data"][@"ios_biz_force_update"] description] isEqualToString:@"0"]) {
                [JHShowAlert showAlertWithTitle: NSLocalizedString(@"温馨提示", NSStringFromClass([self class])) withMessage:json[@"data"][@"ios_biz_intro"] withBtn_cancel: NSLocalizedString(@"取消", NSStringFromClass([self class])) withBtn_sure: NSLocalizedString(@"确定", NSStringFromClass([self class])) withCancelBlock:^{
                    [JHShareModel shareModel].isNotUpdate =YES;
                }withSureBlock:^{
                    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:json[@"data"][@"ios_biz_download"]]];
                }];
            }else{
                [JHShowAlert showAlertWithTitle: NSLocalizedString(@"温馨提示", NSStringFromClass([self class])) withMessage:json[@"data"][@"ios_biz_intro"] withBtn_cancel:nil withBtn_sure: NSLocalizedString(@"确定", NSStringFromClass([self class])) withCancelBlock:nil withSureBlock:^{
                    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:json[@"data"][@"ios_biz_download"]]];
                }];
                
            }
        }
        
    } failure:^(NSError *error) {
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化一些对象
    [self initData];
    //创建表格
    [self creatUITableView];
    if (!isFirst) {
        //请求商户信息
        SHOW_HUD
        [self postHttpForBizInfo];
    }
    shenheURL = @"";
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(version) name:UIApplicationWillEnterForegroundNotification object:nil];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(logout) name:@"LoginOut" object:nil];
}
- (void)logout
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    JHBaseNavVC *nav1 = [[JHBaseNavVC alloc]initWithRootViewController:[JHLoginVC new]];
    window.rootViewController = nav1;
}
#pragma mark - 这是初始化的一些方法
-(void)initData{
    //标题
    self.navigationItem.title =  NSLocalizedString(@"商户中心", NSStringFromClass([self class]));
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    //创建一个左边边的按钮进去信息界面
    [self creatlefttBtn];
    //在导航两边添加两个按钮
    [self creatrightBtn];
    //关闭左滑到上一页的手势
    self.fd_interactivePopDisabled = YES;
}
#pragma mark - 请求商户信息
-(void)postHttpForBizInfo{
    [HttpTool postWithAPI:@"biz/shop/shop/info" withParams:@{} success:^(id json) {
        NSLog(@"%@",json);
        HIDE_HUD
        if ([json[@"error"] isEqualToString:@"0"]) {
            JHShareModel * model = [JHShareModel shareModel];
            model.infoDictionary = json[@"data"];
            infoModel = [JHHomePageModel creatJHHomePageModelWithDictionary:json[@"data"]];
            if ([json[@"data"][@"msg"] integerValue] > 0) {
                label_msg.hidden = NO;
            }else{
                label_msg.hidden = YES;
            }
            if ([json[@"data"][@"verify"][@"verify"] isEqualToString:@"1"] ) {
                isYes = NO;
                type =  NSLocalizedString(@"认证完成", NSStringFromClass([self class]));
            }else if([json[@"data"][@"verify"][@"verify"] isEqualToString:@"2"]){
                isYes = YES;
                type =  NSLocalizedString(@"重新认证", NSStringFromClass([self class]));
            }else if([json[@"data"][@"verify"][@"verify"] isEqualToString:@"0"] &&
                     ([json[@"data"][@"verify"][@"updatetime"] integerValue] > 0)){
                isYes = YES;
                type =  NSLocalizedString(@"正在审核", NSStringFromClass([self class]));
            }else if([json[@"data"][@"verify"][@"verify"] isEqualToString:@"0"]){
                isYes = YES;
                type =  NSLocalizedString(@"立即认证", NSStringFromClass([self class]));
            }
            label_msg.text = json[@"data"][@"msg"];
            [myTableView reloadData];
            shenheURL = json[@"data"][@"bills_url"][@"wait_audited_url"];
        }else{
            if (![json[@"error"] isEqualToString:@"101"]) {
                [JHShowAlert showAlertWithTitle: NSLocalizedString(@"温馨提示", NSStringFromClass([self class])) withMessage:json[@"message"] withBtn_cancel:nil withBtn_sure: NSLocalizedString(@"知道了", NSStringFromClass([self class])) withCancelBlock:nil withSureBlock:nil];
            }
        }
        [_header endRefreshing];
    } failure:^(NSError *error) {
        HIDE_HUD
        [_header endRefreshing];
        [JHShowAlert showAlertWithTitle: NSLocalizedString(@"温馨提示", NSStringFromClass([self class])) withMessage: NSLocalizedString(@"服务器繁忙,请稍后访问", NSStringFromClass([self class])) withBtn_cancel:nil withBtn_sure: NSLocalizedString(@"知道了", NSStringFromClass([self class])) withCancelBlock:nil
                          withSureBlock:nil];
        NSLog(@"%@",error.localizedDescription);
    }];
}
#pragma mark - 这是创建导航上的左边的按钮的方法
-(void)creatlefttBtn{
    //创建左边的按钮
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = FRAME(0,0, 30, 30);
    [btn addTarget:self action:@selector(clickToMsgVC) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = item;
    //创建小红点
    label_msg = [[UILabel alloc]init];
    label_msg.frame = FRAME(22, 0, 12,12);
    label_msg.layer.cornerRadius = 6;
    label_msg.layer.masksToBounds = YES;
    label_msg.adjustsFontSizeToFitWidth = YES;
    label_msg.font = FONT(8);
    label_msg.textAlignment = NSTextAlignmentCenter;
    label_msg.textColor = [UIColor whiteColor];
    label_msg.backgroundColor = [UIColor redColor];
    label_msg.hidden = YES;
    [btn addSubview:label_msg];
    //创建imageView
    UIImageView * imageV = [[UIImageView alloc]init];
    imageV.frame = FRAME(7, 2.5, 20, 25);
    imageV.image = [UIImage imageNamed:@"home_news"];
    [btn addSubview:imageV];
}
#pragma mrak - 这是创建导航上的右边的按钮的方法
-(void)creatrightBtn{
    _customBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _customBtn.frame = CGRectMake(0, 0, 40, 40);
    [_customBtn setImage:[UIImage imageNamed:@"top-zhankai"] forState:UIControlStateNormal];
    [_customBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithCustomView:_customBtn];
    self.navigationItem.rightBarButtonItem = btn;
    
}
- (void)btnClick:(UIButton *)btn{
    view1 = [[XTPopView alloc] initWithOrigin:CGPointMake(WIDTH-35, _customBtn.frame.origin.y + 64) Width:130 Height:40 * 3 Type:XTTypeOfUpRight Color:[UIColor whiteColor]];
    view1.dataArray = @[ NSLocalizedString(@"扫一扫", NSStringFromClass([self class])), NSLocalizedString(@"收款", NSStringFromClass([self class])), NSLocalizedString(@"设置", NSStringFromClass([self class]))];
    view1.images = @[@"icon-sao",@"icon-shoukuan", @"icon-setting"];
    view1.fontSize = 13;
    view1.row_height = 40;
    view1.titleTextColor = [UIColor colorWithWhite:0.3 alpha:1];
    view1.delegate = self;
    [view1 popView];
}
- (void)selectIndexPathRow:(NSInteger)index
{
    [view1 removeFromSuperview];
    switch (index) {
        case 0:
        {
            NSLog(@"扫一扫");
            [self clickToSweep];
        }
            break;
        case 1:
        {
            NSLog(@"收款");
            GetMoneyVC *vc = [[GetMoneyVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 2:
        {
            NSLog(@"设置");
            MainSettingVC *setVC = [[MainSettingVC alloc] init];
            [self.navigationController pushViewController:setVC animated:YES];
            
        }
            break;
        case 3:
        {
            NSLog(@"功能开启");
            //跳转到功能开启
            JHFfunctionVC * vc = [[JHFfunctionVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        default:
            break;
    }
}

#pragma mark - 这是创建表的方法
-(void)creatUITableView{
    myTableView = [[UITableView alloc]initWithFrame:FRAME(0, 0, WIDTH, HEIGHT - 64 -50)  style:UITableViewStylePlain];
    myTableView.tableFooterView = [UIView new];
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [myTableView registerClass:[JHHomePageCellOne class] forCellReuseIdentifier:@"cell1"];
    [myTableView registerClass:[JHHomePageCellTwo class] forCellReuseIdentifier:@"cell2"];
    [myTableView registerClass:[JHHomePageCellThree class] forCellReuseIdentifier:@"cell3"];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [self.view addSubview:myTableView];
    _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(downRefresh)];
    _header.stateLabel.textColor = [UIColor colorWithRed:129/255.0 green:129/255.0 blue:129/255.0 alpha:1];
    _header.lastUpdatedTimeLabel.hidden = YES;
    [_header setTitle: NSLocalizedString(@"下拉可以刷新", NSStringFromClass([self class])) forState:MJRefreshStateIdle];
    [_header setTitle: NSLocalizedString(@"现在可以刷新啦", NSStringFromClass([self class])) forState:MJRefreshStatePulling];
    [_header setTitle: NSLocalizedString(@"正在为您努力刷新中", NSStringFromClass([self class])) forState:MJRefreshStateRefreshing];
    myTableView.mj_header = _header;
}
#pragma mark - 这是下拉刷新的方法
-(void)downRefresh{
    [self postHttpForBizInfo];
}
#pragma mark - 这是UITableView的代理和数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        if (!isYes) {
            return 138;
        }else{
            return 90;
        }
    }else if(indexPath.row == 1){
        return 173;
    }
    else{
        return 218;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        if (!isYes) {
            JHHomePageCellOne * cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
            cell.model = infoModel;
            [cell.btn addTarget:self action:@selector(clickToQuanPsd) forControlEvents:UIControlEventTouchUpInside];
//            [cell.btn_group addTarget:self action:@selector(clickToGroup) forControlEvents:UIControlEventTouchUpInside];
//            [cell.btn_hui addTarget:self action:@selector(clickToFavorable) forControlEvents:UIControlEventTouchUpInside];
            [cell.btn_bill addTarget:self action:@selector(clickToMyBill) forControlEvents:UIControlEventTouchUpInside];
//            [cell.btn_TodayOrder addTarget:self action:@selector(clickToTodayOrder) forControlEvents:UIControlEventTouchUpInside];
//            [cell.btn_TodayIncome addTarget:self action:@selector(clickToTodayIncome) forControlEvents:UIControlEventTouchUpInside];
            myTextField = cell.textFiled;
            myTextField.delegate = self;
            [cell setMyBlock:^(NSInteger num) {
                switch (num) {
                    case 0:
                    {
                        NSLog(@"扫一扫");
                        [self clickToSweep];
                    }
                        break;
                    case 1:
                    {
                        NSLog(@"收款");
                        GetMoneyVC *vc = [[GetMoneyVC alloc]init];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                        break;
//                    case 2:
//                    {
//                        NSLog(@"功能开启");
//                        //跳转到功能开启
//                        JHFfunctionVC * vc = [[JHFfunctionVC alloc]init];
//                        [self.navigationController pushViewController:vc animated:YES];
//
//                    }
//                        break;
                    default:
                    {
                        NSLog(@"设置");
                        MainSettingVC *setVC = [[MainSettingVC alloc] init];
                        [self.navigationController pushViewController:setVC animated:YES];
                        
                        
                    }
                        break;
                }
            }];
            return cell;
        }else{
            JHHomePageCellThree * cell = [tableView dequeueReusableCellWithIdentifier:@"cell3" forIndexPath:indexPath];
            cell.type = type;
            [cell.btn_attestation addTarget:self action:@selector(clickToAttestation:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
    }else if (indexPath.row == 1){
        static NSString *str = @"JHHomeMoneyCell";
        JHHomeMoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[JHHomeMoneyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        cell.dic = infoModel.count;
        __weak typeof (self)weakSelf = self;
        [cell setClickBlock:^{
              NSLog(@"点击查看的按钮");
            JHStatementVC *vc = [[JHStatementVC alloc]init];
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
        return cell;
    }
    else{
        JHHomePageCellTwo * cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
        cell.audit = [JHShareModel shareModel].infoDictionary[@"waimai"][@"audit"];
        cell.have_waimai = [JHShareModel shareModel].infoDictionary[@"waimai_open"];
        for (int i = 0; i < 8; i ++) {
            JHMyButton * btn = cell.btnArray[i];
            btn.tag = i;
            [btn addTarget:self action:@selector(clickToSubController:) forControlEvents:UIControlEventTouchUpInside];
        }
        return cell;
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
#pragma mark - 这是textField的代理方法
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if ([textField.text isEqualToString: NSLocalizedString(@"请输入核销码", NSStringFromClass([self class]))]) {
        textField.text = @"";
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.text.length == 0) {
        textField.text =  NSLocalizedString(@"请输入核销码", NSStringFromClass([self class]));
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}
#pragma mark - 这是点击立即认证的方法
-(void)clickToAttestation:(UIButton *)sender{
    JHAttestationVC * vc = [[JHAttestationVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 这是点击进入消息界面的方法
-(void)clickToMsgVC{
    if (isYes) {
        [self creatUIAlertViewControllerWithMessage: NSLocalizedString(@"您需要先完成认证", NSStringFromClass([self class])) withCancelBtn:nil withTrueBtn: NSLocalizedString(@"知道了", NSStringFromClass([self class]))];
        return;
    }
    //点击进入消息的界面
    JHMainMessageVC * vc = [[JHMainMessageVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 这是点击扫描二维码的方法
-(void)clickToSweep{
    if (isYes) {
        [self creatUIAlertViewControllerWithMessage: NSLocalizedString(@"您需要先完成认证", NSStringFromClass([self class])) withCancelBtn:nil withTrueBtn: NSLocalizedString(@"知道了", NSStringFromClass([self class]))];
        return;
    }
    QRCodeReaderViewController * code = [QRCodeReaderViewController new];
    code.navigationItem.title =  NSLocalizedString(@"扫一扫", NSStringFromClass([self class]));
    code.modalPresentationStyle = UIModalPresentationFormSheet;
    code.delegate = self;
    __weak typeof(self)wself = self;
    [code setCompletionWithBlock:^(NSString *resultAsString) {
        //暂时的处理
        [wself.navigationController popViewControllerAnimated:YES];
        //[self creatUIAlertViewControllerWithMessage:[NSString stringWithFormat:@"%@\n%@",NSLocalizedString(@"扫描结果如下", nil),resultAsString] withCancelBtn:nil withTrueBtn:NSLocalizedString(@"知道了", nil)];
        [self postHttpToGetInfoWithCode:resultAsString];
        
    }];
    [self.navigationController pushViewController:code animated:YES];
    
}
#pragma mark - QRCodeReader Delegate Methods
//- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result
//{
//    [self creatUIAlertViewControllerWithMessage:@"QRCodeReader" withCancelBtn:nil withTrueBtn:NSLocalizedString(@"知道了", nil)];
//
//}
- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 这是输入江湖劵密码后的按钮点击的方法
-(void)clickToQuanPsd{
    if (myTextField.text.length == 0 || [myTextField.text isEqualToString: NSLocalizedString(@"请输入核销码", NSStringFromClass([self class]))]) {
        [JHShowAlert showAlertWithMsg: NSLocalizedString(@"请先输入劵码", NSStringFromClass([self class]))];
        [self.view endEditing:YES];
        return;
    }
    [self postHttpToGetInfoWithCode:myTextField.text];
}
#pragma mark - 这是输入劵码后或者扫描二维码后需要调用获取信息的方法
-(void)postHttpToGetInfoWithCode:(NSString *)code{
    SHOW_HUD
    [HttpTool postWithAPI:@"biz/quan/get" withParams:@{@"code":code} success:^(id json) {
        NSLog(@"%@",json);
        if ([json[@"error"] isEqualToString:@"0"]) {
            if (![myTextField.text isEqualToString: NSLocalizedString(@"请输入核销码", NSStringFromClass([self class]))]) {
                myTextField.text =  NSLocalizedString(@"请输入核销码", NSStringFromClass([self class]));
            }
            [self.view endEditing:YES];
            if (json[@"data"][@"tuan"]) {
                JHTrueToConsumeVC * vc = [[JHTrueToConsumeVC alloc]init];
                vc.dictionary = json[@"data"];
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                JHTakeTheirMsgVC * vc1 = [[JHTakeTheirMsgVC alloc]init];
                vc1.hidesBottomBarWhenPushed = YES;
                vc1.dictionary = json[@"data"];
                [self.navigationController pushViewController:vc1 animated:YES];
            }
        }else{
            if (![myTextField.text isEqualToString: NSLocalizedString(@"请输入核销码", NSStringFromClass([self class]))]) {
                myTextField.text = NSLocalizedString( NSLocalizedString(@"请输入核销码", nil), NSStringFromClass([self class]));
            }
            [self.view endEditing:YES];
            [JHShowAlert showAlertWithMsg:json[@"message"]];
        }
        HIDE_HUD
    } failure:^(NSError *error) {
        HIDE_HUD
        [self.view endEditing:YES];
        if (![myTextField.text isEqualToString: NSLocalizedString(@"请输入核销码", NSStringFromClass([self class]))]) {
            myTextField.text =  NSLocalizedString(@"请输入核销码", NSStringFromClass([self class]));
        }
        [JHShowAlert showAlertWithTitle: NSLocalizedString(@"温馨提示", NSStringFromClass([self class])) withMessage: NSLocalizedString(@"服务器繁忙,请稍后访问", NSStringFromClass([self class])) withBtn_cancel:nil withBtn_sure: NSLocalizedString(@"知道了", NSStringFromClass([self class])) withCancelBlock:nil
                          withSureBlock:nil];
        NSLog(@"%@",error.localizedDescription);
    }];
    
}
#pragma mark - 这是点击进入我的账单的方法
-(void)clickToMyBill{
    NSLog(@"这是点击进入我的账单的方法");
    JHCapitalMainVC * vc = [[JHCapitalMainVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 这是下面的九个按钮点击的方法
-(void)clickToSubController:(JHMyButton*)sender{
    if (isYes) {
        [self creatUIAlertViewControllerWithMessage: NSLocalizedString(@"您需要先完成认证", NSStringFromClass([self class])) withCancelBtn:nil withTrueBtn: NSLocalizedString(@"知道了", NSStringFromClass([self class]))];
        return;
    }
    switch (sender.tag) {
        case 0:
        {
            if ([[JHShareModel shareModel].infoDictionary[@"waimai_open"] isEqualToString:@"1"]) {
                //判断是否有条件进入
                NSString *waimai_closed = [JHShareModel shareModel].infoDictionary[@"waimai_closed"];
                if ([waimai_closed isEqualToString:@"1"] ) {
                    //店铺被删除,无法进入
                    [JHShowAlert showAlertWithMsg: NSLocalizedString(@"抱歉,您的外卖店铺已被关闭", NSStringFromClass([self class]))];
                }else{
                    JHDeliveryMainVC *vc = [[JHDeliveryMainVC alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                
            }else if([[JHShareModel shareModel].infoDictionary[@"waimai_open"] isEqualToString:@"3"]){
                //进入审核界面
                JHWebVC *web = [[JHWebVC alloc] init];
                web.urlStr = shenheURL;
                [self.navigationController pushViewController:web animated:YES];
            }else{
                Class  vcClass = NSClassFromString(@"JHdeliveryOpenVC");
                [self.navigationController pushViewController:[vcClass new] animated:YES];
            }
        }
            break;
        case 1:
        {
            Class vcClass = NSClassFromString(@"JHTuangouProductManageMainVC");
            [self.navigationController pushViewController:[vcClass new] animated:YES];
            
        }
            break;
        case 2:
        {
            JHPreferentialSetVC * vc = [[JHPreferentialSetVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 3:
            
        {
            addSeatMainVC * vc = [[addSeatMainVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 4:
        {
            Class vcClass = NSClassFromString(@"JHShopSetMainVC");
            [self.navigationController pushViewController:[vcClass new] animated:YES];
        }
            break;
        case 5:
        {
            JHShopEvaluateMainVC * vc  = [[JHShopEvaluateMainVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 6:
        {
            JHStatisticalMainVC * vc = [[JHStatisticalMainVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 7:
        {
            JHCustomerMainVC * vc = [[JHCustomerMainVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 8:
        {
            
        }
            break;
        default:
            break;
    }

}
#pragma mark - 这是弹出警告框的方法
-(void)creatUIAlertViewControllerWithMessage:(NSString *)msg withCancelBtn:(NSString *)cancelBtn withTrueBtn:(NSString *)trueBtn{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle: NSLocalizedString(@"温馨提示", NSStringFromClass([self class])) message:msg preferredStyle:UIAlertControllerStyleAlert];
    if (cancelBtn) {
        [alert addAction:[UIAlertAction actionWithTitle:cancelBtn style:UIAlertActionStyleCancel handler:nil]];
    }
    if (trueBtn) {
        [alert addAction:[UIAlertAction actionWithTitle:trueBtn style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
    }
    [self presentViewController:alert animated:YES completion:nil];
}
@end
