//
//  AddSeatVC.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/9/30.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "AddSeatVC.h"
#import "AddSeatCell.h"
#import "AddSeatModel.h"
#import <MJRefresh.h>
#import "MakeOrderVC.h"
@interface AddSeatVC ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray * modelArray;
    MJRefreshAutoNormalFooter * _footer;
    MJRefreshNormalHeader * _header;
    NSInteger _page;
}
@property(nonatomic,retain)UITableView *myTableView;

@end

@implementation AddSeatVC
- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化一些数据的方法
    [self initData];
    SHOW_HUD
    [self postHttpWithPage:_page];
    //添加表视图
    [self.view addSubview:self.myTableView];
}
#pragma mark - 这是初始化一些数据的方法
-(void)initData{
    self.view.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
    modelArray = @[].mutableCopy;
    _page = 1;
}
#pragma mark - 这是创建表视图的方法
-(UITableView * )myTableView{
    if(_myTableView == nil){
        _myTableView = ({
            UITableView * table = [[UITableView alloc]initWithFrame:CGRectMake(0, 10, WIDTH, HEIGHT - 64 - 10) style:UITableViewStyleGrouped];
            table.delegate = self;
            table.dataSource = self;
            table.tableFooterView = [UIView new];
            table.showsVerticalScrollIndicator = NO;
            table.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
            _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(downRefresh)];
            _header.stateLabel.textColor = [UIColor colorWithRed:129/255.0 green:129/255.0 blue:129/255.0 alpha:1];
            _header.lastUpdatedTimeLabel.hidden = YES;
            [_header setTitle: NSLocalizedString(@"下拉可以刷新", NSStringFromClass([self class])) forState:MJRefreshStateIdle];
            [_header setTitle: NSLocalizedString(@"现在可以刷新啦", NSStringFromClass([self class])) forState:MJRefreshStatePulling];
            [_header setTitle: NSLocalizedString(@"正在为您努力刷新中", NSStringFromClass([self class])) forState:MJRefreshStateRefreshing];
            table.mj_header = _header;
            _footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(upLoadData)];
            [_footer setTitle:@"" forState:MJRefreshStateIdle];
            [_footer setTitle: NSLocalizedString(@"正在加载更多的数据...", NSStringFromClass([self class])) forState:MJRefreshStateRefreshing];
            table.mj_footer = _footer;
            table;
        });
    }
    return _myTableView;
}
#pragma mark 这是补齐UITableViewCell分割线
-(void)viewDidLayoutSubviews {
    if ([_myTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_myTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        [_myTableView setSeparatorColor:LINE_COLOR];
    }
    if ([_myTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_myTableView setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - 这是UITableView的代理和方法和数据方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return modelArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    AddSeatModel * model = modelArray[indexPath.section];
    if (model.status == 0 || model.status == 1) {
        return 145 + model.height + 10;
    }else if(model.status == -1){
        return 125 + model.height;
    }
    else{
        return 105 + model.height + 10;
    }
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView * view = [UIView new];
    view.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cell_str = @"cell_zhanzuo";
    AddSeatCell * cell = [tableView dequeueReusableCellWithIdentifier:cell_str];
    if (!cell) {
        cell = [[AddSeatCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_str];
    }
    cell.indexPath = indexPath;
    cell.model= modelArray[indexPath.section];
    [cell setMyBlock:^(UIButton * sender) {
        AddSeatModel * model = modelArray[sender.tag];
        if ([sender.titleLabel.text isEqualToString: NSLocalizedString(@"确认接单", NSStringFromClass([self class]))]) {
            MakeOrderVC * vc = [[MakeOrderVC alloc]init];
            vc.isPaidui = NO;
            vc.paidui_id = model.dingzuo_id;
            [vc setMyBlcok:^{
                [self downRefresh];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([sender.titleLabel.text isEqualToString: NSLocalizedString(@"拒绝接单", NSStringFromClass([self class]))]){
            [self postCancelHttpWithPaiDuiId:model.dingzuo_id];
        }else if ([sender.titleLabel.text isEqualToString: NSLocalizedString(@"确认到店", NSStringFromClass([self class]))]){
            [self postSureEatHttpWithDingzuoID:model];
        }
        
    }];

    return cell;
}
#pragma mark - 这是下拉刷新
-(void)downRefresh{
    _page = 1;
    [self postHttpWithPage:_page];
}
#pragma mark - 上拉加载
-(void)upLoadData{
    _page ++;
    [self postHttpWithPage:_page];
}
#pragma - mark 这是发送获取排队列表的请求
-(void)postHttpWithPage:(NSInteger)page{
    [HttpTool postWithAPI:@"biz/yuyue/dingzuo/items" withParams:@{@"page":@(page).stringValue} success:^(id json) {
        NSLog(@"json:%@",json);
        HIDE_HUD
        if ([json[@"error"] isEqualToString:@"0"]) {
            if (page == 1) {
                [modelArray removeAllObjects];
            }
            NSArray * tempArray = json[@"data"][@"items"];
            for (NSDictionary * dic in tempArray) {
                AddSeatModel * model = [AddSeatModel shareAddSeatModelWithDic:dic];
                [modelArray addObject:model];
            }

        }else{
            [JHShowAlert showAlertWithMsg:json[@"message"]];
        }
        [_myTableView reloadData];
        [_header endRefreshing];
        [_footer endRefreshing];
    } failure:^(NSError *error) {
        HIDE_HUD
        [_header endRefreshing];
        [_footer endRefreshing];
        NSLog(@"error:%@",error.localizedDescription);
    }];
}
#pragma mark - 这是点击拒绝接单的请求方法
-(void)postCancelHttpWithPaiDuiId:(NSString *)paiduiID{
    SHOW_HUD
    [HttpTool postWithAPI:@"biz/yuyue/dingzuo/cancel" withParams:@{@"dingzuo_id":paiduiID} success:^(id json) {
        HIDE_HUD
        NSLog(@"json:%@",json);
        if ([json[@"error"] isEqualToString:@"0"]) {
            [self downRefresh];
        }else{
            [JHShowAlert showAlertWithMsg:json[@"message"]];
        }
    } failure:^(NSError *error) {
        HIDE_HUD
        [JHShowAlert showAlertWithMsg: NSLocalizedString(@"网络连接出错,请检查网络", NSStringFromClass([self class]))];
        NSLog(@"error:%@",error.localizedDescription);
    }];
}
#pragma mark - 这是点击确认到店的方法
-(void)postSureEatHttpWithDingzuoID:(AddSeatModel *)model{
    SHOW_HUD
    [HttpTool postWithAPI:@"biz/yuyue/dingzuo/complate" withParams:@{@"dingzuo_id":model.dingzuo_id,@"zhuohao_id":model.zhuohao_id} success:^(id json) {
        HIDE_HUD
        if ([json[@"error"] isEqualToString:@"0"]) {
            [self downRefresh];
        }else{
            [JHShowAlert showAlertWithMsg:json[@"message"]];
        }
    } failure:^(NSError *error) {
        HIDE_HUD
        [JHShowAlert showAlertWithMsg: NSLocalizedString(@"网络连接出错,请检查网络", NSStringFromClass([self class]))];
        NSLog(@"error:%@",error.localizedDescription);
    }];
}
@end
