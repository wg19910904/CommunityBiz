//
//  JHPreferentiaDetailVC.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/26.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHPreferentiaDetailVC.h"
#import "JHPreferentiaDetailCellOne.h"
#import "JHPreferentiaDetailCellTwo.h"
#import "JHPreferentiaDetailCellThree.h"
#import "JHPreferentiaDetailCellFour.h"
#import <MJRefresh.h>
#import "JHShopReplyVC.h"
#import "JHPreferentiaDetailModel.h"
@implementation JHPreferentiaDetailVC{
    UITableView * myTableView;//指向表格的指针
    float height_evaluate;//评论的高度
    float height_reply;//回复的高度
    MJRefreshNormalHeader * _header;//下拉刷新的
    JHPreferentiaDetailModel * detailModel;
    UIButton * btn;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    //初始化一些数据的方法
    [self initData];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //发送请求
    SHOW_HUD
    [self postHttp];
}
#pragma mark - 这是发送请求的方法
-(void)postHttp{
    [HttpTool postWithAPI:@"biz/shop/shop/maidan_detail" withParams:@{@"order_id":self.order_id} success:^(id json) {
       HIDE_HUD
        NSLog(@"%@",json);
        if ([json[@"error"] isEqualToString:@"0"]) {
            detailModel = [[JHPreferentiaDetailModel alloc]initWithDictionary:json[@"data"][@"order"]];
        }else{
            [JHShowAlert showAlertWithMsg:json[@"message"]];
        }
         if ([detailModel.state isEqualToString: NSLocalizedString(@"待回复", NSStringFromClass([self class]))]) {
             if (btn == nil) {
                 btn = [[UIButton alloc]init];
                 [btn setBackgroundColor:[UIColor colorWithRed:250/255.0 green:175/255.0 blue:25/255.0 alpha:1] forState:UIControlStateNormal];
                 btn.frame = FRAME(0, HEIGHT - 64 - 50, WIDTH, 50);
                 [btn setTitle:NSLocalizedString(@"回复", NSStringFromClass([self class])) forState:UIControlStateNormal];
                 [btn addTarget:self action:@selector(clickToReply) forControlEvents:UIControlEventTouchUpInside];
                 [self.view addSubview:btn];
             }
        }else{
             [btn removeFromSuperview];
             btn = nil;
         }
        [self creatUITaleView];
        [_header endRefreshing];
    } failure:^(NSError *error) {
        HIDE_HUD
        [_header endRefreshing];
        [JHShowAlert showAlertWithMsg: NSLocalizedString(@"服务器繁忙,请稍后访问", NSStringFromClass([self class]))];
    }];
}
#pragma mark - 这是初始化一些数据的方法
-(void)initData{
    self.navigationItem.title =  NSLocalizedString(@"优惠买单详情", NSStringFromClass([self class]));
    self.view.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
}
#pragma mark - 这是点击回复的按钮
-(void)clickToReply{
    JHShopReplyVC *  reply = [[JHShopReplyVC alloc]init];
    reply.isPhoto = detailModel.isPhoto;
    reply.headUrl = detailModel.headUrl;
    reply.name = detailModel.name;
    reply.score = detailModel.score;
    reply.evaluate  = detailModel.content;
    reply.dateline = detailModel.time_evaluate;
    reply.photoArray = detailModel.photoArray;
    reply.comment_id = detailModel.comment_id;
    [self.navigationController pushViewController:reply animated:YES];
}
#pragma mark - 这是创建表格的方法
-(void)creatUITaleView{
    if (myTableView == nil) {
        if ([detailModel.state isEqualToString: NSLocalizedString(@"待回复", NSStringFromClass([self class]))]) {
            myTableView = [[UITableView alloc]initWithFrame:FRAME(0, 0, WIDTH, HEIGHT - 64 - 50) style:UITableViewStylePlain];
            
        }else{
            myTableView = [[UITableView alloc]initWithFrame:FRAME(0, 0, WIDTH, HEIGHT - 64) style:UITableViewStylePlain];
        }
        myTableView.tableFooterView = [UIView new];
        myTableView.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
        myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        myTableView.showsVerticalScrollIndicator = NO;
        [myTableView registerClass:[JHPreferentiaDetailCellOne class] forCellReuseIdentifier:@"cell1"];
        [myTableView registerClass:[JHPreferentiaDetailCellTwo class] forCellReuseIdentifier:@"cell2"];
        [myTableView registerClass:[JHPreferentiaDetailCellThree class] forCellReuseIdentifier:@"cell3"];
        [myTableView registerClass:[JHPreferentiaDetailCellFour class] forCellReuseIdentifier:@"cell4"];
        myTableView.delegate = self;
        myTableView.dataSource = self;
        [self.view addSubview:myTableView];
        _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(downRefresh)];
        _header.lastUpdatedTimeLabel.hidden = YES;
        [_header setTitle: NSLocalizedString(@"下拉可以刷新", NSStringFromClass([self class])) forState:MJRefreshStateIdle];
        [_header setTitle: NSLocalizedString(@"现在可以刷新啦", NSStringFromClass([self class])) forState:MJRefreshStatePulling];
        [_header setTitle: NSLocalizedString(@"正在为您努力刷新中", NSStringFromClass([self class])) forState:MJRefreshStateRefreshing];
        myTableView.mj_header = _header;
    }else{
        if ([detailModel.state isEqualToString: NSLocalizedString(@"待回复", NSStringFromClass([self class]))]) {
            myTableView.frame = FRAME(0, 0, WIDTH, HEIGHT - 64 - 50);
            
        }else{
            myTableView.frame = FRAME(0, 0, WIDTH, HEIGHT - 64);
        }
        [myTableView reloadData];
    }
 
}
#pragma mark - 这是表格的代理和数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([detailModel.state isEqualToString: NSLocalizedString(@"等待客户评价", NSStringFromClass([self class]))]) {
        return 3;
    }else{
        return 4;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            return 50;
            break;
         case 1:
            return 100;
            break;
         case 2:
            return 150;
            break;
        case 3:
        {
            CGSize size = [detailModel.content boundingRectWithSize:CGSizeMake(WIDTH - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
            height_evaluate = size.height;
            CGSize size1 = [detailModel.reply boundingRectWithSize:CGSizeMake(WIDTH - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
            height_reply = size1.height;
            if (!detailModel.isPhoto && [detailModel.state isEqualToString:NSLocalizedString(@"待回复", NSStringFromClass([self class]))]) {
                return 105+height_evaluate;
            }else if(detailModel.isPhoto&&[detailModel.state isEqualToString:NSLocalizedString(@"待回复", NSStringFromClass([self class]))]){
                return 115 + (WIDTH - 50)/4 + height_evaluate;
            }else if (!detailModel.isPhoto&&[detailModel.state isEqualToString:NSLocalizedString(@"已回复", NSStringFromClass([self class]))]){
                return 105+height_evaluate + 30 + height_reply;
            }else {
                return 115 + (WIDTH - 50)/4 + height_evaluate + 30 + height_reply;
            }
        }
            break;
        default:
            return 0;
            break;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            JHPreferentiaDetailCellOne * cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
            cell.model = detailModel;
            return cell;
        }
            break;
        case 1:
        {
            JHPreferentiaDetailCellTwo * cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
            cell.model = detailModel;
            return cell;
        }
            break;
        case 2:
        {
            JHPreferentiaDetailCellThree * cell = [tableView dequeueReusableCellWithIdentifier:@"cell3" forIndexPath:indexPath];
            cell.model = detailModel;
            return cell;
        }
            break;
        case 3:
        {
            JHPreferentiaDetailCellFour * cell = [tableView dequeueReusableCellWithIdentifier:@"cell4" forIndexPath:indexPath];
            cell.height_evaluate = height_evaluate;
            cell.height_reply = height_reply;
            cell.model = detailModel;
            return cell;
        }
        default:
            return 0;
            break;
    }
}
#pragma mark - 这是下拉刷新的方法
-(void)downRefresh{
    [self postHttp];
}
@end
