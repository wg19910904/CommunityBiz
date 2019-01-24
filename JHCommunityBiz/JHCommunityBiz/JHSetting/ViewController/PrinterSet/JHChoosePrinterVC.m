//
//  JHChoosePrinterVC.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/18.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHChoosePrinterVC.h"
#import "JHPrinterSetVC.h"
#import "JHCludeModel.h"
#import "JHCludeTableViewCell.h"
#import "JHCloudPrinterSetVC.h"
@interface JHChoosePrinterVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *mainTableView;
@end

@implementation JHChoosePrinterVC
{
    //蓝牙打印开关
    UISwitch *blueTooth_switch;
    UISwitch *cloud_switch;
    //第二个分区的标题
    UILabel *section_title;
    //蓝牙设备数据源
    NSMutableArray *_allPeripheralArray;
    UILabel * label_current;
    NSMutableArray * _allCloudArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _allCloudArray = @[].mutableCopy;
    self.navigationItem.title = NSLocalizedString(@"选择打印机", nil);
    //创建表视图
    [self makeMainTableView];
    //创建右侧按钮
    [self createRightBtn];
    //蓝牙连接上后需要改变的一些状态
    [[JHShareModel shareModel].blueTooth setConnectBlock:^(BOOL connect){
        [self changeStatus];
    }];
    //蓝牙关闭
    [[JHShareModel shareModel].blueTooth setPowerOffBlock:^{
        [self BlueTooth_PowerOff];
    }];
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(connectInActive) name:@"connectInActive" object:nil];
}
-(void)connectInActive{
    blueTooth_switch.on = YES;
    [self handleBlueTooth_switch:blueTooth_switch];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //云打印
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"CLOUD_STATE"]) {
        [self postForCloudPrict];
    }
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [_allCloudArray removeAllObjects];
    [_mainTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}
#pragma mark - 创建表视图
- (void)makeMainTableView
{
    _mainTableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                              style:(UITableViewStyleGrouped)];
        tableView.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
        tableView.separatorColor = DEFAULT_BACKGROUNDCOLOR;
        [tableView registerClass:[JHCludeTableViewCell class] forCellReuseIdentifier:@"cell_tableView_cloud"];
        tableView.delegate = self;
        tableView.dataSource = self;
        [self.view addSubview:tableView];
        tableView;
    });
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
#pragma mark - 点击设置按钮
- (void)setting
{
    JHPrinterSetVC *vc = [[JHPrinterSetVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - tableView delegate and dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }else {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"BLUETOOTH_STATE"]) {
            return _allPeripheralArray.count;
        }else{
            return _allCloudArray.count;
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 30;
    }
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        UIView *backView = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 30)];
        backView.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
        if (!section_title) {
            section_title = ({
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, WIDTH - 20, 30)];
                label.text = NSLocalizedString(@"打印设备列表", nil);
                label.textColor = [UIColor colorWithHex:@"999999" alpha:1.0];
                label.font = FONT(14);
                [backView addSubview:label];
                label;
            });
        }
        [backView addSubview:section_title];
        return backView;
    }else{
        return [UIView new];
    }
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
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        if (row == 0) {
            static NSString * str_resuable = @"cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str_resuable];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str_resuable];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel * label = [cell viewWithTag:2000];
            [label removeFromSuperview];
            label = nil;
            //添加左侧titleLabel
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(10, 0, 100, 44)];
            titleLabel.text = NSLocalizedString(@"蓝牙打印", nil);
            titleLabel.font = FONT(14);
            titleLabel.tag = 2000;
            titleLabel.textColor = HEX(@"333333", 1.0f);
            [cell addSubview:titleLabel];
            if (!blueTooth_switch) {
                blueTooth_switch = [[UISwitch alloc] initWithFrame:switch_rect];
                blueTooth_switch.transform = CGAffineTransformMakeScale(0.8, 0.8);
                blueTooth_switch.backgroundColor = [UIColor clearColor];
                blueTooth_switch.tintColor = DEFAULT_BACKGROUNDCOLOR;
                blueTooth_switch.onTintColor = THEME_COLOR;
                [blueTooth_switch addTarget:self
                                     action:@selector(handleBlueTooth_switch:)
                           forControlEvents:UIControlEventAllTouchEvents];
                [cell addSubview:blueTooth_switch];
                if ([[NSUserDefaults standardUserDefaults] boolForKey:@"BLUETOOTH_STATE"]) {
                    [blueTooth_switch setOn:YES animated:YES];
                    [self handleBlueTooth_switch:blueTooth_switch];
                    [JHShareModel shareModel].blueTooth.refreshBlock = ^(NSMutableArray *allPeripheralArray){
                        
                        _allPeripheralArray = allPeripheralArray;
                        [_mainTableView reloadSections:[NSIndexSet indexSetWithIndex:1]
                                      withRowAnimation:UITableViewRowAnimationNone];
                    };
                    [[JHShareModel shareModel].blueTooth handleStatus];
                }else{
                    [blueTooth_switch setOn:NO animated:YES];
                }
            }
            return cell;
        } else {
            static NSString * str = @"CELL";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel * label = [cell viewWithTag:1000];
            [label removeFromSuperview];
            label = nil;
            //添加左侧titleLabel
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(10, 0, 100, 44)];
            titleLabel.text = NSLocalizedString(@"云打印", nil);
            titleLabel.font = FONT(14);
            titleLabel.tag = 1000;
            titleLabel.textColor = HEX(@"333333", 1.0f);
            [cell addSubview:titleLabel];
            if (!cloud_switch) {
                cloud_switch = [[UISwitch alloc] initWithFrame:switch_rect];
                cloud_switch.transform = CGAffineTransformMakeScale(0.8, 0.8);
                cloud_switch.backgroundColor = [UIColor clearColor];
                cloud_switch.tintColor = DEFAULT_BACKGROUNDCOLOR;
                cloud_switch.onTintColor = THEME_COLOR;
                [cloud_switch addTarget:self action:@selector(handleCloud_switch:)
                           forControlEvents:(UIControlEventAllTouchEvents)];
            }
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"CLOUD_STATE"]) {
                [cloud_switch setOn:YES animated:YES];
            }else{
                [cloud_switch setOn:NO animated:YES];
            }
            [cell addSubview:cloud_switch];
            return cell;
        }
    } else {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"BLUETOOTH_STATE"]) {
            UITableViewCell * cell = [[UITableViewCell alloc]init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            CBPeripheral * peripheral = _allPeripheralArray[indexPath.row];
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            cell.textLabel.text = peripheral.name;
            UIButton * btn = [cell viewWithTag:100+indexPath.row];
            [btn removeFromSuperview];
            btn = nil;
            UIButton * btn_state = [[UIButton alloc]initWithFrame:FRAME(WIDTH - 90, 5, 80, 34)];
            [btn_state setTitleColor:THEME_COLOR forState:UIControlStateNormal];
            btn_state.titleLabel.font = [UIFont systemFontOfSize:15];
            btn_state.layer.borderColor = THEME_COLOR.CGColor;
            btn_state.layer.borderWidth = YES;
            btn_state.layer.cornerRadius = 3;
            btn_state.layer.masksToBounds = YES;
            btn_state.tag = 100+indexPath.row;
            [cell addSubview:btn_state];
            if (peripheral.state == CBPeripheralStateConnected) {
               [btn_state setTitle:NSLocalizedString(@"断开", nil) forState:UIControlStateNormal];
               [btn_state setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }else{
                [btn_state setTitle:NSLocalizedString(@"连接", nil) forState:UIControlStateNormal];
                [btn_state setTitleColor:THEME_COLOR forState:UIControlStateNormal];
            }
            [btn_state addTarget:self action:@selector(clickToConnectBlueTooth:) forControlEvents:UIControlEventTouchUpInside];
            return cell;

        }else{
            JHCludeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell_tableView_cloud" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            JHCludeModel * model = _allCloudArray[indexPath.row];
            cell.indexPath = indexPath;
            cell.model = model;
            [cell.btn_set addTarget:self action:@selector(clickToSet:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btn_revise addTarget:self action:@selector(clickToRevise:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btn_delete addTarget:self action:@selector(clickToDelete:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
 
        }
    }
}
#pragma mark - 这是点击连接蓝牙的方法
-(void)clickToConnectBlueTooth:(UIButton *)sender{
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"BLUETOOTH_STATE"]) {
            NSLog(@"点击连接蓝牙");
            UITableViewCell * cell = (UITableViewCell *)[sender superview];
            NSIndexPath * indexPath = [_mainTableView indexPathForCell:cell];
            [[NSUserDefaults standardUserDefaults] setInteger:indexPath.row forKey:@"INDEXPATH"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            if ([sender.titleLabel.text isEqualToString:NSLocalizedString(@"断开", nil)]) {
                [[JHShareModel shareModel].blueTooth cancelPeripheralConnection];
                [sender setTitle:NSLocalizedString(@"连接", nil) forState:UIControlStateNormal];
                [sender setTitleColor:THEME_COLOR forState:UIControlStateNormal];
            }else{
                SHOW_HUD
                //断开其他蓝牙
                if ([JHShareModel shareModel].blueTooth.peripheral) {
                    [[JHShareModel shareModel].blueTooth cancelPeripheralConnection];
                }
                //执行连接蓝牙的代码
                CBPeripheral  *  peripheral = _allPeripheralArray[indexPath.row];
                [[JHShareModel shareModel].blueTooth connectPeripheral:peripheral];
            }
            
        }

}
#pragma mark - 这是点击启用/不启用的方法
-(void)clickToSet:(UIButton *)sender{
    NSLog(@"点击的是启用>>>%ld",sender.tag);
    if ([sender.titleLabel.text isEqualToString:NSLocalizedString(@"启用", nil)]) {
        for (JHCludeModel * model in _allCloudArray) {
            if ([model.status isEqualToString:@"1"]) {
                [self postHttpForSettingWithPlat_id:model.plat_id];
            }
        }
        [self postHttpForSettingWithStatus:@"1" withBtn:sender];
    }else{
        [self postHttpForSettingWithStatus:@"0" withBtn:sender];
    }
}
#pragma mark - 这是专门处理在点击一个启用的时候,其他的都变成不可启用
-(void)postHttpForSettingWithPlat_id:(NSString * )plat_id{
    [HttpTool postWithAPI:@"biz/printer/setstatus" withParams:@{@"plat_id":plat_id,@"status":@"0"} success:^(id json)
     {
         if ([json[@"error"] isEqualToString:@"0"]) {
             [_mainTableView reloadData];
        }else{
         
        }
     } failure:^(NSError *error) {}];
 
}
#pragma mark - 这是发送是否启用的方法
-(void)postHttpForSettingWithStatus:(NSString * )status withBtn:(UIButton *)sender {
    SHOW_HUD
    JHCludeModel * model = _allCloudArray[sender.tag];
    [HttpTool postWithAPI:@"biz/printer/setstatus" withParams:@{@"plat_id":model.plat_id,@"status":status} success:^(id json)
     {
         if ([json[@"error"] isEqualToString:@"0"]) {
             if ([status isEqualToString:@"1"]) {
                 [sender setTitle:NSLocalizedString(@"已启用", nil) forState:UIControlStateNormal];
                 [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"yunPrintState"];
                 [[NSUserDefaults standardUserDefaults] synchronize];
                  [JHShareModel shareModel].printType = @"yunPrint";
                  model.status = @"1";
             }else{
                 [sender setTitle:NSLocalizedString(@"启用", nil) forState:UIControlStateNormal];
                 [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"yunPrintState"];
                 [[NSUserDefaults standardUserDefaults] synchronize];
                  [JHShareModel shareModel].printType = @"";
                  model.status = @"0";
             }
         }else{
             [JHShowAlert showAlertWithMsg:json[@"message"]];
         }
         HIDE_HUD
     } failure:^(NSError *error) {
         HIDE_HUD
         [JHShowAlert showAlertWithMsg:NSLocalizedString(@"服务器繁忙,请稍后访问", nil)];
     }];
 
}
#pragma mark - 点击的是修改
-(void)clickToRevise:(UIButton *)sender{
    NSLog(@"点击的是修改>>>%ld",sender.tag);
    JHCludeModel * model = _allCloudArray[sender.tag];
    JHCloudPrinterSetVC * vc = [[JHCloudPrinterSetVC alloc]init];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark - 点击的是删除
-(void)clickToDelete:(UIButton *)sender{
    NSLog(@"点击的是删除>>>%ld",sender.tag);
    SHOW_HUD
    JHCludeModel * model = _allCloudArray[sender.tag];
    [HttpTool postWithAPI:@"biz/printer/delete" withParams:@{@"plat_id":model.plat_id} success:^(id json) {
        HIDE_HUD
        if ([json[@"error"] isEqualToString:@"0"]) {
            [_allCloudArray removeObjectAtIndex:sender.tag];
            [_mainTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        }else{
            [JHShowAlert showAlertWithMsg:json[@"message"]];
        }
    } failure:^(NSError *error) {
        HIDE_HUD
        [JHShowAlert showAlertWithMsg:NSLocalizedString(@"服务器繁忙,请稍后访问", nil)];
        NSLog(@"error:%@",error.localizedDescription);
    }];
}
-(void)changeStatus{
    HIDE_HUD
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:[[NSUserDefaults standardUserDefaults] integerForKey:@"INDEXPATH"] inSection:1];
    UITableViewCell * cell = [_mainTableView cellForRowAtIndexPath:indexPath];
    UIButton  * btn = [cell viewWithTag:100+indexPath.row];
    [btn setTitle:NSLocalizedString(@"断开", nil) forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_mainTableView reloadData];
}
-(void)BlueTooth_PowerOn{
    
}
-(void)BlueTooth_PowerOff{
    [blueTooth_switch setOn:NO animated:YES];
    [[JHShareModel shareModel].blueTooth stopScan];
    [_allPeripheralArray removeAllObjects];
    [_mainTableView reloadSections:[NSIndexSet indexSetWithIndex:1]
                  withRowAnimation:UITableViewRowAnimationNone];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"BLUETOOTH_STATE"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
#pragma mark - 切换蓝牙开关
- (void)handleBlueTooth_switch:(UISwitch *)sender
{
    [JHShareModel shareModel].blueTooth.switchBlock = ^(BOOL on){
        [blueTooth_switch setOn:on animated:YES];
    };
    
    if (sender.on) {
        [cloud_switch setOn:NO animated:YES];
        [_allCloudArray removeAllObjects];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"CLOUD_STATE"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"yunPrintState"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [JHShareModel shareModel].blueTooth.refreshBlock = ^(NSMutableArray *allPeripheralArray){
        _allPeripheralArray = allPeripheralArray;
        [_mainTableView reloadSections:[NSIndexSet indexSetWithIndex:1]
                          withRowAnimation:UITableViewRowAnimationNone];
        };
        [[JHShareModel shareModel].blueTooth handleStatus];

    }else{
        if ([JHShareModel shareModel].blueTooth.peripheral.state == CBPeripheralStateConnected ) {
            [[JHShareModel shareModel].blueTooth cancelPeripheralConnection];
        }
        [[JHShareModel shareModel].blueTooth stopScan];
        [_allPeripheralArray removeAllObjects];
        [_mainTableView reloadSections:[NSIndexSet indexSetWithIndex:1]
                      withRowAnimation:UITableViewRowAnimationNone];
    }
    [[NSUserDefaults standardUserDefaults] setBool:sender.on forKey:@"BLUETOOTH_STATE"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    if (sender.on) {
        [JHShareModel shareModel].printType = @"blueTooth";
    }
}
#pragma mark - 切换云打印开关
- (void)handleCloud_switch:(UISwitch * )sender
{
    if (sender.on) {
        [blueTooth_switch setOn:NO];
        if ([JHShareModel shareModel].blueTooth.peripheral.state == CBPeripheralStateConnected ) {
            [[JHShareModel shareModel].blueTooth cancelPeripheralConnection];
        }
        [[JHShareModel shareModel].blueTooth stopScan];
        [_allPeripheralArray removeAllObjects];
        [_mainTableView reloadSections:[NSIndexSet indexSetWithIndex:1]
                      withRowAnimation:UITableViewRowAnimationNone];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"BLUETOOTH_STATE"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"CLOUD_STATE"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [self postForCloudPrict];
    }else{
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"yunPrintState"];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"CLOUD_STATE"];
        [[NSUserDefaults standardUserDefaults] synchronize];
         [_allCloudArray removeAllObjects];
        [_mainTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
#pragma mark - 这是请求云打印数据的接口
-(void)postForCloudPrict{
    HIDE_HUD
    SHOW_HUD
    [HttpTool postWithAPI:@"biz/printer/items" withParams:@{} success:^(id json) {
        HIDE_HUD
        if ([json[@"error"] isEqualToString:@"0"]) {
            NSArray * tempArray = json[@"data"][@"items"];
            [_allCloudArray removeAllObjects];
            for (NSDictionary * dic  in tempArray) {
                JHCludeModel * clude_model = [JHCludeModel creatJHCludeModelWithDic:dic];
                [_allCloudArray addObject:clude_model];
            }
            if (_allCloudArray.count > 0) {
                [_mainTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
            }
        }else{
            [JHShowAlert showAlertWithMsg:json[@"message"]];
        }
        
    } failure:^(NSError *error) {
        HIDE_HUD
        [JHShowAlert showAlertWithMsg:NSLocalizedString(@"服务器繁忙,请稍后访问", nil)];
        NSLog(@"error:%@",error.localizedDescription);
    }];
}
@end
