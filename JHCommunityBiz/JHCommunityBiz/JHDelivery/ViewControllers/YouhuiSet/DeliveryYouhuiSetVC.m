//
//  DeliveryYouhuiSetVC.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/19.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "DeliveryYouhuiSetVC.h"
#import "ZJSwitch.h"
#import "QiPeiFooterView.h"
#import "DeliveryYouhuiCell.h"
#import <IQKeyboardManager.h>
#import "DeliveryYouhuiVM.h"
#import "DeliveryYouhuiDetailModel.h"
@interface DeliveryYouhuiSetVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *mainTableView;
@end

@implementation DeliveryYouhuiSetVC
{
    ZJSwitch *onlinePaySwitch;
    ZJSwitch *arrivePaySwitch;
    ZJSwitch *selfPickSwitch;
    ZJSwitch *youhuiSwitch;
    UITextField *firstField;
    NSMutableArray<DeliveryYouhuiDetailModel *> *dataSource;
    DeliveryYouhuiVM *vm;
    //记录是否存在减免
    BOOL haveJianMian;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    //创建表视图
    [self createTableView];
    //添加底部按钮
    [self addBottomBtn];
    //获取信息
    [self loadData];
}
- (void)initData
{
    self.navigationItem.title = NSLocalizedString(@"外送优惠设置", nil);
    self.view.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
    dataSource = @[].mutableCopy;
}
#pragma mark - 创建表视图
- (void)createTableView
{
    _mainTableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, WIDTH, HEIGHT - 64 - 50)
                                                              style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
        tableView.separatorColor = DEFAULT_BACKGROUNDCOLOR;
        tableView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:tableView];
        tableView.layoutMargins = UIEdgeInsetsZero;
        tableView.separatorInset = UIEdgeInsetsZero;
        tableView;
    });
}
#pragma mark - 添加底部按钮
- (void)addBottomBtn
{
    UIButton *sureBtn =  [UIButton new];
    [self.view addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_bottom).with.offset(-50);
        make.left.equalTo(self.view).with.offset(10);
        make.right.equalTo(self.view).with.offset(-10);
        make.bottom.equalTo(self.view).with.offset(-10);
    }];
    sureBtn.layer.cornerRadius = 3;
    sureBtn.layer.masksToBounds = YES;
    [sureBtn setBackgroundColor:HEX(@"faaf19", 1.0) forState:(UIControlStateNormal)];
    [sureBtn setTitle:NSLocalizedString(@"保存", nil) forState:(UIControlStateNormal)];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [sureBtn addTarget:self action:@selector(clickSureBtn:) forControlEvents:(UIControlEventTouchUpInside)];
}
#pragma mark - 获取优惠信息
- (void)loadData
{
    SHOW_HUD
    [HttpTool postWithAPI:@"biz/waimai/youhui/youhui/get"
               withParams:@{}
                  success:^(id json) {
                      HIDE_HUD
                      NSLog(@"biz/waimai/youhui/youhui/get---%@",json);
                      if ([json[@"error"] isEqualToString:@"0"]) {
                          vm = [DeliveryYouhuiVM yy_modelWithJSON:json[@"data"]];
                          //处理数据
                          onlinePaySwitch.on = [vm.online_pay integerValue];
                          arrivePaySwitch.on = [vm.is_daofu integerValue];
                          selfPickSwitch.on = [vm.is_ziti integerValue];
                          firstField.text = [NSString stringWithFormat:@"%g",[vm.first_amount floatValue]];
                          BOOL on_off = vm.youhui.count > 0 ? YES : NO;
                          [youhuiSwitch setOn:on_off animated:YES];
                          haveJianMian = youhuiSwitch.on;
                          [dataSource addObjectsFromArray:vm.youhui];
                          [_mainTableView reloadData];
                          
                      }else{
                              
                          [JHShowAlert showAlertWithMsg:json[@"message"]];
                      }
                      
                  } failure:^(NSError *error) {
                      
                      HIDE_HUD
                      [JHShowAlert showAlertWithMsg:NSLocalizedString(@"服务器连接异常", nil)];
                    
                  }];

}
#pragma mark - tableView delegate and dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 3;
            break;
        case 1:
            return 1;
        case 2:
            if (haveJianMian) {
                return dataSource.count;
            }
            return 0;
        default:
            return 1;
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 0.01;
            break;
        case 1:
            return 10;
        case 2:
            return 54;
        default:
            return 0.01;
            break;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        
        UIView *headerView = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 54)];
        UIView *cellView = [[UIView alloc] initWithFrame:FRAME(0, 10, WIDTH, 44)];
        cellView.backgroundColor = [UIColor whiteColor];
        UIImageView *leftIV = [[UIImageView alloc] initWithFrame:FRAME(10, 14.5, 15, 15)];
        leftIV.image = IMAGE(@"Delivery_reduce");
        //添加label 和 switch 开关
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, WIDTH - 90, 44)];
        titleLabel.font = FONT(14);
        titleLabel.textColor = [UIColor colorWithHex:@"333333" alpha:1.0];
        titleLabel.text = NSLocalizedString(@"在线支付减免设置", nil);
        if (!youhuiSwitch) {
            youhuiSwitch = [[ZJSwitch alloc] initWithFrame:switch_rect];
            youhuiSwitch.transform = CGAffineTransformMakeScale(0.8, 0.8);
            youhuiSwitch.backgroundColor = [UIColor clearColor];
            youhuiSwitch.tintColor = DEFAULT_BACKGROUNDCOLOR;
            youhuiSwitch.onTintColor = THEME_COLOR;
            [youhuiSwitch addTarget:self
                             action:@selector(youhuiS_valueChange)
                   forControlEvents:(UIControlEventValueChanged)];
        }
        [cellView addSubview:leftIV];
        [cellView addSubview:titleLabel];
        [cellView addSubview:youhuiSwitch];
        [headerView addSubview:cellView];
        return headerView;
    }else{
    
        return NULL;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3) {
        return 70;
    }else if(indexPath.section == 0 && indexPath.row == 1 && vm.pei_type.integerValue == 1){
        return 0;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return section == 2 ? (youhuiSwitch.on? 50.0 : 0.01): 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 2 && haveJianMian) {
     
        QiPeiFooterView *footer = [[QiPeiFooterView alloc] initWithFrame:FRAME(0, 0, WIDTH, 50)];
        [footer.addBtn addTarget:self
                          action:@selector(clickAddBtn:)
                forControlEvents:(UIControlEventTouchUpInside)];
        return  footer;
    }
    return [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 0.01)];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    switch (section) {
        case 0:
        {
            if (row == 0) {
                UITableViewCell *cell = [[UITableViewCell alloc] init];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UIImageView *leftIV = [[UIImageView alloc] initWithFrame:FRAME(10, 14.5, 15, 15)];
                leftIV.image = IMAGE(@"Delivery_pdy");
                //添加label 和 switch 开关
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, WIDTH - 90, 44)];
                titleLabel.font = FONT(14);
                titleLabel.textColor = [UIColor colorWithHex:@"333333" alpha:1.0];
                titleLabel.text = NSLocalizedString(@"是否支持在线支付", nil);
                if (!onlinePaySwitch) {
                    onlinePaySwitch = [[ZJSwitch alloc] initWithFrame:switch_rect];
                    onlinePaySwitch.transform = CGAffineTransformMakeScale(0.8, 0.8);
                    onlinePaySwitch.backgroundColor = [UIColor clearColor];
                    onlinePaySwitch.tintColor = DEFAULT_BACKGROUNDCOLOR;
                    onlinePaySwitch.onTintColor = THEME_COLOR;
                }
                [cell addSubview:leftIV];
                [cell addSubview:titleLabel];
                [cell addSubview:onlinePaySwitch];
                return cell;
                
            }else if (row == 1) {
                
                UITableViewCell *cell = [[UITableViewCell alloc] init];
                if(vm.pei_type.integerValue == 1){
                    return cell;
                }else{
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    UIImageView *leftIV = [[UIImageView alloc] initWithFrame:FRAME(10, 14.5, 15, 15)];
                    leftIV.image = IMAGE(@"Delivery_pdy");
                    //添加label 和 switch 开关
                    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, WIDTH - 90, 44)];
                    titleLabel.font = FONT(14);
                    titleLabel.textColor = [UIColor colorWithHex:@"333333" alpha:1.0];
                    titleLabel.text = NSLocalizedString(@"是否支持餐到付款", nil);
                    if (!arrivePaySwitch) {
                        arrivePaySwitch = [[ZJSwitch alloc] initWithFrame:switch_rect];
                        arrivePaySwitch.transform = CGAffineTransformMakeScale(0.8, 0.8);
                        arrivePaySwitch.backgroundColor = [UIColor clearColor];
                        arrivePaySwitch.tintColor = DEFAULT_BACKGROUNDCOLOR;
                        arrivePaySwitch.onTintColor = THEME_COLOR;
                    }
                    [cell addSubview:leftIV];
                    [cell addSubview:titleLabel];
                    [cell addSubview:arrivePaySwitch];
                    return cell;
                }
               
            }else{
                UITableViewCell *cell = [[UITableViewCell alloc] init];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UIImageView *leftIV = [[UIImageView alloc] initWithFrame:FRAME(10, 14.5, 15, 15)];
                leftIV.image = IMAGE(@"Delivery_Distribution");
                //添加label 和 switch 开关
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, WIDTH - 90, 44)];
                titleLabel.font = FONT(14);
                titleLabel.textColor = [UIColor colorWithHex:@"333333" alpha:1.0];
                titleLabel.text = NSLocalizedString(@"是否支持到店自提", nil);
                if (!selfPickSwitch) {
                    selfPickSwitch = [[ZJSwitch alloc] initWithFrame:switch_rect];
                    selfPickSwitch.transform = CGAffineTransformMakeScale(0.8, 0.8);
                    selfPickSwitch.backgroundColor = [UIColor clearColor];
                    selfPickSwitch.tintColor = DEFAULT_BACKGROUNDCOLOR;
                    selfPickSwitch.onTintColor = THEME_COLOR;
                }
                [cell addSubview:leftIV];
                [cell addSubview:titleLabel];
                [cell addSubview:selfPickSwitch];
                return cell;
            }
        }
            break;
         
        case 1:
        {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIImageView *leftIV = [[UIImageView alloc] initWithFrame:FRAME(10, 14.5, 15, 15)];
            leftIV.image = IMAGE(@"Delivery_first");
            //添加label 和 switch 开关
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, WIDTH - 90, 44)];
            titleLabel.font = FONT(14);
            titleLabel.textColor = [UIColor colorWithHex:@"333333" alpha:1.0];
            titleLabel.text = NSLocalizedString(@"新用户首次下单立减:", nil);
            if (!firstField) {
                firstField = [[UITextField alloc] initWithFrame:FRAME(WIDTH - 110, 4, 100, 36)];
                firstField.font = FONT(14);
                firstField.textColor = THEME_COLOR;
                UILabel *unitLabel = [[UILabel alloc] initWithFrame:FRAME(0, 0, 35, 34)];
                unitLabel.text = MT;
                unitLabel.textColor = HEX(@"333333", 1.0f);
                unitLabel.font = FONT(15);
                unitLabel.textAlignment = NSTextAlignmentCenter;
                unitLabel.backgroundColor = [UIColor whiteColor];
                firstField.rightViewMode = UITextFieldViewModeAlways;
                firstField.rightView = unitLabel;
                firstField.textAlignment = NSTextAlignmentCenter;
                firstField.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
            }
            [cell addSubview:leftIV];
            [cell addSubview:titleLabel];
            [cell addSubview:firstField];
            return cell;
        }
            break;
        case 2:
        {
            DeliveryYouhuiCell *cell = [[DeliveryYouhuiCell alloc] init];
            cell.row = indexPath.row;
            cell.dataSource = dataSource;
            cell.dataModel = dataSource[indexPath.row];
            [cell.deleteBtn addTarget:self
                                action:@selector(clickDeleteBtn:)
                     forControlEvents:(UIControlEventTouchUpInside)];
            return cell;
        }
            break;
            
        default:
        {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:FRAME(0, 0, WIDTH, 70)];
            cell.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
            UILabel *label = [[UILabel alloc] initWithFrame:FRAME(10, 0, WIDTH - 20, 70)];
            label.font = FONT(14);
            label.numberOfLines = 3;
            label.textColor = HEX(@"666666", 1.0);
            NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:
                                          [NSString stringWithFormat:@"%@\n%@\n%@",NSLocalizedString(@"温馨提示:", nil),NSLocalizedString(@"1.商家设置的优惠活动,优惠金额由商家自行承担;", nil),NSLocalizedString(@"2.酒水不打折;", nil)]];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.lineSpacing = 4;
            [attString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attString.length)];
            label.attributedText = attString;
            [cell addSubview:label];
            return cell;
            
        }
            break;
    }
}
#pragma mark - 减免开关值改变
- (void)youhuiS_valueChange
{
    haveJianMian = youhuiSwitch.on;
    [_mainTableView reloadSections:[NSIndexSet indexSetWithIndex:2]
                  withRowAnimation:UITableViewRowAnimationNone];

}
#pragma mark - 点击了加号按钮
- (void)clickAddBtn:(UIButton *)sender
{
    DeliveryYouhuiDetailModel *model = [DeliveryYouhuiDetailModel new];
    model.order_amount = @"";
    model.youhui_amount = @"";
    [dataSource addObject:model];
    [_mainTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:dataSource.count - 1
                                                                inSection:2]]
                          withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark - 点击删除按钮
- (void)clickDeleteBtn:(UIButton *)sender
{
    DeliveryYouhuiCell *cell = (DeliveryYouhuiCell *)[sender superview];
    NSIndexPath *indexPath = [_mainTableView indexPathForCell:cell];
    [dataSource removeObjectAtIndex:indexPath.row];
    [_mainTableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row inSection:2]]
                          withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark - 点击了保存按钮
- (void)clickSureBtn:(UIButton *)sender
{
    NSMutableArray *youhuiArray = @[].mutableCopy;
    if (haveJianMian) {
        for (DeliveryYouhuiDetailModel *dataModel in dataSource) {
            NSString *temString = [NSString stringWithFormat:@"%@:%@",dataModel.order_amount,dataModel.youhui_amount];
            [youhuiArray addObject:temString];
        }
    }
    NSString * youhuiString = [youhuiArray componentsJoinedByString:@","];
    NSDictionary *paramDic = @{@"online_pay":@(onlinePaySwitch.on),
                               @"is_daofu":@(arrivePaySwitch.on),
                               @"is_ziti":@(selfPickSwitch.on),
                               @"first_amount":firstField.text,
                               @"order_youhui":youhuiString};
    if (!onlinePaySwitch.on && !arrivePaySwitch.on) {
        [JHShowAlert showAlertWithMsg:NSLocalizedString(@"请选择在线支付和货到付款至少一种付款方式", nil)];
        return;
    }
    SHOW_HUD
    [HttpTool postWithAPI:@"biz/waimai/youhui/youhui/set"
               withParams:paramDic
                  success:^(id json) {
                      NSLog(@"biz/waimai/youhui/youhui/set--%@",json);
                      HIDE_HUD
                      if ([json[@"error"] isEqualToString:@"0"]) {
                          [JHShowAlert showAlertWithMsg:NSLocalizedString(@"保存成功", nil)
                                           withBtnTitle:NSLocalizedString(@"确定", nil)
                                           withBtnBlock:^{
                                               [self.navigationController popViewControllerAnimated:YES];
                                           }];
                      }else{
                      
                          [JHShowAlert showAlertWithMsg:json[@"message"]];
                      }
                  } failure:^(NSError *error) {
                      HIDE_HUD
                      [JHShowAlert showAlertWithMsg:NSLocalizedString(@"服务器连接异常", nil)];
                      
                  }];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
