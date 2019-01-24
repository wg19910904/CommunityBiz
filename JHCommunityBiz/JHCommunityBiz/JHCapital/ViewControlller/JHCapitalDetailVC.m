//
//  JHCapitalDetailVC.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/20.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHCapitalDetailVC.h"
#import "JHCapitalMainCellOne.h"
#import "JHCapitalMainCellTwo.h"
#import "JHCapitalCellNone.h"
#import "JHCapitalModel.h"
#import <MJRefresh.h>
#import "JHCapitalDetailAnotherVC.h"
#import "DSToast.h"
@interface JHCapitalDetailVC ()<UITableViewDelegate,UITableViewDataSource>

{
    UITableView * myTableView;//表视图
    MJRefreshNormalHeader * _header;//下拉刷新用的
    MJRefreshAutoNormalFooter * _footer;//上拉加载
    BOOL isYes;//模拟用的
    UILabel * label_totalMoney;
    NSMutableArray * infoArray;//存放记录的数组
    NSInteger  num;
    DSToast * toast;
}

@end

@implementation JHCapitalDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化一些数据
    [self initData];
    //创建一些子控件
    [self creatSubControl];
    //创建表视图
    [self creatUITableView];
    //发送请求
    SHOW_HUD
    [self postHttpWithPage:@(num).stringValue];
}
#pragma mark - 这是发送请求的方法
-(void)postHttpWithPage:(NSString *)page{
    [HttpTool postWithAPI:@"biz/shop/money/log" withParams:@{@"page":page} success:^(id json) {
        NSLog(@"%@",json);
        if ([json[@"error"] isEqualToString:@"0"]) {
            if (page.integerValue == 1) {
                [infoArray removeAllObjects];
            }
            label_totalMoney.text = json[@"data"][@"money"];
            NSArray * tempArray = json[@"data"][@"items"];
            for (NSDictionary * dic in tempArray) {
                JHCapitalModel * model = [JHCapitalModel showJHCapitalModelWithDictionary:dic];
                [infoArray addObject:model];
            }
            if (infoArray.count == 0) {
                isYes = YES;
            }else{
                isYes = NO;
            }
            [myTableView reloadData];
            if (toast == nil && tempArray.count == 0 && [page integerValue] > 1) {
                toast = [[DSToast alloc]initWithText:NSLocalizedString(@"亲,没有更多数据了", nil)];
                [toast showInView:self.view  showType:DSToastShowTypeCenter withBlock:^{
                    toast = nil;
                }];
            }
        }else{
            [JHShowAlert showAlertWithMsg:json[@"message"]];
        }
         HIDE_HUD
        [_header endRefreshing];
        [_footer endRefreshing];
    } failure:^(NSError *error) {
         HIDE_HUD
        [_header endRefreshing];
        [_footer endRefreshing];
        [JHShowAlert showAlertWithMsg:NSLocalizedString(@"服务器繁忙,请稍后访问", nil)];
        NSLog(@"%@",error.localizedDescription);
    }];
}
#pragma mark - 初始化一些数据
-(void)initData{
    infoArray = @[].mutableCopy;
    num = 1;
    self.navigationItem.title = NSLocalizedString(@"资金明细", nil);
}
#pragma mark - 创建一些子控件
-(void)creatSubControl{
    UILabel * label = [[UILabel alloc]init];
    label.frame = FRAME(10, 20, 150, 20);
    label.text = NSLocalizedString(@"当前总金额", nil);
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = THEME_COLOR;
    [self.view addSubview:label];
    label_totalMoney = [[UILabel alloc]init];
    label_totalMoney.frame = FRAME(WIDTH/2 - 10, 20, WIDTH/2, 20);
    label_totalMoney.text = @"0";
    label_totalMoney.textColor = [UIColor colorWithRed:251/255.0 green:184/255.0 blue:57/255.0 alpha:1];
    label_totalMoney.textAlignment = NSTextAlignmentRight;
    label_totalMoney.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:label_totalMoney];
}
#pragma mark - 这是创建表视图的方法
-(void)creatUITableView{
    myTableView  = [[UITableView alloc]initWithFrame:FRAME(0, 60, WIDTH, HEIGHT - 124) style:UITableViewStylePlain];
    myTableView.tableFooterView = [UIView new];
    myTableView.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:myTableView];
    [myTableView registerClass:[JHCapitalMainCellOne class] forCellReuseIdentifier:@"cell"];
    [myTableView registerClass:[JHCapitalMainCellTwo class] forCellReuseIdentifier:@"cell1"];
    [myTableView registerClass:[JHCapitalCellNone class] forCellReuseIdentifier:@"cellNone"];
    _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshUpdata)];
    _header.stateLabel.textColor = [UIColor colorWithRed:129/255.0 green:129/255.0 blue:129/255.0 alpha:1];
    _header.lastUpdatedTimeLabel.hidden = YES;
    [_header setTitle:NSLocalizedString(@"下拉可以刷新", nil) forState:MJRefreshStateIdle];
    [_header setTitle:NSLocalizedString(@"现在可以刷新啦", nil) forState:MJRefreshStatePulling];
    [_header setTitle:NSLocalizedString(@"正在为您努力刷新中", nil) forState:MJRefreshStateRefreshing];
    myTableView.mj_header = _header;
    _footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(upLoadData)];
    [_footer setTitle:@"" forState:MJRefreshStateIdle];
    [_footer setTitle:NSLocalizedString(@"正在加载更多的数据...", nil) forState:MJRefreshStateRefreshing];
    myTableView.mj_footer = _footer;
    myTableView.delegate = self;
    myTableView.dataSource = self;
}
#pragma mark - 这是表视图的代理和数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!isYes) {
        return infoArray.count + 1;
    }else{
        return 1;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!isYes) {
        if (indexPath.row == 0) {
            return 40;
        }else{
            return 65;
        }
        
    }else{
            return HEIGHT - 174;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!isYes) {
        if (indexPath.row == 0) {
            JHCapitalMainCellOne * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            cell.num = @(infoArray.count).stringValue;
            return cell;
        }else{
            JHCapitalMainCellTwo * cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
            cell.indexPath = indexPath;
            if (infoArray.count > 0) {
                 JHCapitalModel * model = infoArray[indexPath.row - 1];
                 cell.model = model;
            }
            return cell;
        }
    }else{
        JHCapitalCellNone * cell = [tableView dequeueReusableCellWithIdentifier:@"cellNone" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row != 0 && !isYes) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        JHCapitalModel * model = infoArray[indexPath.row - 1];
        JHCapitalDetailAnotherVC * vc = [[JHCapitalDetailAnotherVC alloc]init];
        vc.log_id = model.log_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - 这是下拉刷新的方法
-(void)refreshUpdata{
    num = 1;
    [self postHttpWithPage:@(num).stringValue];
}
#pragma mark - 这是上拉加载的方法
-(void)upLoadData{
    num ++;
    [self postHttpWithPage:@(num).stringValue];
}
@end
