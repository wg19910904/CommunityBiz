//
//  JHNotiSetVC.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/17.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHPrinterSetVC.h"
#import "ZJSwitch.h"
#import "JHBlueToothPriterSetVC.h"
#import "JHCloudPrinterSetVC.h"
@interface JHPrinterSetVC()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *mainTableView;
@end
@implementation JHPrinterSetVC
{
    ZJSwitch *order_switch;
    ZJSwitch *evaluate_switch;
    ZJSwitch *complain_switch;
    ZJSwitch *system_switch;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"打印设置", nil);
    //创建表视图
    [self makeMainTableView];
}
#pragma mark -添加右侧按钮
- (void)createRightBtn
{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(0, 0, 40, 40)];
    [rightBtn addTarget:self action:@selector(setting) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitle:NSLocalizedString(@"设置", nil) forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = FONT(17);
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
}
#pragma mark - 创建表视图
- (void)makeMainTableView
{
    _mainTableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                              style:(UITableViewStyleGrouped)];
        
        tableView.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
        tableView.separatorColor = DEFAULT_BACKGROUNDCOLOR;
        tableView.delegate = self;
        tableView.dataSource = self;
        [self.view addSubview:tableView];
        tableView;
    });
}
#pragma mark - tableView delegate and dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSArray *titleArray = @[NSLocalizedString(@"蓝牙打印设置", nil),NSLocalizedString(@"云打印设置", nil)];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:FRAME(0, 0, WIDTH, 44)];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //添加左侧titleLabel
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(10, 0, 100, 44)];
    titleLabel.text = titleArray[row];
    titleLabel.font = FONT(14);
    titleLabel.textColor = HEX(@"333333", 1.0f);
    [cell addSubview:titleLabel];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_mainTableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        //跳转到蓝牙设置界面
        JHBlueToothPriterSetVC * vc = [[JHBlueToothPriterSetVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        //跳转云打印设置界面
        JHCloudPrinterSetVC * vc = [[JHCloudPrinterSetVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
