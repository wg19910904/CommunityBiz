//
//  JHNewCapitalVC.m
//  JHCommunityBiz
//
//  Created by ijianghu on 2017/11/29.
//  Copyright © 2017年 com.jianghu. All rights reserved.
//

#import "JHNewCapitalVC.h"
#import "JHNewCapitalHeaderCell.h"
#import "JHNewCapitalListCell.h"
#import "UITableView+XHTool.h"
#import "JHCapitalModel.h"
#import "JHWebVC.h"
@interface JHNewCapitalVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSString  *count;
    NSString *money;
    NSString *tixian_url;
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *infoArray;
@end

@implementation JHNewCapitalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _infoArray = @[].mutableCopy;
    [self creatRightNavBtn];
    [self tableView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getData];
}
-(void)creatRightNavBtn{
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle: NSLocalizedString(@"资金明细", NSStringFromClass([self class])) style:UIBarButtonItemStylePlain target:self action:@selector(clickRightItem)];
    self.navigationItem.rightBarButtonItem = item;
    
}
-(void)getData{
    SHOW_HUD
    [HttpTool postWithAPI:@"biz/shop/money/log" withParams:@{@"today":@"1"} success:^(id json) {
        NSLog(@"%@",json);
        if ([json[@"error"] isEqualToString:@"0"]) {
            [_infoArray removeAllObjects];
            tixian_url = json[@"data"][@"tixian_url"];
            count = json[@"data"][@"total_count"];
            money = json[@"data"][@"money"];
            NSArray * tempArray = json[@"data"][@"items"];
            for (NSDictionary * dic in tempArray) {
                JHCapitalModel * model = [JHCapitalModel showJHCapitalModelWithDictionary:dic];
                [_infoArray addObject:model];
            }
            [_tableView reloadData];
        }else{
            [JHShowAlert showAlertWithMsg:json[@"message"]];
        }
        HIDE_HUD
        [_tableView.mj_header endRefreshing];
        //[_footer endRefreshing];
    } failure:^(NSError *error) {
        HIDE_HUD
        [_tableView.mj_header endRefreshing];
        //[_footer endRefreshing];
        [JHShowAlert showAlertWithMsg: NSLocalizedString(@"服务器繁忙,请稍后访问", NSStringFromClass([self class]))];
        NSLog(@"%@",error.localizedDescription);
    }];
}
-(void)clickRightItem{
    NSLog(@"资金明细");
    Class class = NSClassFromString(@"JHNewCapitalDetailVC");
    JHBaseVC *vc = [class new];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 这是创建表视图的方法
-(UITableView * )tableView{
    if(_tableView == nil){
        _tableView = ({
            UITableView * table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64-49) style:UITableViewStyleGrouped];
            table.delegate = self;
            table.dataSource = self;
            table.tableFooterView = [UIView new];
            table.showsVerticalScrollIndicator = NO;
            table.backgroundColor = [UIColor whiteColor];
            table.separatorStyle = UITableViewCellSeparatorStyleNone;
            [self.view addSubview:table];
            [table downToRefreshWithBlock:^{
                [self getData];
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
    return indexPath.section == 0? 200 : 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return 0.01;
    }
    return 34;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return nil;
    }
    UILabel *lab = [[UILabel alloc]init];
    lab.backgroundColor = [UIColor whiteColor];
    lab.textColor = HEX(@"999999", 1);
    lab.text = [NSString stringWithFormat: NSLocalizedString(@"近%@笔资金明细", NSStringFromClass([self class])),count?count:@"0"];
    lab.font = FONT(14);
    lab.textAlignment = NSTextAlignmentCenter;
    return lab;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString *str = @"JHNewCapitalHeaderCell";
        JHNewCapitalHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (!cell) {
            cell = [[JHNewCapitalHeaderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        }
        cell.money = money;
        [cell setClickBlock:^{
            NSLog(@"点击了提现的按钮");
            JHWebVC *vc = [[JHWebVC alloc]init];
            vc.urlStr = tixian_url;
            [self.navigationController pushViewController:vc animated:YES];
        }];
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
@end
