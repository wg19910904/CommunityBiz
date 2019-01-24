//
//  JHGroupChitRecordVC.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/25.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHGroupChitRecordVC.h"
#import "JHGroupChitRecordCell.h"
#import "JHGroupChitRecordModel.h"
#import <MJRefresh.h>
#import "JHGroupScanControl.h"
#import "JHAllCell.h"
#import "DSToast.h"
#import "JHTrueToConsumeVC.h"
@implementation JHGroupChitRecordVC{
    UITableView * myTableView;//这是创建的表视图
    MJRefreshNormalHeader * _header;//下拉刷新的
    MJRefreshAutoNormalFooter * _footer;//上拉加载的
    //模拟用的
    BOOL isYes;//是否有数据
    NSInteger num;
    NSMutableArray * infoArray;
    DSToast * toast;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    //初始化一些数据的方法
    [self initData];
    //添加表格
    [self creatUITableView];
    //发送请求
    SHOW_HUD
    [self postHttpWithPage:@"1"];
}
#pragma mark - 这是发送请求的方法
-(void)postHttpWithPage:(NSString *)page{
    [HttpTool postWithAPI:@"biz/shop/shop/tuan_log" withParams:@{@"page":page} success:^(id json) {
        NSLog(@"%@",json);
        HIDE_HUD
        if ([json[@"error"] isEqualToString:@"0"]) {
            if (page.integerValue == 1) {
                [infoArray removeAllObjects];
            }
            NSArray * tempArray = json[@"data"][@"items"];
            for (NSDictionary * dic in tempArray) {
                JHGroupChitRecordModel * model = [JHGroupChitRecordModel creatJHGroupChitRecordModelWithDictionary:dic];
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
    self.navigationItem.title =  NSLocalizedString(@"团购代金券记录", NSStringFromClass([self class]));
    UIButton * btn  = [[UIButton alloc]init];
    btn.frame = FRAME(0, 0, 60, 30);
    btn.layer.cornerRadius = 3;
    btn.layer.masksToBounds = YES;
    btn.layer.borderWidth = 1;
    [btn setTitle: NSLocalizedString(@"核销", NSStringFromClass([self class])) forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithRed:250/255.0 green:175/255.0 blue:25/255.0 alpha:1] forState:UIControlStateNormal];
    btn.layer.borderColor = [UIColor colorWithRed:250/255.0 green:175/255.0 blue:25/255.0 alpha:1].CGColor;
    [btn addTarget:self action:@selector(clickToVerification) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = item;
}
#pragma mark - 这是点击核销的方法
-(void)clickToVerification{
    NSLog(@"点击了核销");
//    if (isYes) {
//        [JHShowAlert showAlertWithMsg:NSLocalizedString(@"暂时没有可核销数据", nil)];
//        return;
//    }
    [JHGroupScanControl showJHGroupScanControlWithNav:self.navigationController withBlock:^(NSDictionary *dic) {
        //点击的确定并且在密码正确的情况下才会调用
        JHTrueToConsumeVC * vc = [[JHTrueToConsumeVC alloc]init];
        vc.dictionary = dic;
        [self.navigationController pushViewController:vc animated:YES];
    } withSweepBlock:^(NSDictionary *dic) {
        JHTrueToConsumeVC * vc = [[JHTrueToConsumeVC alloc]init];
        vc.dictionary = dic;
        [self.navigationController pushViewController:vc animated:YES];
    }];
}
#pragma mark - 这是创建表视图的方法
-(void)creatUITableView{
    myTableView = [[UITableView alloc]initWithFrame:FRAME(0, 0, WIDTH, HEIGHT - 64) style:UITableViewStylePlain];
    myTableView.tableFooterView = [UIView new];
    myTableView.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:myTableView];
    [myTableView registerClass:[JHGroupChitRecordCell class] forCellReuseIdentifier:@"cell"];
    [myTableView registerClass:[JHAllCell class] forCellReuseIdentifier:@"cell1"];
    _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(downRefresh)];
    _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(downRefresh)];
    _header.stateLabel.textColor = [UIColor colorWithRed:129/255.0 green:129/255.0 blue:129/255.0 alpha:1];
    _header.lastUpdatedTimeLabel.hidden = YES;
    [_header setTitle: NSLocalizedString(@"下拉可以刷新", NSStringFromClass([self class])) forState:MJRefreshStateIdle];
    [_header setTitle: NSLocalizedString(@"现在可以刷新啦", NSStringFromClass([self class])) forState:MJRefreshStatePulling];
    [_header setTitle: NSLocalizedString(@"正在为您努力刷新中", NSStringFromClass([self class])) forState:MJRefreshStateRefreshing];
    myTableView.mj_header = _header;
    _footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    [_footer setTitle:@"" forState:MJRefreshStateIdle];
    [_footer setTitle: NSLocalizedString(@"正在加载更多的数据...", NSStringFromClass([self class])) forState:MJRefreshStateRefreshing];
    myTableView.mj_footer = _footer;
    myTableView.delegate = self;
    myTableView.dataSource = self;
}
#pragma mark - 这是表的代理和数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!isYes) {
        return infoArray.count;
    }else{
       return 1;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!isYes) {
        return 100;
    }else{
        return HEIGHT - 64;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!isYes&&infoArray.count != 0) {
        JHGroupChitRecordCell  * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        JHGroupChitRecordModel * model = infoArray[indexPath.row];
        cell.model = model;
        return cell;
    }else{
        JHAllCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
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
    [self postHttpWithPage:@(num).stringValue];
}
@end
