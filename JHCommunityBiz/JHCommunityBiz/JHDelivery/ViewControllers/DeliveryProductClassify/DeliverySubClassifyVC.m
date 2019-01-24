//
//  DeliverySubClassifyVC.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/23.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "DeliverySubClassifyVC.h"
#import "DeliverySubClassifyCell.h"
#import "DeliveryClassifyBottomView.h"
#import "DeliverySubClassifyVM.h"
#import <MJRefresh.h>
#import "DeliveryAddClassifyView.h"
#import "DeliveryModifyClassifyView.h"
#import "DeliverySubClassifyDetailModel.h"
@interface DeliverySubClassifyVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *mainTableView;
@end

@implementation DeliverySubClassifyVC
{
    //编辑按钮
    UIButton *editBtn;
    //父级类别
    UILabel *fatherLabel;
    DeliveryClassifyBottomView *bottomView;
    DeliverySubClassifyVM *vm;
    NSInteger page;
    MJRefreshAutoNormalFooter *_footerRefresh;
    NSMutableArray *dataSource;
    BOOL selectAll;
    NSMutableArray *_deleteArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //数据相关
    [self initData];
    //添加上方view
    [self addTopView];
    //创建表视图
    [self createTableView];
    [self loadData];
}
- (void)initData
{
    self.navigationItem.title = NSLocalizedString(@"子类分级管理", nil);
    page = 1;
    dataSource = @[].mutableCopy;
    _deleteArray = @[].mutableCopy;
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
    [editBtn setTitle:NSLocalizedString(@"编辑", nil) forState:UIControlStateNormal];
    [editBtn setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateSelected];
    editBtn.titleLabel.font = FONT(18);
    [editBtn addTarget:self action:@selector(clickEditBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 60,0,60,50)];
    [addBtn setImage:[UIImage imageNamed:@"Delivery_add"] forState:UIControlStateNormal];
    addBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 15, 10, 15);
    [addBtn addTarget:self action:@selector(clickAddBtn:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:editBtn];
    [topView addSubview:addBtn];
    //添加父级别
    fatherLabel = [[UILabel alloc] initWithFrame:FRAME(0, 50, WIDTH, 35)];
    fatherLabel.textColor = HEX(@"333333", 1.0f);
    fatherLabel.font = FONT(15);
    fatherLabel.textAlignment = NSTextAlignmentCenter;
    fatherLabel.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
    [topView addSubview:fatherLabel];
    
    CALayer *lineLayer1 = [CALayer layer];
    lineLayer1.frame = FRAME(0, 84.5, WIDTH, 0.5);
    lineLayer1.backgroundColor = LINE_COLOR.CGColor;
    CALayer *lineLayer2 = [CALayer layer];
    lineLayer2.frame = FRAME(0, 49.5, WIDTH, 0.5);
    lineLayer2.backgroundColor = LINE_COLOR.CGColor;
    [topView.layer addSublayer:lineLayer2];
    [self.view addSubview:topView];
}
#pragma mark - 创建表视图
- (void)createTableView
{
    _mainTableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,85, WIDTH, HEIGHT - 64 - 50)
                                                              style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
        tableView.separatorColor = LINE_COLOR;
        tableView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:tableView];
        tableView.layoutMargins = UIEdgeInsetsZero;
        tableView.separatorInset = UIEdgeInsetsZero;
        //创建加载表尾
        _footerRefresh = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self
                                                              refreshingAction:@selector(loadData)];
        [_footerRefresh setTitle:@"" forState:MJRefreshStateIdle];//普通闲置状态
        tableView.mj_footer = _footerRefresh;
        tableView;
    });
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
    return section == 0 ? 0.01 : 10;
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DeliverySubClassifyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DeliverySubClassifyVCID"];
    if (!cell) {
        cell = [[DeliverySubClassifyCell alloc] initWithStyle:(UITableViewCellStyleDefault)
                                           reuseIdentifier:@"DeliverySubClassifyVCID"];
    }
    cell.dataModel = dataSource[indexPath.section];
    if (tableView.editing) {
        cell.titleLabel.frame = FRAME(40, 0,112, 44);
        
    }else{
        cell.titleLabel.frame = FRAME(10, 0,112, 44);
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
        NSString *sectionStr = @(indexPath.section).stringValue;
        if (![_deleteArray containsObject:sectionStr]) {
            [_deleteArray addObject:sectionStr];
            [self changeDeleteBtnStatus];
        }
        if (_deleteArray.count == dataSource.count) {
            bottomView.selectedAllBtn.selected = YES;
            selectAll = YES;
        }
    }else{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.editing) {
        NSString *sectionStr = @(indexPath.section).stringValue;
        if ([_deleteArray containsObject:sectionStr]) {
            [_deleteArray removeObject:sectionStr];
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
    NSString *sectionStr = @(indexPath.section).stringValue;
    if (selectAll || [_deleteArray containsObject:sectionStr]) {
        [_mainTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:0];
        [self tableView:_mainTableView didSelectRowAtIndexPath:indexPath];
    }
}
- (void)loadData
{
    SHOW_HUD
    [HttpTool postWithAPI:@"biz/waimai/product/cate/items"
               withParams:@{@"parent_id":_parent_id,
                            @"page":@(page++)}
                  success:^(id json) {
                      HIDE_HUD
                      NSLog(@"biz/waimai/product/cate/items---%@",json);
                      if ([json[@"error"] isEqualToString:@"0"]) {
                          vm = [DeliverySubClassifyVM yy_modelWithJSON:json[@"data"]];
                          [dataSource addObjectsFromArray:vm.items];
                          fatherLabel.text = vm.father;
                          [_mainTableView reloadData];
                      }else{
                          [JHShowAlert showAlertWithMsg:json[@"message"]];
                      }
                      
                      [_footerRefresh endRefreshing];
                  }
                  failure:^(NSError *error) {
                      HIDE_HUD
                      [_footerRefresh endRefreshing];
                      [JHShowAlert showAlertWithMsg:NSLocalizedString(@"服务器连接异常", nil)];
                  }];
}
#pragma mark - 点击编辑按钮
- (void)clickEditBtn:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected) {
        //将表视图切换到可编辑状态
        _mainTableView.frame = FRAME(0,85, WIDTH, HEIGHT - 64 - 100 - 35);
        _mainTableView.editing = YES;
        [self addBottomView];
        NSArray<DeliverySubClassifyCell*> *cellArray = [_mainTableView visibleCells];
        for (DeliverySubClassifyCell *cell in cellArray) {
            [UIView animateWithDuration:0.3 animations:^{
                cell.titleLabel.frame = FRAME(40, 0,112, 44);
            }];
        }
        _mainTableView.mj_footer = nil;
    }else{
        //将表视图切换到不可编辑状态
        _mainTableView.frame = FRAME(0,85, WIDTH, HEIGHT - 64 - 85);
        _mainTableView.editing = NO;
        [self hideBottomView];
        NSArray<DeliverySubClassifyCell*> *cellArray = [_mainTableView visibleCells];
        for (DeliverySubClassifyCell *cell in cellArray) {
            [UIView animateWithDuration:0.3 animations:^{
                cell.titleLabel.frame = FRAME(10, 0,112, 44);
            }];
        }
        _mainTableView.mj_footer = _footerRefresh;
    }
}
#pragma mark - 点击加号按钮
- (void)clickAddBtn:(UIButton *)sender
{
    __weak typeof(self)weakSelf = self;
    NSString *subtitle = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"一级分类:", nil),vm.father];
    __block  DeliveryAddClassifyView *backView = [[DeliveryAddClassifyView alloc]
                                                  initWithTitle:NSLocalizedString(@"添加二级分类", nil)
                                                  withSubTitle:subtitle
                                                  withRemindTitle:NSLocalizedString(@"请输入二级类别名称", nil)
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
    backView.parent_id = _parent_id;
    [self.view addSubview:backView];
}
#pragma mark - 添加底部视图
- (void)addBottomView
{
    if (!bottomView) {
        bottomView = [[DeliveryClassifyBottomView alloc] initWithFrame:FRAME(0, HEIGHT - 64, WIDTH, 50)];
        [bottomView.selectedAllBtn addTarget:self
                                      action:@selector(clickSelectedAllBtn:)
                            forControlEvents:(UIControlEventTouchUpInside)];
        [bottomView.deleteBtn addTarget:self
                                 action:@selector(clickDeleteBtn:)
                       forControlEvents:(UIControlEventTouchUpInside)];
    }
    [self.view addSubview:bottomView];
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
#pragma mark - 点击cell内的编辑按钮
- (void)clickCellEditBtn:(UIButton *)sender
{
    //获取indexPath
    UITableViewCell *cell = (UITableViewCell *)[sender superview];
    NSIndexPath *indexPath = [_mainTableView indexPathForCell:cell];
    NSInteger section = indexPath.section;
    DeliverySubClassifyDetailModel *dataModel = dataSource[section];
    NSString *subtitle = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"一级分类:", nil),vm.father];
    __weak typeof(self)weakSelf = self;
    __block DeliveryModifyClassifyView *backView = [[DeliveryModifyClassifyView alloc]
                                                    initWithTitle:NSLocalizedString(@"编辑子分类", nil)
                                                    withSubTitle:subtitle
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
                                                    withCateTitle:dataModel.title
                                                    withOrderBy:dataModel.orderby
                                                    withCate_id:dataModel.cate_id];
    
    
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
        NSArray<DeliverySubClassifyCell *> *visibleCells = [_mainTableView visibleCells];
        for (DeliverySubClassifyCell *cell in visibleCells) {
            NSIndexPath *indexPath = [_mainTableView indexPathForCell:cell];
            [self tableView:_mainTableView didSelectRowAtIndexPath:indexPath];
            [_mainTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    }else{ //取消全选
        selectAll = NO;
        [_deleteArray removeAllObjects];
        [self changeDeleteBtnStatus];
        NSArray<DeliverySubClassifyCell *> *visibleCells = [_mainTableView visibleCells];
        for (DeliverySubClassifyCell *cell in visibleCells) {
            NSIndexPath *indexPath = [_mainTableView indexPathForCell:cell];
            [self tableView:_mainTableView didDeselectRowAtIndexPath:indexPath];
            [_mainTableView deselectRowAtIndexPath:indexPath animated:NO];
        }
    }
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
        [JHShowAlert showAlertWithMsg:NSLocalizedString(@"未选择需要删除的分类", nil)];
        return;
    }
    
    [JHShowAlert showAlertWithTitle:nil withMessage:NSLocalizedString(@"您确定要删除吗?\n删除的话会使得子类下的商品一并删除,请谨慎操作!", nil) withBtn_cancel:NSLocalizedString(@"取消", nil) withBtn_sure:NSLocalizedString(@"确定", nil) withCancelBlock:^{
        [_deleteArray removeAllObjects];
        [self clickEditBtn:editBtn];
        
    } withSureBlock:^{
        NSMutableArray *cate_id = @[].mutableCopy;
        for (NSString *section in _deleteArray) {
            DeliverySubClassifyDetailModel *model = (DeliverySubClassifyDetailModel *)dataSource[section.integerValue];
            [cate_id addObject:model.cate_id];
        }
        //删除分类
        SHOW_HUD
        [HttpTool postWithAPI:@"biz/waimai/product/cate/delete"
                   withParams:@{@"cate_id":[cate_id componentsJoinedByString:@","]}
                      success:^(id json) {
                          HIDE_HUD
                          __weak typeof(self)weakSelf = self;
                          if ([json[@"error"] isEqualToString:@"0"]) {
                              [JHShowAlert showAlertWithMsg:NSLocalizedString(@"删除成功", nil)];
                              [dataSource removeAllObjects];
                              [weakSelf clickEditBtn:editBtn];
                              [weakSelf loadData];
                          }else{
                              [JHShowAlert showAlertWithMsg:NSLocalizedString(@"删除失败,请稍后再试", nil)];
                          }
                      }
                      failure:^(NSError *error) {
                          HIDE_HUD
                          [JHShowAlert showAlertWithMsg:NSLocalizedString(@"服务器连接异常", nil)];
                      }];

    }];
   
   }
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
