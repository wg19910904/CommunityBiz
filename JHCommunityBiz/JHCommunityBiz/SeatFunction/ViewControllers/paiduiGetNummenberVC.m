//
//  paiduiGetNummenberVC.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/9/30.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "paiduiGetNummenberVC.h"
#import "PaiduiCell.h"
#import "PaiduiModel.h"
#import <MJRefresh.h>
#import "MakeOrderVC.h"
@interface paiduiGetNummenberVC ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray * modelArray;
    MJRefreshAutoNormalFooter * _footer;
    MJRefreshNormalHeader * _header;
    NSInteger _page;
}
@property(nonatomic,retain)UILabel *label_title;//显示提示的
@property(nonatomic,retain)UITableView *myTableView;
@end

@implementation paiduiGetNummenberVC
- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化一些数据的方法
    [self initData];
    //添加头部的提示
    [self.view addSubview:self.label_title];
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
#pragma mark - 创建头部提示的label
-(UILabel *)label_title{
    if (!_label_title) {
        _label_title = [[UILabel alloc]init];
        _label_title.frame = FRAME(0,10, WIDTH, 30);
        _label_title.text = NSLocalizedString(@"仅显示最近两天的排队号单", NSStringFromClass([self class]));
        _label_title.textColor = HEX(@"f5a623", 1.0);
        _label_title.textAlignment = NSTextAlignmentCenter;
        _label_title.font = FONT(14);
        _label_title.backgroundColor = HEX(@"fff5e5", 1.0);
    }
    return _label_title;
}
#pragma mark - 这是创建表视图的方法
-(UITableView * )myTableView{
    if(_myTableView == nil){
        _myTableView = ({
            UITableView * table = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, WIDTH, HEIGHT - 64 - 50) style:UITableViewStyleGrouped];
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
    PaiduiModel * model = modelArray[indexPath.section];
    if (model.status == 0 || model.status == 1) {
        return 145;
    }else if(model.status == -1){
        return 125;
    }
    else{
       return 105;
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
    static NSString * cell_str = @"cell_paidui";
    PaiduiCell * cell = [tableView dequeueReusableCellWithIdentifier:cell_str];
    if (!cell) {
        cell = [[PaiduiCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_str];
    }
    cell.indexPath = indexPath;
    cell.model= modelArray[indexPath.section];
    [cell setMyBlock:^(UIButton *sender) {
        PaiduiModel * model = modelArray[sender.tag];
        if ([sender.titleLabel.text isEqualToString: NSLocalizedString(@"确认接单", NSStringFromClass([self class]))]) {
            MakeOrderVC * vc = [[MakeOrderVC alloc]init];
            vc.isPaidui = YES;
            vc.paidui_id = model.paidui_id;
            [vc setMyBlcok:^{
                [self downRefresh];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if ([sender.titleLabel.text isEqualToString: NSLocalizedString(@"拒绝接单", NSStringFromClass([self class]))]){
            [self postCancelHttpWithPaiDuiId:model.paidui_id];
        }else if([sender.titleLabel.text isEqualToString: NSLocalizedString(@"确认就餐", NSStringFromClass([self class]))]){
            [self postSureEatHttpWithPaiduiID:model];
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
    [HttpTool postWithAPI:@"biz/yuyue/paidui/items" withParams:@{@"page":@(page).stringValue} success:^(id json) {
        NSLog(@"json:%@",json);
        HIDE_HUD
        if ([json[@"error"] isEqualToString:@"0"]) {
            if (page == 1) {
                [modelArray removeAllObjects];
            }
            NSArray * tempArray = json[@"data"][@"items"];
            for (NSDictionary * dic in tempArray) {
                PaiduiModel * model = [PaiduiModel sharePaiduiModelWithDic:dic];
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
        [JHShowAlert showAlertWithMsg: NSLocalizedString(@"网络连接出错,请检查网络", NSStringFromClass([self class]))];
        NSLog(@"error:%@",error.localizedDescription);
    }];
}
#pragma mark - 这是点击拒绝接单的请求方法
-(void)postCancelHttpWithPaiDuiId:(NSString *)paiduiID{
    SHOW_HUD
    [HttpTool postWithAPI:@"biz/yuyue/paidui/cancel" withParams:@{@"paidui_id":paiduiID} success:^(id json) {
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
#pragma mark - 这是点击确认就餐的方法
-(void)postSureEatHttpWithPaiduiID:(PaiduiModel *)model{
    SHOW_HUD
    [HttpTool postWithAPI:@"biz/yuyue/paidui/complate" withParams:@{@"paidui_id":model.paidui_id,@"zhuohao_id":model.zhuohao_id} success:^(id json) {
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
