//
//  JHGroupListCompletionVC.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/28.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHGroupListCompletionVC.h"
#import "JHGroupOrderListOtherCell.h"
#import "JHGroupOrderListOtherModel.h"
#import <MJRefresh.h>
#import "JHGroupOrderDetailVC.h"
#import "DSToast.h"
#import "JHAllCell.h"
@implementation JHGroupListCompletionVC{
    UITableView * myTableView;
    MJRefreshNormalHeader * _header;
    MJRefreshAutoNormalFooter * _footer;
    NSArray * array;
    NSInteger num;
    NSMutableArray * infoArray;
    DSToast * toast;
    BOOL isYes;
    NSMutableDictionary *addCondition;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    //这是初始化一些数据的方法
    [self initData];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //这是发送请求的方法
    SHOW_HUD
    [infoArray removeAllObjects];
    [self postHttpWithPage:@"1"];
}
- (void)reloadTableViewCondition:(NSMutableDictionary *)condition{
    addCondition = condition.mutableCopy;
    [self postHttpWithPage:@(num).stringValue];
}

#pragma mark - 这是发送一个请求的方法
-(void)postHttpWithPage:(NSString *)page{
    [addCondition setObject:page forKey:@"page"];
    [addCondition setObject:@"1" forKey:@"status"];
    [HttpTool postWithAPI:@"biz/tuan/order/items" withParams:addCondition success:^(id json) {
        NSLog(@"%@",json);
        if ([json[@"error"] isEqualToString:@"0"]) {
            if (page.integerValue == 1) {
                [infoArray removeAllObjects];
            }
            NSArray * tempArray = json[@"data"][@"items"];
            for (NSDictionary * dic  in tempArray) {
                JHGroupOrderListOtherModel * model = [JHGroupOrderListOtherModel creatJHGroupOrderListOtherModelWithDictionary:dic];
                NSLog(@"%@",model.order_status);
                [infoArray addObject:model];
            }
            if (infoArray.count == 0) {
                isYes = NO;
            }else{
                isYes = YES;
            }
            //这是创建表格的方法
            [self creatUITabaleView];
            if (toast == nil && tempArray.count == 0 && [page integerValue] > 1) {
                toast = [[DSToast alloc]initWithText: NSLocalizedString(@"亲,没有更多数据了", NSStringFromClass([self class]))];
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
        [JHShowAlert showAlertWithMsg: NSLocalizedString(@"服务器繁忙,请稍后访问", NSStringFromClass([self class]))];
        NSLog(@"%@",error.localizedDescription);
    }];
}
#pragma mark - 这是初始化一些数据的方法
-(void)initData{
    infoArray = @[].mutableCopy;
    addCondition = @{}.mutableCopy;
    num = 1;
    self.view.backgroundColor = [UIColor whiteColor];
    //array = @[@"2",@"1",@"3",@"4",@"5",@"6"];
}
#pragma mark - 这是创建表格的方法
-(void)creatUITabaleView{
    if (myTableView == nil) {
        myTableView = [[UITableView alloc]initWithFrame:FRAME(0, 0, WIDTH, HEIGHT - 114) style:UITableViewStyleGrouped];
        myTableView.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
        myTableView.tableFooterView = [UIView new];
        myTableView.showsVerticalScrollIndicator = NO;
        myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        myTableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 0.01)];
        [myTableView registerClass:[JHGroupOrderListOtherCell class] forCellReuseIdentifier:@"cell"];
        [myTableView registerClass:[JHAllCell class] forCellReuseIdentifier:@"cell1"];
        myTableView.delegate = self;
        myTableView.dataSource = self;
        [self.view addSubview:myTableView];
        _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(downRefresh)];
        _header.lastUpdatedTimeLabel.hidden = YES;
        [_header setTitle: NSLocalizedString(@"下拉可以刷新", NSStringFromClass([self class])) forState:MJRefreshStateIdle];
        [_header setTitle: NSLocalizedString(@"现在可以刷新啦", NSStringFromClass([self class])) forState:MJRefreshStatePulling];
        [_header setTitle: NSLocalizedString(@"正在为您努力刷新中", NSStringFromClass([self class])) forState:MJRefreshStateRefreshing];
        myTableView.mj_header = _header;
        _footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
        [_footer setTitle: NSLocalizedString(@"正在加载更多的数据...", NSStringFromClass([self class])) forState:MJRefreshStateRefreshing];
        [_footer setTitle:@"" forState:MJRefreshStateIdle];
        myTableView.mj_footer = _footer;
    }else{
        [myTableView reloadData];
    }
}
#pragma mark - 这是下拉刷新的方法
-(void)downRefresh{
    num = 1;
    
    [self postHttpWithPage:@(num).stringValue];
}
#pragma mark - 这是上拉加载的方法
-(void)loadData{
    num ++;
    [self postHttpWithPage:@(num).stringValue];}
#pragma mark - 这是表视图的代理和数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (isYes) {
        //return 6;
        return infoArray.count;
    }else{
        return 1;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (isYes && infoArray.count > 0) {
        JHGroupOrderListOtherModel * model = infoArray[indexPath.section];
        //JHGroupOrderListOtherModel * m = infoArray[0];
        //NSLog(@"%ld+++++%@++++%@",indexPath.section,model.order_status_label,m.order_status_label);
        if ([model.order_status_label isEqualToString: NSLocalizedString(@"待回复", NSStringFromClass([self class]))] || [model.order_status_label isEqualToString: NSLocalizedString(@"已消费", NSStringFromClass([self class]))]) {
            return 150;
        }else{
            return 110;
        }
    }else{
        return HEIGHT - 64;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (isYes) {
        JHGroupOrderListOtherCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.indexPath = indexPath;
        if (infoArray.count != 0) {
            JHGroupOrderListOtherModel * model = infoArray[indexPath.section];
            cell.model = model;
        }
        return cell;
    }else{
        JHAllCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld",indexPath.section);
    if (isYes) {
        if (infoArray.count != 0) {
            JHGroupOrderListOtherModel * model = infoArray[indexPath.section];
            JHGroupOrderDetailVC * vc = [[JHGroupOrderDetailVC alloc]init];
            vc.type = model.type;
            vc.order_id = model.order_id;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
@end
