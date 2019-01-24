//
//  JHCapitalDetailAnotherVC.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/19.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHCapitalDetailAnotherVC.h"
#import "HZQChangeDateLine.h"
@interface JHCapitalDetailAnotherVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * myTableView;//这是创建表视图的对象
    NSArray * titleArray;//存放单元格前面的内容的
    NSMutableArray * detailArray;//存放单元格后面的内容的
    UIView * label_line;//分割线
}
@end

@implementation JHCapitalDetailAnotherVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化一些数据
    [self initData];
    //这是请求数据的方法
    SHOW_HUD
    [self postHttp];
}
#pragma mark - 这是发送请求的方法
-(void)postHttp{
    [HttpTool postWithAPI:@"biz/shop/money/log_detail" withParams:@{@"log_id":self.log_id} success:^(id json) {
        NSLog(@"%@",json);
        if ([json[@"error"] isEqualToString:@"0"]) {
            if ([json[@"data"][@"log"][@"money"] integerValue] < 0) {
                titleArray = @[NSLocalizedString(@"转出金额", nil),@"",NSLocalizedString(@"类型", nil),NSLocalizedString(@"时间", nil),NSLocalizedString(@"备注", nil)];
                detailArray = [NSMutableArray arrayWithObjects:
                               json[@"data"][@"log"][@"money"],@"",
                               NSLocalizedString(@"支出", nil),
                               [HZQChangeDateLine dateLineExchangeWithTime:json[@"data"][@"log"][@"dateline"]],
                               json[@"data"][@"log"][@"intro"], nil];
            }else{
                titleArray = @[NSLocalizedString(@"入账金额", nil),@"",NSLocalizedString(@"类型", nil),NSLocalizedString(@"时间", nil),NSLocalizedString(@"备注", nil)];
                detailArray = [NSMutableArray arrayWithObjects:
                               json[@"data"][@"log"][@"money"],@"",
                               NSLocalizedString(@"收入", nil),
                               [HZQChangeDateLine dateLineExchangeWithTime:json[@"data"][@"log"][@"dateline"]],
                               json[@"data"][@"log"][@"intro"], nil];
            }
            //这是创建表格的方法
            [self creatUITableView];
        }else{
            [JHShowAlert showAlertWithMsg:json[@"message"]];
        }
        HIDE_HUD
    } failure:^(NSError *error) {
        HIDE_HUD
        [JHShowAlert showAlertWithMsg:NSLocalizedString(@"服务器繁忙,请稍后访问", nil)];
        NSLog(@"%@",error.localizedDescription);
    }];
}
#pragma mark - 初始化一些数据的方法
-(void)initData{
    self.navigationItem.title = NSLocalizedString(@"资金明细", nil);
    
}
#pragma mark - 这是创建表格的方法
-(void)creatUITableView{
    myTableView = [[UITableView alloc]initWithFrame:FRAME(0, 0, WIDTH, HEIGHT - 64) style:UITableViewStylePlain];
    myTableView.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.tableFooterView = [UIView new];
    [myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [self.view addSubview:myTableView];
}
#pragma mark - 这是UITableView的代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        return 10;
    }else{
        return 50;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
        return cell;
    }else{
        static NSString * str = @"cell1";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = titleArray[indexPath.row];
        cell.textLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1];
        cell.detailTextLabel.text = detailArray[indexPath.row];
        if (indexPath.row == 0) {
            cell.detailTextLabel.textColor = [UIColor colorWithRed:248/255.0 green:168/255.0 blue:37/255.0 alpha:1];
        }else{
            cell.detailTextLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1];
        }
        UILabel * label = (UILabel *)[cell viewWithTag:100];
        [label removeFromSuperview];
        label = nil;
        if (label == nil) {
            label_line = [[UIView alloc]init];
            label_line.frame = FRAME(0, 49.5, WIDTH, 0.5);
            label_line.tag = 100;
            label_line.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
            [cell addSubview:label_line];
      }
      return cell;
    }
}
@end
