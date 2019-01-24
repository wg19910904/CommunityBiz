//
//  DeliveryProductVC.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/19.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "DeliveryProductVC.h"
#import "DeliveryProductCell.h"
#import "SubNavView.h"
#import "DeliveryProductSubClassifyVC.h"
#import "DeliverySubShelfVC.h"
#import "DeliveryProductBottomView.h"
#import "DeliveryProductAllModifyBottomView.h"
#import "DeliveryProductVM.h"
#import <MJRefresh.h>
#import "DeliveryProductCellModel.h"
#import "DeliveryProductModifyVC.h"
@class DeliveryProductAddVC;
@interface DeliveryProductVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *mainTableView;
@property(nonatomic, strong)DeliveryProductSubClassifyVC *classifyVC;
@property(nonatomic, strong)DeliverySubShelfVC *shelfVC;
@end

@implementation DeliveryProductVC
{
    //刷新
    MJRefreshNormalHeader *_headerRefresh;
    MJRefreshAutoNormalFooter *_footerRefresh;
    UIButton *_classifyBtn;
    UIButton *_shelfBtn;
    UIButton *_saleNumBtn;
    UIButton *rightBtn;//导航栏右侧按钮
    //点击批量管理时,底部出现的view
    DeliveryProductAllModifyBottomView *allModifyBottomView;
    NSMutableDictionary *paramDic;
    DeliveryProductVM *vm;
    NSMutableArray *dataSource;
    NSInteger page;
    BOOL isSelectAll;
    NSMutableArray *selectedArr;
}

- (void)viewDidLoad {
    //设置相关信息
    [self initData];
    //创建页面内导航栏
    [self makeSubnav];
    //创建表视图
    [self createMainTableView];
    //添加底部view
    [self makeBottomView];
    //添加导航栏右侧按钮
    [self addRightBtn];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadNewData];
}
#pragma mark - 添加导航栏右侧按钮
- (void)addRightBtn
{
    //未选中时为未完成订单,选中时为已完成订单
    rightBtn = [[UIButton alloc] initWithFrame:FRAME(0, 0, 55, 30)];
    [rightBtn setTitle:NSLocalizedString(@"", nil) forState:(UIControlStateNormal)];
    [rightBtn setTitle:NSLocalizedString(@"取消", nil) forState:(UIControlStateSelected)];
    [rightBtn setTitleColor:HEX(@"faaf19", 1.0f) forState:(UIControlStateNormal)];
    rightBtn.titleLabel.font = FONT(16);
    [rightBtn addTarget:self action:@selector(clickRightBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}
- (void)initData
{
    self.view.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
    self.navigationItem.title = NSLocalizedString(@"店铺商品管理", nil);
    [super viewDidLoad];
    paramDic = @{@"cate_id":@0,
                 @"status":@1,
                 @"sales":@0}.mutableCopy;
    dataSource = @[].mutableCopy;
    selectedArr = @[].mutableCopy;
    //添加通知
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(deleteNavVC) name:@"JHDeleteNavVCNotificationName" object: nil];
}
#pragma mark - 请求新数据
- (void)loadNewData
{
    selectedArr = @[].mutableCopy;
    [_mainTableView setEditing:NO animated:YES];
    page = 1;
    [paramDic addEntriesFromDictionary:@{@"page":@(page)}];
    SHOW_HUD
    [HttpTool postWithAPI:@"biz/waimai/product/product/items"
               withParams:paramDic
                  success:^(id json) {
                      HIDE_HUD
                      NSLog(@"biz/waimai/product/product/items--%@",json);
                      if ([json[@"error"] isEqualToString:@"0"]) {
                          vm = [DeliveryProductVM yy_modelWithJSON:json[@"data"]];
                          [dataSource removeAllObjects];
                          [dataSource addObjectsFromArray:vm.items];
                          [_mainTableView reloadData];
                      }else{
                          [JHShowAlert showAlertWithMsg:json[@"message"]];
                      }
                      [_headerRefresh endRefreshing];
                  } failure:^(NSError *error) {
                      HIDE_HUD
                      [_headerRefresh endRefreshing];
                      [JHShowAlert showAlertWithMsg:NSLocalizedString(@"服务器连接异常", nil)];
                  }];
}
#pragma mark - 请求更多数据
- (void)loadMoreData
{
    [paramDic addEntriesFromDictionary:@{@"page":@(++page)}];
    SHOW_HUD
    [HttpTool postWithAPI:@"biz/waimai/product/product/items"
               withParams:paramDic
                  success:^(id json) {
                      HIDE_HUD
                      NSLog(@"biz/waimai/product/product/items--%@",json);
                      if ([json[@"error"] isEqualToString:@"0"]) {
                          vm = [DeliveryProductVM yy_modelWithJSON:json[@"data"]];
                          [dataSource addObjectsFromArray:vm.items];
                          [_mainTableView reloadData];
                      }else{
                          [JHShowAlert showAlertWithMsg:json[@"message"]];
                      }
                      [_footerRefresh endRefreshing];
                  } failure:^(NSError *error) {
                      HIDE_HUD
                      [_footerRefresh endRefreshing];
                      [JHShowAlert showAlertWithMsg:NSLocalizedString(@"服务器连接异常", nil)];
                  }];
}
#pragma mark - makeSubnav
- (void)makeSubnav
{
    SubNavView *navView = [[SubNavView alloc] initWithFrame:FRAME(0,0, WIDTH, 40)];
    navView.titleArray = @[NSLocalizedString(@"全部分类", nil),NSLocalizedString(@"已上架", nil),NSLocalizedString(@"销量", nil)];
    _classifyBtn = navView.btn0;
    _shelfBtn = navView.btn1;
    _saleNumBtn = navView.btn2;
    [_classifyBtn addTarget:self action:@selector(clickClassifyBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_shelfBtn addTarget:self action:@selector(clickShelfBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_saleNumBtn addTarget:self action:@selector(clickSaleNumBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:navView];
}
#pragma mark - 创建表视图
- (void)createMainTableView
{
    _mainTableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,40, WIDTH, HEIGHT-154)
                                                             style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
        tableView.separatorColor = LINE_COLOR;
        tableView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:tableView];
        tableView.layoutMargins = UIEdgeInsetsZero;
        tableView.separatorInset = UIEdgeInsetsZero;
        //-----------------刷新和加载更多添加--------------------
        //创建刷新表头
        _headerRefresh = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
        _headerRefresh.lastUpdatedTimeLabel.hidden = YES;
        [_headerRefresh setTitle:NSLocalizedString(@"现在可以刷新啦", nil) forState:MJRefreshStatePulling];
        [_headerRefresh setTitle:NSLocalizedString(@"正在为您努力刷新中", nil) forState:MJRefreshStateRefreshing];
        _headerRefresh.stateLabel.textColor = [UIColor colorWithRed:129/255.0
                                                              green:129/255.0
                                                               blue:129/255.0
                                                              alpha:1.0];
        tableView.mj_header = _headerRefresh;
        //创建加载表尾
        _footerRefresh = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self
                                                              refreshingAction:@selector(loadMoreData)];
        [_footerRefresh setTitle:@"" forState:MJRefreshStateIdle];//普通闲置状态
        tableView.mj_footer = _footerRefresh;
        //----------------------------------------------------
        tableView;
    });
}
#pragma mark - 添加底部view
- (void)makeBottomView
{
    DeliveryProductBottomView *bottomView = [[DeliveryProductBottomView alloc]
                                                 initWithFrame:FRAME(0, HEIGHT - 50-64, WIDTH, 50)];
    [self.view addSubview:bottomView];
    //添加方法
    [bottomView.manageBtn addTarget:self
                             action:@selector(clickManageBtn:)
                   forControlEvents:(UIControlEventTouchUpInside)];
    [bottomView.addBtn addTarget:self action:@selector(addDeliveryProduct) forControlEvents:(UIControlEventTouchUpInside)];
}
#pragma mark - tableView delegate and dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DeliveryProductCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeliveryProductCellID"];
    if (!cell) {
        cell = [[DeliveryProductCell alloc] initWithStyle:(UITableViewCellStyleDefault)
                                          reuseIdentifier:@"DeliveryProductCellID"];
    }
    cell.dataModel = dataSource[indexPath.section];
    cell.navVC = self.navigationController;
    if ([_shelfBtn.titleLabel.text isEqualToString:NSLocalizedString(@"已上架", nil)]) {
        cell.cellType = EDeliveryProductCellTypeShelied;
    }else if ([_shelfBtn.titleLabel.text isEqualToString:NSLocalizedString(@"未上架", nil)]){
        cell.cellType = EDeliveryProductCellTypeNotShelied;
    }else{
        cell.cellType = EDeliveryProductCellTypeOverdue;
    }
    if (_mainTableView.editing) {
        cell.back_view.center = CGPointMake(WIDTH/2 + 40, 80);
        
    }else{
        
        cell.back_view.center = CGPointMake(WIDTH/2, 80);
    }
    [cell.shelfBtn addTarget:self
                      action:@selector(clickCellShelfBtn:)
            forControlEvents:(UIControlEventTouchUpInside)];
    [cell.OffBtn addTarget:self
                      action:@selector(clickCellOffShelfBtn:)
            forControlEvents:(UIControlEventTouchUpInside)];
    [cell.modifyBtn addTarget:self
                       action:@selector(clickCellModifyBtn:)
             forControlEvents:(UIControlEventTouchUpInside)];
    return cell;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.editing) {
        NSString *sectionStr = @(indexPath.section).stringValue;
      if (![selectedArr containsObject:sectionStr]) {
            [selectedArr addObject:sectionStr];
        
        }
        NSLog(@"%@",selectedArr);
        if (selectedArr.count == dataSource.count) {
            allModifyBottomView.selectAllBtn.selected = YES;
            isSelectAll = YES;
        }
    }else{
        
        DeliveryProductCellModel *cellModel = dataSource[indexPath.section];
        DeliveryProductModifyVC *modifyVC = [[DeliveryProductModifyVC alloc] init];
        [modifyVC setRefreshBlock:^{
        }];
        modifyVC.dataModel = cellModel;
        [self.navigationController pushViewController:modifyVC animated:YES];
    }
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.editing) {
        NSString *sectionStr = @(indexPath.section).stringValue;
        if ([selectedArr containsObject:sectionStr]) {
            [selectedArr removeObject:sectionStr];
            
        }
        NSLog(@"%@",selectedArr);
        if (selectedArr.count != dataSource.count) {
            allModifyBottomView.selectAllBtn.selected = NO;
            isSelectAll = NO;
        }
    }else{
        
        
    }

}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *sectionStr = @(indexPath.section).stringValue;
   if ([selectedArr containsObject:sectionStr] || isSelectAll) {
        [_mainTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:0];
        [self tableView:_mainTableView didSelectRowAtIndexPath:indexPath];
    }
}
#pragma mark - 点击分类按钮
- (void)clickClassifyBtn:(UIButton *)sender
{
    NSLog(@"点击分类按钮");
    if (sender.selected) { //当前为选中状态
        [_classifyVC.view removeFromSuperview];
    }else{//未选中状态
        if (!_classifyVC) {
            _classifyVC = [[DeliveryProductSubClassifyVC alloc] init];
            __weak typeof(self) weakSelf = self;
            _classifyVC.refreshBlock = ^(NSDictionary *temDic){
                //处理参数
                [weakSelf handleParamsDicWithDic:temDic];
                //将subNav视图移除
                [weakSelf deleteNavVC];
            };
            _classifyVC.refreshBtnTitleBlock = ^(NSString *btnTitle){
                [weakSelf handleClassifyBtn:btnTitle];
            };
            [self addChildViewController:_classifyVC];
            
        }
        [self.view addSubview:_classifyVC.view];
    }
    sender.selected = !sender.selected;
    _shelfBtn.selected = NO;
    _saleNumBtn.selected = NO;
    [_shelfVC.view removeFromSuperview];
}
#pragma mark - 点击商品状态按钮
- (void)clickShelfBtn:(UIButton *)sender
{
    NSLog(@"点击排序按钮");
    if (sender.selected) { //当前为选中状态
        [_shelfVC.view removeFromSuperview];
    }else{//未选中状态
        if (!_shelfVC) {
            _shelfVC = [[DeliverySubShelfVC alloc] init];
            __weak typeof(self) weakSelf = self;

            _shelfVC.refreshBtnTitleBlock = ^(NSString *btnTitle){
                [weakSelf updateShelfBtnTitle:btnTitle];
            };
            _shelfVC.refreshBlock = ^(NSDictionary *temDic){
                //处理参数
                [weakSelf handleParamsDicWithDic:temDic];
                //将subNav视图移除
                [weakSelf deleteNavVC];
            };
            [self addChildViewController:_shelfVC];
        }
        [self.view addSubview:_shelfVC.view];
    }
    sender.selected = !sender.selected;
    _classifyBtn.selected = NO;
    _saleNumBtn.selected = NO;
    [_classifyVC.view removeFromSuperview];
}
#pragma mark - 点击销量按钮
- (void)clickSaleNumBtn:(UIButton *)sender
{
    [self deleteNavVC];
    sender.selected = !sender.selected;
    if (sender.selected) {
        [paramDic addEntriesFromDictionary:@{@"sales":@1}];
    }else{
        [paramDic addEntriesFromDictionary:@{@"sales":@0}];
    }
    [self loadNewData];
}
#pragma mark - 改变上架按钮的状态
- (void)updateShelfBtnTitle:(NSString *)title
{
    [_shelfBtn setTitle:title forState:(UIControlStateNormal)];
    //判断类型
    if ([_shelfBtn.titleLabel.text isEqualToString:NSLocalizedString(@"已上架", nil)]) {
        allModifyBottomView.bottomViewType = EStatusShelf;
    }else if ([_shelfBtn.titleLabel.text isEqualToString:NSLocalizedString(@"未上架", nil)]){
        allModifyBottomView.bottomViewType = EStatusNotShelf;
    }else{
        allModifyBottomView.bottomViewType = EStatusOverdue;
    }
}
#pragma mark - 通知移除NavVC的view的方法
- (void)deleteNavVC
{
    [_classifyVC.view removeFromSuperview];
    [_shelfVC.view removeFromSuperview];
    _classifyBtn.selected = NO;
    _shelfBtn.selected = NO;
}
#pragma mark - 点击了批量管理按钮
- (void)clickManageBtn:(UIButton *)sender
{
    if (dataSource.count == 0) {
        [JHShowAlert showAlertWithMsg:NSLocalizedString(@"当前无商品", nil)];
        return;
    }
    rightBtn.selected = YES;
    if (!_mainTableView.editing) {
        //将表视图切换到可编辑状态
        _mainTableView.editing = YES;
        NSArray<DeliveryProductCell*> *cellArray = [_mainTableView visibleCells];
        for (DeliveryProductCell *cell in cellArray) {
            [UIView animateWithDuration:0.3 animations:^{
                cell.back_view.center = CGPointMake(WIDTH/2 + 40, 80);
            }];
        }
        if (!allModifyBottomView) {
            allModifyBottomView = [[DeliveryProductAllModifyBottomView alloc]
                                         initWithFrame:FRAME(0, HEIGHT - 64, WIDTH, 50)];
            [allModifyBottomView.selectAllBtn addTarget:self
                                                 action:@selector(clickSelectAllBtn:)
                                       forControlEvents:(UIControlEventTouchUpInside)];
            [allModifyBottomView.outShelfBtn addTarget:self
                                                action:@selector(clickAllOffShelfBtn:)
                                      forControlEvents:(UIControlEventTouchUpInside)];
            [allModifyBottomView.shelfBtn addTarget:self
                                             action:@selector(clickAllShelfBtn:)
                                   forControlEvents:(UIControlEventTouchUpInside)];
            [self.view addSubview:allModifyBottomView];
        }
        //判断类型
        if ([_shelfBtn.titleLabel.text isEqualToString:NSLocalizedString(@"已上架", nil)]) {
            allModifyBottomView.bottomViewType = EStatusShelf;
        }else if ([_shelfBtn.titleLabel.text isEqualToString:NSLocalizedString(@"未上架", nil)]){
            allModifyBottomView.bottomViewType = EStatusNotShelf;
        }
        //出现
        [UIView animateWithDuration:0.3 animations:^{
                            allModifyBottomView.frame = FRAME(0, HEIGHT - 64 - 50, WIDTH, 50);
                            }];
        //禁用刷新和加载
        _mainTableView.mj_header = nil;
        _mainTableView.mj_footer = nil;
    }

}
#pragma mark - 点击取消编辑按钮
- (void)clickRightBtn:(UIButton *)sender
{
    if (!(_mainTableView && _mainTableView.editing)) return;
    sender.selected = !sender.selected;
    if (!sender.selected) {
        //点击将表视图不可编辑
        self.mainTableView.editing = NO;
        NSArray<DeliveryProductCell*> *cellArray = [_mainTableView visibleCells];
        for (DeliveryProductCell *cell in cellArray) {
            [UIView animateWithDuration:0.3 animations:^{
                cell.back_view.center = CGPointMake(WIDTH/2, 80);
            }];
        }
        //消失
        [UIView animateWithDuration:0.3 animations:^{
            allModifyBottomView.frame = FRAME(0, HEIGHT - 64, WIDTH, 50);
            allModifyBottomView.selectAllBtn.selected = NO;
        }];
        isSelectAll = NO;
        //启用刷新和加载
        _mainTableView.mj_header = _headerRefresh;
        _mainTableView.mj_footer = _footerRefresh;
    }
}
#pragma mark - 处理分类按钮
- (void)handleClassifyBtn:(NSString *)title
{
    [_classifyBtn setTitle:title forState:(UIControlStateNormal)];
}
#pragma mark - 处理上架状态按钮
- (void)handleShelfBtn:(NSString *)title
{
    [_shelfBtn setTitle:title forState:(UIControlStateNormal)];
}
#pragma mark - 添加外送商品
- (void)addDeliveryProduct
{
    JHBaseVC *vc = [NSClassFromString(@"DeliveryProductAddVC") new];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 处理分类回调的参数
- (void)handleParamsDicWithDic:(NSDictionary *)temDic
{
    [paramDic addEntriesFromDictionary:temDic];
    [dataSource removeAllObjects];
    [self loadNewData];
}
#pragma mark - 点击cell内的上架按钮
- (void)clickCellShelfBtn:(UIButton *)sender
{
    //获取cell
    DeliveryProductCell *cell = (DeliveryProductCell *)[[sender superview] superview];
    NSIndexPath *indexPath = [_mainTableView indexPathForCell:cell];
    DeliveryProductCellModel *cellModel = dataSource[indexPath.section];
    SHOW_HUD
    [HttpTool postWithAPI:@"biz/waimai/product/product/batch_status"
               withParams:@{@"status":@1,
                            @"ids":cellModel.product_id}
                  success:^(id json) {
                      HIDE_HUD
                      NSLog(@"biz/waimai/product/product/batch_status--%@",json);
                      if ([json[@"error"] isEqualToString:@"0"]) {
                          [JHShowAlert showAlertWithMsg:NSLocalizedString(@"修改成功", nil)
                                           withBtnTitle:NSLocalizedString(@"知道了", nil)
                                           withBtnBlock:^{
                                               [self loadNewData];
                                           }];
                      }else{
                          [JHShowAlert showAlertWithMsg:NSLocalizedString(@"修改失败,请稍后再试", nil)];
                      }
                  }
                  failure:^(NSError *error) {
                      HIDE_HUD
                      [JHShowAlert showAlertWithMsg:NSLocalizedString(@"服务器连接异常", nil)];
                  }];
}
#pragma mark - 点击cell内的下架按钮
- (void)clickCellOffShelfBtn:(UIButton *)sender
{
    //获取cell
    DeliveryProductCell *cell = (DeliveryProductCell *)[[sender superview] superview];
    NSIndexPath *indexPath = [_mainTableView indexPathForCell:cell];
    DeliveryProductCellModel *cellModel = dataSource[indexPath.section];
    SHOW_HUD
    [HttpTool postWithAPI:@"biz/waimai/product/product/batch_status"
               withParams:@{@"status":@0,
                            @"ids":cellModel.product_id}
                  success:^(id json) {
                      HIDE_HUD
                      NSLog(@"biz/waimai/product/product/batch_status--%@",json);
                      if ([json[@"error"] isEqualToString:@"0"]) {
                          [JHShowAlert showAlertWithMsg:NSLocalizedString(@"修改成功", nil)
                                           withBtnTitle:NSLocalizedString(@"知道了", nil)
                                           withBtnBlock:^{
                                               [self loadNewData];
                                           }];
                      }else{
                          [JHShowAlert showAlertWithMsg:NSLocalizedString(@"修改失败,请稍后再试", nil)];
                      }
                  }
                  failure:^(NSError *error) {
                      HIDE_HUD
                      [JHShowAlert showAlertWithMsg:NSLocalizedString(@"服务器连接异常", nil)];
                  }];
}
#pragma mark - 点击cell内的修改按钮
- (void)clickCellModifyBtn:(UIButton *)sender
{
    //获取cell
    DeliveryProductCell *cell = (DeliveryProductCell *)[[sender superview] superview];
    NSIndexPath *indexPath = [_mainTableView indexPathForCell:cell];
    DeliveryProductCellModel *cellModel = dataSource[indexPath.section];
    DeliveryProductModifyVC *modifyVC = [[DeliveryProductModifyVC alloc] init];
    [modifyVC setRefreshBlock:^{
    }];
    modifyVC.dataModel = cellModel;
    [self.navigationController pushViewController:modifyVC animated:YES];
}
#pragma mark - 点击全选按钮
- (void)clickSelectAllBtn:(UIButton *)sender
{
    sender.selected = !sender.selected;
    isSelectAll = sender.selected;
    [selectedArr removeAllObjects];
    if (isSelectAll) {
        for (int i = 0; i < dataSource.count; i++) {
            [selectedArr addObject:@(i).stringValue];
        }
        NSArray<DeliveryProductCell*> *cellArray = _mainTableView.visibleCells;
        [cellArray enumerateObjectsUsingBlock:^(DeliveryProductCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //更改为选中
            [_mainTableView selectRowAtIndexPath:[_mainTableView indexPathForCell:obj] animated:NO scrollPosition:0];
            [self tableView:_mainTableView didSelectRowAtIndexPath:[_mainTableView indexPathForCell:obj]];
        }];
    }else{
        NSArray<DeliveryProductCell*> *cellArray = _mainTableView.visibleCells;
        [cellArray enumerateObjectsUsingBlock:^(DeliveryProductCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //更改为选中
            [_mainTableView deselectRowAtIndexPath:[_mainTableView indexPathForCell:obj] animated:NO];
            [self tableView:_mainTableView didDeselectRowAtIndexPath:[_mainTableView indexPathForCell:obj]];
        }];
    }
}
#pragma mark - 点击全部下架按钮
- (void)clickAllOffShelfBtn:(UIButton *)sender
{
    if (selectedArr.count == 0) {
        [JHShowAlert showAlertWithMsg:NSLocalizedString(@"未选择下架商品", nil)];
        return;
    }
    NSMutableArray *ids = @[].mutableCopy;
    for (NSString *section in selectedArr) {
        DeliveryProductCellModel *cellModel = dataSource[section.integerValue];
        [ids addObject:cellModel.product_id];
    }
    SHOW_HUD
    [HttpTool postWithAPI:@"biz/waimai/product/product/batch_status"
               withParams:@{@"status":@0,
                            @"ids":[ids componentsJoinedByString:@","]}
                  success:^(id json) {
                      HIDE_HUD
                      NSLog(@"biz/waimai/product/product/batch_status--%@",json);
                      if ([json[@"error"] isEqualToString:@"0"]) {
                          [JHShowAlert showAlertWithMsg:NSLocalizedString(@"修改成功", nil)
                                           withBtnTitle:NSLocalizedString(@"知道了", nil)
                                           withBtnBlock:^{
                                               isSelectAll = NO;
                                               [self clickRightBtn:rightBtn];
                                               allModifyBottomView.selectAllBtn.selected = NO;
                                               [self loadNewData];
                                           }];
                      }else{
                          [JHShowAlert showAlertWithMsg:NSLocalizedString(@"修改失败,请稍后再试", nil)];
                      }
                  }
                  failure:^(NSError *error) {
                      HIDE_HUD
                      [JHShowAlert showAlertWithMsg:NSLocalizedString(@"服务器连接异常", nil)];
                  }];
}
#pragma mark - 点击全部上架按钮
- (void)clickAllShelfBtn:(UIButton *)sender
{
    if (selectedArr.count == 0) {
        [JHShowAlert showAlertWithMsg:NSLocalizedString(@"未选择下架商品", nil)];
        return;
    }
    NSMutableArray *ids = @[].mutableCopy;
    for (NSString *section in selectedArr) {
        DeliveryProductCellModel *cellModel = dataSource[section.integerValue];
        [ids addObject:cellModel.product_id];
    }
    SHOW_HUD
    [HttpTool postWithAPI:@"biz/waimai/product/product/batch_status"
               withParams:@{@"status":@1,
                            @"ids":[ids componentsJoinedByString:@","]}
                  success:^(id json) {
                      HIDE_HUD
                      NSLog(@"biz/waimai/product/product/batch_status--%@",json);
                      if ([json[@"error"] isEqualToString:@"0"]) {
                          [JHShowAlert showAlertWithMsg:NSLocalizedString(@"修改成功", nil)
                                           withBtnTitle:NSLocalizedString(@"知道了", nil)
                                           withBtnBlock:^{
                                               isSelectAll = NO;
                                               [self clickRightBtn:rightBtn];
                                               allModifyBottomView.selectAllBtn.selected = NO;
                                               [self loadNewData];
                                           }];
                      }else{
                          [JHShowAlert showAlertWithMsg:NSLocalizedString(@"修改失败,请稍后再试", nil)];
                      }
                  }
                  failure:^(NSError *error) {
                      HIDE_HUD
                      [JHShowAlert showAlertWithMsg:NSLocalizedString(@"服务器连接异常", nil)];
                  }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
