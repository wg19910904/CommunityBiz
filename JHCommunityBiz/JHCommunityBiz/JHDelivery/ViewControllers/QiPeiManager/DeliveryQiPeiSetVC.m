//
//  DeliveryQiPeiSetVC.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/19.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "DeliveryQiPeiSetVC.h"
#import <IQKeyboardManager.h>
#import "QiPeiHeadView.h"
#import "QiPeiFooterView.h"
#import "DeliveryQiPeiAmountCell.h"
#import "DeliveryQiPeiVM.h"
@interface DeliveryQiPeiSetVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property(nonatomic,strong)UITableView *mainTableView;
@end

@implementation DeliveryQiPeiSetVC
{
    UITextField *min_amountField;
    UITextField *rangeField;
    UITextField *pei_typeField;
    UIButton *rightBtn;
    UIButton *sureBtn;
    //点击配送方式的的背景
    UIControl *_backView;
    UIView *peiTypeView;
    NSMutableArray *dataSource;
    
    DeliveryQiPeiVM *vm;
    NSDictionary *titleDic;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"起/配送管理", nil);
    dataSource = @[].mutableCopy;
    //创建主表视图
    [self createMainTableView];
    //添加底部按钮
    [self addBottomBtn];
    //获取信息
    [self loadData];
}
#pragma mark - 创建表视图
- (void)createMainTableView
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
        tableView.layoutMargins = UIEdgeInsetsZero;
        tableView.separatorInset = UIEdgeInsetsZero;
        tableView;
    });
}
#pragma mark - 添加底部按钮
- (void)addBottomBtn
{
    sureBtn =  [UIButton new];
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
    [sureBtn addTarget:self action:@selector(clickSaveBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
}
#pragma mark - 请求数据
- (void)loadData
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [HttpTool postWithAPI:@"biz/waimai/freight/freight/get"
                   withParams:@{}
                      success:^(id json) {
                          NSLog(@"biz/waimai/freight/freight/get--%@",json);
                          if ([json[@"error"] isEqualToString:@"0"]) {
                              vm = [DeliveryQiPeiVM yy_modelWithJSON:json[@"data"]];
                              [dataSource addObjectsFromArray:vm.freight_stage];
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  min_amountField.text = [NSString stringWithFormat:@"%g",[vm.min_amount floatValue]];
                                  rangeField.text = vm.pei_distance;
                                  NSArray *titleArray = @[NSLocalizedString(@"自己送", nil),NSLocalizedString(@"第三方配送", nil)];
                                  pei_typeField.text = titleArray[[vm.pei_type integerValue]];
                                  [_mainTableView reloadSections:[NSIndexSet indexSetWithIndex:2]
                                                withRowAnimation:UITableViewRowAnimationNone];
                                  if (vm.pei_type.integerValue == 1) {
                                      min_amountField.userInteractionEnabled = NO;
                                      sureBtn.hidden = YES;
                                      pei_typeField.userInteractionEnabled = NO;
                                  }
                                  
                              });
                          }else{
                              
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  
                                  [JHShowAlert showAlertWithMsg:json[@"message"]];
                              });
                          }
                      }
                      failure:^(NSError *error) {
                          
                          dispatch_async(dispatch_get_main_queue(), ^{
                              
                              [JHShowAlert showAlertWithMsg:NSLocalizedString(@"服务器连接异常", nil)];
                          });
                          
                      }];
    });
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
            return 1;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return dataSource.count;
            break;
        default:
            return 2;
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
            break;
        case 2:
            return 60;
            break;
        default:
            return 10;
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return section != 2 ? NULL : [[QiPeiHeadView alloc] initWithFrame:FRAME(0, 0, WIDTH, 60)];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return (section == 2 && [vm.pei_type integerValue] != 1) ? 50.0 : 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return (section != 2 || [vm.pei_type integerValue] == 1 ) ? NULL : ({
    
        QiPeiFooterView *footer = [[QiPeiFooterView alloc] initWithFrame:FRAME(0, 0, WIDTH, 50)];
        [footer.addBtn addTarget:self
                          action:@selector(clickAddBtn:)
                forControlEvents:(UIControlEventTouchUpInside)];
        footer;
    });
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    switch (section) {
        case 0:
        {
            UITableViewCell *cell = [UITableViewCell new];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(10, 0, 70, 44)];
            titleLabel.text = NSLocalizedString(@"起送金额", nil);
            titleLabel.font = FONT(15);
            titleLabel.textColor = HEX(@"333333", 1.0f);
            [cell addSubview:titleLabel];
            if (!min_amountField) {
                min_amountField = [[UITextField alloc] initWithFrame:FRAME(80, 5, 140, 34)];
                min_amountField.textColor = THEME_COLOR;
                min_amountField.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
                min_amountField.font = FONT(15);
                UILabel *unitLabel = [[UILabel alloc] initWithFrame:FRAME(0, 0, 35, 34)];
                unitLabel.text = MT;
                unitLabel.textColor = HEX(@"333333", 1.0f);
                unitLabel.font = FONT(15);
                unitLabel.textAlignment = NSTextAlignmentCenter;
                unitLabel.backgroundColor = [UIColor whiteColor];
                min_amountField.rightViewMode = UITextFieldViewModeAlways;
                min_amountField.rightView = unitLabel;
                min_amountField.textAlignment = NSTextAlignmentCenter;
            }
            min_amountField.keyboardType = UIKeyboardTypeNumberPad;
            [cell addSubview:min_amountField];
            return cell;
        }
            break;
        case 1:
        {
            UITableViewCell *cell = [UITableViewCell new];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(10, 0, 70, 44)];
            titleLabel.text = NSLocalizedString(@"配送范围", nil);
            titleLabel.font = FONT(15);
            titleLabel.textColor = HEX(@"333333", 1.0f);
            [cell addSubview:titleLabel];
            if (!rangeField) {
                rangeField = [[UITextField alloc] initWithFrame:FRAME(80, 5, 140, 34)];
                rangeField.textColor = THEME_COLOR;
                rangeField.font = FONT(15);
                UILabel *unitLabel = [[UILabel alloc] initWithFrame:FRAME(0, 0, 35, 34)];
                unitLabel.text = @"km";
                unitLabel.textColor = HEX(@"333333", 1.0f);
                unitLabel.font = FONT(15);
                unitLabel.backgroundColor = [UIColor whiteColor];
                unitLabel.textAlignment = NSTextAlignmentCenter;
                rangeField.rightViewMode = UITextFieldViewModeAlways;
                rangeField.rightView = unitLabel;
                rangeField.textAlignment = NSTextAlignmentCenter;
                rangeField.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
            }
            rangeField.keyboardType = UIKeyboardTypeNumberPad;
            [cell addSubview:rangeField];
            return cell;
        }
            break;
        case 2:
        {
            DeliveryQiPeiAmountCell *cell = [[DeliveryQiPeiAmountCell alloc] init];
            cell.row = indexPath.row;
            cell.isThird = (vm.pei_type.integerValue == 1);
            cell.dataModel = dataSource[indexPath.row];
            [cell.deleteBtn addTarget:self
                               action:@selector(clickCellDeleteBtn:)
                     forControlEvents:(UIControlEventTouchUpInside)];
            return cell;
        }
            break;
        default:
        {
            if (indexPath.row == 0) {
                UITableViewCell *cell = [UITableViewCell new];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(10, 0, 70, 44)];
                titleLabel.text = NSLocalizedString(@"配送方式", nil);
                titleLabel.font = FONT(15);
                titleLabel.textColor = HEX(@"333333", 1.0f);
                [cell addSubview:titleLabel];
                if (!pei_typeField) {
                    pei_typeField = [[UITextField alloc] initWithFrame:FRAME(80, 5, WIDTH - 90, 34)];
                    pei_typeField.textColor = THEME_COLOR;
                    pei_typeField.font = FONT(15);
                    pei_typeField.textAlignment = NSTextAlignmentCenter;
                    pei_typeField.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
                    rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
                    rightBtn.imageEdgeInsets = UIEdgeInsetsMake(10.5, 10, 10.5, 10);
                    //[rightBtn setImage:[UIImage imageNamed:@"shop_drop-down"] forState:UIControlStateNormal];
                    [rightBtn setImage:[UIImage imageNamed:@"up"] forState:UIControlStateSelected];
                    rightBtn.backgroundColor = [UIColor whiteColor];
                    rightBtn.layer.borderColor = DEFAULT_BACKGROUNDCOLOR.CGColor;
                    rightBtn.layer.borderWidth = 1.0;
                    [rightBtn addTarget:self action:@selector(clickPeiTypeCellBtn:) forControlEvents:UIControlEventTouchUpInside];
                    pei_typeField.rightViewMode = UITextFieldViewModeAlways;
                    //pei_typeField.rightView = rightBtn;
                    pei_typeField.delegate = self;
                    
                }
                pei_typeField.keyboardType = UIKeyboardTypeNumberPad;
                [cell addSubview:pei_typeField];
                return cell;
            }else{
                UITableViewCell *cell = [[UITableViewCell alloc] init];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
                UILabel *remindLabel = [[UILabel alloc] initWithFrame:FRAME(10, 0, WIDTH - 20, 44)];
                remindLabel.text = NSLocalizedString(@"温馨提示:起/配送金额设置为0即免起/配送费\n当配送方式为自己送时,第三方配送费无需设置", nil);
                remindLabel.font = FONT(14);
                remindLabel.numberOfLines = 0;
                remindLabel.textColor = HEX(@"666666", 1.0);
                remindLabel.textAlignment = NSTextAlignmentCenter;
                [cell addSubview:remindLabel];
                return cell;
            }
        }
            break;
    }
}
#pragma mark - 点击了右侧按钮
- (void)clickPeiTypeCellBtn:(UIButton *)sender
{
    //获取cell
//    UITableViewCell *cell = [_mainTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
//    CGRect rect = [cell convertRect:cell.bounds toView:self.view];
//    CGFloat peiTypeViewY;
//    peiTypeViewY = CGRectGetMaxY(rect) - 110 + 20;
//    sender.selected = !sender.selected;
//    if(sender.selected){
//
//        sender.backgroundColor = THEME_COLOR;
//    }else{
//
//        sender.backgroundColor = [UIColor whiteColor];
//    }
//    //在windows上添加视图
//    _backView = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
//    _backView.backgroundColor = [UIColor colorWithRed:0/255.0
//                                                green:0/255.0
//                                                 blue:0/255.0 alpha:0.2];
//
//    //为_backView添加方法
//    [_backView addTarget:self action:@selector(tapBackView) forControlEvents:UIControlEventTouchUpInside];
//    [[UIApplication sharedApplication].delegate.window addSubview:_backView];
//
//    //创建配送方式视图
//    peiTypeView = [[UIView alloc] initWithFrame:CGRectMake(80, peiTypeViewY, WIDTH - 90, 105)];
//    peiTypeView.backgroundColor = [UIColor whiteColor];
//    //NSArray *titleArray = @[NSLocalizedString(@"自己送", nil),NSLocalizedString(@"第三方配送", nil),NSLocalizedString(@"配送员代购", nil)];
//    NSArray *titleArray = @[NSLocalizedString(@"自己送", nil),NSLocalizedString(@"第三方配送", nil)];
//    //循环创建button
//    for (int i = 0; i < titleArray.count; i++) {
//        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 18+35*i, WIDTH - 80, 35)];
//        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
//        btn.tag = i + 1;
//        [btn setTitleColor:[UIColor colorWithHex:@"333333" alpha:1.0] forState:UIControlStateNormal];
//        btn.titleLabel.font = FONT(12);
//        [btn addTarget:self action:@selector(clickTypeBtn:) forControlEvents:UIControlEventTouchUpInside];
//        [peiTypeView addSubview:btn];
//    }
//
//    [_backView addSubview:peiTypeView];
}
#pragma mark - 点击背景view
- (void)tapBackView
{
    rightBtn.selected = NO;
    rightBtn.backgroundColor = [UIColor whiteColor];
    NSLog(@"点击背景view");
    [UIView animateWithDuration:0.15
                     animations:^{
                         _backView.backgroundColor = [UIColor colorWithRed:0/255.0
                                                                     green:0/255.0
                                                                      blue:0/255.0
                                                                     alpha:0.0];
                     }];
    [_backView removeFromSuperview];
    _backView = nil;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return NO;
}
#pragma mark - 点击添加按钮
- (void)clickAddBtn:(UIButton *)sender
{
    DeliveryQiPeiDetailModel *model = [DeliveryQiPeiDetailModel new];
    model.fkm = @"";
    model.sm = @"";
    model.fm = @"";
    [dataSource addObject:model];
    [_mainTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:dataSource.count - 1
                                                              inSection:2]]
                                        withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark - 点击cell内的删除按钮
- (void)clickCellDeleteBtn:(UIButton *)sender
{
    //获取indexPath
    UITableViewCell *cell = (UITableViewCell *)[sender superview];
    NSIndexPath *indexPath = [_mainTableView indexPathForCell:cell];
    NSInteger row = indexPath.row;
    [dataSource removeObjectAtIndex:row];
    [_mainTableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row
                                                                inSection:2]]
                          withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark - 点击方式按钮
- (void)clickTypeBtn:(UIButton *)sender
{
    [self tapBackView];
    pei_typeField.text = sender.titleLabel.text;
    
}
#pragma mark - 点击保存按钮
- (void)clickSaveBtn:(UIButton *)sender
{
    //组建参数
    NSArray *titleArray = @[NSLocalizedString(@"自己送", nil),NSLocalizedString(@"第三方配送", nil)];
    NSString *peyString = pei_typeField.text;
    NSInteger peiType = [titleArray indexOfObject:peyString];
    NSString *min_amount = min_amountField.text;
    NSString *pei_distance = rangeField.text;
    if (peyString.length == 0 || min_amount.length == 0 || pei_distance.length == 0) {
        [JHShowAlert showAlertWithMsg:NSLocalizedString(@"请填写完整信息", nil)];
        return;
    }
    NSMutableArray *fkmArr = @[].mutableCopy;
    NSMutableArray *fmArr = @[].mutableCopy;
    NSMutableArray *smArr = @[].mutableCopy;
    for (int i = 0; i<dataSource.count; i++) {
        DeliveryQiPeiDetailModel *dataModel = (DeliveryQiPeiDetailModel *)dataSource[i];
        NSString *fkm = [@([dataModel.fkm integerValue]) description] ;
        NSString *fm = [@([dataModel.fm integerValue]) description];
        NSString *sm = [@([dataModel.sm integerValue]) description];
        
        if (fkm.length == 0) {
            //参数不正确,不组建
        }else{
        
            [fkmArr addObject:fkm];
            [fmArr addObject:fm];
            [smArr addObject:sm];
        }
    }
    NSDictionary *paramDic = @{@"min_amount":min_amount,
                               @"pei_distance":pei_distance,
                               @"fkm":[fkmArr componentsJoinedByString:@","],
                               @"fm":[fmArr componentsJoinedByString:@","],
                               @"sm":[smArr componentsJoinedByString:@","],
                               @"pei_type":@(peiType)};
    SHOW_HUD
    [HttpTool postWithAPI:@"biz/waimai/freight/freight/set"
               withParams:paramDic
                  success:^(id json) {
                      HIDE_HUD
                      if ([json[@"error"] isEqualToString:@"0"]) {
                         
                          [JHShowAlert showAlertWithTitle:NSLocalizedString(@"温馨提醒", nil)
                                              withMessage:NSLocalizedString(@"保存成功", nil)
                                           withBtn_cancel:NSLocalizedString(@"知道了", nil)
                                             withBtn_sure:nil
                                          withCancelBlock:^{
                                              [self.navigationController popViewControllerAnimated:YES];
                                          } withSureBlock:nil];
                      }else{
                          
                          [JHShowAlert showAlertWithMsg:json[@"message"]];
                      }
                  } failure:^(NSError *error) {
                      HIDE_HUD
                      [JHShowAlert showAlertWithMsg:NSLocalizedString(@"服务器连接异常", nil)];
                  }];
}
-(void)buildParamDic
{
//    NSInteger pei_type = [];
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
