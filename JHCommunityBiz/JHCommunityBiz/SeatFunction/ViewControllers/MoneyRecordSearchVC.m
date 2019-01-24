//
//  MoneyRecordSearchVC.m
//  JHCommunityBiz
//
//  Created by ijianghu on 2017/11/11.
//  Copyright © 2017年 com.jianghu. All rights reserved.
//

#import "MoneyRecordSearchVC.h"
#import <IQKeyboardManager.h>
#import "ReconderSearchInputCell.h"
#import "ReconderSearchTypeCell.h"
#import "ReconderTaiKNameCell.h"
#import "ReconderDimTimeCell.h"
#import "ReconderSearchChoseTimeCell.h"
#import "HZQDatePicker.h"
#import "QRCodeListModel.h"
@interface MoneyRecordSearchVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    NSString *startTime;
    NSString *endTime;
    BOOL isWeek;//周
    BOOL isMonth;//月
    NSInteger taikaiIndex;
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIButton *resetBtn;//重置的按钮
@property(nonatomic,strong)UIButton *sureBtn;//确定筛选的按钮
@property(nonatomic,weak)UITextField *searchTextF;//搜索的输入框
@property(nonatomic,strong)NSMutableArray *typeArr;//搜索的类型
@property(nonatomic,weak)UITextField *nameTextV;//姓名的输入框
@property(nonatomic,strong)NSMutableArray *infoArr;//数组
@property(nonatomic,strong)NSMutableArray *nameArr;
@end

@implementation MoneyRecordSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title =  NSLocalizedString(@"筛选", NSStringFromClass([self class]));
    self.view.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
    _typeArr = @[@"0",@"0",@"0"].mutableCopy;
    taikaiIndex = -1;
    _infoArr = @[].mutableCopy;
    _nameArr = @[].mutableCopy;
    [self tableView];
    [self resetBtn];
    [self sureBtn];
    [self getData];
}
-(void)getData{
    SHOW_HUD
    [HttpTool postWithAPI:@"biz/decca/items" withParams:@{@"is_all":@"1"} success:^(id json) {
        HIDE_HUD
        if ([json[@"error"] isEqualToString:@"0"]) {
            NSLog(@"输出的数据是:%@",json);
            NSArray *tempArr = json[@"data"][@"items"];
            for (int i = 0; i < tempArr.count; i++) {
                NSDictionary *dic = tempArr[i];
                QRCodeListModel *model = [QRCodeListModel getDataWithDic:dic];
                [_nameArr addObject:model.title];
                [_infoArr addObject:model];
            }
            [_nameArr insertObject: NSLocalizedString(@"全部台卡", NSStringFromClass([self class])) atIndex:0];
            if (tempArr.count > 0) {
                [_tableView reloadData];
            }
        }else{
            [self showToastAlertMessageWithTitle:json[@"message"]];
        }
    } failure:^(NSError *error) {
        HIDE_HUD
        NSLog(@"请求出错:%@",error);
    }];
}
-(UIButton *)resetBtn{
    if (!_resetBtn) {
        _resetBtn = [UIButton new];
        [_resetBtn setTitle: NSLocalizedString(@"重置", NSStringFromClass([self class])) forState:UIControlStateNormal];
        [_resetBtn setTitleColor:HEX(@"ff9900", 1) forState:UIControlStateNormal];
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
    _typeArr = @[@"0",@"0",@"0"].mutableCopy;
    ReconderSearchTypeCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    [cell removeSelectorIndex];
    ReconderDimTimeCell *cell1 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
    [cell1 removeSelecter];
    endTime = nil;
    startTime = nil;
    isMonth = NO;
    isWeek = NO;
    taikaiIndex = -1;
    [_tableView reloadData];
    
}
-(UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [UIButton new];
        [_sureBtn setTitle: NSLocalizedString(@"确定筛选", NSStringFromClass([self class])) forState:UIControlStateNormal];
        [_sureBtn setTitleColor:HEX(@"ffffff", 1) forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = FONT(16);
        _sureBtn.backgroundColor = HEX(@"ff9900", 1);
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
    NSMutableDictionary *tempDic = @{}.mutableCopy;
    if (_searchTextF.text.length > 0) {
        [tempDic setObject:_searchTextF.text forKey:@"order_id"];
    }else{
        if (isWeek || isMonth) {
            NSString *str = isWeek?@"week":@"month";
            [tempDic setObject:str forKey:@"trading"];
        }
        if (startTime.length > 0) {
            if (![startTime containsString:@" 00:00:00"]) {
                startTime = [startTime stringByAppendingString:@" 00:00:00"];
            }
             NSInteger start = [self ExchangeWithTime:startTime];
             [tempDic setObject:@(start).stringValue forKey:@"start_day"];
        }
        if (endTime.length > 0) {
            if (![endTime containsString:@" 23:59:59"]) {
                endTime = [endTime stringByAppendingString:@" 23:59:59"];
            }
             NSInteger end = [self ExchangeWithTime:endTime];
             [tempDic setObject:@(end).stringValue forKey:@"end_day"];
        }
        NSString *type_str;
        for (int i = 0; i < _typeArr.count; i++) {
            NSString *str = _typeArr[i];
            if ([str isEqualToString:@"1"] && i == 0){
                type_str = @"wxpay";
            }
            if ([str isEqualToString:@"1"] && i == 1){
                type_str = type_str.length>0?[type_str stringByAppendingString:@",alipay"]:@"alipay";
            }
            if ([str isEqualToString:@"1"] && i == 2){
                type_str = type_str.length>0?[type_str stringByAppendingString:@",decca"]:@"decca";
            }
        }
        if (type_str.length > 0) {
            [tempDic setObject:type_str forKey:@"type"];
            if (taikaiIndex >0) {
                QRCodeListModel *model = _infoArr[taikaiIndex-1];
                [tempDic setObject:model.decca_id forKey:@"decca_id"];
            }
        }
    }
    if (self.clickBlock) {
        self.clickBlock(tempDic);
        [self.navigationController popViewControllerAnimated:YES];
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
            table.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
            table.separatorStyle = UITableViewCellSeparatorStyleNone;
            [self.view addSubview:table];
            table;
        });
    }
    return _tableView;
}
#pragma mark - 这是UITableView的代理和方法和数据方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 3) {
        return 3;
    }
    if (section == 2) {
        NSInteger taikai = [_typeArr[2]integerValue];
        if (taikai == 0) {
            taikaiIndex = -1;
        }
        return taikai == 1?1:0;
    }
    
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     __weak typeof (self)weakSelf = self;
    if (indexPath.section == 0) {
        static NSString *str  = @"ReconderSearchInputCell";
        ReconderSearchInputCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[ReconderSearchInputCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        cell.inputText.delegate = self;
        _searchTextF = cell.inputText;
        [cell setSearchBlock:^{
            [weakSelf clickSearch];
        }];
        return cell;
    }else if (indexPath.section == 1){
        static NSString *str  = @"ReconderSearchTypeCell";
        ReconderSearchTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[ReconderSearchTypeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        [cell setChoseBlock:^(NSInteger index,NSString *str) {
            [_typeArr replaceObjectAtIndex:index withObject:str];
            if (index == 2) {
                 [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }];
        return cell;
    }
    else if (indexPath.section == 2){
        ReconderTaiKNameCell *cell = [[ReconderTaiKNameCell alloc]init];
        cell.nameArr = _nameArr;
        [cell setClickBlock:^(NSInteger index) {
            taikaiIndex = index;
        }];
        return cell;
    }else if (indexPath.section == 3 && indexPath.row == 0){
        static NSString *str  = @"ReconderDimTimeCell";
        ReconderDimTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[ReconderDimTimeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
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
            [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:3]] withRowAnimation:UITableViewRowAnimationNone];
            [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:3]] withRowAnimation:UITableViewRowAnimationNone];
        }];
        return cell;
    }else{
        static NSString *str  = @"ReconderSearchChoseTimeCell";
        ReconderSearchChoseTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[ReconderSearchChoseTimeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        cell.rightBtn.tag = indexPath.row;
        [cell.rightBtn addTarget:self action:@selector(clickChoseTime:) forControlEvents:UIControlEventTouchUpInside];
        if (indexPath.row == 1) {
            cell.leftL.text =  NSLocalizedString(@"开始时间", NSStringFromClass([self class]));
            [cell.rightBtn setTitle:startTime?startTime: NSLocalizedString(@"请选择", NSStringFromClass([self class])) forState:UIControlStateNormal];
        }else{
             cell.leftL.text = NSLocalizedString(@"结束时间", NSStringFromClass([self class]));
             [cell.rightBtn setTitle:endTime?endTime:NSLocalizedString(@"请选择", NSStringFromClass([self class])) forState:UIControlStateNormal];
        }
        cell.rightBtn.titleMargin = cell.rightBtn.titleLabel.text.length == 3?70:40;
        return cell;
    }
}
#pragma mark - 点击了选择时间段的
-(void)clickChoseTime:(UIButton *)sender{
    HZQDatePicker * datePicker = [[HZQDatePicker alloc]init];
    datePicker.iscanSelectPassTime = YES;
      [self.view endEditing:YES];
    __weak typeof (self)weakSelf = self;
    [datePicker setMyBlock:^(NSString * time) {
        if (sender.tag == 1) {
            if (endTime && [endTime compare:time] == -1) {
                [JHShowAlert showAlertWithMsg: NSLocalizedString(@"开始时间要小于结束时间", NSStringFromClass([self class]))];
                return ;
            }
            startTime = time;
        }else{
            if (startTime && [startTime compare:time] == 1) {
                [JHShowAlert showAlertWithMsg: NSLocalizedString(@"结束时间要大于开始时间", NSStringFromClass([self class]))];
                return ;
            }
            endTime = time;
        }
        ReconderDimTimeCell *cell = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
        [cell removeSelecter];
        isMonth = NO;
        isWeek = NO;
        [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:sender.tag inSection:3]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    [datePicker creatDatePickerWithObj:datePicker withDate:[NSDate date]];
}
#pragma mark - 点击搜索的方法
-(void)clickSearch{
    NSLog(@"点击了搜索");
    if (_searchTextF.text.length == 0) {
        [self showToastAlertMessageWithTitle: NSLocalizedString(@"请输入单号", NSStringFromClass([self class]))];
    }else{
        NSMutableDictionary *tempDic = @{}.mutableCopy;
        [tempDic setObject:_searchTextF.text forKey:@"order_id"];
        if (self.clickBlock) {
            self.clickBlock(tempDic);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
#pragma mark - 这是UITextField的代理方法
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [IQKeyboardManager sharedManager].enable = YES;
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
@end
