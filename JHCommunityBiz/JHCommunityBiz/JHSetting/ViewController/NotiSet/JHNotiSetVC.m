//
//  JHNotiSetVC.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/17.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHNotiSetVC.h"
#import "JHNotiSetModel.h"
@interface JHNotiSetVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *mainTableView;
@end
@implementation JHNotiSetVC
{
    UISwitch *order_switch;
    UISwitch *evaluate_switch;
    UISwitch *complain_switch;
    UISwitch *system_switch;
    JHNotiSetModel * statusModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"通知设置", nil);
    //获取通知的各种状态的
    [self postHttpForStatus];
}
#pragma mark - 这是获取通知设置的各种状态
-(void)postHttpForStatus{
    SHOW_HUD
    [HttpTool postWithAPI:@"biz/noti/get" withParams:@{} success:^(id json) {
        NSLog(@"json+++%@",json);
        if ([json[@"error"] isEqualToString:@"0"]) {
            statusModel = [[JHNotiSetModel alloc]initWithDictionary:json[@"data"][@"noti"]];
        }else{
            [JHShowAlert showAlertWithMsg:json[@"message"]];
        }
        HIDE_HUD
        //创建表视图
        [self makeMainTableView];
    } failure:^(NSError *error) {
        HIDE_HUD
        NSLog(@"%@",error.localizedDescription);
    }];
}
#pragma mark - 创建表视图
- (void)makeMainTableView
{
    if (_mainTableView == nil) {
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

    }else{
        [_mainTableView reloadData];
    }
}
#pragma mark - tableView delegate and dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
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
    NSArray *titleArray = @[NSLocalizedString(@"订单/催单消息", nil),NSLocalizedString(@"评价消息", nil),NSLocalizedString(@"投诉消息", nil),NSLocalizedString(@"系统消息", nil)];
    //方法
    SEL s1 = @selector(handleOrder_Switch);
    SEL s2 = @selector(handleEvaluate_switch);
    SEL s3 = @selector(handleComplain_switch);
    SEL s4 = @selector(handleSystem_switch);
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:FRAME(0, 0, WIDTH, 44)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //添加左侧titleLabel
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(10, 0, 100, 44)];
    titleLabel.text = titleArray[row];
    titleLabel.font = FONT(14);
    titleLabel.textColor = HEX(@"333333", 1.0f);
    [cell addSubview:titleLabel];
    
    //添加右侧switch开关;
    if (row == 0) {
        if (!order_switch) {
            order_switch = [[UISwitch alloc] initWithFrame:FRAME(WIDTH - 58, 5, 32.5, 20)];
            order_switch.transform = CGAffineTransformMakeScale(0.8, 0.8);
            order_switch.backgroundColor = [UIColor clearColor];
            order_switch.tintColor = DEFAULT_BACKGROUNDCOLOR;
            order_switch.onTintColor = THEME_COLOR;
            if ([statusModel.order_msg isEqualToString:@"1"]) {
                [order_switch setOn:YES animated:YES];
            }else{
                [order_switch setOn:NO animated:YES];
            }
            [order_switch addTarget:self action:s1 forControlEvents:UIControlEventAllTouchEvents];
        }
        [cell addSubview:order_switch];
    }
    if (row == 1) {
        if (!evaluate_switch) {
            evaluate_switch = [[UISwitch alloc] initWithFrame:FRAME(WIDTH - 58, 5, 32.5, 20)];
            evaluate_switch.transform = CGAffineTransformMakeScale(0.8, 0.8);
            evaluate_switch.backgroundColor = [UIColor clearColor];
            evaluate_switch.tintColor = DEFAULT_BACKGROUNDCOLOR;
            evaluate_switch.onTintColor = THEME_COLOR;
            [evaluate_switch addTarget:self action:s2 forControlEvents:(UIControlEventAllTouchEvents)];
        }
        if ([statusModel.comment_msg isEqualToString:@"1"]) {
            [evaluate_switch setOn:YES animated:YES];
        }else{
            [evaluate_switch setOn:NO animated:YES];
        }
        [cell addSubview:evaluate_switch];
    }
    if (row == 2) {
        if (!complain_switch) {
            complain_switch = [[UISwitch alloc] initWithFrame:FRAME(WIDTH - 58, 5, 32.5, 20)];
            complain_switch.transform = CGAffineTransformMakeScale(0.8, 0.8);
            complain_switch.backgroundColor = [UIColor clearColor];
            complain_switch.tintColor = DEFAULT_BACKGROUNDCOLOR;
            complain_switch.onTintColor = THEME_COLOR;
            [complain_switch addTarget:self action:s3 forControlEvents:(UIControlEventAllTouchEvents)];
        }
        if ([statusModel.complaint_msg isEqualToString:@"1"]) {
            [complain_switch setOn:YES animated:YES];
        }else{
            [complain_switch setOn:NO animated:YES];        }
        [cell addSubview:complain_switch];
    }
    if (row == 3) {
        if (!system_switch) {
            system_switch = [[UISwitch alloc] initWithFrame:FRAME(WIDTH - 58, 5, 32.5, 20)];
            system_switch.transform = CGAffineTransformMakeScale(0.8, 0.8);
            system_switch.backgroundColor = [UIColor clearColor];
            system_switch.tintColor = DEFAULT_BACKGROUNDCOLOR;
            system_switch.onTintColor = THEME_COLOR;
            [system_switch addTarget:self action:s4 forControlEvents:(UIControlEventAllTouchEvents)];
        }
        if ([statusModel.system_msg isEqualToString:@"1"]) {
            [system_switch setOn:YES animated:YES];
        }else{
            [system_switch setOn:NO animated:YES];
        }
        [cell addSubview:system_switch];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_mainTableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - 订单消息开关
- (void)handleOrder_Switch
{
    NSLog(@"切换订单消息开关");
    if (order_switch.on) {
        //打开订单消息开关
        [self postSetNotWithDic:@{@"order_msg":@"1"}  withSwitch:order_switch];
    }else{
        [self postSetNotWithDic:@{@"order_msg":@"0"}  withSwitch:order_switch];
    }
}
#pragma mark - 评价消息开关
- (void)handleEvaluate_switch
{
    NSLog(@"切换评价消息开关");
    if (evaluate_switch.on) {
        //打开评价消息开关
        [self postSetNotWithDic:@{@"comment_msg":@"1"}  withSwitch:evaluate_switch];
    }else{
        [self postSetNotWithDic:@{@"comment_msg":@"0"}  withSwitch:evaluate_switch];
    }
}
#pragma mark - 投诉催单消息开关
- (void)handleComplain_switch
{
    NSLog(@"切换投诉催单消息开关");
    if (complain_switch.on) {
        [self postSetNotWithDic:@{@"complaint_msg":@"1"}  withSwitch:complain_switch];
    }else{
        [self postSetNotWithDic:@{@"complaint_msg":@"0"}  withSwitch:complain_switch];
    }
}
#pragma mark - 系统消息开关
- (void)handleSystem_switch
{
    NSLog(@"切换系统消息开关");
    if(system_switch.on){
        //打开系统消息的开关
        [self postSetNotWithDic:@{@"system_msg":@"1"}  withSwitch:system_switch];
    }else{
        [self postSetNotWithDic:@{@"system_msg":@"0"}  withSwitch:system_switch];
    }
}
#pragma mark - 设置是否接受消息提醒的方法
-(void)postSetNotWithDic:(NSDictionary *)dic withSwitch:(UISwitch *)mySwitch{
    [HttpTool postWithAPI:@"biz/noti/set" withParams:dic success:^(id json) {
        
        if ([json[@"error"] isEqualToString:@"0"]) {
            
        }else{
            [JHShowAlert showAlertWithMsg:json[@"message"]];
            [mySwitch setOn:NO animated:YES];
        }
    } failure:^(NSError *error) {
        [JHShowAlert showAlertWithMsg:NSLocalizedString(@"服务器繁忙,请稍后访问", nil)];
        [mySwitch setOn:NO animated:YES];
        NSLog(@"%@",error.localizedDescription);
    }];
}
@end
