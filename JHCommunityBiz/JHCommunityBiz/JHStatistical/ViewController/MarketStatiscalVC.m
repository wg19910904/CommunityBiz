//
//  MarketStatiscalVC.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/7/1.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "MarketStatiscalVC.h"
#import "JHMarketModel.h"
#import "JHMarketStatiscalCell.h"
@interface MarketStatiscalVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * myTableView;//指向表格的方法
    JHMarketModel * model;
}
@end

@implementation MarketStatiscalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化数据的方法
    [self initData];
    //这是请求数据的方法
    SHOW_HUD
    [self postHttp];
}
#pragma mark - 这是发送请求的方法
-(void)postHttp{
    [HttpTool postWithAPI:@"biz/tongji/sales" withParams:@{} success:^(id json) {
        NSLog(@"%@",json);
        if ([json[@"error"] isEqualToString:@"0"]) {
            model = [[JHMarketModel alloc]init];
            model.weekDataArray = json[@"data"][@"week_items"];
            model.monthDataArray = json[@"data"][@"month_items"];
        }
        //创建表格的方法
        [self creatUITableView];
         HIDE_HUD
    } failure:^(NSError *error) {
         HIDE_HUD
        [JHShowAlert showAlertWithMsg:NSLocalizedString(@"服务器繁忙,请稍后访问", nil)];
        NSLog(@"%@",error.localizedDescription);
    }];
}
#pragma  mark - 这是初始化一些数据的方法
-(void)initData{
    
}
#pragma mark - 这是创建表格的方法
-(void)creatUITableView{
    if (myTableView == nil) {
        myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 50 - 64) style:UITableViewStylePlain];
        myTableView.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
        myTableView.tableFooterView = [UIView new];
        myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:myTableView];
        [myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [myTableView registerClass:[JHMarketStatiscalCell class] forCellReuseIdentifier:@"cell1"];
        myTableView.delegate = self;
        myTableView.dataSource = self;
    }else{
        [myTableView reloadData];
    }
}
#pragma mark - 这是表的代理和数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 || indexPath.row == 2) {
        return 15;
    }else{
        return 210;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 || indexPath.row == 2) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
        return cell;
    }else{
        JHMarketStatiscalCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        cell.indexpath = indexPath;
        cell.model = model;
        return cell;
    }
}
@end
