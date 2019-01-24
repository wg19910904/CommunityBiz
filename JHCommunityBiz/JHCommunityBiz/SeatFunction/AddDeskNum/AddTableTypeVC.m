//
//  DeliveryClassifyVC.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/19.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "AddTableTypeVC.h"
#import "DeliveryClassifyCell.h"
#import "AddTableSubTypeVC.h"
#import "DeliveryClassifyBottomView.h"
#import <MJRefresh.h>
#import "DeliveryClassifyVM.h"
#import "DeliveryAddClassifyView.h"
#import "DeliveryModifyClassifyView.h"
@interface AddTableTypeVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *mainTableView;
@property(nonatomic,retain)NSMutableArray *deleteArray;//选中需要删除的分类
@end

@implementation AddTableTypeVC
{
    //编辑按钮
    UIButton *editBtn;
    DeliveryClassifyBottomView *bottomView;
    //刷新
    MJRefreshNormalHeader *_headerRefresh;
    MJRefreshAutoNormalFooter *_footerRefresh;
    NSInteger page;
    DeliveryClassifyVM *vm;
    NSMutableArray *dataSource;
    BOOL selectAll;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //数据相关
    [self initData];
    //添加上方view
    [self addTopView];
    //添加表视图
    [self createTableView];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    page = 1;
    dataSource = @[].mutableCopy;
    [self loadData];
   
}
- (void)initData
{
    self.navigationItem.title =  NSLocalizedString(@"桌号分类管理", NSStringFromClass([self class]));
    self.view.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
    page = 1;
    dataSource = @[].mutableCopy;
    self.deleteArray = @[].mutableCopy;
}
#pragma mark - 添加上方view
- (void)addTopView
{
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor whiteColor];
    topView.frame = CGRectMake(0, 0, WIDTH, 50);
    //添加编辑按钮和右侧添加按钮
    editBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 50,50)];
    [editBtn setTitleColor:THEME_COLOR forState:UIControlStateNormal];
    [editBtn setTitle: NSLocalizedString(@"编辑", NSStringFromClass([self class])) forState:UIControlStateNormal];
    [editBtn setTitle: NSLocalizedString(@"取消", NSStringFromClass([self class])) forState:UIControlStateSelected];
    editBtn.titleLabel.font = FONT(18);
    [editBtn addTarget:self action:@selector(clickEditBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 60,0,60,50)];
    [addBtn setImage:[UIImage imageNamed:@"Delivery_add"] forState:UIControlStateNormal];
    addBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 15, 10, 15);
    [addBtn addTarget:self action:@selector(clickAddBtn:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:editBtn];
    [topView addSubview:addBtn];
    CALayer *lineLayer = [CALayer layer];
    lineLayer.frame = FRAME(0, 49.5, WIDTH, 0.5);
    lineLayer.backgroundColor = LINE_COLOR.CGColor;
    [topView.layer addSublayer:lineLayer];
    [self.view addSubview:topView];
}
#pragma mark - 创建表视图
- (void)createTableView
{
    _mainTableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,50, WIDTH, HEIGHT - 64 - 50)
                                                              style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
        tableView.separatorColor = LINE_COLOR;
        tableView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:tableView];
        tableView.layoutMargins = UIEdgeInsetsZero;
        tableView.separatorInset = UIEdgeInsetsZero;
        //-----------------刷新和加载更多添加-------------------
//        _footerRefresh = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self
//                                                              refreshingAction:@selector(loadData)];
//        [_footerRefresh setTitle:@"" forState:MJRefreshStateIdle];
//        tableView.mj_footer = _footerRefresh;
        //----------------------------------------------------
        tableView;
    });
}
- (void)loadData
{
    selectAll = NO;
    [self.deleteArray removeAllObjects];
    [_mainTableView setEditing:NO animated:YES];
    SHOW_HUD
//    if(dataSource.count==0) page=1;
    [HttpTool postWithAPI:@"biz/yuyue/zhuohao/cateItems"
               withParams:@{@"page":@(1)}
                  success:^(id json) {
                      HIDE_HUD
                      NSLog(@"biz/yuyue/zhuohao/cateItems--%@",json);
                      vm = [DeliveryClassifyVM yy_modelWithJSON:json];
                      if ([vm.error isEqualToString:@"0"]) {
                          [dataSource addObjectsFromArray:vm.data[@"items"]];
                          [_mainTableView reloadData];
                          
                      }else{
                      
                          [JHShowAlert showAlertWithMsg:vm.message];
                      }
                      [_footerRefresh endRefreshing];
                  }
                  failure:^(NSError *error) {
                      HIDE_HUD
                      [_footerRefresh endRefreshing];
                      [JHShowAlert showAlertWithMsg: NSLocalizedString(@"服务器连接异常", NSStringFromClass([self class]))];
                      
                  }];
}
#pragma mark - 点击编辑按钮
- (void)clickEditBtn:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        //将表视图切换到可编辑状态
        _mainTableView.frame = FRAME(0,50, WIDTH, HEIGHT - 64 - 100);
        _mainTableView.editing = YES;
        [self addBottomView];
        NSArray<DeliveryClassifyCell*> *cellArray = [_mainTableView visibleCells];
        for (DeliveryClassifyCell *cell in cellArray) {
            [UIView animateWithDuration:0.3 animations:^{
                cell.titleLabel.frame = FRAME(40, 0,112, 44);
                cell.editBtn.frame = FRAME(152, 0, 44, 44);

            }];
        }
        _mainTableView.mj_footer = nil;
    }else{
        [_deleteArray removeAllObjects];
        [self changeDeleteBtnStatus];
        //将表视图切换到不可编辑状态
        _mainTableView.frame = FRAME(0,50, WIDTH, HEIGHT - 64 - 50);
        _mainTableView.editing = NO;
        [self hideBottomView];
        NSArray<DeliveryClassifyCell*> *cellArray = [_mainTableView visibleCells];
        for (DeliveryClassifyCell *cell in cellArray) {
            [UIView animateWithDuration:0.3 animations:^{
                cell.titleLabel.frame = FRAME(10, 0,112, 44);
                cell.editBtn.frame = FRAME(122, 0, 44, 44);
            }];
        }
        _mainTableView.mj_footer = _footerRefresh;
    }
}
#pragma mark - 添加底部视图
- (void)addBottomView
{
    if (!bottomView) {
        bottomView = [[DeliveryClassifyBottomView alloc] initWithFrame:FRAME(0, HEIGHT - 64, WIDTH, 50)];
        [self.view addSubview:bottomView];
        [bottomView.selectedAllBtn addTarget:self
                                      action:@selector(clickSelectedAllBtn:)
                            forControlEvents:(UIControlEventTouchUpInside)];
        [bottomView.deleteBtn addTarget:self
                                 action:@selector(clickDeleteBtn:)
                       forControlEvents:(UIControlEventTouchUpInside)];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        bottomView.frame = FRAME(0, HEIGHT - 64 - 50, WIDTH, 50);
    }];
}
#pragma mark - 隐藏底部视图
- (void)hideBottomView
{
    [UIView animateWithDuration:0.3 animations:^{
        bottomView.frame = FRAME(0, HEIGHT - 64, WIDTH, 50);
    } completion:^(BOOL finished) {
        
        [bottomView removeFromSuperview];
        bottomView = nil;
    }];
    
}
#pragma mark - 点击加号按钮
- (void)clickAddBtn:(UIButton *)sender
{
    __weak typeof(self)weakSelf = self;
    __block  DeliveryAddClassifyView *backView = [[DeliveryAddClassifyView alloc]
                                         initWithTitle: NSLocalizedString(@"添加分类", NSStringFromClass([self class]))
                                         withSubTitle:@""
                                         withRemindTitle: NSLocalizedString(@"请输入类别名称", NSStringFromClass([self class]))
                                         withCancelBlock:^{
                                             [backView removeFromSuperview];
                                             backView = nil;
                                         }
                                         withSureBlock:^{
                                             page = 1;
                                             dataSource = @[].mutableCopy;
                                             [weakSelf loadData];
                                             [backView removeFromSuperview];
                                             backView = nil;
                                             
                                         }];
    backView.urlLink=@"biz/yuyue/zhuohao/createCate";
    [self.view addSubview:backView];
}
#pragma mark - tableView delegate and dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectio
{
    return dataSource.count;
}
-
(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DeliveryClassifyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeliveryClassifyCellID"];
    if (!cell) {
        cell = [[DeliveryClassifyCell alloc] initWithStyle:(UITableViewCellStyleDefault)
                                           reuseIdentifier:@"DeliveryClassifyCellID"];
    }
    cell.dataDic = dataSource[indexPath.row];
    if (tableView.editing) {
        cell.titleLabel.frame = FRAME(40, 0,112, 44);
        cell.editBtn.frame = FRAME(152, 0, 44, 44);
        
    }else{
        cell.titleLabel.frame = FRAME(10, 0,112, 44);
        cell.editBtn.frame = FRAME(122, 0, 44, 44);
    }
    [cell.editBtn addTarget:self
                     action:@selector(clickCellEditBtn:)
           forControlEvents:(UIControlEventTouchUpInside)];
    return cell;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.editing) {
        NSString *rowStr = @(indexPath.row).stringValue;
        if (![_deleteArray containsObject:rowStr]) {
            [_deleteArray addObject:rowStr];
            [self changeDeleteBtnStatus];
        }
        if (_deleteArray.count == dataSource.count) {
            bottomView.selectedAllBtn.selected = YES;
            selectAll = YES;
        }
        
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        NSString *parent_id = [dataSource[indexPath.row] valueForKey:@"cate_id"] ?
                              [dataSource[indexPath.row] valueForKey:@"cate_id"] : @"";
        AddTableSubTypeVC *vc = [[AddTableSubTypeVC alloc] init];
        vc.parent_id = parent_id;
        vc.supCateTitle=dataSource[indexPath.row][@"title"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.editing) {
        NSString *rowStr = @(indexPath.row).stringValue;
        if ([_deleteArray containsObject:rowStr]) {
            [_deleteArray removeObject:rowStr];
            [self changeDeleteBtnStatus];
        }
        if (_deleteArray.count != dataSource.count) {
            bottomView.selectedAllBtn.selected = NO;
            selectAll = NO;
        }
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *rowStr = @(indexPath.row).stringValue;
    if (selectAll || [_deleteArray containsObject:rowStr]) {
        [_mainTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:0];
        [self tableView:_mainTableView didSelectRowAtIndexPath:indexPath];
    }
}

- (void)clickCellEditBtn:(UIButton *)sender
{
    //获取indexPath
    UITableViewCell *cell = (UITableViewCell *)[sender superview];
    NSIndexPath *indexPath = [_mainTableView indexPathForCell:cell];
    NSInteger row = indexPath.row;
    NSDictionary *dataDic = dataSource[row];
    __weak typeof(self)weakSelf = self;
   __block DeliveryModifyClassifyView *backView = [[DeliveryModifyClassifyView alloc]
                                             initWithTitle: NSLocalizedString(@"编辑分类", NSStringFromClass([self class]))
                                              withSubTitle:@""
                                           withRemindTitle:@""
                                           withCancelBlock:^{
                                            [backView removeFromSuperview];
                                             backView = nil;
                                           }
                                            withSureBlock:^{
                                                page = 1;
                                                dataSource = @[].mutableCopy;
                                                [weakSelf loadData];
                                                [backView removeFromSuperview];
                                                backView = nil;
                                            }
                                             withCateTitle:dataDic[@"title"]
                                             withOrderBy:dataDic[@"orderby"]
                                             withCate_id:dataDic[@"cate_id"]];
    
    backView.urlLink=@"biz/yuyue/zhuohao/editCate";
    [self.view addSubview:backView];
}
#pragma mark - 点击全选按钮
- (void)clickSelectedAllBtn:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) { //全选
        selectAll = YES;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            for (int i = 0; i<dataSource.count; i++) {
                [_deleteArray addObject:@(i).stringValue];
            }
        });
        
        NSArray<DeliveryClassifyCell *> *visibleCells = [_mainTableView visibleCells];
        for (DeliveryClassifyCell *cell in visibleCells) {
            NSIndexPath *indexPath = [_mainTableView indexPathForCell:cell];
            [self tableView:_mainTableView didSelectRowAtIndexPath:indexPath];
            [_mainTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    }else{ //取消全选
        selectAll = NO;
        [_deleteArray removeAllObjects];
        
        NSArray<DeliveryClassifyCell *> *visibleCells = [_mainTableView visibleCells];
        for (DeliveryClassifyCell *cell in visibleCells) {
            NSIndexPath *indexPath = [_mainTableView indexPathForCell:cell];
            [self tableView:_mainTableView didDeselectRowAtIndexPath:indexPath];
            [_mainTableView deselectRowAtIndexPath:indexPath animated:NO];
        }
    }
    
    [self changeDeleteBtnStatus];
}
#pragma mark - 改变删除按钮的状态
- (void)changeDeleteBtnStatus
{
    if (_deleteArray.count == 0) {
        [bottomView.deleteBtn setBackgroundColor:HEX(@"bbbbbb", 1.0) forState:(UIControlStateNormal)];
    }else{
        [bottomView.deleteBtn setBackgroundColor:THEME_COLOR forState:(UIControlStateNormal)];
    }
}
#pragma mark - 点击删除按钮
- (void)clickDeleteBtn:(UIButton *)sender
{
    if (_deleteArray.count == 0) {
        [JHShowAlert showAlertWithMsg: NSLocalizedString(@"未选择需要删除的分类", NSStringFromClass([self class]))];
        return;
    }
    
    [JHShowAlert showAlertWithTitle:nil withMessage: NSLocalizedString(@"您确定要删除吗?\n删除的话会使得该类下的所有子类以及子类下的商品一并删除,请谨慎操作!", NSStringFromClass([self class])) withBtn_cancel: NSLocalizedString(@"取消", NSStringFromClass([self class])) withBtn_sure: NSLocalizedString(@"确定", NSStringFromClass([self class])) withCancelBlock:^{
        [_deleteArray removeAllObjects];
        [self clickEditBtn:editBtn];
        
    } withSureBlock:^{
        
        NSMutableArray *cate_id = @[].mutableCopy;
        for (NSString *row in _deleteArray) {
            [cate_id addObject: dataSource[row.integerValue][@"cate_id"]];
        }
        //删除分类
        SHOW_HUD
        [HttpTool postWithAPI:@"biz/yuyue/zhuohao/deleteCate"
                   withParams:@{@"cate_id":[cate_id componentsJoinedByString:@","]}
                      success:^(id json) {
                          HIDE_HUD
                          __weak typeof(self)weakSelf = self;
                          if ([json[@"error"] isEqualToString:@"0"]) {
                              [JHShowAlert showAlertWithMsg: NSLocalizedString(@"删除成功", NSStringFromClass([self class])) withBtnTitle: NSLocalizedString(@"确定", NSStringFromClass([self class])) withBtnBlock:^{
                                  page = 1;
                                  [dataSource removeAllObjects];
                                  [weakSelf clickEditBtn:editBtn];
                                  [weakSelf loadData];
                              }];
                          }else{
                              [JHShowAlert showAlertWithMsg: NSLocalizedString(@"删除失败,请稍后再试", NSStringFromClass([self class]))];
                          }
                      }
                      failure:^(NSError *error) {
                          HIDE_HUD
                          [JHShowAlert showAlertWithMsg: NSLocalizedString(@"服务器连接异常", NSStringFromClass([self class]))];
                      }];
 
    }];
}
@end
