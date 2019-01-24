//
//  QRCodeListVC.m
//  JHCommunityBiz
//
//  Created by ijianghu on 2017/11/14.
//  Copyright © 2017年 com.jianghu. All rights reserved.
//

#import "QRCodeListVC.h"
#import "QRCodeListCell.h"
#import "AddQRCodeVC.h"
#import "QRCodeDetailVC.h"
#import "QRCodeListModel.h"
#import "UITableView+XHTool.h"
@interface QRCodeListVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger page;
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *infoArr;
@end

@implementation QRCodeListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _infoArr = @[].mutableCopy;
    self.view.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
    self.navigationItem.title =  NSLocalizedString(@"台卡管理", NSStringFromClass([self class]));
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithImage:IMAGE(@"top-zhankai") style:UIBarButtonItemStylePlain target:self action:@selector(clickAddBtn)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    [self tableView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    page = 1;
    [self getData];
}
-(void)clickAddBtn{
    AddQRCodeVC *vc = [[AddQRCodeVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)getData{
    SHOW_HUD
    [HttpTool postWithAPI:@"biz/decca/items" withParams:@{@"page":@(page).stringValue} success:^(id json) {
        HIDE_HUD
        if ([json[@"error"] isEqualToString:@"0"]) {
            NSLog(@"输出的数据是:%@",json);
            if (page == 1) {
                [_infoArr removeAllObjects];
            }
            NSArray *tempArr = json[@"data"][@"items"];
            for (int i = 0; i < tempArr.count; i++) {
                NSDictionary *dic = tempArr[i];
                QRCodeListModel *model = [QRCodeListModel getDataWithDic:dic];
                [_infoArr addObject:model];
            }
            if (tempArr.count > 0) {
                [_tableView reloadData];
            }else{
                [self showToastAlertMessageWithTitle: NSLocalizedString(@"没有更多数据了", NSStringFromClass([self class]))];
            }
             [_tableView.mj_header endRefreshing];
             [_tableView.mj_footer endRefreshing];
        }else{
            [self showToastAlertMessageWithTitle:json[@"message"]];
        }
    } failure:^(NSError *error) {
        HIDE_HUD
        NSLog(@"请求出错:%@",error);
    }];
}
#pragma mark - 这是创建表视图的方法
-(UITableView * )tableView{
    if(_tableView == nil){
        _tableView = ({
            UITableView * table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64) style:UITableViewStyleGrouped];
            table.delegate = self;
            table.dataSource = self;
            table.tableFooterView = [UIView new];
            table.showsVerticalScrollIndicator = NO;
            table.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
            table.separatorStyle = UITableViewCellSeparatorStyleNone;
            [self.view addSubview:table];
            [table downToRefreshWithBlock:^{
                page =  1;
                [self getData];
            }];
            [table upToLoadWithBlock:^{
                page ++;
                [self getData];
            }];
            table;
        });
    }
    return _tableView;
}
#pragma mark - 这是UITableView的代理和方法和数据方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _infoArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = @"QRCodeListCell";
    QRCodeListCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[QRCodeListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    cell.model = _infoArr[indexPath.section];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    QRCodeListModel *model = _infoArr[indexPath.section];
    QRCodeDetailVC *vc = [[QRCodeDetailVC alloc]init];
    vc.spec_id = model.decca_id;
    [self.navigationController pushViewController:vc animated:YES];
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
//必须实现,但是可以不处理
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *deleteRoWAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title: NSLocalizedString(@"删除", NSStringFromClass([self class])) handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        QRCodeListModel *model = _infoArr[indexPath.section];
        [self deleteData:model.decca_id sec:indexPath.section];
    }];
    return @[deleteRoWAction];
}
#pragma mark - 这是删除的方法
-(void)deleteData:(NSString *)decca_id sec:(NSInteger)sec{
    SHOW_HUD
    [HttpTool postWithAPI:@"biz/decca/delete" withParams:@{@"decca_id":decca_id} success:^(id json) {
        HIDE_HUD
        if ([json[@"error"] isEqualToString:@"0"]) {
            [_infoArr removeObjectAtIndex:sec];
            [self showToastAlertMessageWithTitle: NSLocalizedString(@"删除成功!", NSStringFromClass([self class]))];
            [_tableView deleteSections:[NSIndexSet indexSetWithIndex:sec] withRowAnimation:UITableViewRowAnimationAutomatic];
        }else{
            [self showToastAlertMessageWithTitle:json[@"message"]];
        }
    } failure:^(NSError *error) {
        HIDE_HUD
        NSLog(@"操作失败:%@",error);
        [self showToastAlertMessageWithTitle: NSLocalizedString(@"操作失败", NSStringFromClass([self class]))];
    }];
}
@end
