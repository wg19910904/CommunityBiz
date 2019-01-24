//
//  JHNewCapitalVC.m
//  JHCommunityBiz
//
//  Created by ijianghu on 2017/11/29.
//  Copyright © 2017年 com.jianghu. All rights reserved.
//

#import "JHNewCapitalDetailVC.h"
#import "JHNewCapitalListCell.h"
#import "YFCalendarView.h"
#import "UITableView+XHTool.h"
@interface JHNewCapitalDetailVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger page;
    NSString *dateLine;
     NSString *money;
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)YFCalendarView *calendarView;
@property(nonatomic,copy)NSString *choosedDate;
@property(nonatomic,strong)UIButton*dateBtn;
@property(nonatomic,copy)NSString *yearStr;
@property(nonatomic,strong)NSMutableArray *infoArray;
@end

@implementation JHNewCapitalDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _infoArray = @[].mutableCopy;
    self.navigationItem.title = NSLocalizedString(@"资金明细", NSStringFromClass([self class]));
    [self creatRightNavBtn];
    [self tableView];
    page = 1;
    NSDate *date = [NSDate date];
    NSInteger dateL = [date timeIntervalSince1970];
    dateLine = @(dateL).stringValue;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getData:@""];
}
-(void)getData:(NSString *)date{
    SHOW_HUD
    [HttpTool postWithAPI:@"biz/shop/money/log" withParams:@{@"day":date,@"page":@(page)} success:^(id json) {
        NSLog(@"%@",json);
        if ([json[@"error"] isEqualToString:@"0"]) {
            if (page == 1) {
                [_infoArray removeAllObjects];
            }
            money = json[@"data"][@"money"];
            NSArray * tempArray = json[@"data"][@"items"];
            for (NSDictionary * dic in tempArray) {
                JHCapitalModel * model = [JHCapitalModel showJHCapitalModelWithDictionary:dic];
                [_infoArray addObject:model];
            }
            if (page > 1 && tempArray.count == 0) {
                [self showToastAlertMessageWithTitle: NSLocalizedString(@"没有更多数据了...", NSStringFromClass([self class]))];
            }
            [_tableView reloadData];
        }else{
            [JHShowAlert showAlertWithMsg:json[@"message"]];
        }
        HIDE_HUD
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        HIDE_HUD
        [_tableView.mj_header endRefreshing];
        [_tableView.mj_footer endRefreshing];
        [JHShowAlert showAlertWithMsg: NSLocalizedString(@"服务器繁忙,请稍后访问", NSStringFromClass([self class]))];
        NSLog(@"%@",error.localizedDescription);
    }];
}
-(void)creatRightNavBtn{
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc]init];
    [dateFormater setDateFormat:@"MM-dd"];
    NSString *str = [dateFormater stringFromDate:[NSDate date]];
    [dateFormater setDateFormat:@"yyyy"];
    _yearStr = [dateFormater stringFromDate:[NSDate date]];
    _dateBtn = [[UIButton alloc]initWithFrame:FRAME(0, 0, 65, 30)];
    [_dateBtn setTitle:str forState:UIControlStateNormal];
    [_dateBtn setImage:IMAGE(@"btn_calendar") forState:UIControlStateNormal];
    _dateBtn.titleLabel.font = FONT(14);
    _dateBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -75);
    _dateBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -18, 0, 18);
    [_dateBtn addTarget:self action:@selector(clickRightItem) forControlEvents:UIControlEventTouchUpInside];
    [_dateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:_dateBtn];
    self.navigationItem.rightBarButtonItem = item;
    
}
-(void)clickRightItem{
    [self.calendarView sheetShowInView:self.tabBarController.view];
}
#pragma mark - 这是创建表视图的方法
-(UITableView * )tableView{
    if(_tableView == nil){
        _tableView = ({
            UITableView * table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64) style:UITableViewStyleGrouped];
            table.delegate = self;
            table.dataSource = self;
            table.tableFooterView = [UIView new];
            table.showsVerticalScrollIndicator = NO;
            table.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
            table.separatorStyle = UITableViewCellSeparatorStyleNone;
            [self.view addSubview:table];
            [table downToRefreshWithBlock:^{
                page = 1;
                [self getData:dateLine];
            }];
            [table upToLoadWithBlock:^{
                page ++;
                [self getData:dateLine];
            }];
            table;
        });
    }
    return _tableView;
}
#pragma mark - 这是UITableView的代理和方法和数据方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 0? 1 : _infoArray.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.section == 0? 40 : 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return 0.01;
    }
    return 44;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return nil;
    }
    UILabel *lab = [[UILabel alloc]init];
    lab.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
    lab.textColor = HEX(@"333333", 1);
    lab.text = [NSString stringWithFormat: NSLocalizedString(@"  %@年", NSStringFromClass([self class])),_yearStr];
    lab.font = FONT(14);
    return lab;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString *str = @"cellStr";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor = HEX(@"ff9c00", 1);
        cell.detailTextLabel.text = money;
        cell.textLabel.text =  NSLocalizedString(@"  当前总金额", NSStringFromClass([self class]));
        cell.textLabel.textColor = HEX(@"333333", 1);
        cell.textLabel.font = FONT(14);
        return cell;
    }else{
        static NSString *str = @"JHNewCapitalListCell";
        JHNewCapitalListCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[JHNewCapitalListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        cell.model = _infoArray[indexPath.row];
        return cell;
    }
}
-(YFCalendarView *)calendarView{
    if (_calendarView==nil) {
        _calendarView=[[YFCalendarView alloc] init];
        __weak typeof(self) weakSelf=self;
        _calendarView.selectDayHandler = ^(NSInteger year,NSInteger month,NSInteger day){
            [weakSelf getDataWithDate:year month:month day:day];
        };
    }
    _calendarView.choosedDate = self.choosedDate;
    return _calendarView;
}
#pragma mark ======选择时间刷新数据=======
-(void)getDataWithDate:(NSInteger)year month:(NSInteger)month day:(NSInteger)day{
    _yearStr = @(year).stringValue;
    self.choosedDate = [NSString stringWithFormat:@"%ld-%ld-%ld",year,month,day];
    [_dateBtn setTitle:[NSString stringWithFormat:@"%ld-%ld",month,day] forState:UIControlStateNormal];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *str2 = [NSString stringWithFormat:@"%4ld-%02ld-%02ld ",year,month,day];
    NSDate *date = [dateFormatter dateFromString:str2];
    page = 1;
    NSInteger dateL = [date timeIntervalSince1970];
    dateLine = @(dateL).stringValue;
    [self getData:dateLine];
}
@end

