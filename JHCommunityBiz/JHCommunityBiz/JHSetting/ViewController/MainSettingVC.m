//
//  MainSettingVC.m
//  WaimaiShop
//
//  Created by xixixi on 15/12/26.
//  Copyright © 2015年 ijianghu. All rights reserved.
//

#import "MainSettingVC.h"
#import "ZJSwitch.h"
#import "AppDelegate.h"
#import "HttpTool.h"
#import "JHSetStatusVC.h"
#import "JHAccountSetVC.h"
#import "JHNotiSetVC.h"
#import "JHChoosePrinterVC.h"
#import "JHLoginVC.h"
#import "JHBaseNavVC.h"
#import "JHWebVC.h"
@interface MainSettingVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *mainTableView;
@end

@implementation MainSettingVC
{
     UITextField *_peiTimeF;//商家配送时间
    UILabel * valueLabel;
    //语音开关
    ZJSwitch *switchBtn_voice;
    //勿扰模式
    //声音滑块开关
    UISlider *slider;
    ZJSwitch *switchBtn_no_disturb;
    //蓝牙连接状态标签
    UILabel *contentLabel;
    //自动打印订单
    ZJSwitch *switchBtn_youhui_auto;
    //外送订单自动打印
    ZJSwitch *switchBtn_waisongorder_auto;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化相关数据
    [self initData];
    //创建表视图
    [self createTableView];
    //创建退出登录按钮
    [self createLogoutBtn];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([JHShareModel shareModel].blueTooth.peripheral.state == CBPeripheralStateConnected ||
        [[NSUserDefaults standardUserDefaults] boolForKey:@"yunPrintState"]) {
        contentLabel.text = NSLocalizedString(@"已连接", nil);
        contentLabel.textColor = THEME_COLOR;
    }else{
        contentLabel.text = NSLocalizedString(@"未连接", nil);
        contentLabel.textColor = HEX(@"999999", 1.0);
    }
}
#pragma mark -初始化相关数据
- (void)initData
{
    self.view.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
    self.fd_interactivePopDisabled = YES;
    self.title = NSLocalizedString(@"设置", nil);
}
#pragma mark - 创建表视图
- (void)createTableView
{
    _mainTableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, WIDTH, HEIGHT - 64 - 60)
                                                      style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
        tableView.separatorColor = DEFAULT_BACKGROUNDCOLOR;
        tableView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
            make.bottom.equalTo(self.view).with.offset(-60 );
        }];
        tableView.layoutMargins = UIEdgeInsetsZero;
        tableView.separatorInset = UIEdgeInsetsZero;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(showRegsterID)];
        tap.numberOfTapsRequired = 10;
        [tableView addGestureRecognizer:tap];
        tableView;
    });
}
#pragma mark - 创建退出登录按钮
- (void)createLogoutBtn
{
    UIButton *logoutBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, HEIGHT - 50 - 64- (isIPhoneX?32:0), WIDTH - 20 , 40)];
    [logoutBtn setTitle:GLOBAL(@"退出登录") forState:UIControlStateNormal];
    [logoutBtn setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
    logoutBtn.titleLabel.font = FONT(17);
    [logoutBtn setBackgroundColor:HEX(@"fa4535", 1.0f) forState:(UIControlStateNormal)];;
    logoutBtn.layer.cornerRadius = 4;
    logoutBtn.layer.masksToBounds = YES;
    [logoutBtn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logoutBtn];
}
#pragma mark - UITableViewDelegate and dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 4 && (indexPath.row == 0||indexPath.row == 2)) {
        return 0;
    }else{
        return 40;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 0.01;
            break;
        case 1:
            return 10;
            break;
        case 2:
            return 10;
            break;
        case 3:
            return 10;
            break;
        default:
            return 0.0;
            break;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 1;
            break;
        case 3:
            return 4;
            break;
        default:
            return 0;
            break;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return  [UIView new];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            //添加labe
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, WIDTH - 108 - 10, 40)];
            titleLabel.font = FONT(14);
            titleLabel.textColor = [UIColor colorWithHex:@"333333" alpha:1.0];
            titleLabel.text = NSLocalizedString(@"外送营业状态", nil);
            [cell addSubview:titleLabel];
            if (!_peiTimeF) {
                _peiTimeF = [[UITextField alloc] initWithFrame:CGRectMake(80, 0, WIDTH - 110, 44)];
                _peiTimeF.textColor = THEME_COLOR;
                _peiTimeF.font = FONT(14);
                _peiTimeF.textAlignment = NSTextAlignmentRight;
                _peiTimeF.userInteractionEnabled = NO;
                _peiTimeF.text = [NSString stringWithFormat:@"%@",[JHShareModel shareModel].infoDictionary[@"cate_name"]];
            }
            return cell;
            break;
        }
        case 1:
        {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            //添加label
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, WIDTH - 108 - 10, 40)];
            titleLabel.font = FONT(14);
            titleLabel.textColor = [UIColor colorWithHex:@"333333" alpha:1.0];
            titleLabel.text = NSLocalizedString(@"账号设置", nil);
            [cell addSubview:titleLabel];
            return cell;
        }
            break;
        
        case 2:
        {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            //添加label
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, WIDTH - 108 - 10, 40)];
            titleLabel.font = FONT(14);
            titleLabel.textColor = [UIColor colorWithHex:@"333333" alpha:1.0];
            titleLabel.text = NSLocalizedString(@"通知设置", nil);
            [cell addSubview:titleLabel];
            return cell;
        }
            break;
        case 3:
        {
            switch (indexPath.row) {
                case 0:
                {
                    UITableViewCell *cell = [[UITableViewCell alloc] init];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    //添加label
                    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, WIDTH - 108 - 10, 40)];
                    titleLabel.font = FONT(14);
                    titleLabel.textColor = [UIColor colorWithHex:@"333333" alpha:1.0];
                    titleLabel.text = NSLocalizedString(@"打印设置", nil);
                    contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH - 128, 0, 100, 40)];
                    contentLabel.font = FONT(14);
                    contentLabel.textAlignment = NSTextAlignmentRight;
                    if ([JHShareModel shareModel].blueTooth.peripheral.state == CBPeripheralStateConnected ||
                        [[NSUserDefaults standardUserDefaults] boolForKey:@"yunPrintState"]) {
                        contentLabel.text = NSLocalizedString(@"已连接", nil);
                        contentLabel.textColor = THEME_COLOR;
                    }else{
                        contentLabel.text = NSLocalizedString(@"未连接", nil);
                        contentLabel.textColor = HEX(@"999999", 1.0);
                    }
                    [cell addSubview:titleLabel];
                    [cell addSubview:contentLabel];
                    return cell;
                }
                    break;
                case 1:
                {
                    UITableViewCell *cell = [[UITableViewCell alloc] init];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    //添加label 和 switch 开关
                    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, WIDTH - 108 - 10, 40)];
                    titleLabel.font = FONT(14);
                    titleLabel.textColor = [UIColor colorWithHex:@"333333" alpha:1.0];
                    titleLabel.text = NSLocalizedString(@"外送订单自动打印", nil);
                    if (!switchBtn_waisongorder_auto) {
                        switchBtn_waisongorder_auto = [[ZJSwitch alloc] initWithFrame:switch_rect];
                        switchBtn_waisongorder_auto.transform = CGAffineTransformMakeScale(0.8, 0.8);
                        switchBtn_waisongorder_auto.backgroundColor = [UIColor clearColor];
                        switchBtn_waisongorder_auto.tintColor = DEFAULT_BACKGROUNDCOLOR;
                        switchBtn_waisongorder_auto.onTintColor = THEME_COLOR;
                        switchBtn_waisongorder_auto.on = [JHShareModel shareModel].waisong_autoPrint;
                        [switchBtn_waisongorder_auto addTarget:self action:@selector(handle_WaisongSwitch) forControlEvents:UIControlEventValueChanged];
                    }
                    [cell addSubview:titleLabel];
                    [cell addSubview:switchBtn_waisongorder_auto];
                    return cell;
                }
                    break;
                case 2:
                {
                    UITableViewCell *cell = [[UITableViewCell alloc] init];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    //添加label
                    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, WIDTH - 108 - 10, 40)];
                    titleLabel.font = FONT(14);
                    titleLabel.textColor = [UIColor colorWithHex:@"333333" alpha:1.0];
                    titleLabel.text = NSLocalizedString(@"系统版本", nil);
                    //获取当前版本号
                    NSDictionary *dic = [[NSBundle mainBundle] infoDictionary];
                    NSString * version = [dic objectForKey:@"CFBundleShortVersionString"];
                    UILabel * versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH - 120, 0, 110, 40)];
                    versionLabel.textColor = [UIColor colorWithHex:@"999999" alpha:1.0];
                    versionLabel.font = FONT(14);
                    versionLabel.textAlignment = NSTextAlignmentRight;
                    versionLabel.text = version;
                    [cell addSubview:titleLabel];
                    [cell addSubview:versionLabel];
                    return cell;
                }
                    break;
                case 3:
                {
                    UITableViewCell *cell = [[UITableViewCell alloc] init];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    //添加label
                    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, WIDTH - 108 - 10, 40)];
                    titleLabel.font = FONT(14);
                    titleLabel.textColor = [UIColor colorWithHex:@"333333" alpha:1.0];
                    titleLabel.text = NSLocalizedString(@"关于我们", nil);
                    [cell addSubview:titleLabel];
                    return cell;
                }
                    break;
                default:
                    return [[UITableViewCell alloc] init];
                    break;
            }
        default:
            return NULL;
            break;
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_mainTableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        //跳转到设置状态界面
        JHSetStatusVC *vc = [[JHSetStatusVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if(section == 1){
        //跳转到设置账号界面
        JHAccountSetVC *vc = [[JHAccountSetVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (section == 2){
        //跳转到通知设置界面
        JHNotiSetVC *vc = [[JHNotiSetVC alloc] init];
         [self.navigationController pushViewController:vc animated:YES];
        
    }else if (section == 3 && row == 0){
        //跳转到打印机界面
        JHChoosePrinterVC *vc = [[JHChoosePrinterVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if(section == 3 && row == 3){
        JHWebVC *vc =[[JHWebVC alloc]init];
        vc.urlStr = [NSString stringWithFormat:@"http://%@/about/about",KReplace_Url];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 勿扰模式
- (void)handleSwitchBtn_statusEvent
{
    [JHShareModel shareModel].noDisturb = switchBtn_no_disturb.on;
}
#pragma mark - 优惠买单自动打印
- (void)handleYouhuiAuto
{
    [JHShareModel shareModel].maidan_autoPrint = switchBtn_youhui_auto.on;
}
#pragma mark - 外送订单自动打印
- (void)handle_WaisongSwitch
{
    [JHShareModel shareModel].waisong_autoPrint = switchBtn_waisongorder_auto.on;
}
#pragma mark - 展示regsterID
- (void)showRegsterID
{
    NSString *regID =  [[NSUserDefaults standardUserDefaults] objectForKey:@"registrationID"];
    
    UIAlertController *alertViewController = [UIAlertController  alertControllerWithTitle:@"RegsterID"
                                                                                  message:regID
                                                                           preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"知道了(已经复制到剪贴板)", nil) style:UIAlertActionStyleCancel handler:nil];
    [alertViewController addAction:cancelAction];
    
    CopyString(regID?regID:@"")
    
    
    [self presentViewController:alertViewController animated:YES completion:nil];
}
#pragma mark - 退出登录
- (void)logout
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"token"];
    [HttpTool postWithAPI:@"biz/account/loginout"
               withParams:@{}
                  success:^(id json) {} failure:^(NSError *error) {}];
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    JHBaseNavVC *nav1 = [[JHBaseNavVC alloc]initWithRootViewController:[JHLoginVC new]];
    window.rootViewController = nav1;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
