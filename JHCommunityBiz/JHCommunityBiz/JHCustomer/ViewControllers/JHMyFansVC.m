//
//  JHMyFansVC.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/17.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHMyFansVC.h"
#import "JHMyFansModel.h"
#import "JHMyFansCellOne.h"
#import "JHMyFansCellTwo.h"
#import "JHCustomerCellNone.h"
#import <MJRefresh.h>
#import "JHCustomerVC.h"
#import "DSToast.h"
@interface JHMyFansVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * myTableView;//表视图
    MJRefreshNormalHeader * _header;//这是下拉刷新的
    MJRefreshAutoNormalFooter * _footer;//这是上拉加载的
    BOOL isYes;//模拟用的
    NSInteger num;
    NSMutableArray * infoArray;//存放我的粉丝的
    DSToast * toast;
    NSString * total_count;//本店的粉丝总数
}
@end

@implementation JHMyFansVC
- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化一些数据的方法
    [self initData];
    //创建表视图
    [self creatUITableView];
    //发送请求
    SHOW_HUD
    [self postHttpWithPage:@(num).stringValue];
}
#pragma mark - 这是发送请求的方法
-(void)postHttpWithPage:(NSString *)page{
    [HttpTool postWithAPI:@"biz/member/fans" withParams:@{@"page":page} success:^(id json) {
        NSLog(@"%@",json);
        if ([json[@"error"] isEqualToString:@"0"]) {
            if (page.integerValue == 1) {
                [infoArray removeAllObjects];
            }
            total_count = json[@"data"][@"total_count"];
            NSArray * tempArray = nil;
            if ([json[@"data"][@"items"] isKindOfClass:[NSString class]]) {
                tempArray = @[];
            }else{
                tempArray = json[@"data"][@"items"];
            }
            for (NSDictionary * dic  in tempArray) {
                JHMyFansModel * model = [JHMyFansModel showJHMyFansModelWithDictionary:dic];
                [infoArray addObject:model];
            }
            if (infoArray.count == 0) {
                isYes = YES;
            }else{
                isYes = NO;
            }
            [myTableView reloadData];
            if (toast == nil && tempArray.count == 0 && [page integerValue] > 1) {
                toast = [[DSToast alloc]initWithText:NSLocalizedString(@"亲,没有更多数据了", nil)];
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
        [JHShowAlert showAlertWithMsg:NSLocalizedString(@"服务器繁忙,请稍后访问", nil)];
        NSLog(@"%@",error.localizedDescription);
    }];
}

#pragma mark - 这是初始化一些方法
-(void)initData{
    num = 1;
    infoArray = @[].mutableCopy;
}
#pragma mark - 这是创建表视图的方法
-(void)creatUITableView{
    myTableView = [[UITableView alloc]initWithFrame:FRAME(0, 0, WIDTH, HEIGHT - 104) style:UITableViewStylePlain];
    myTableView.tableFooterView = [UIView new];
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [myTableView registerClass:[JHMyFansCellOne class] forCellReuseIdentifier:@"cell"];
    [myTableView registerClass:[JHMyFansCellTwo class] forCellReuseIdentifier:@"cell1"];
     [myTableView registerClass:[JHCustomerCellNone class] forCellReuseIdentifier:@"cell2"];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [self.view addSubview:myTableView];
    _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(downRefresh)];
    _header.stateLabel.textColor = [UIColor colorWithRed:129/255.0 green:129/255.0 blue:129/255.0 alpha:1];
    _header.lastUpdatedTimeLabel.hidden = YES;
    [_header setTitle:NSLocalizedString(@"下拉可以刷新", nil) forState:MJRefreshStateIdle];
    [_header setTitle:NSLocalizedString(@"现在可以刷新啦", nil) forState:MJRefreshStatePulling];
    [_header setTitle:NSLocalizedString(@"正在为您努力刷新中", nil) forState:MJRefreshStateRefreshing];
    myTableView.mj_header = _header;
    _footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(upLoadData)];
    [_footer setTitle:@"" forState:MJRefreshStateIdle];
    [_footer setTitle:NSLocalizedString(@"正在加载更多的数据...", nil) forState:MJRefreshStateRefreshing];
    myTableView.mj_footer = _footer;
}
#pragma mark - 这是下拉刷新的方法
-(void)downRefresh{
    num = 1;
    
    [self postHttpWithPage:@(num).stringValue];
}
#pragma mark - 这是上拉加载的方法
-(void)upLoadData{
    num ++;
    [self postHttpWithPage:@(num).stringValue];
}
#pragma mark - 这是表视图的代理和数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!isYes) {
        return infoArray.count + 1;
        
    }else{
        return 1;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!isYes) {
        if (indexPath.row == 0) {
            return 40;
        }else{
            return 60;
        }
    }else{
        return HEIGHT - 104;
    }
    
}
-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(!isYes){
        if (indexPath.row == 0) {
            JHMyFansCellOne * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            cell.num = [total_count integerValue];
            return cell;
        }else{
            
            JHMyFansCellTwo * cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
            JHMyFansModel * model = infoArray[indexPath.row - 1];
            cell.model = model;
            return cell;
        }
    }else{
        
        JHCustomerCellNone * cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
        cell.str = NSLocalizedString(@"暂无粉丝", nil);
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        cell.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row != 0) {
        JHMyFansModel * model = infoArray[indexPath.row - 1];
        [myTableView deselectRowAtIndexPath:indexPath animated:YES];
        JHCustomerVC * vc = [[JHCustomerVC alloc]init];
        vc.uid = model.uid;
        vc.isFans = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
