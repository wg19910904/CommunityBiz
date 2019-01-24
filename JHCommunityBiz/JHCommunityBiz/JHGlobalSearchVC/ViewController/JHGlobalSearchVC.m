 //
//  JHGlobalSearchVC.m
//  JHCommunityStaff
//
//  Created by ijianghu on 2017/12/15.
//  Copyright © 2017年 jianghu2. All rights reserved.
//

#import "JHGlobalSearchVC.h"
#import <IQKeyboardManager.h>
#import "SReconderSearchInputCell.h"
#import "SReconderDimTimeCell.h"
#import "SReconderSearchChoseTimeCell.h"
#import "HZQDatePicker.h"
#import "JHShowAlert.h"
#import "JHGroupOrderListVC.h"
#import "DeliveryOrderListVC.h"
@interface JHGlobalSearchVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    NSString *startTime;
    NSString *endTime;
    BOOL isWeek;//周
    BOOL isMonth;//月
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIButton *resetBtn;//重置的按钮
@property(nonatomic,strong)UIButton *sureBtn;//确定筛选的按钮
@property(nonatomic,weak)UITextField *searchTextF;//搜索的输入框
@property(nonatomic,weak)UITextField *nameTextV;//姓名的输入框
@end
@implementation JHGlobalSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"筛选", NSStringFromClass([self class]));
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.view.backgroundColor = HEX(@"f5f5f5",1.0f);
    startTime = [self dateLineExchangeWithTime:_cacheDic[@"bg_time"]];
    endTime = [self dateLineExchangeWithTime:_cacheDic[@"end_time"]];
    [self tableView];
    [self resetBtn];
    [self sureBtn];
}
-(UIButton *)resetBtn{
    if (!_resetBtn) {
        _resetBtn = [UIButton new];
        [_resetBtn setTitle: NSLocalizedString(@"重置", NSStringFromClass([self class])) forState:UIControlStateNormal];
        [_resetBtn setTitleColor:_tintColor forState:UIControlStateNormal];
        _resetBtn.titleLabel.font = FONT(16);
        _resetBtn.backgroundColor = [UIColor whiteColor];
        _resetBtn.layer.cornerRadius = 4;
        _resetBtn.layer.masksToBounds = YES;
        [self.view addSubview:_resetBtn];
        [_resetBtn addTarget:self action:@selector(clickReset) forControlEvents:UIControlEventTouchUpInside];
        [_resetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 15;
            make.bottom.offset = -10;
            make.height.offset = 44;
            make.width.offset = 120;
        }];
        
    }
    return _resetBtn;
}
-(void)clickReset{
    NSLog(@"点击重置的方法");
    _searchTextF.text = nil;
    SReconderDimTimeCell *cell1 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    [cell1 removeSelecter];
    endTime = nil;
    startTime = nil;
    isMonth = NO;
    isWeek = NO;
    [_tableView reloadData];
    //手动执行筛选的方法
    [self clickSureSearch];
}
-(UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [UIButton new];
        [_sureBtn setTitle: NSLocalizedString(@"确定筛选", NSStringFromClass([self class])) forState:UIControlStateNormal];
        [_sureBtn setTitleColor:HEX(@"ffffff", 1) forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = FONT(16);
        _sureBtn.backgroundColor = _tintColor;
        _sureBtn.layer.cornerRadius = 4;
        _sureBtn.layer.masksToBounds = YES;
        [self.view addSubview:_sureBtn];
        [_sureBtn addTarget:self action:@selector(clickSureSearch) forControlEvents:UIControlEventTouchUpInside];
        [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_resetBtn.mas_right).offset = 10;
            make.bottom.offset = -10;
            make.height.offset = 44;
            make.right.offset = -15;
        }];
    }
    return _sureBtn;
}
#pragma mark - 点击确定筛选的方法
-(void)clickSureSearch{
    NSLog(@"点击筛选的方法");
    NSMutableDictionary *tempDic = @{@"so":@"",
                                     @"pay_time":@"",
                                     @"bg_time":@"",
                                     @"end_time":@""}.mutableCopy;
    if (_searchTextF.text.length > 0) {
        [tempDic setObject:_searchTextF.text forKey:@"so"];
    }else{
        if (isWeek || isMonth) {
            NSString *str = isWeek?@"week":@"month";
            [tempDic setObject:str forKey:@"pay_time"];
        }
        if (startTime.length > 0) {
            if (![startTime containsString:@" 00:00:00"]) {
                startTime = [startTime stringByAppendingString:@" 00:00:00"];
            }
            NSInteger start = [self ExchangeWithTime:startTime];
            [tempDic setObject:@(start).stringValue forKey:@"bg_time"];
        }
        if (endTime.length > 0) {
            if (![endTime containsString:@" 23:59:59"]) {
                 endTime = [endTime stringByAppendingString:@" 23:59:59"];
            }
            NSInteger end = [self ExchangeWithTime:endTime];
            [tempDic setObject:@(end).stringValue forKey:@"end_time"];
        }
    }
    switch (self.searchType) {
        case ESearch_waimai:
        {
            DeliveryOrderListVC *waimaiOrderList = [[DeliveryOrderListVC alloc] init];
            waimaiOrderList.addCondition = tempDic;
            [self.navigationController pushViewController:waimaiOrderList animated:YES];
        }
            break;
            
        case ESearch_tuangou:
        {
            JHGroupOrderListVC *vc = [[JHGroupOrderListVC alloc] init];
            vc.isShaiXuan = YES;
            [vc reloadTableViewCondition:tempDic];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        case ESearch_maidan:
            if (self.clickBlock) {
                self.clickBlock(tempDic);
                [self.navigationController popViewControllerAnimated:YES];
            }
            break;
            
        default:
            
            break;
    }
}
#pragma mark - 这是创建表视图的方法
-(UITableView * )tableView{
    if(_tableView == nil){
        _tableView = ({
            UITableView * table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64-64) style:UITableViewStylePlain];
            table.rowHeight = UITableViewAutomaticDimension;
            table.estimatedRowHeight = 100;
            table.delegate = self;
            table.dataSource = self;
            table.tableFooterView = [UIView new];
            table.showsVerticalScrollIndicator = NO;
            table.backgroundColor = HEX(@"f5f5f5",1.0f);;
            table.separatorStyle = UITableViewCellSeparatorStyleNone;
            [self.view addSubview:table];
            table;
        });
    }
    return _tableView;
}
#pragma mark - 这是UITableView的代理和方法和数据方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return 3;
    }
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = HEX(@"f5f5f5",1.0f);;
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof (self)weakSelf = self;
    if (indexPath.section == 0) {
        static NSString *str  = @"SReconderSearchInputCell";
        SReconderSearchInputCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[SReconderSearchInputCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        cell.inputText.delegate = self;
        cell.searchImgStr = self.searchImgStr;
        _searchTextF = cell.inputText;
        if (_cacheDic[@"so"]) {
             _searchTextF.text = _cacheDic[@"so"];
        }
        [cell setSearchBlock:^{
            [weakSelf clickSearch];
        }];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section == 1 && indexPath.row == 0){
        static NSString *str  = @"SReconderDimTimeCell";
        SReconderDimTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[SReconderDimTimeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        cell.tintColor = _tintColor;
        NSString *duration = _cacheDic[@"pay_time"];
        if ([duration isEqualToString:@"week"]) {
            [cell selectBtnWithIndex:0];
            
        }else if([duration isEqualToString:@"month"]){
            [cell selectBtnWithIndex:1];
            
        }
        [cell setClickBlock:^(NSInteger tag){
            if (tag == 0) {
                isWeek = YES;
                isMonth = NO;
            }else{
                isMonth = YES;
                isWeek = NO;
            }
            endTime = nil;
            startTime = nil;
            _searchTextF.text = @"";
            [_searchTextF resignFirstResponder];
            [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
            [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
        }];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        static NSString *str  = @"SReconderSearchChoseTimeCell";
        SReconderSearchChoseTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[SReconderSearchChoseTimeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        cell.choseTimeArrow = self.choseTimeArrow;
        cell.rightBtn.tag = indexPath.row;
        [cell.rightBtn addTarget:self action:@selector(clickChoseTime:) forControlEvents:UIControlEventTouchUpInside];
        if (indexPath.row == 1) {
            cell.leftL.text = NSLocalizedString(@"开始时间", NSStringFromClass([self class]));
            [cell.rightBtn setTitle:startTime.length?startTime: NSLocalizedString(@"请选择", NSStringFromClass([self class])) forState:UIControlStateNormal];
        }else{
            cell.leftL.text = NSLocalizedString(@"结束时间", NSStringFromClass([self class]));
            [cell.rightBtn setTitle:endTime.length?endTime: NSLocalizedString(@"请选择", NSStringFromClass([self class])) forState:UIControlStateNormal];
        }
        cell.rightBtn.titleMargin = cell.rightBtn.titleLabel.text.length == 3?70:40;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
#pragma mark - 点击了选择时间段的
-(void)clickChoseTime:(UIButton *)sender{
    HZQDatePicker * datePicker = [[HZQDatePicker alloc]init];
    datePicker.iscanSelectPassTime = YES;
    __weak typeof (self)weakSelf = self;
     [self.view endEditing:YES];
    [datePicker setMyBlock:^(NSString * time) {
        if (sender.tag == 1) {
            if (endTime.length && [endTime compare:time] == -1) {
                [JHShowAlert showAlertWithMsg: NSLocalizedString(@"开始时间要小于结束时间", NSStringFromClass([self class]))];
                return ;
            }
            startTime = time;
        }else{
            if (startTime.length && [startTime compare:time] == 1) {
                [JHShowAlert showAlertWithMsg: NSLocalizedString(@"结束时间要大于开始时间", NSStringFromClass([self class]))];
                return ;
            }
            endTime = time;
        }
        SReconderDimTimeCell *cell = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        [cell removeSelecter];
        isMonth = NO;
        isWeek = NO;
        _searchTextF.text = @"";
        [_searchTextF resignFirstResponder];
        [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:sender.tag inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    [datePicker creatDatePickerWithObj:datePicker withDate:[NSDate date]];
}
#pragma mark - 点击搜索的方法
-(void)clickSearch{
    [self clickSureSearch];
}
#pragma mark - 这是UITextField的代理方法
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [IQKeyboardManager sharedManager].enable = YES;
    if (startTime) {
        startTime = nil;
        [self.tableView  reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
    }
    if (endTime) {
        [self.tableView  reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
    }
    if (isWeek || isMonth) {
        isWeek = NO;
        isMonth = NO;
        SReconderDimTimeCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        [cell removeSelecter];
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}
#pragma mark - 滑动表的时候让键盘下落
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([IQKeyboardManager sharedManager].enable) {
        
    }else{
        [self.view endEditing:YES];
    }
}
#pragma mark - 这是表结束减速的时候
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [IQKeyboardManager sharedManager].enable = YES;
}
#pragma mark - 这是表开始拖动的时候
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [IQKeyboardManager sharedManager].enable = NO;
}
-(NSInteger )ExchangeWithTime:(NSString *)time{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * date = [dateFormatter dateFromString:time];
    NSInteger dateline = [date timeIntervalSince1970];
    return dateline;
}
-(NSString *)dateLineExchangeWithTime:(NSString *)dateLine{
    if (dateLine) {
        NSInteger num = [dateLine integerValue];
        NSDate * date = [NSDate dateWithTimeIntervalSince1970:num];
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString * time = [dateFormatter stringFromDate:date];
        return time;
    }else{
        return nil;
    }
}
@end
