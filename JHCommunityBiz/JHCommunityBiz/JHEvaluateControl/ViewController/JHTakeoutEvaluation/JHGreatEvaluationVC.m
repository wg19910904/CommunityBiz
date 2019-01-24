//
//  JHGreatEvaluationVC.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/13.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHGreatEvaluationVC.h"
#import "JHEvaluteModel.h"
#import "JHEvaluteCell.h"
#import <MJRefresh.h>
#import "JHReplyVC.h"
#import "JHEvaluateNoneCell.h"
#import "DSToast.h"
@interface JHGreatEvaluationVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * myTableView;
    NSMutableArray * evaluateStr_array;//评论的模拟数组
    NSMutableArray * replyStr_array;//回复的模拟数组
    float height_evaluate;//评价的内容的高度
    float height_reply;//回复的内容的高度
    MJRefreshNormalHeader * _header;//这是下拉刷新的
    MJRefreshAutoNormalFooter * _footer;//这是上拉加载的
    //下面的bool变量都是用来模拟数据时使用的
    BOOL isPhoto;//是否有照片
    BOOL isReply;//是否已经回复
    BOOL isYes;//模拟数据的
    NSInteger num;
    NSMutableArray * infoArray;
    DSToast * toast;
}

@end

@implementation JHGreatEvaluationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化一些数据
    [self initData];
    //添加表视图
    [self creatUITableView];
    //发送请求
    SHOW_HUD
    [self postHttpWithPage:@"1"];
}
#pragma mark - 这是发送请求的方法
-(void)postHttpWithPage:(NSString *)page{
    [HttpTool postWithAPI:@"biz/waimai/comment/comment/items" withParams:@{@"page":page,@"type":@"1"} success:^(id json) {
        NSLog(@"%@",json);
        if ([json[@"error"] isEqualToString:@"0"]) {
            if (page.integerValue == 1) {
                [infoArray removeAllObjects];
            }
            NSArray * tempArray = json[@"data"][@"items"];
            for (NSDictionary * dic in tempArray) {
                JHEvaluteModel * model = [JHEvaluteModel creatJHEvaluteModelWithDictionary:dic];
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

#pragma mark - 这是初始化一些数据的方法
-(void)initData{
    num = 1;
    infoArray = @[].mutableCopy;
    
}
#pragma mark - 这是创建表格的方法
-(void)creatUITableView{
    myTableView = [[UITableView alloc]initWithFrame:FRAME(0, 0, WIDTH, HEIGHT - 140 - 64) style:UITableViewStylePlain];
    myTableView.tableFooterView = [UIView new];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [myTableView registerClass:[JHEvaluteCell class] forCellReuseIdentifier:@"cell"];
    [myTableView registerClass:[JHEvaluateNoneCell class] forCellReuseIdentifier:@"cell1"];
    myTableView.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
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
    myTableView.delegate = self;
    myTableView.dataSource = self;
    
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

#pragma mark - 这是表的代理和数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (isYes) {
        return 1;
    }else{
        return infoArray.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (isYes) {
        return HEIGHT - 140 - 64;
    }else{
        if (infoArray.count > 0) {
             return [JHEvaluteCell getHeightWithModel:infoArray[indexPath.row]];
        }else{
            return 0;
        }
       
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (isYes) {
        JHEvaluateNoneCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        JHEvaluteCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.indexPath = indexPath;
        JHEvaluteModel * model = infoArray[indexPath.row];
        cell.model = model;
        cell.btn_reply.tag = indexPath.row;
        [cell.btn_reply addTarget:self action:@selector(clickToReply:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}
#pragma mark - 这是点击进入回复界面的方法
-(void)clickToReply:(UIButton *)sender{
    NSLog(@"点击了进入回复界面");
    JHReplyVC * vc = [[JHReplyVC alloc]init];
    JHEvaluteModel * model = infoArray[sender.tag];
    vc.comment_id = model.comment_id;
    [vc setMyBlock:^(void){
        [self downRefresh];
    }];
    [self.navigationController pushViewController:vc animated:YES];}
@end
