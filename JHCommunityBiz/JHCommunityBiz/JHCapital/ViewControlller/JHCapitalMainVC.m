//
//  JHCapitalMainVC.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/19.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHCapitalMainVC.h"
#import "JHCapitalMainCellOne.h"
#import "JHCapitalMainCellTwo.h"
#import "JHCapitalCellNone.h"
#import "JHCapitalModel.h"
#import <MJRefresh.h>
#import "JHCapitalDetailAnotherVC.h"
#import "JHCapitalDetailVC.h"
#import "JHWithDrawDispostVC.h"
@interface JHCapitalMainVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * myTableView;//表视图
    MJRefreshNormalHeader * _header;//下拉刷新用的
    //MJRefreshAutoNormalFooter * _footer;//上拉加载
    BOOL isYes;//模拟用的
    NSInteger num;
    NSMutableArray * infoArray;//存放记录的数组
    UILabel * label_money;//显示余额的
}
@end

@implementation JHCapitalMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //这是初始化一些数据的方法
    [self initData];
    //创建子控件
    [self creatSubControl];
    //创建表视图
    [self creatUITableView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [infoArray removeAllObjects];
    //这是发送请求的方法
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
            label_money.text = json[@"data"][@"money"];
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
        }else{
            [JHShowAlert showAlertWithMsg:json[@"message"]];
        }
        HIDE_HUD
        [_header endRefreshing];
        //[_footer endRefreshing];
    } failure:^(NSError *error) {
        HIDE_HUD
        [_header endRefreshing];
        //[_footer endRefreshing];
        [JHShowAlert showAlertWithMsg:NSLocalizedString(@"服务器繁忙,请稍后访问", nil)];
        NSLog(@"%@",error.localizedDescription);
    }];
}
#pragma mark - 这是初始化一些数据的方法
-(void)initData{
    num = 1;
    infoArray = @[].mutableCopy;
    self.navigationItem.title = NSLocalizedString(@"我的账单", nil);
}
#pragma mark - 这是创建子控件的方法
-(void)creatSubControl{
    //显示账户余额四个字的
    UILabel * label_title = [[UILabel alloc]init];
    label_title.frame = FRAME(10, 15, 100, 20);
    label_title.text = NSLocalizedString(@"账户余额", nil);
    label_title.textColor = THEME_COLOR;
    label_title.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:label_title];
    //显示分割线的
    UIView * label_line = [[UIView alloc]init];
    label_line.frame = FRAME(0, 49.5, WIDTH, 0.5);
    label_line.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    [self.view addSubview:label_line];
    //显示金额的
    label_money = [[UILabel alloc]init];
    label_money.frame = FRAME(WIDTH - 160, 15, 150, 20);
    label_money.textColor = [UIColor colorWithRed:248/255.0 green:168/255.0 blue:37/255.0 alpha:1];
    label_money.text = @"0";
    label_money.adjustsFontSizeToFitWidth = YES;
    label_money.font = [UIFont systemFontOfSize:16];
    label_money.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:label_money];
    //创建点击资金明细的按钮
    UIButton * btn_detail = [[UIButton alloc]init];
    btn_detail.frame = FRAME(1, 50, WIDTH/2 - 2, 60);
    [btn_detail addTarget:self action:@selector(clickToDetail) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_detail];
    //创建按钮中间的小图
    UIImageView * imageView = [[UIImageView alloc]init];
    imageView.frame = FRAME((WIDTH/2 -27)/2, 15, 25, 10);
    imageView.image = [UIImage imageNamed:@"capital_detailed"];
    [btn_detail addSubview:imageView];
    //创建按钮中间显示的资金明细
    UILabel * label_text = [[UILabel alloc]init];
    label_text.frame = FRAME(0, 35, WIDTH/2, 20);
    label_text.textAlignment = NSTextAlignmentCenter;
    label_text.text = NSLocalizedString(@"资金明细", nil);
    label_text.font = [UIFont systemFontOfSize:15];
    label_text.textColor = [UIColor colorWithWhite:0.2 alpha:1];
    [btn_detail addSubview:label_text];
    //创建点击资金提现的按钮
    UIButton * btn_withDraw= [[UIButton alloc]init];
    btn_withDraw.frame = FRAME(WIDTH/2+1, 50, WIDTH/2 - 2, 60);
    [btn_withDraw addTarget:self action:@selector(clickToWithDraw) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_withDraw];
    //创建按钮中间的小图
    UIImageView * imageV = [[UIImageView alloc]init];
    imageV.frame = FRAME((WIDTH/2 -27)/2, 8, 30, 20);
    imageV.image = [UIImage imageNamed:@"capital_Withdrawals"];
    [btn_withDraw addSubview:imageV];
    //创建按钮中间显示的资金明细
    UILabel * label_txt = [[UILabel alloc]init];
    label_txt.frame = FRAME(0, 35, WIDTH/2, 20);
    label_txt.textAlignment = NSTextAlignmentCenter;
    label_txt.text = NSLocalizedString(@"资金提现", nil);
    label_txt.font = [UIFont systemFontOfSize:15];
    label_txt.textColor = [UIColor colorWithWhite:0.2 alpha:1];
    [btn_withDraw addSubview:label_txt];
    //创建两个按钮中间的分割线
    UIView * label_l = [[UIView alloc]init];
    label_l.frame = FRAME(WIDTH/2-0.5, 55, 1, 50);
    label_l.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    [self.view addSubview:label_l];

}
#pragma mark - 这是点击进入我的账单的方法
-(void)clickToDetail{
    JHCapitalDetailVC * vc = [[JHCapitalDetailVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 这是点击资金提现的方法
-(void)clickToWithDraw{
    JHWithDrawDispostVC * vc = [[JHWithDrawDispostVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 这是创建表视图的方法
-(void)creatUITableView{
    myTableView  = [[UITableView alloc]initWithFrame:FRAME(0, 110, WIDTH, HEIGHT - 174-49) style:UITableViewStylePlain];
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
    myTableView.delegate = self;
    myTableView.dataSource = self;
//    _footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(upLoadData)];
//    [_footer setTitle:@"" forState:MJRefreshStateIdle];
//    [_footer setTitle:NSLocalizedString(@"正在加载更多的数据...", nil) forState:MJRefreshStateRefreshing];
//    myTableView.mj_footer = _footer;

}
#pragma mark - 这是表视图的代理和数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!isYes) {
        return infoArray.count+1;
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
@end
