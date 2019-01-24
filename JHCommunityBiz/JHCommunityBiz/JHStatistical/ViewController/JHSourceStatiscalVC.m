//
//  JHSourceStatiscalVC.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/11.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHSourceStatiscalVC.h"
#import "JHSourceCell.h"
#import "JHSourceModel.h"
@interface JHSourceStatiscalVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * myTableView;//指向表格的方法
    JHSourceModel *  model;
}
@end

@implementation JHSourceStatiscalVC
- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化数据的方法
    [self initData];
    //发送请求
    SHOW_HUD
    [self postHttp];
}
-(void)postHttp{
    [HttpTool postWithAPI:@"biz/tongji/source" withParams:@{} success:^(id json) {
        NSLog(@"%@",json);
        if ([json[@"error"] isEqualToString:@"0"]) {
            model = [[JHSourceModel alloc]init];
            model.month_dictioanry = json[@"data"][@"month_count"];
            model.week_dictioanry = json[@"data"][@"week_count"];
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
        [myTableView registerClass:[JHSourceCell class] forCellReuseIdentifier:@"cell1"];
        myTableView.delegate = self;
        myTableView.dataSource = self;
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
        JHSourceCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        cell.indexpath = indexPath;
        cell.model = model;
        return cell;
    }
}
@end
