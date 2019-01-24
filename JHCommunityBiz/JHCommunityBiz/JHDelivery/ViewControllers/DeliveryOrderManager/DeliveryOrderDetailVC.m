//
//  DeliveryOrderDetailVC.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/7/8.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "DeliveryOrderDetailVC.h"
#import "DeliveryOrderDetailCellOne.h"//订单号cell
#import "DeliveryOrderDetailCellTwo.h"//下单时间cell
#import "DeliveryOrderDetailCellThree.h"//客户信息cell
#import "DeliveryOrderDetailCellFour.h"//商品信息cell
#import "DeliveryOrderDetailCellFive.h"//合计及结算价cell
#import "DeliveryOrderDetailCellSix.h"//配送员信息cell
#import "JHEvaluteDeliveryCell.h"//评价cell
#import "DeliveryOrderDetailLogsCell.h"//日志cell
#import "DeliveryOrderDetailVM.h"
#import "JHEvaluteModel.h"
#import "JHGroupScanControl.h"
#import "JHTakeTheirMsgVC.h"
#import "DeliveryReplyVC.h"
#import "JHReplyVC.h"
#import "NSDateToString.h"
@interface DeliveryOrderDetailVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *mainTableView;
@end

@implementation DeliveryOrderDetailVC
{
    NSArray *dataSourceProducts;
    NSArray *dataSourceLogs;
    UIButton *rightBtn;//右上角按钮
    NSInteger sectionNum;
    NSInteger logNum;
    UIButton *bottomBtn;
    NSInteger staff_id;
    NSInteger comment_status;
    DeliveryOrderDetailVM *vm;
    JHEvaluteModel *evaluateModel;
    CGFloat packagePrice;
    CGFloat pei_amount;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self.view addSubview:self.mainTableView];
    [self loadData];
}
- (void)initData
{
    self.navigationItem.title = NSLocalizedString(@"订单详情", nil);
    sectionNum = 4;
    logNum = 0;
    dataSourceProducts = @[];
    dataSourceLogs = @[];
    staff_id = 0;
    comment_status = 0;
    packagePrice = 0.0;
    pei_amount = 0.0;
}
- (UITableView *)mainTableView
{
    _mainTableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, WIDTH, HEIGHT - 64 - 55)
                                                              style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
        tableView.separatorColor = LINE_COLOR;
        tableView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:tableView];
        tableView.layoutMargins = UIEdgeInsetsZero;
        tableView.separatorInset = UIEdgeInsetsZero;
        tableView;
    });
    return _mainTableView;
}
#pragma mark - 添加右侧按钮
- (void)addRightBtn
{
    rightBtn = [[UIButton alloc] initWithFrame:FRAME(0, 0, 75, 30)];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [rightBtn setBackgroundColor:THEME_COLOR forState:(UIControlStateNormal)];
    rightBtn.titleLabel.font = FONT(15);
    rightBtn.layer.cornerRadius = 4;
    rightBtn.layer.masksToBounds = YES;
    rightBtn.layer.borderWidth = 0.7;
    rightBtn.layer.borderColor = THEME_COLOR.CGColor;
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}
#pragma mark - 添加底部按钮
- (void)addBottomView
{
    bottomBtn = [UIButton new];
    [bottomBtn setBackgroundColor:HEX(@"faaf19", 1.0) forState:(UIControlStateNormal)];
    [self.view addSubview:bottomBtn];
    [bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    //添加打印按钮
    UIButton *printerBtn = [[UIButton alloc] initWithFrame:FRAME(WIDTH - 60, 0, 60, 50)];
    [printerBtn setImage:IMAGE(@"printer") forState:(UIControlStateNormal)];
    printerBtn.imageEdgeInsets = UIEdgeInsetsMake(14, 19, 14, 19);
    [bottomBtn addSubview:printerBtn];
    
    [printerBtn addTarget:self action:@selector(clickPrinterBtn:) forControlEvents:(UIControlEventTouchUpInside)];
}
#pragma mark - 点击导航栏右侧按钮
- (void)clickRightBtn:(UIButton *)sender
{
    NSLog(@"执行点击右上角按钮的方法");
    
}
#pragma mark - tableView delegate and dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 8;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 1;
            break;
        case 2:
        {
            
        }
            return dataSourceProducts.count;
            break;
        case 3:
            return 2;
            break;
        case 4:
            return 2;
            break;
        case 5:
            return staff_id>0?1:0;
            break;
        case 6:
            return comment_status>0?1:0;
            break;
        default:
            return 1;
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 5) return staff_id>0?10:CGFLOAT_MIN;
    if (section == 6) return comment_status>0?10:CGFLOAT_MIN;
    if (section > 0 && section != 3 && section != 7) return 10;
    else if (vm && vm.pei_type.integerValue == 3 && section == 7 && vm.spend_status.integerValue == 1) return 90;
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (vm && vm.pei_type.integerValue == 3 && section == 7 && vm.spend_status.integerValue == 1) {
        UIView * view = [UIView new];
        view.frame = FRAME(0, 0, WIDTH, 90);
        view.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
        UIView * centerView = [UIView new];
        centerView.frame = FRAME(10, 10, WIDTH - 20, 70);
        centerView.backgroundColor = [UIColor whiteColor];
        centerView.layer.cornerRadius = 3;
        centerView.layer.masksToBounds = YES;
        centerView.layer.borderColor = LINE_COLOR.CGColor;
        centerView.layer.borderWidth = 1;
        [view addSubview:centerView];
        //创建显示验证密码的label
        UILabel * label_security = [[UILabel alloc]init];
        label_security.frame = FRAME(10, 15, 150, 20);
        label_security.text = NSLocalizedString(@"验证密码", nil);
        label_security.font = [UIFont systemFontOfSize:15];
        [centerView addSubview:label_security];
        //创建显示验证密码的label
        UILabel * label_code = [[UILabel alloc]init];
        label_code.frame = FRAME(10, 45, 150, 20);
        label_code.text = vm.spend_number;
        label_code.textColor = [UIColor colorWithWhite:0.6 alpha:1];
        label_code.font = FONT(15);
        [centerView addSubview:label_code];
        //显示已经验证的label
        UILabel * label = [[UILabel alloc]init];
        label.frame = FRAME(WIDTH - 90, 45, 60, 20);
        label.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1];
        label.layer.cornerRadius = 3;
        label.layer.masksToBounds = YES;
        label.text = NSLocalizedString(@"已验证", nil);
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        [centerView addSubview:label];
        return view;
    }else{
        return nil;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                return 44;
            }else{
                return 70;
            }
        }
            break;
        case 1:
            if (vm)
            
                return [DeliveryOrderDetailCellThree getHeight:@{@"contact":vm.contact,
                                                             @"mobile":vm.mobile,
                                                             @"addr":vm.addr,
                                                             @"note":vm.intro}];
            else
                return 125;
            break;
            
        case 2:
            return 44;
            break;
        case 3:
        {
            if (indexPath.row ==0) {
                if (packagePrice>0) return 44;
            }else{
                if (pei_amount>0) return 44;
            }
            return 0.0;
        }
            break;
        case 4:
            return 44;
            break;
        case 5:
            return 88;
            break;
        case 6:
            return [JHEvaluteDeliveryCell getHeightWithModel:evaluateModel];
            break;
        default:
            return dataSourceLogs.count *44;
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    switch (section) {
        case 0:
        {
            if (row == 0) {
                DeliveryOrderDetailCellOne *cell = [_mainTableView dequeueReusableCellWithIdentifier:@"DeliveryOrderDetailCellOneID"];
                if (!cell) {
                    cell = [[DeliveryOrderDetailCellOne alloc] initWithStyle:(UITableViewCellStyleDefault)
                                                             reuseIdentifier:@"DeliveryOrderDetailCellOneID"];
                }
                if (vm) cell.dataDic = @{@"order_id":vm.order_id,
                                           @"order_status_label":vm.order_status_label};
                    else cell.dataDic = @{};
                
                return cell;
            }else{
                
                DeliveryOrderDetailCellTwo *cell = [_mainTableView dequeueReusableCellWithIdentifier:@"DeliveryOrderDetailCellTwoID"];
                if (!cell) {
                    cell = [[DeliveryOrderDetailCellTwo alloc] initWithStyle:(UITableViewCellStyleDefault)
                                                             reuseIdentifier:@"DeliveryOrderDetailCellTwoID"];
                }
                if (vm) cell.dataDic = @{@"dateline":vm.dateline,
                                         @"pei_time":vm.pei_time.integerValue == 0 ? NSLocalizedString(@"尽快送达", nil) :
                                             [NSDateToString stringFromUnixTime:vm.pei_time]};
                    else cell.dataDic = @{};
                return cell;
            }
        }
            break;
        case 1:
        {
            DeliveryOrderDetailCellThree *cell = [_mainTableView dequeueReusableCellWithIdentifier:@"DeliveryOrderDetailCellThreeID"];
            if (!cell) {
                cell = [[DeliveryOrderDetailCellThree alloc] initWithStyle:(UITableViewCellStyleDefault)
                                                         reuseIdentifier:@"DeliveryOrderDetailCellThreeID"];
            }
            if (vm) {
                cell.dataDic = @{@"contact":vm.contact,
                                 @"mobile":vm.mobile,
                                 @"addr":vm.pei_type.integerValue == 3 ? NSLocalizedString(@"自提", nil):vm.addr,
                                 @"note":vm.intro,
                                 @"lat":vm.lat,
                                 @"lng":vm.lng,
                                 @"house":vm.house};
                cell.navVC = self.navigationController;
            }
            return cell;
        }
            break;
        case 2:
        {
            DeliveryOrderDetailCellFour *cell = [_mainTableView dequeueReusableCellWithIdentifier:@"DeliveryOrderDetailCellFourID"];
            if (!cell) {
                cell = [[DeliveryOrderDetailCellFour alloc] initWithStyle:(UITableViewCellStyleDefault)
                                                           reuseIdentifier:@"DeliveryOrderDetailCellFourID"];
            }
            NSInteger index = MIN(indexPath.row, dataSourceProducts.count - 1);
            cell.dataDic = dataSourceProducts[index];
            return cell;
        }
            break;
        case 3:
        {
            DeliveryOrderDetailCellFour *cell = [_mainTableView dequeueReusableCellWithIdentifier:@"DeliveryOrderDetailCellFourID"];
            if (!cell) {
                cell = [[DeliveryOrderDetailCellFour alloc] initWithStyle:(UITableViewCellStyleDefault)
                                                          reuseIdentifier:@"DeliveryOrderDetailCellFourID"];
            }
            if (row ==0) {
                cell.productL.text = NSLocalizedString(@"打包费", nil);
                cell.priceL.text = [MS stringByAppendingString:vm.pei_type.integerValue == 4 ?@(0).stringValue:@(packagePrice).description];
            }else{
                cell.productL.text = NSLocalizedString(@"配送费", nil);
                cell.priceL.text = [MS stringByAppendingString:@(pei_amount).description];
            }
            cell.layer.masksToBounds = YES;
            return cell;
        }
            break;
        case 4:
        {
            //创建数组字典
            NSArray *dataArr = @[@{},@{}];
            if (vm) {
               dataArr = @[@{@"title":NSLocalizedString(@"合计", nil),
                             @"price":@(vm.amount.floatValue+
                                 vm.first_youhui.floatValue+
                                 vm.hongbao.floatValue+
                                 vm.order_youhui.floatValue).stringValue},
                           @{@"title":NSLocalizedString(@"结算价", nil),
                             @"first_youhui":vm.first_youhui,
                             @"hongbao_amount":vm.hongbao,
                             @"manjian":vm.order_youhui,
                             @"price":vm.amount}];
            }
            DeliveryOrderDetailCellFive *cell = [_mainTableView dequeueReusableCellWithIdentifier:@"DeliveryOrderDetailCellFiveID"];
            if (!cell) {
                cell = [[DeliveryOrderDetailCellFive alloc] initWithStyle:(UITableViewCellStyleDefault)
                                                          reuseIdentifier:@"DeliveryOrderDetailCellFiveID"];
            }
            if (vm)  cell.dataDic = dataArr[indexPath.row];
            return cell;
        }
            break;
        case 5:
        {
            DeliveryOrderDetailCellSix *cell = [_mainTableView dequeueReusableCellWithIdentifier:@"DeliveryOrderDetailCellSixID"];
            if (!cell) {
                cell = [[DeliveryOrderDetailCellSix alloc] initWithStyle:(UITableViewCellStyleDefault)
                
                                                         reuseIdentifier:@"DeliveryOrderDetailCellSixID"];
                
            }
            if (vm)  cell.dataDic = vm.staff;
            cell.navVC = self.navigationController;
            return cell;
        }
            break;
        case 6:
        {
            JHEvaluteDeliveryCell *cell = [_mainTableView dequeueReusableCellWithIdentifier:@"JHEvaluteDeliveryCellID"];
            if (!cell) {
                cell = [[JHEvaluteDeliveryCell alloc] initWithStyle:(UITableViewCellStyleDefault)
                                                         reuseIdentifier:@"JHEvaluteDeliveryCellID"];
            }
            cell.model = evaluateModel;
            return cell;
        }
            break;
            
        default:
        {
            DeliveryOrderDetailLogsCell *cell = [_mainTableView dequeueReusableCellWithIdentifier:@"DeliveryOrderDetailLogsCell"];
            if (!cell) {
                cell = [[DeliveryOrderDetailLogsCell alloc] initWithStyle:(UITableViewCellStyleDefault)
                                                          reuseIdentifier:@"DeliveryOrderDetailLogsCell"];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.dataArr = dataSourceLogs;
            return cell;
        }
            break;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
#pragma mark - 请求数据
- (void)loadData
{
    SHOW_HUD
    [HttpTool postWithAPI:@"biz/waimai/order/order/detail"
               withParams:@{@"order_id":_order_id}
                  success:^(id json) {
                      HIDE_HUD
                      NSLog(@"biz/waimai/order/order/detail--%@",json);
                      if ([json[@"error"] isEqualToString:@"0"]) {
                          vm = [DeliveryOrderDetailVM yy_modelWithJSON:json[@"data"]];
                          dataSourceProducts = vm.products;
                          dataSourceLogs = vm.logs;
                          pei_amount = [vm.freight floatValue];
                          comment_status = vm.comment_status.integerValue;
                          staff_id = vm.staff_id.integerValue;
                          evaluateModel = [JHEvaluteModel creatJHEvaluteModelWithDictionary:vm.comment_info];
                          [self getPackage];
                          [_mainTableView reloadData];
                          [self handleBtnStatus:vm];
                      }else{
                          [JHShowAlert showAlertWithMsg:json[@"message"]];
                      }
                  } failure:^(NSError *error) {
                      HIDE_HUD
                      [JHShowAlert showAlertWithMsg:NSLocalizedString(@"服务器连接异常", nil)];
                  }];
}
#pragma mark - 获取打包费
- (void)getPackage
{
    for (NSDictionary *dic in vm.products) {
        packagePrice+=([dic[@"package_price"] floatValue]*[dic[@"product_number"] integerValue]);
    }
}
#pragma mark - 点击打印按钮
- (void)clickPrinterBtn:(UIButton *)sender
{
    NSString *printType = [JHShareModel shareModel].printType;
    if (!printType || printType.length == 0) {
        [JHShowAlert showAlertWithMsg:NSLocalizedString(@"打印机未连接\n请先进行连接", nil)
                         withBtnTitle:NSLocalizedString(@"知道了", nil)
                         withBtnBlock:^{
                             //获取选择打印机的控制器
                             Class class = NSClassFromString(@"JHChoosePrinterVC");
                             [self.navigationController pushViewController:[class new] animated:YES];
                         }];
        return;
    }
    //判断打印类型
    if ([[JHShareModel shareModel].printType isEqualToString:@"yunPrint"]) {
        SHOW_HUD
        [HttpTool postWithAPI:@"biz/printer/printorder" withParams:@{@"order_id":vm.order_id,
                                                                     @"num":@([[NSUserDefaults standardUserDefaults] integerForKey:@"print_num"]).stringValue} success:^(id json) {
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
        [[JHShareModel shareModel].blueTooth printOrder:@{@"shop_title":vm.waimai_title,
                                                          @"dateline":vm.dateline,
                                                          @"pei_time":vm.pei_time_print,
                                                          @"pay_code":vm.pay_code,
                                                          @"products":vm.products,
                                                          @"first_youhui":vm.first_youhui,
                                                          @"hongbao":vm.hongbao,
                                                          @"order_youhui":vm.order_youhui,
                                                          @"total_price":vm.amount,
                                                          @"addr":vm.addr,
                                                          @"contact":vm.contact,
                                                          @"mobile":vm.mobile,
                                                          @"online_pay":vm.online_pay,
                                                          @"pei_amount":vm.freight,
                                                          @"order_id":vm.order_id,
                                                          @"house":vm.house,
                                                          @"intro":vm.intro
                                                          }];
    }
}

- (void)handleBtnStatus:(DeliveryOrderDetailVM *)dataVM
{
    if (self.myBlock) {
        self.myBlock();
    }
    [bottomBtn removeFromSuperview];
    bottomBtn = nil;
    [rightBtn removeFromSuperview];
    rightBtn = nil;
    [self addRightBtn];
    [self addBottomView];
    NSString *order_status = dataVM.order_status;
    if ([dataVM.pei_type isEqualToString:@"3"] && order_status.integerValue < 8 &&
        order_status.integerValue != -1 && order_status.integerValue != 0) { //自提单
        [bottomBtn setTitle:NSLocalizedString(@"验证核销", nil) forState:(UIControlStateNormal)];
        [bottomBtn addTarget:self action:@selector(hexiao) forControlEvents:(UIControlEventTouchUpInside)];
        return;
    }
    if ([dataVM.pei_type isEqualToString:@"4"] && order_status.integerValue < 8 &&
        order_status.integerValue != -1 && order_status.integerValue != 0) { //自提单
        [bottomBtn setTitle:NSLocalizedString(@"已出餐", nil) forState:(UIControlStateNormal)];
        [bottomBtn addTarget:self action:@selector(deliver) forControlEvents:(UIControlEventTouchUpInside)];
        return;
    }
    if (order_status.integerValue == 0) { // 下一步:接单
        [bottomBtn setTitle:NSLocalizedString(@"接单", nil) forState:(UIControlStateNormal)];
        [bottomBtn addTarget:self action:@selector(takeOrder) forControlEvents:(UIControlEventTouchUpInside)];
        [rightBtn setTitle:NSLocalizedString(@"放弃接单", nil) forState:(UIControlStateNormal)];
        [rightBtn addTarget:self action:@selector(giveUp) forControlEvents:(UIControlEventTouchUpInside)];
        rightBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        
    }else if (order_status.integerValue == 1 || order_status.integerValue ==  2) { //下一步:配送
        [bottomBtn setTitle:NSLocalizedString(@"配送", nil) forState:(UIControlStateNormal)];
        [bottomBtn addTarget:self action:@selector(pei) forControlEvents:(UIControlEventTouchUpInside)];
        if (dataVM.cui_time.length > 1) {
            [rightBtn setTitle:NSLocalizedString(@"回复催单", nil) forState:(UIControlStateNormal)];
            rightBtn.layer.borderColor = [UIColor whiteColor].CGColor;
            [rightBtn addTarget:self action:@selector(replyCui) forControlEvents:(UIControlEventTouchUpInside)];
        }
    }else if (order_status.integerValue == 3){ //下一步:配送完成
        [bottomBtn setTitle:NSLocalizedString(@"确认送达", nil) forState:(UIControlStateNormal)];
        [bottomBtn addTarget:self action:@selector(deliver) forControlEvents:(UIControlEventTouchUpInside)];
        if (dataVM.cui_time.integerValue> 0) {
            [rightBtn setTitle:NSLocalizedString(@"回复催单", nil) forState:(UIControlStateNormal)];
            rightBtn.layer.borderColor = [UIColor whiteColor].CGColor;
            [rightBtn addTarget:self action:@selector(replyCui) forControlEvents:(UIControlEventTouchUpInside)];
        }
    }else if (order_status.integerValue == 4){ //下一步:等待确认完成或超时自动完成(底部按钮展示灰色)
        [bottomBtn setTitle:NSLocalizedString(@"已配送", nil) forState:(UIControlStateNormal)];
        [bottomBtn setBackgroundColor:HEX(@"d2d2d2", 1.0) forState:(UIControlStateNormal)];
        //bottomBtn.userInteractionEnabled = NO;
    }else if (order_status.integerValue == 8){ //订单已经完成:判断是否回复并展示
        if ([dataVM.comment_info[@"reply_time"] integerValue] > 0 ) {
            [bottomBtn setTitle:NSLocalizedString(@"已回复", nil) forState:(UIControlStateNormal)];
            [bottomBtn setBackgroundColor:HEX(@"d2d2d2", 1.0) forState:(UIControlStateNormal)];
            //bottomBtn.userInteractionEnabled = NO;
        }else if ([dataVM.comment_info[@"comment_id"] integerValue] > 0 ) {
            [bottomBtn setTitle:NSLocalizedString(@"回复评价", nil) forState:(UIControlStateNormal)];
            [bottomBtn addTarget:self action:@selector(replyComment) forControlEvents:(UIControlEventTouchUpInside)];
        }else{
            [bottomBtn setTitle:NSLocalizedString(@"已完成", nil) forState:(UIControlStateNormal)];
            [bottomBtn setBackgroundColor:HEX(@"d2d2d2", 1.0) forState:(UIControlStateNormal)];
            //bottomBtn.userInteractionEnabled = NO;
        }
    }else if (order_status.integerValue == -1){ //订单已经取消
        [bottomBtn setTitle:NSLocalizedString(@"已取消", nil) forState:(UIControlStateNormal)];
        [bottomBtn setBackgroundColor:HEX(@"d2d2d2", 1.0) forState:(UIControlStateNormal)];
         bottomBtn.userInteractionEnabled = NO;
    }
    bottomBtn.titleLabel.font = FONT(20);
}
#pragma mark - 核销
- (void)hexiao
{
    //核销
    [JHGroupScanControl showJHGroupScanControlWithNav:self.navigationController withBlock:^(NSDictionary *dic) {
        //点击的确定并且在密码正确的情况下才会调用
        JHTakeTheirMsgVC * vc = [[JHTakeTheirMsgVC alloc]init];
        vc.dictionary = dic;
        vc.completionBlock = ^(){
            [self loadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    } withSweepBlock:^(NSDictionary *dic) {
        JHTakeTheirMsgVC * vc = [[JHTakeTheirMsgVC alloc]init];
        vc.hidesBottomBarWhenPushed =YES;
        vc.dictionary = dic;
        vc.completionBlock = ^(){
            [self loadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }];
}
#pragma mark - 接单
- (void)takeOrder
{
    SHOW_HUD
    [HttpTool postWithAPI:@"biz/waimai/order/order/jiedan"
               withParams:@{@"order_id":vm.order_id}
                  success:^(id json) {
                      HIDE_HUD
                      NSLog(@"biz/waimai/order/order/jiedan--%@",json);
                      if (ERROR_0) {
                          [self loadData];
                          [JHShowAlert showAlertWithMsg: vm.pei_type.integerValue == 3 ?  NSLocalizedString(@"接单成功,等待自提", nil) :(vm.pei_type.integerValue == 4?  NSLocalizedString(@"接单成功", nil):NSLocalizedString(@"接单成功,请尽快配送", nil))];
                      }else{
                          [JHShowAlert showAlertWithMsg:ERROR_MESSAGE];
                      }
                  }
                  failure:^(NSError *error) {
                      HIDE_HUD
                      [JHShowAlert showAlertWithMsg:NSLocalizedString(@"服务器连接异常", nil)];
                  }];
}
#pragma mark - 放弃接单
- (void)giveUp
{
    SHOW_HUD
    [HttpTool postWithAPI:@"biz/waimai/order/order/cancel"
               withParams:@{@"order_id":vm.order_id}
                  success:^(id json) {
                      HIDE_HUD
                      if (ERROR_0) {
                          [self loadData];
                      }
                  }
                  failure:^(NSError *error) {
                      HIDE_HUD
                  }];
}
#pragma mark - 配送
- (void)pei
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"温馨提示",nil) message:NSLocalizedString(@"是否自己配送",nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *canaelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
    [controller addAction:canaelAction];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确认", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (vm.pei_type.integerValue == 0) {
            SHOW_HUD
            [HttpTool postWithAPI:@"biz/waimai/order/order/pei"
                       withParams:@{@"order_id":vm.order_id}
                          success:^(id json) {
                              HIDE_HUD
                              NSLog(@"biz/waimai/order/order/pei--%@",json);
                              if (ERROR_0) {
                                  //配送
                                  [JHShowAlert showAlertWithMsg:NSLocalizedString(@"已配送", nil)];
                                  [self loadData];
                              }else{
                                  [JHShowAlert showAlertWithMsg:ERROR_MESSAGE];
                              }
                          }
                          failure:^(NSError *error) {
                              HIDE_HUD
                          }];
        }else if(vm.pei_type.integerValue == 1){
            SHOW_HUD
            [HttpTool postWithAPI:@"biz/waimai/order/order/qiang"
                       withParams:@{@"order_id":vm.order_id}
                          success:^(id json) {
                              HIDE_HUD
                              NSLog(@"biz/waimai/order/order/qiang--%@",json);
                              if (ERROR_0) {
                                  //配送
                                  [JHShowAlert showAlertWithMsg:NSLocalizedString(@"已配送", nil)];
                                  [self loadData];
                              }else{
                                  [JHShowAlert showAlertWithMsg:ERROR_MESSAGE];
                              }
                          }
                          failure:^(NSError *error) {
                              HIDE_HUD
                          }];
        }
    }];
    [controller addAction:sureAction];
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:controller animated:YES completion:nil];
//    
//    
//    if (vm.pei_type.integerValue == 0) {
//        SHOW_HUD
//        [HttpTool postWithAPI:@"biz/waimai/order/order/pei"
//                   withParams:@{@"order_id":vm.order_id}
//                      success:^(id json) {
//                          HIDE_HUD
//                          NSLog(@"biz/waimai/order/order/pei--%@",json);
//                          if (ERROR_0) {
//                              //配送
//                              [JHShowAlert showAlertWithMsg:NSLocalizedString(@"已配送", nil)];
//                              [self loadData];
//                          }else{
//                              [JHShowAlert showAlertWithMsg:ERROR_MESSAGE];
//                          }
//                      }
//                      failure:^(NSError *error) {
//                          HIDE_HUD
//                      }];
//    }else if(vm.pei_type.integerValue == 1){
//        SHOW_HUD
//        [HttpTool postWithAPI:@"biz/waimai/order/order/qiang"
//                   withParams:@{@"order_id":vm.order_id}
//                      success:^(id json) {
//                          HIDE_HUD
//                          NSLog(@"biz/waimai/order/order/qiang--%@",json);
//                          if (ERROR_0) {
//                              //配送
//                              [JHShowAlert showAlertWithMsg:NSLocalizedString(@"已配送", nil)];
//                              [self loadData];
//                          }else{
//                              [JHShowAlert showAlertWithMsg:ERROR_MESSAGE];
//                          }
//                      }
//                      failure:^(NSError *error) {
//                          HIDE_HUD
//                      }];
//    }

}
- (void)deliver
{
    SHOW_HUD
    [HttpTool postWithAPI:@"biz/waimai/order/order/delivered"
               withParams:@{@"order_id":vm.order_id}
                  success:^(id json) {
                      HIDE_HUD
                      NSLog(@"biz/waimai/order/order/delivered--%@",json);
                      if (ERROR_0) {
                          [JHShowAlert showAlertWithMsg:NSLocalizedString(@"订单已确认送达", nil)];
                          [self loadData];
                      }else{
                          __weak typeof(self)weakSelf = self;
                          [JHShowAlert showAlertWithMsg:ERROR_MESSAGE withBtnTitle:NSLocalizedString(@"确定", nil) withBtnBlock:^{
                              [weakSelf loadData];
                          }];
                      }
                  }
                  failure:^(NSError *error) {
                      HIDE_HUD
                  }];
}
#pragma mark - 回复催单
- (void)replyCui
{
    DeliveryReplyVC *vc = [[DeliveryReplyVC alloc] init];
    vc.order_id = vm.order_id;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 回复评价
- (void)replyComment
{
    __weak typeof(self)weakSelf = self;
    JHReplyVC *vc = [[JHReplyVC alloc] init];
    vc.comment_id = vm.comment_info[@"comment_id"];
    vc.myBlock = ^(){
        [weakSelf loadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
