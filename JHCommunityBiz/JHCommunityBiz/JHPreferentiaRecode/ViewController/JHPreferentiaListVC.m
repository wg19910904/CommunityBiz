//
//  JHPreferentiaListVC.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/26.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHPreferentiaListVC.h"
#import "JHPreferentiaListCell.h"
#import "JHAllCell.h"
#import "JHPreferentiaListModel.h"
#import <MJRefresh.h>
#import "DSToast.h"
#import "JHGlobalSearchVC.h"
@implementation JHPreferentiaListVC{
    UITableView * myTableView;//表视图
    MJRefreshNormalHeader * _header;//下拉刷新
    MJRefreshAutoNormalFooter * _footer;//上拉加载
    //模拟用的
    BOOL isYes;
    //模拟用的
    NSArray * array;
    NSInteger num;
    NSMutableArray * infoArray;//存放model类的数组
    DSToast * toast;
    NSMutableDictionary *addCondition;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    //初始化一些数据的方法
    [self initData];
    //这是创建表格的方法
    [self creatUITableView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //请求数据
    SHOW_HUD
    num = 1;
    [infoArray removeAllObjects];
    [self postHttpWithPage:@(num).stringValue];
}
-(void)postHttpWithPage:(NSString *)page{
    [addCondition setObject:page forKey:@"page"];
    [HttpTool postWithAPI:@"biz/shop/shop/maidan_log" withParams:addCondition success:^(id json) {
        NSLog(@"%@",json);
        if ([json[@"error"] isEqualToString:@"0"]) {
            if (page.integerValue == 1) {
                [infoArray removeAllObjects];
            }
            NSArray * tempArray = json[@"data"][@"items"];
            for (NSDictionary * dic in tempArray) {
                JHPreferentiaListModel * model = [JHPreferentiaListModel creatJHPreferentiaListModelWithDictionary:dic];
                [infoArray addObject:model];
          }
            if (infoArray.count == 0) {
                isYes = YES;
            }else{
                isYes = NO;
            }

            [myTableView reloadData];
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
    num = 1;
    infoArray = @[].mutableCopy;
    addCondition = @{}.mutableCopy;
    self.navigationItem.title =  NSLocalizedString(@"优惠买单记录", NSStringFromClass([self class]));
    self.view.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(0, 0, 20, 20)];
    [rightBtn addTarget:self action:@selector(clickRightBnt)
       forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"btn_shaixuan"] forState:UIControlStateNormal];
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
}
#pragma mark==导航栏右侧按钮=====
- (void)clickRightBnt{
    __weak typeof(self)weakself = self;
    JHGlobalSearchVC *vc = [[JHGlobalSearchVC alloc]init];
    vc.searchType =  ESearch_maidan;
    vc.cacheDic = addCondition;
    vc.searchImgStr = @"btn_search";
    vc.choseTimeArrow = @"btn_arrow_r";
    vc.tintColor = HEX(@"ff9900", 1);
    [vc setClickBlock:^(NSMutableDictionary *dic) {
        //循环添加新增的筛选字段,刷新界面
        NSArray *keys = [dic allKeys];
        for (NSString *key in keys) {
            [addCondition setObject:dic[key] forKey:key];
        }
        [weakself postHttpWithPage:@(num).stringValue];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 这是创建表格的方法
-(void)creatUITableView{
    myTableView = [[UITableView alloc]initWithFrame:FRAME(0, 10, WIDTH, HEIGHT - 74) style:UITableViewStylePlain];
    myTableView.tableFooterView = [UIView new];
    myTableView.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:myTableView];
    [myTableView registerClass:[JHPreferentiaListCell class] forCellReuseIdentifier:@"cell"];
    [myTableView registerClass:[JHAllCell class] forCellReuseIdentifier:@"cell1"];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(downRfresh)];
    _header.lastUpdatedTimeLabel.hidden = YES;
    [_header setTitle: NSLocalizedString(@"下拉可以刷新", NSStringFromClass([self class])) forState:MJRefreshStateIdle];
    [_header setTitle: NSLocalizedString(@"现在可以刷新啦", NSStringFromClass([self class])) forState:MJRefreshStatePulling];
    [_header setTitle: NSLocalizedString(@"正在为您努力刷新中", NSStringFromClass([self class])) forState:MJRefreshStateRefreshing];
    myTableView.mj_header = _header;
    _footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    [_footer setTitle:@"" forState:MJRefreshStateIdle];
    [_footer setTitle: NSLocalizedString(@"正在加载更多的数据...", NSStringFromClass([self class])) forState:MJRefreshStateRefreshing];
    myTableView.mj_footer = _footer;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!isYes) {
         return infoArray.count;
    }else{
        return 1;
    }
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (!isYes) {
        JHPreferentiaListModel * model = infoArray[indexPath.row];
        if ([model.reply isEqualToString:@"0"]&&[model.comment isEqualToString:@"1"]) {
            return 210;
        }else {
            return 170;
        }

    }else{
            return HEIGHT - 74;
    }
}
-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!isYes) {
        JHPreferentiaListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        if (infoArray.count > 0) {
            JHPreferentiaListModel * model = infoArray[indexPath.row];
            cell.indexPath = indexPath;
            cell.vc = self;
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
    if (!isYes) {
        JHPreferentiaListModel * model = infoArray[indexPath.row];
        JHPreferentiaDetailVC * vc = [[JHPreferentiaDetailVC alloc]init];
        vc.order_id = model.order_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - 这是下拉刷新的方法
-(void)downRfresh{
    num = 1;
   
    [self postHttpWithPage:@(num).stringValue];
}
#pragma mark - 这是上拉加载数据的
-(void)loadData{
    num++;
    [self postHttpWithPage:@(num).stringValue];
}
@end
