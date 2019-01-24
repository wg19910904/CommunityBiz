//
//  JHSetStatusVC.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/17.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHSetStatusVC.h"
#import "JHSetStatusCell.h"
#import "JHPickerView.h"
#import "JHPeiTimeVC.h"
#import "XHTextView.h"
@interface JHSetStatusVC ()<UITableViewDelegate,UITableViewDataSource>{
   UITextField *_peiTimeF;//商家配送时间
   UITextField *_yudingTimeF;//预订单时间
}
@property(nonatomic,strong)UITableView *mainTableView;
@end

@implementation JHSetStatusVC
{
    NSInteger delivcer_statusType;
    UILabel *_sTimeLabel;
    UILabel *_lTimeLabel;
    JHSetStatusCell *statusCell;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
    self.navigationItem.title = NSLocalizedString(@"营业状态", nil);
    //初始化表视图
    [self makeTableView];
}
#pragma mark - 创建表视图
- (void)makeTableView
{
    _mainTableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                              style:(UITableViewStyleGrouped)];
        tableView.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorColor = DEFAULT_BACKGROUNDCOLOR;
        [self.view addSubview:tableView];
        tableView;
    });
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
    }
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.01;
    }
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 2) {
        return 70;
    }
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                
                    UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:FRAME(0,0, WIDTH, 44)];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    //添加title
                    UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(0,0, WIDTH, 44)];
                    titleLabel.font = FONT(14);
                    titleLabel.textColor = HEX(@"333333", 1.0f);
                    titleLabel.textAlignment = NSTextAlignmentCenter;
                    titleLabel.text = NSLocalizedString(@"营业状态设置", nil);
                    [cell addSubview:titleLabel];
                    return cell;
                }
                    break;
                default:
                {
                    if (statusCell) {
                        return statusCell;
                    }
                    statusCell = [[JHSetStatusCell alloc] initWithFrame:FRAME(0,0, WIDTH, 44)];
                    NSDictionary *dic = [JHShareModel shareModel].infoDictionary;
                    NSDictionary *dic2 = [dic[@"waimai"] isKindOfClass:[NSDictionary class]]? dic[@"waimai"]:@{};
                    if (dic2 && [[dic2 allKeys] containsObject:@"yy_status"]) {
                        UIButton *selectBtn = (UIButton *)[statusCell viewWithTag:[dic2[@"yy_status"] integerValue] + 100];
                        [statusCell cilckBtn:selectBtn];
                    }
                    statusCell.statusBlock = ^(NSInteger type){
                        
                        delivcer_statusType = type;
                        
                    };
                    return statusCell;
                }
                    break;
            }
        }
            break;
        default:
            switch (indexPath.row) {
                case 0:
                {
                    UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:FRAME(0,0, WIDTH, 44)];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(10, 0, 100, 44)];
                    titleLabel.text = NSLocalizedString(@"配送时间", nil);
                    titleLabel.font = FONT(14);
                    titleLabel.textColor = HEX(@"333333", 1.0f);
                    [cell addSubview:titleLabel];
                    //添加右侧时间标签
                    if (!_sTimeLabel) {
                        _sTimeLabel = [[UILabel alloc] initWithFrame:FRAME(80, 0, WIDTH - 150, 44)];
                        _sTimeLabel.textColor = THEME_COLOR;
                        _sTimeLabel.textAlignment = NSTextAlignmentRight;
                        _sTimeLabel.font = FONT(14);
                         _sTimeLabel.userInteractionEnabled = NO;
                        NSDictionary *dic = [JHShareModel shareModel].infoDictionary;
                        NSDictionary *dic2 = [dic[@"waimai"] isKindOfClass:[NSDictionary class]]? dic[@"waimai"]:@{};
                        NSMutableArray * timeArr = dic2[@"yy_peitime"];
                        NSMutableArray *timeArr1 = @[].mutableCopy;
                        if (timeArr != nil && ![timeArr isKindOfClass:[NSNull class]] && timeArr.count != 0) {
                            for (NSDictionary *dic in timeArr) {
                                [timeArr1 addObject:[NSString stringWithFormat:@"%@-%@",dic[@"stime"],dic[@"ltime"]]];
                            }
                        }else{
                            timeArr1 = nil;
                        }
                        if (dic2 && [[dic2 allKeys] containsObject:@"yy_peitime"]) {
                            _sTimeLabel.text = [timeArr1 componentsJoinedByString:@","];
                        }
                    }
                    [cell addSubview:_sTimeLabel];
                    return cell;
                }
                    break;
                case 1:
                {
                    UITableViewCell * cell = [[UITableViewCell alloc] init];
                    cell.backgroundColor = [UIColor whiteColor];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    //添加左侧label
                    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0,85,44)];
                    titleLabel.font = FONT(14);
                    titleLabel.textColor = [UIColor colorWithHex:@"333333" alpha:1.0];
                    titleLabel.text = NSLocalizedString(@"预订单时间", @"JHShopInfoSetVC");
                    [cell addSubview:titleLabel];
                    //添加输入文本框
                    if (!_yudingTimeF) {
                        _yudingTimeF = [[UITextField alloc] initWithFrame:CGRectMake(120, 0, WIDTH - 150, 44)];
                        _yudingTimeF.textColor = THEME_COLOR;
                        _yudingTimeF.font = FONT(14);
                        _yudingTimeF.textAlignment = NSTextAlignmentRight;
                        _yudingTimeF.userInteractionEnabled = NO;
                        _yudingTimeF.text = [NSString stringWithFormat:@"%@天",[JHShareModel shareModel].infoDictionary[@"waimai"][@"yuyue_day"]];
                    }
                    [cell addSubview:_yudingTimeF];
                    return cell;
                    
                }
                    break;
                default:
                {
                    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:FRAME(0, 0, WIDTH, 70)];
                    cell.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
                    //添加保存按钮
                    UIButton *saveBtn = [[UIButton alloc] initWithFrame:FRAME(30, 15, WIDTH - 60, 40)];
                    [saveBtn setBackgroundColor:HEX(@"faaf19", 1.0f) forState:(UIControlStateNormal)];
                    [saveBtn setTitle:NSLocalizedString(@"保存修改", nil) forState:(UIControlStateNormal)];
                    [saveBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
                    saveBtn.titleLabel.font = FONT(16);
                    saveBtn.layer.cornerRadius = 3;
                    saveBtn.layer.masksToBounds = YES;
                    [saveBtn addTarget:self action:@selector(clickSaveBtn) forControlEvents:(UIControlEventTouchUpInside)];
                    [cell addSubview:saveBtn];
                    return cell;
                }
                    break;
            }
            break;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_mainTableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1 && indexPath.row  == 0){
        
        //配送时间
        JHPeiTimeVC *peiTimeVC = [JHPeiTimeVC new];
        peiTimeVC.timeArr = [_sTimeLabel.text componentsSeparatedByString:@","].mutableCopy;
        peiTimeVC.timeBlock = ^(NSArray *timeArr){
            _sTimeLabel.text = [timeArr componentsJoinedByString:@","];
        };
        [self.navigationController pushViewController:peiTimeVC animated:YES];

    }
    if (indexPath.section == 1 && indexPath.row == 1) {
        //预计单时间范围
        __block JHPickerView * pickerView = [[JHPickerView alloc]init];
        [pickerView showpickerViewWithArray:@[
                                              NSLocalizedString(@"1天", @"JHSetStatusVC"),
                                              NSLocalizedString(@"2天", @"JHSetStatusVC"),
                                              NSLocalizedString(@"3天", @"JHSetStatusVC"),
                                              NSLocalizedString(@"4天", @"JHSetStatusVC"),
                                              NSLocalizedString(@"5天", @"JHSetStatusVC"),
                                              NSLocalizedString(@"6天", @"JHSetStatusVC")].mutableCopy withSelectedText:_yudingTimeF.text  withBlock:^(NSString *result) {
                                                  if (result == nil) {
                                                      [pickerView removeFromSuperview];
                                                      pickerView = nil;
                                                      return;
                                                  }
                                                  NSLog(@"%@",result);
                                                  //获取index
                                                  NSInteger index =[@[
                                                                      NSLocalizedString(@"1天", @"JHSetStatusVC"),
                                                                      NSLocalizedString(@"2天", @"JHSetStatusVC"),
                                                                      NSLocalizedString(@"3天", @"JHSetStatusVC"),
                                                                      NSLocalizedString(@"4天", @"JHSetStatusVC"),
                                                                      NSLocalizedString(@"5天", @"JHSetStatusVC"),
                                                                      NSLocalizedString(@"6天", @"JHSetStatusVC")] indexOfObject:result];
                                                  
                                                  [JHShareModel shareModel].infoDictionary[@"waimai"][@"yuyue_day"] = @((index+1)).stringValue;
                                                  [pickerView removeFromSuperview];
                                                  pickerView = nil;
                                                  //刷新预约数据
                                                  _yudingTimeF.text =  [NSString stringWithFormat:@"%@天",[JHShareModel shareModel].infoDictionary[@"waimai"][@"yuyue_day"]];
                                              }];
    }
        
}

#pragma mark - 点击保存修改按钮
- (void)clickSaveBtn
{
//    //判断
//    BOOL correct = [self judgeTime];
//    if (correct == NO) {
//        [JHShowAlert showAlertWithMsg:NSLocalizedString(@"请选择正确时间\n结束时间需在开始时间之后", nil)];
//    }
    NSLog(@"%@",[JHShareModel shareModel].infoDictionary[@"waimai"][@"yuyue_day"]);
    SHOW_HUD
    [HttpTool postWithAPI:@"biz/shop/shop/waimai_yingye"
               withParams:@{@"yy_status":@(statusCell.statusCode),
                            @"yuyue_day":[JHShareModel shareModel].infoDictionary[@"waimai"][@"yuyue_day"],
                           }
                  success:^(id json) {
                      HIDE_HUD
                      if ([json[@"error"] isEqualToString:@"0"]) {
                          [[NSNotificationCenter defaultCenter] postNotificationName:@"KGetNewBizInfoNoti"
                                                                              object:nil];
                          [JHShowAlert showAlertWithTitle:NSLocalizedString(@"温馨提示", nil)
                                              withMessage:NSLocalizedString(@"保存成功", nil)
                                           withBtn_cancel:NSLocalizedString(@"确定", nil)
                                             withBtn_sure:nil
                                          withCancelBlock:^{
                                              [self.navigationController popViewControllerAnimated:YES];
                                          } withSureBlock:nil];
                      }else{
                          
                          [JHShowAlert showAlertWithMsg:json[@"message"]];
                          
                      }
                    
                  } failure:^(NSError *error) {
                      HIDE_HUD
                      [JHShowAlert showAlertWithMsg:NSLocalizedString(@"服务器或网络异常", nil)];
                  }];
}
- (BOOL)judgeTime
{
    NSString *stime = _sTimeLabel.text;
    NSString *ltime = _lTimeLabel.text;
    if (stime.length < 5) {
        stime = [@"0" stringByAppendingString:stime];
    }
    if (ltime.length < 5) {
        ltime = [@"0" stringByAppendingString:ltime];
    }
    return  [ltime compare:stime] == 1 ? YES : NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
