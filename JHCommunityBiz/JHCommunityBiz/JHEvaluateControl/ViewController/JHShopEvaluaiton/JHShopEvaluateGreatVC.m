//
//  JHShopEvaluateGreatVC.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/25.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHShopEvaluateGreatVC.h"
#import "JHShopEvaluateCell.h"
#import <MJRefresh.h>
#import "JHEvaluateNoneCell.h"
#import "JHShopEvaluateModel.h"
#import "JHShopReplyVC.h"
#import "DSToast.h"
@interface JHShopEvaluateGreatVC ()<UITableViewDataSource,UITableViewDelegate>
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
    BOOL isYes;//模拟用的
    NSInteger num;
    NSMutableArray * infoArray;
    DSToast * toast;
}
@end

@implementation JHShopEvaluateGreatVC
- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化一些数据
    [self initData];
    //添加表视图
    [self creatUITableView];
    //这是发送请求的方法
    SHOW_HUD
    [self postHttpWithPage:@(num).stringValue];
}
#pragma mark - 这是发送请求的方法
-(void)postHttpWithPage:(NSString *)page{
    [HttpTool postWithAPI:@"biz/comment/items" withParams:@{@"page":page,@"type":@"1"} success:^(id json) {
        NSLog(@"%@",json);
        if ([json[@"error"] isEqualToString:@"0"]) {
            if (page.integerValue == 1) {
                [infoArray removeAllObjects];
            }
            NSArray * tempArray = json[@"data"][@"items"];
            for (NSDictionary * dic in tempArray) {
                JHShopEvaluateModel * model = [JHShopEvaluateModel creatJHShopEvaluateModelWithDictiionary:dic];
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
    infoArray = @[].mutableCopy;
    num = 1;
}
#pragma mark - 这是创建表格的方法
-(void)creatUITableView{
    myTableView = [[UITableView alloc]initWithFrame:FRAME(0, 0, WIDTH, HEIGHT - 100 - 64) style:UITableViewStylePlain];
    myTableView.tableFooterView = [UIView new];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [myTableView registerClass:[JHShopEvaluateCell class] forCellReuseIdentifier:@"cell"];
    [myTableView registerClass:[JHEvaluateNoneCell class] forCellReuseIdentifier:@"cell1"];
    myTableView.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
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
        return HEIGHT - 100 - 64;
    }else{
        JHShopEvaluateModel * model = nil;
        if (infoArray.count > 0) {
            model = infoArray[indexPath.row];
        }

        CGSize size = [model.content boundingRectWithSize:CGSizeMake(WIDTH - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
        height_evaluate = size.height;
        CGSize size1 = [model.reply boundingRectWithSize:CGSizeMake(WIDTH - 30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
        height_reply = size1.height;
        if (model.reply.length > 0 && model.photoArray.count > 0) {
            isPhoto = YES;
            isReply = YES;
            return 60 + height_evaluate + 15 + (WIDTH - 50)/4 + 30 + height_reply+40;
            
        }else if (model.reply.length == 0 && model.photoArray.count > 0){
            isPhoto = YES;
            isReply = NO;
            return 60 + height_evaluate + 15 + (WIDTH - 50)/4 + 35;
        }else if (model.reply.length > 0 && model.photoArray.count == 0){
            isPhoto = NO;
            isReply = YES;
            return 60 + height_evaluate + 30 + height_reply  + 50;
        }else{
            isReply = NO;
            isPhoto = NO;
            return 60 + height_evaluate + 40;
        }
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (isYes) {
        JHEvaluateNoneCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        JHShopEvaluateCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.indexPath = indexPath;
        JHShopEvaluateModel * model = infoArray[indexPath.row];
        cell.height_reply = height_reply;
        cell.height_evaluate = height_evaluate;
        cell.model = model;
        cell.btn_reply.tag = indexPath.row;
        [cell.btn_reply addTarget:self action:@selector(clickToReply:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}
#pragma mark - 这是点击进入回复界面的方法
-(void)clickToReply:(UIButton *)sender{
    NSLog(@"点击了进入回复界面");
    JHShopEvaluateModel * model = infoArray[sender.tag];
    JHShopReplyVC * vc = [[JHShopReplyVC alloc]init];
    vc.comment_id = model.comment_id;
    vc.headUrl = model.face;
    vc.name = model.nickname;
    vc.score = model.score;
    vc.dateline = model.time_evaluate;
    vc.evaluate = model.content;
    vc.photoArray = model.photoArray;
    [vc setMyBlock:^(void){
        [self downRefresh];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
