//
//  JHIncomeStatiscalVC.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/11.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHIncomeStatiscalVC.h"
#import"JHBrokenLineCell.h"
#import "JHStatiscalMainCell.h"
#import "JHCurveCell.h"
#import "JHstatiscalModel.h"
#import "JHIncomeModel.h"
#import <MJRefresh.h>
@interface JHIncomeStatiscalVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * myTableView;//创建表视图
    NSArray * array_title;//小标题
    NSMutableArray * array_data;//小标题下的四个数值
    NSMutableArray * infoArray;//存放model类的
    NSMutableArray * dataArray;//近一月的数据
    NSMutableArray * dateArray;//近一月的日期
    MJRefreshNormalHeader * _header;//下拉刷新的时候
}
@end

@implementation JHIncomeStatiscalVC

- (void)viewDidLoad {
    [super viewDidLoad];
     //初始化数据
    [self initData];
    //发送请求的方法
    SHOW_HUD
    [self postHttp];
}
#pragma mark - 这是发送请求的方法
-(void)postHttp{
    [HttpTool postWithAPI:@"biz/tongji/money" withParams:@{} success:^(id json) {
        NSLog(@"%@",json);
        if ([json[@"error"] isEqualToString:@"0"]) {
            //模拟假数据
            array_data = [NSMutableArray arrayWithObjects:
                          json[@"data"][@"today_money"],
                          json[@"data"][@"week_money"],
                          json[@"data"][@"month_money"],
                          json[@"data"][@"total_money"],
                          nil];
            NSArray * tempArray = json[@"data"][@"items"];
            for (NSDictionary * dic in tempArray) {
                [dateArray addObject:dic[@"date"]];
                [dataArray addObject:dic[@"money"]];
                JHIncomeModel * model = [JHIncomeModel creatJHIncomeModelWithDictionary:dic];
                [infoArray addObject:model];
            }
            //创建表视图
            [self creatUITableView];
        }else{
            [JHShowAlert showAlertWithMsg:json[@"message"]];
        }
        HIDE_HUD
         [_header endRefreshing];
    } failure:^(NSError *error) {
        HIDE_HUD
        [_header endRefreshing];
        [JHShowAlert showAlertWithMsg:NSLocalizedString(@"服务器繁忙,请稍后访问", nil)];
        NSLog(@"%@",error.localizedDescription);
    }];
}
#pragma mark - 这是初始化数据的
-(void)initData{
    array_title = @[NSLocalizedString(@"今日收入", nil),NSLocalizedString(@"近7天收入", nil),NSLocalizedString(@"近30天收入", nil),NSLocalizedString(@"累计总收入", nil)];
    infoArray = @[].mutableCopy;
    dataArray = @[].mutableCopy;
    dateArray = @[].mutableCopy;
}
#pragma mark - 这是创建表视图的方法
-(void)creatUITableView{
    if (myTableView == nil) {
        myTableView = [[UITableView alloc]initWithFrame:FRAME(0, 0, WIDTH, HEIGHT - 64-50) style:UITableViewStylePlain];
        myTableView.tableFooterView = [UIView new];
        [self.view addSubview:myTableView];
        myTableView.showsVerticalScrollIndicator = NO;
        myTableView.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
        myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [myTableView registerClass:[JHBrokenLineCell class] forCellReuseIdentifier:@"cell1"];
        [myTableView registerClass:[JHCurveCell class] forCellReuseIdentifier:@"cell2"];
        [myTableView registerClass:[JHStatiscalMainCell class] forCellReuseIdentifier:@"cell3"];
        _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(downRefresh)];
        _header.lastUpdatedTimeLabel.hidden = YES;
        [_header setTitle:NSLocalizedString(@"下拉可以刷新", nil) forState:MJRefreshStateIdle];
        [_header setTitle:NSLocalizedString(@"现在可以刷新啦", nil) forState:MJRefreshStatePulling];
        [_header setTitle:NSLocalizedString(@"正在为您努力刷新中", nil) forState:MJRefreshStateRefreshing];
        myTableView.mj_header = _header;
        myTableView.delegate = self;
        myTableView.dataSource = self;

    }else{
        [myTableView reloadData];
    }
}
#pragma mark - 这是下拉刷新的方法
-(void)downRefresh{
    [dateArray removeAllObjects];
    [dataArray removeAllObjects];
    [infoArray removeAllObjects];
    [self postHttp];
}
#pragma mark - 这是表视图的代理和数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 120;
    }else if (indexPath.row == 1||indexPath.row == 3){
        return 10;
    }else{
        return 210;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        JHStatiscalMainCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell3" forIndexPath:indexPath];
        JHstatiscalModel * model = nil;
        cell.titleArray = array_title;
        cell.dataArray = array_data;
        cell.model = model;
        return cell;
    }else if (indexPath.row == 1 || indexPath.row == 3){
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
        return cell;
    }else if (indexPath.row == 2){
        JHBrokenLineCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        [cell configUI:indexPath withInfoArray:infoArray withNum:1];
        return cell;
    }else {
        JHCurveCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
        [cell creatNSMutableArray:dataArray withNSMutableArray:dateArray];
        cell.label_title.text = NSLocalizedString(@"近30天收入曲线", nil);
        return cell;
    }
}
@end
