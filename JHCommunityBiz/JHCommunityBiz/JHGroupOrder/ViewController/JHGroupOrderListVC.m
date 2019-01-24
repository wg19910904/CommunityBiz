//
//  JHGroupOrderListVC.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/28.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHGroupOrderListVC.h"
#import "JHGroupOrderListCell.h"
#import "JHGroupListModel.h"
#import <MJRefresh.h>
#import "JHGroupScanControl.h"
#import "JHGroupOrderDetailVC.h"
#import "JHAllCell.h"
#import "DSToast.h"
#import "JHTrueToConsumeVC.h"
@implementation JHGroupOrderListVC{
    UITableView * myTabaleView;
    MJRefreshNormalHeader * _header;
    MJRefreshAutoNormalFooter * _footer;
    NSInteger num;
    BOOL isYes;
    NSMutableArray * infoArray;
    DSToast * toast;
    NSMutableDictionary *addCondition;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"筛选结果", nil);
    //这是初始化一些数据的方法
    [self initData];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //发送请求
    SHOW_HUD
    [infoArray removeAllObjects];
    [self postHttpWithPage:@"1"];
}

- (void)reloadTableViewCondition:(NSMutableDictionary *)condition{
    addCondition = condition.mutableCopy;
}

#pragma mark - 这是发送请求的方法
-(void)postHttpWithPage:(NSString *)page{
    if (addCondition == nil) {
        addCondition = @{}.mutableCopy;
    }
    [addCondition setObject:page forKey:@"page"];
    if ([addCondition.allKeys containsObject:@"status"] == NO) {
        if (!_isShaiXuan) {
             [addCondition setObject:@"0" forKey:@"status"];
        }
    }
    [HttpTool postWithAPI:@"biz/tuan/order/items" withParams:addCondition success:^(id json) {
        NSLog(@"%@",json);
        if ([json[@"error"] isEqualToString:@"0"]) {
            if (page.integerValue == 1) {
                [infoArray removeAllObjects];
            }
            NSArray * tempArray = json[@"data"][@"items"];
            for (NSDictionary * dic in tempArray) {
                JHGroupListModel * model = [JHGroupListModel creatJHGroupListModelWithDictionary:dic];
                [infoArray addObject:model];
            }
            if (infoArray.count == 0) {
                isYes = NO;
            }else{
                isYes = YES;
            }
            //创建表格的方法
            [self creatUITableView];
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
}
#pragma mark - 这是创建表格的方法
-(void)creatUITableView{
    if (myTabaleView == nil) {
        int a = 114;
        if (_isShaiXuan) {
            a = 64;
        }
        myTabaleView  = [[UITableView alloc]initWithFrame:FRAME(0, 0, WIDTH, HEIGHT - a) style:UITableViewStyleGrouped];
        myTabaleView.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
        myTabaleView.separatorStyle = UITableViewCellSeparatorStyleNone;
        myTabaleView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 0.01)];
        myTabaleView.tableFooterView = [UIView new];
        myTabaleView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:myTabaleView];
        [myTabaleView registerClass:[JHGroupOrderListCell class] forCellReuseIdentifier:@"cell"];
        [myTabaleView registerClass:[JHAllCell class] forCellReuseIdentifier:@"cell1"];
        _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(downRefresh)];
        _header.lastUpdatedTimeLabel.hidden = YES;
        [_header setTitle: NSLocalizedString(@"下拉可以刷新", NSStringFromClass([self class])) forState:MJRefreshStateIdle];
        [_header setTitle: NSLocalizedString(@"现在可以刷新啦", NSStringFromClass([self class])) forState:MJRefreshStatePulling];
        [_header setTitle: NSLocalizedString(@"正在为您努力刷新中", NSStringFromClass([self class])) forState:MJRefreshStateRefreshing];
        myTabaleView.mj_header = _header;
        _footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
        [_footer setTitle: NSLocalizedString(@"正在加载更多的数据...", NSStringFromClass([self class])) forState:MJRefreshStateRefreshing];
        [_footer setTitle:@"" forState:MJRefreshStateIdle];
        myTabaleView.mj_footer = _footer;
        myTabaleView.delegate = self;
        myTabaleView.dataSource = self;
    }else{
        [myTabaleView reloadData];
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
#pragma mark - 这是表格的代理和数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (!isYes) {
        return 1;
    }else{
        return infoArray.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (isYes && infoArray.count > 0) {
        JHGroupListModel * model = infoArray[indexPath.section];
        if ([model.order_status_label isEqualToString: NSLocalizedString(@"待回复", NSStringFromClass([self class]))] ||
            [model.order_status_label isEqualToString: NSLocalizedString(@"已消费", NSStringFromClass([self class]))] ||
            [model.order_status_label isEqualToString: NSLocalizedString(@"待消费", NSStringFromClass([self class]))]) {
            return 150;
        }
        return 110;
    }else{
        return HEIGHT - 64;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (isYes) {
        JHGroupOrderListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        JHGroupListModel * model = infoArray[indexPath.section];
        cell.model = model;
        cell.btn_cancel.tag = indexPath.section;
        cell.btn_Verification.tag = indexPath.section;
        [cell.btn_cancel addTarget:self action:@selector(clickToCancel:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btn_Verification addTarget:self action:@selector(clickToVerification:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else{
        JHAllCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了>>>>>%ld",indexPath.section);
    if (isYes) {
        JHGroupListModel * model = infoArray[indexPath.section];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        JHGroupOrderDetailVC * vc = [[JHGroupOrderDetailVC alloc]init];
        vc.order_id = model.order_id;
        vc.type = model.type;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - 这是点击取消的方法
-(void)clickToCancel:(UIButton *)sender{
    NSLog(@"点击了取消");
}
#pragma mark - 这是点击验证的方法
-(void)clickToVerification:(UIButton *)sender{
    NSLog(@"点击了验证的方法");
    if ([sender.titleLabel.text isEqualToString: NSLocalizedString(@"验证", NSStringFromClass([self class]))]) {
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
    }else{
        JHGroupListModel * model = infoArray[sender.tag];
        JHGroupOrderDetailVC * vc = [[JHGroupOrderDetailVC alloc]init];
        vc.order_id = model.order_id;
        vc.type = model.type;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
#pragma mark - 这是弹出警告框的方法
-(void)creatUIAlertViewControllerWithMessage:(NSString *)msg withCancelBtn:(NSString *)cancelBtn withTrueBtn:(NSString *)trueBtn{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle: NSLocalizedString(@"温馨提示", NSStringFromClass([self class])) message:msg preferredStyle:UIAlertControllerStyleAlert];
    if (cancelBtn) {
        [alert addAction:[UIAlertAction actionWithTitle:cancelBtn style:UIAlertActionStyleCancel handler:nil]];
    }
    if (trueBtn) {
        [alert addAction:[UIAlertAction actionWithTitle:trueBtn style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
    }
    [self presentViewController:alert animated:YES completion:nil];
}

@end
