//
//  IncompleteJieVC.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/24.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "DeliveryOrderListVC.h"
#import "DeliveryOrderCell.h"
#import "DeliceryOrderJieVM.h"
#import <MJRefresh.h>
#import "DeliveryOrderDetailVC.h"
#import "DeliveryReplyVC.h"
#import "JHGroupScanControl.h"
#import "JHTakeTheirMsgVC.h"
#import "JHReplyVC.h"
@interface DeliveryOrderListVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *mainTableView;
@end

@implementation DeliveryOrderListVC
{
    NSInteger page;
    DeliceryOrderJieVM *vm;
    NSMutableArray *dataSource;
    //刷新头和尾
    MJRefreshNormalHeader *_header;
    MJRefreshAutoNormalFooter *_footer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    page = 1;
    dataSource = @[].mutableCopy;
    self.navigationItem.title = NSLocalizedString(@"筛选结果", nil);
    //创建表视图
    [self createMainTableView];
    if (!self.superVC) {
        self.superVC = self;
    }
    //获取数据
    [self loadNewData];
}
#pragma mark - 创建表视图
- (void)createMainTableView
{
    CGFloat fixHeight = _addCondition.count > 0 ? 0.0 : 40;
    _mainTableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, WIDTH, HEIGHT - 64 - fixHeight)
                                                              style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
        tableView.separatorColor = LINE_COLOR;
        tableView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:tableView];
        tableView.layoutMargins = UIEdgeInsetsZero;
        tableView.separatorInset = UIEdgeInsetsZero;
        //添加刷新表头
        _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        _header.stateLabel.textColor = [UIColor colorWithRed:129/255.0 green:129/255.0 blue:129/255.0 alpha:1];
        _header.lastUpdatedTimeLabel.hidden = YES;
        [_header setTitle:NSLocalizedString(@"下拉可以刷新", nil) forState:MJRefreshStateIdle];
        [_header setTitle:NSLocalizedString(@"现在可以刷新啦", nil) forState:MJRefreshStatePulling];
        [_header setTitle:NSLocalizedString(@"正在为您努力刷新中", nil) forState:MJRefreshStateRefreshing];
        tableView.mj_header = _header;
        //创建加载表尾
        _footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self
                                                       refreshingAction:@selector(loadMoreData)];
        [_footer setTitle:@"" forState:MJRefreshStateIdle];//普通闲置状态
        tableView.mj_footer = _footer;
        tableView;
    });
}
#pragma mark - tableView delegate and dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DeliveryOrderCellModel *model = dataSource[indexPath.section];
    return getStrHeight([model.addr stringByAppendingString:model.house? model.house:@""], WIDTH - 150, 14) + 10 + getStrHeight(model.intro, WIDTH - 30, 14) + 190 + 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DeliveryOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeliveryOrderCellID"];
    if (!cell) {
        cell = [[DeliveryOrderCell alloc] initWithStyle:(UITableViewCellStyleDefault)
                                        reuseIdentifier:@"DeliveryOrderCellID"];
    }
    cell.dataModel = dataSource[indexPath.section];
    [cell.giveUpBtn addTarget:self action:@selector(clickCellGiveUpBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    cell.giveUpBtn.hidden = self.listType != EWaimai_OrderList_type_daijiedan;
    [cell.replyBtn addTarget:self
                      action:@selector(replyCui:)
            forControlEvents:(UIControlEventTouchUpInside)];
    //判断当前需要展示的类型
    if (cell.dataModel.order_status.integerValue == 0) {
        self.listType = EWaimai_OrderList_type_daijiedan;
    }
    if (cell.dataModel.order_status.integerValue == 1 ||
        cell.dataModel.order_status.integerValue == 2 ||
        cell.dataModel.order_status.integerValue == 3 ||
        cell.dataModel.order_status.integerValue == 4) {
        self.listType = EWaimai_OrderList_type_delivering;
    }
    
    if (cell.dataModel.order_status.integerValue == 8 ) {
        self.listType = EWaimai_OrderList_type_complete;
    }
    
    if (cell.dataModel.order_status.integerValue == -1) {
        self.listType = EWaimai_OrderList_type_cancel;
    }
    
    switch (self.listType) {
        case EWaimai_OrderList_type_daijiedan:
        {
          [cell.actionBtn setTitle:NSLocalizedString(@"接单", nil) forState:(UIControlStateNormal)];
          [cell.actionBtn setTitleColor:HEX(@"faaf19",1.0) forState:(UIControlStateNormal)];
        }
            break;
        case EWaimai_OrderList_type_delivering:
        {
            if (cell.dataModel.pei_type.integerValue == 3) {//核销
                [cell.actionBtn setTitle:NSLocalizedString(@"核销", nil) forState:(UIControlStateNormal)];
                [cell.actionBtn setTitleColor:HEX(@"faaf19", 1.0) forState:(UIControlStateNormal)];
            }if (cell.dataModel.pei_type.integerValue == 4) {//核销
                [cell.actionBtn setTitle:NSLocalizedString(@"已出餐", nil) forState:(UIControlStateNormal)];
                [cell.actionBtn setTitleColor:HEX(@"faaf19", 1.0) forState:(UIControlStateNormal)];
            }
            else if(cell.dataModel.order_status.integerValue == 1 ||
                     cell.dataModel.order_status.integerValue == 2){
                [cell.actionBtn setTitle:NSLocalizedString(@"配送", nil) forState:(UIControlStateNormal)];
                [cell.actionBtn setTitleColor:HEX(@"faaf19", 1.0) forState:(UIControlStateNormal)];
            }else if (cell.dataModel.order_status.integerValue == 3){
                [cell.actionBtn setTitle:NSLocalizedString(@"确认送达", nil) forState:(UIControlStateNormal)];
                [cell.actionBtn setTitleColor:HEX(@"faaf19", 1.0) forState:(UIControlStateNormal)];
            }else if (cell.dataModel.order_status.integerValue == 4){
                [cell.actionBtn setTitle:NSLocalizedString(@"已送达", nil) forState:(UIControlStateNormal)];
                [cell.actionBtn setTitleColor:HEX(@"999999", 1.0) forState:(UIControlStateNormal)];
            }
        }
            break;
        case EWaimai_OrderList_type_complete:
        {
            if ([cell.dataModel.comment_info[@"reply_time"] integerValue] > 0) {
                [cell.actionBtn setTitle:NSLocalizedString(@"已回复", nil) forState:(UIControlStateNormal)];
                [cell.actionBtn setTitleColor:HEX(@"999999", 1.0) forState:(UIControlStateNormal)];
            }else if ([cell.dataModel.comment_status integerValue] > 0){
                [cell.actionBtn setTitle:NSLocalizedString(@"回复", nil) forState:(UIControlStateNormal)];
                [cell.actionBtn setTitleColor:HEX(@"faaf19", 1.0) forState:(UIControlStateNormal)];
            }else if ([cell.dataModel.order_status isEqualToString:@"-1"]){
                [cell.actionBtn setTitle:NSLocalizedString(@"已取消", nil) forState:(UIControlStateNormal)];
                [cell.actionBtn setTitleColor:HEX(@"999999", 1.0) forState:(UIControlStateNormal)];
            }else if ([cell.dataModel.order_status isEqualToString:@"8"]){
                [cell.actionBtn setTitle:NSLocalizedString(@"已完成", nil) forState:(UIControlStateNormal)];
                [cell.actionBtn setTitleColor:HEX(@"999999", 1.0) forState:(UIControlStateNormal)];
            }
        }
            break;
        case EWaimai_OrderList_type_cancel:
        {
            [cell.actionBtn setTitle:NSLocalizedString(@"已取消", nil) forState:(UIControlStateNormal)];
            [cell.actionBtn setTitleColor:HEX(@"999999", 1.0) forState:(UIControlStateNormal)];
        }
            break;
        default:
            break;
    }
    [cell.actionBtn addTarget:self action:@selector(clickActionBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //获取order_id
    DeliveryOrderCellModel *cellModel = (DeliveryOrderCellModel *)dataSource[indexPath.section];
    NSString *order_id = cellModel.order_id;
    DeliveryOrderDetailVC *vc = [[DeliveryOrderDetailVC alloc] init];
    vc.order_id = order_id;
    __weak typeof (self)weakSelf = self;
    [vc setMyBlock:^{
        [weakSelf loadNewData];
    }];
    [self.superVC.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 获取新数据
- (void)loadNewData
{
    HIDE_HUD
    SHOW_HUD
    if (_addCondition == nil) {
        _addCondition = @{}.mutableCopy;
    }
    page = 1;
    //判断是否从筛选界面跳转过来
    NSString *status = @(_listType).stringValue;
    if ([_addCondition.allKeys containsObject:@"so"]) {
        status = @"";
    }
    [_addCondition setObject:status forKey:@"status"];
    [_addCondition setObject:@(page) forKey:@"page"];
    [HttpTool postWithAPI:@"biz/waimai/order/order/items"
               withParams:_addCondition
                  success:^(id json) {
                      HIDE_HUD
                      NSLog(@"biz/waimai/order/order/items--%@",json);
                      if ([json[@"error"] isEqualToString:@"0"]) {
                          vm = [DeliceryOrderJieVM yy_modelWithJSON:json[@"data"]];
                          [dataSource removeAllObjects];
                          [dataSource addObjectsFromArray:vm.items];
                          [_mainTableView reloadData];
                      }else{
                          [JHShowAlert showAlertWithMsg:json[@"message"]];
                      }
                      [_header endRefreshing];
                  }
                  failure:^(NSError *error) {
                      HIDE_HUD
                      [_header endRefreshing];
                      [JHShowAlert showAlertWithMsg:NSLocalizedString(@"服务器连接异常", nil)];
                      
                  }];
}
#pragma mark - 加载更多数据
- (void)loadMoreData
{
    SHOW_HUD
    page++;
    [_addCondition setObject:@(page) forKey:@"page"];
    [HttpTool postWithAPI:@"biz/waimai/order/order/items"
               withParams:_addCondition
                  success:^(id json) {
                      HIDE_HUD
                      NSLog(@"biz/waimai/order/order/items--%@",json);
                      if ([json[@"error"] isEqualToString:@"0"]) {
                          vm = [DeliceryOrderJieVM yy_modelWithJSON:json[@"data"]];
                          [dataSource addObjectsFromArray:vm.items];
                          [_mainTableView reloadData];
                      }else{
                          [JHShowAlert showAlertWithMsg:json[@"message"]];
                      }
                      [_footer endRefreshing];
                  }
                  failure:^(NSError *error) {
                      HIDE_HUD
                      [_footer endRefreshing];
                      [JHShowAlert showAlertWithMsg:NSLocalizedString(@"服务器连接异常", nil)];
                  }];
}
- (void)clickActionBtn:(UIButton *)sender{
    NSString *title = sender.titleLabel.text;
    if ([title isEqualToString:NSLocalizedString(@"接单", nil)]) {
        [self clickCellJieBtn:sender];
    }else if([title isEqualToString:NSLocalizedString(@"配送", nil)]){
        [self clickCellDeliveryBtn_pei:sender];
    }else if([title isEqualToString:NSLocalizedString(@"核销", nil)]){
        [self clickCellDeliveryBtn_hexiao:sender];
    }else if([title isEqualToString:NSLocalizedString(@"确认送达", nil)]){
        [self clickCellDeliveryBtn_arrive:sender];
    }else if([title isEqualToString:NSLocalizedString(@"回复", nil)]){
        [self clickCellReplyBtn:sender];
    }else if([title isEqualToString:NSLocalizedString(@"已出餐", nil)]){
        [self clickCellDeliveryBtn_arrive:sender];
    }
    
}
#pragma mark - 点击cell放弃接单按钮
- (void)clickCellGiveUpBtn:(UIButton *)sender
{
    DeliveryOrderCell *cell = (DeliveryOrderCell *)[sender superview];
    NSIndexPath *indexPath = [_mainTableView indexPathForCell:cell];
    SHOW_HUD
    [HttpTool postWithAPI:@"biz/waimai/order/order/cancel"
               withParams:@{@"order_id":cell.dataModel.order_id}
                  success:^(id json) {
                      HIDE_HUD
                      if (ERROR_0) {
                          //放弃接单
                          [dataSource removeObjectAtIndex:indexPath.section];
                          [_mainTableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationRight];
                      }else{
                          [JHShowAlert showAlertWithMsg:ERROR_MESSAGE];
                      }
                  }
                  failure:^(NSError *error) {
                      HIDE_HUD
                  }];
    
}
#pragma mark - 点击cell内接单按钮
- (void)clickCellJieBtn:(UIButton *)sender
{
    DeliveryOrderCell *cell = (DeliveryOrderCell *)[sender superview];
    NSIndexPath *indexPath = [_mainTableView indexPathForCell:cell];
    SHOW_HUD
    [HttpTool postWithAPI:@"biz/waimai/order/order/jiedan"
               withParams:@{@"order_id":cell.dataModel.order_id}
                  success:^(id json) {
                      HIDE_HUD
                      NSLog(@"biz/waimai/order/order/jiedan--%@",json);
                      if (ERROR_0) {
                          if ([JHShareModel shareModel].waisong_autoPrint) {
                              [self priterWithIndexPath:indexPath];
                          }
                          //接单
                          [dataSource removeObjectAtIndex:indexPath.section];
                          [_mainTableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationRight];
                          if ([cell.dataModel.pei_type isEqualToString:@"3"]) {
                              [JHShowAlert showAlertWithMsg:NSLocalizedString(@"接单成功,等待自提", nil)];
                          }else if([cell.dataModel.pei_type isEqualToString:@"4"]) {
                              [JHShowAlert showAlertWithMsg:NSLocalizedString(@"接单成功", nil)];
                          }
                          else{
                              [JHShowAlert showAlertWithMsg:NSLocalizedString(@"接单成功,请尽快配送", nil)];
                          }
                          
                          
                      }else{
                          [JHShowAlert showAlertWithMsg:ERROR_MESSAGE];
                      }
                  }
                  failure:^(NSError *error) {
                      HIDE_HUD
                  }];
}
- (void)clickCellDeliveryBtn_pei:(UIButton *)sender
{
    //配送
    DeliveryOrderCell *cell = (DeliveryOrderCell *)[sender superview];
    NSIndexPath *indexPath = [_mainTableView indexPathForCell:cell];
    if (cell.dataModel.pei_type.integerValue == 0) {
        SHOW_HUD
        [HttpTool postWithAPI:@"biz/waimai/order/order/pei"
                   withParams:@{@"order_id":cell.dataModel.order_id}
                      success:^(id json) {
                          HIDE_HUD
                          NSLog(@"biz/waimai/order/order/pei--%@",json);
                          if (ERROR_0) {
                              //配送
                              [JHShowAlert showAlertWithMsg:NSLocalizedString(@"已配送", nil)];
                              [self refreshCellAtIndexPath:indexPath
                                              withOrder_id:cell.dataModel.order_id];
                          }else{
                              [JHShowAlert showAlertWithMsg:ERROR_MESSAGE];
                          }
                      }
                      failure:^(NSError *error) {
                          HIDE_HUD
                      }];
    }else if(cell.dataModel.pei_type.integerValue == 1){
        SHOW_HUD
        [HttpTool postWithAPI:@"biz/waimai/order/order/qiang"
                   withParams:@{@"order_id":cell.dataModel.order_id}
                      success:^(id json) {
                          HIDE_HUD
                          NSLog(@"biz/waimai/order/order/qiang--%@",json);
                          if (ERROR_0) {
                              //配送
                              [JHShowAlert showAlertWithMsg:NSLocalizedString(@"已配送", nil)];
                              [self refreshCellAtIndexPath:indexPath
                                              withOrder_id:cell.dataModel.order_id];
                          }else{
                              [JHShowAlert showAlertWithMsg:ERROR_MESSAGE];
                          }
                      }
                      failure:^(NSError *error) {
                          HIDE_HUD
                      }];
    }
}
- (void)clickCellDeliveryBtn_hexiao:(UIButton *)sender
{
    DeliveryOrderCell *cell = (DeliveryOrderCell *)[sender superview];
    NSIndexPath *indexPath = [_mainTableView indexPathForCell:cell];
    //核销
    [JHGroupScanControl showJHGroupScanControlWithNav:self.superVC.navigationController withBlock:^(NSDictionary *dic) {
        //点击的确定并且在密码正确的情况下才会调用
        JHTakeTheirMsgVC * vc = [[JHTakeTheirMsgVC alloc]init];
        vc.dictionary = dic;
        vc.completionBlock = ^(){
            [dataSource removeObjectAtIndex:indexPath.section];
            //            [_mainTableView deleteRowsAtIndexPaths:@[indexPath]
            //                                  withRowAnimation:UITableViewRowAnimationRight];
            [_mainTableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationRight];
        };
        [self.superVC.navigationController pushViewController:vc animated:YES];
    } withSweepBlock:^(NSDictionary *dic) {
        JHTakeTheirMsgVC * vc = [[JHTakeTheirMsgVC alloc]init];
        vc.hidesBottomBarWhenPushed= YES;
        vc.dictionary = dic;
        vc.completionBlock = ^(){
            [dataSource removeObjectAtIndex:indexPath.section];
            //            [_mainTableView deleteRowsAtIndexPaths:@[indexPath]
            //                                  withRowAnimation:UITableViewRowAnimationRight];
            [_mainTableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationRight];
        };
        [self.superVC.navigationController pushViewController:vc animated:YES];
    }];
}
- (void)clickCellDeliveryBtn_arrive:(UIButton *)sender
{
    NSLog(@"确认送达");
    DeliveryOrderCell *cell = (DeliveryOrderCell *)[sender superview];
    NSIndexPath *indexPath = [_mainTableView indexPathForCell:cell];
    SHOW_HUD
    [HttpTool postWithAPI:@"biz/waimai/order/order/delivered"
               withParams:@{@"order_id":cell.dataModel.order_id}
                  success:^(id json) {
                      HIDE_HUD
                      NSLog(@"biz/waimai/order/order/delivered--%@",json);
                      if (ERROR_0) {
                          if (cell.dataModel.pei_type.integerValue == 4) {
                               [JHShowAlert showAlertWithMsg:NSLocalizedString(@"订单已确认出餐", nil)];
                              [dataSource removeObjectAtIndex:indexPath.section];
                              [_mainTableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationRight];
                          }else{
                               [JHShowAlert showAlertWithMsg:NSLocalizedString(@"订单已确认送达", nil)];
                               [self refreshCellAtIndexPath:indexPath withOrder_id:cell.dataModel.order_id];
                          }
                         
                      }else{
                          [JHShowAlert showAlertWithMsg:ERROR_MESSAGE];
                      }
                  }
                  failure:^(NSError *error) {
                      HIDE_HUD
                  }];
}
//回复评价
- (void)clickCellReplyBtn:(UIButton *)sender
{
    DeliveryOrderCell *cell = (DeliveryOrderCell *)[sender superview];
    DeliveryOrderCellModel * model = cell.dataModel;
    JHReplyVC *vc = [[JHReplyVC alloc] init];
    vc.comment_id = model.comment_info[@"comment_id"];
    [self.superVC.navigationController pushViewController:vc animated:YES];
}

//回复催单
- (void)replyCui:(UIButton *)sender
{
    DeliveryOrderCell *cell = (DeliveryOrderCell *)[sender superview];
    //回复催单
    DeliveryReplyVC *vc = [[DeliveryReplyVC alloc] init];
    vc.order_id = cell.dataModel.order_id;
    [self.superVC.navigationController pushViewController:vc animated:YES];
}

-(void)priterWithIndexPath:(NSIndexPath *)indexPath{
    DeliveryOrderCellModel * model = dataSource[indexPath.section];
    NSString *printType = [JHShareModel shareModel].printType;
    if (!printType || printType.length == 0) {
        [JHShowAlert showAlertWithMsg:NSLocalizedString(@"打印机未连接\n请先进行连接", nil)
                         withBtnTitle:NSLocalizedString(@"知道了", nil)
                         withBtnBlock:^{
                             //获取选择打印机的控制器
                             Class class = NSClassFromString(@"JHChoosePrinterVC");
                             UINavigationController *nav = (UINavigationController *)[UIApplication sharedApplication].delegate.window.rootViewController;
                             [nav pushViewController:[class new] animated:YES];
                         }];
        return;
    }
    //判断打印类型
    if ([[JHShareModel shareModel].printType isEqualToString:@"yunPrint"]) {
        SHOW_HUD
        [HttpTool postWithAPI:@"biz/printer/printorder" withParams:@{@"order_id":model.order_id,
                                                                     @"num":@([[NSUserDefaults standardUserDefaults] integerForKey:@"print_num"]).stringValue} success:^(id json) {
                                                                         NSLog(@"%@",json);
                                                                         
                                                                         if ([json[@"error"] isEqualToString:@"0"]) {
                                                                             
                                                                         }else{
                                                                             [JHShowAlert showAlertWithMsg:json[@"message"]];
                                                                         }
                                                                         HIDE_HUD
                                                                     } failure:^(NSError *error) {
                                                                         [JHShowAlert showAlertWithMsg:NSLocalizedString(@"服务器连接异常", nil)];
                                                                         NSLog(@"error%@",error.localizedDescription);
                                                                     }];
        
    }else{
        [[JHShareModel shareModel].blueTooth printOrder:@{@"shop_title":model.waimai_title,
                                                          @"dateline":model.dateline,
                                                          @"pei_time":model.pei_time_print,
                                                          @"pay_code":model.pay_code,
                                                          @"products":model.products,
                                                          @"first_youhui":model.first_youhui,
                                                          @"hongbao":model.hongbao,
                                                          @"order_youhui":model.order_youhui,
                                                          @"total_price":model.amount,
                                                          @"addr":model.addr,
                                                          @"contact":model.contact,
                                                          @"mobile":model.mobile,
                                                          @"online_pay":model.online_pay,
                                                          @"pei_amount":model.freight,
                                                          @"order_id":model.order_id,
                                                          @"house":model.house,
                                                          @"intro":model.intro
                                                          }];
    }
    
}

#pragma mark - 刷新某行
- (void)refreshCellAtIndexPath:(NSIndexPath *)indexPatch withOrder_id:(NSString *)order_id
{
    [HttpTool postWithAPI:@"biz/waimai/order/order/mdetail"
               withParams:@{@"order_id":order_id}
                  success:^(id json) {
                      if (ERROR_0) {
                          //刷新指定行
                          DeliveryOrderCellModel *cellModel = [DeliveryOrderCellModel yy_modelWithJSON:json[@"data"]];
                          [dataSource replaceObjectAtIndex:indexPatch.section withObject:cellModel];
                          [_mainTableView reloadSections:[NSIndexSet indexSetWithIndex:indexPatch.section] withRowAnimation:UITableViewRowAnimationNone];
                      }
                  }
                  failure:^(NSError *error) {
                  }];
}
@end

