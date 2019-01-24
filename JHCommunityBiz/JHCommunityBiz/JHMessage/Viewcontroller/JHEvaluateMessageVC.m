//
//  JHEvaluateMessageVC.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/10.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHEvaluateMessageVC.h"
#import "JHMessageCell.h"
#import "JHMessageModel.h"
#import "JHMessageNoneCell.h"
#import <MJRefresh.h>
#import "DSToast.h"
@interface JHEvaluateMessageVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * mytableView;//表格的对象
    BOOL isData;//判断是否有数据的
    MJRefreshNormalHeader * _header;//下拉刷新的
    MJRefreshAutoNormalFooter * _footer;//上拉加载
     NSInteger num;
    DSToast * toast;
}

@end

@implementation JHEvaluateMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化数据的
    [self initData];
    //创建表格
    [self creatUITableView];
    //这是请求数据的方法
    SHOW_HUD
    [self postHttpWithPage:@"1" withType:@"2"];
}
#pragma mark - 这是请求各个数据的总数的方法
-(void)postHttpWithPage:(NSString *)newPage withType:(NSString *)newType{
    [HttpTool postWithAPI:@"biz/shop/msg/items" withParams:@{@"page":newPage,@"type":newType} success:^(id json) {
        NSLog(@"%@",json);
        if ([json[@"error"] isEqualToString:@"0"]) {
            if (newPage.integerValue == 1) {
                [self.infoArray removeAllObjects];
            }

            NSArray * tempArray = json[@"data"][@"items"];
            for (NSDictionary * dic in tempArray) {
                JHMessageModel * model = [JHMessageModel shareJHMessageModelWithDictionary:dic];
                [self.infoArray addObject:model];
            }
            if (self.infoArray.count > 0) {
                isData  = YES;
            }else{
                isData = NO;
            }
            [mytableView reloadData];
            if (toast == nil && tempArray.count == 0 && [newPage integerValue] > 1) {
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
#pragma mark - 这是初始化一些数据的
-(void)initData{
    isData = YES;
    num = 1;
    self.infoArray = @[].mutableCopy;
}
#pragma mark - 创建表视图
-(void)creatUITableView{
    mytableView = [[UITableView alloc]init];
    mytableView.frame = FRAME(0, 0, WIDTH, HEIGHT - 64 - 85);
    [self.view addSubview:mytableView];
    mytableView.showsVerticalScrollIndicator = NO;
    mytableView.tableFooterView = [UIView new];
    mytableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mytableView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    [mytableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [mytableView registerClass:[JHMessageCell class] forCellReuseIdentifier:@"cell1"];
    [mytableView registerClass:[JHMessageNoneCell class] forCellReuseIdentifier:@"cell0"];
    _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(downRefresh)];
    _header.stateLabel.textColor = [UIColor colorWithRed:129/255.0 green:129/255.0 blue:129/255.0 alpha:1];
    _header.lastUpdatedTimeLabel.hidden = YES;
    [_header setTitle:NSLocalizedString(@"下拉可以刷新", nil) forState:MJRefreshStateIdle];
    [_header setTitle:NSLocalizedString(@"现在可以刷新啦", nil) forState:MJRefreshStatePulling];
    [_header setTitle:NSLocalizedString(@"正在为您努力刷新中", nil) forState:MJRefreshStateRefreshing];
    mytableView.mj_header = _header;
    _footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(upLoadData)];
    [_footer setTitle:@"" forState:MJRefreshStateIdle];
    [_footer setTitle:NSLocalizedString(@"正在加载更多的数据...", nil) forState:MJRefreshStateRefreshing];
    mytableView.mj_footer = _footer;
    mytableView.delegate = self;
    mytableView.dataSource = self;
}
#pragma mark - 这是下拉刷新的方法
-(void)downRefresh{
    num = 1;
    
    [self postHttpWithPage:@(num).description withType:@"2"];

}
#pragma mark - 这是上拉加载的方法
-(void)upLoadData{
    num ++;
    [self postHttpWithPage:@(num).description withType:@"2"];

}
#pragma mark - 这是表的代理方法和数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (isData) {
         return self.infoArray.count + 1;
    }else{
        return 1;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0&&!isData) {
        return HEIGHT - 64 - 85;
    }else if(indexPath.row == 0 && isData){
        return 15;
    }
    else{
        return 90;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0&&!isData) {
        JHMessageNoneCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell0" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.row == 0&&isData) {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        JHMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        JHMessageModel * model = nil;
        if (self.infoArray.count > 0) {
            model  = self.infoArray[indexPath.row - 1];
        }
        cell.model = model;
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!isData) {
        return;
    }
    if (!isData) {
        return;
    }
    if (indexPath.row > 0) {
        JHMessageModel * model = self.infoArray[indexPath.row - 1];
        [HttpTool postWithAPI:@"biz/shop/msg/read" withParams:@{@"msg_id":model.msg_id} success:^(id json) {
            if ([json[@"error"]isEqualToString:@"0"]) {
                JHMessageCell * cell = [mytableView cellForRowAtIndexPath:indexPath];
                cell.label_point.hidden = YES;
                cell.label_message.textColor = [UIColor colorWithWhite:0.4 alpha:1];
                if (self.myBlock) {
                    self.myBlock();
                }
                model.is_read = @"1";
                [self.infoArray replaceObjectAtIndex:indexPath.row - 1 withObject:model];
            }else{
                [JHShowAlert showAlertWithMsg:json[@"message"]];
            }
        } failure:^(NSError *error) {
            [JHShowAlert showAlertWithMsg:NSLocalizedString(@"服务器繁忙,请稍后访问", nil)];
            NSLog(@"%@",error.localizedDescription);
        }];
    }
}

@end
