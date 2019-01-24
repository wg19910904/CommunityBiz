//
//  DeliveryProductGuigeVC.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/7/5.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "DeliveryProductGuigeVC.h"
#import "DeliveryProductGuigeVM.h"
#import "DeliveryProductGuigeCell.h"
#import "DeliveryProductAddGuigeVC.h"
#import "DeliveryProductModifyGuigeVC.h"
@interface DeliveryProductGuigeVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *mainTableView;
@end

@implementation DeliveryProductGuigeVC
{
    DeliveryProductGuigeVM *vm;
    NSMutableArray *dataSource;
    UIButton *_addBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self addBottomView];
}
- (void)initData
{
    [self.view addSubview:self.mainTableView];
    dataSource = @[].mutableCopy;
}
- (void)addBottomView
{
    _addBtn = [[UIButton alloc] initWithFrame:FRAME(0, HEIGHT - 64 - 50, WIDTH , 50)];
    [_addBtn setTitle:NSLocalizedString(@"添加新商品", nil) forState:(UIControlStateNormal)];
    [_addBtn setBackgroundColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [_addBtn setBackgroundColor:HEX(@"faaf19", 1.0) forState:(UIControlStateHighlighted)];
    [_addBtn setImage:IMAGE(@"Delivery_add-to") forState:(UIControlStateNormal)];
    [_addBtn setTitleColor:HEX(@"333333", 1.0f) forState:(UIControlStateNormal)];
    _addBtn.titleLabel.font = FONT(15);
    [_addBtn addTarget:self action:@selector(addGuige:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:_addBtn];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
}
- (void)loadData
{
    SHOW_HUD
    [HttpTool postWithAPI:@"biz/waimai/product/spec/items"
               withParams:@{@"product_id":_product_id}
                  success:^(id json) {
                      HIDE_HUD
                      NSLog(@"biz/waimai/product/spec/items--%@",json);
                      if ([json[@"error"] isEqualToString:@"0"]) {
                          vm = [DeliveryProductGuigeVM yy_modelWithJSON:json[@"data"]];
                          self.navigationItem.title = vm.product_name;
                          [dataSource removeAllObjects];
                          [dataSource addObjectsFromArray:vm.items];
                          [_mainTableView reloadData];
                      }else{
                          [JHShowAlert showAlertWithMsg:json[@"message"]];
                      }
                  }
                  failure:^(NSError *error) {
                      HIDE_HUD
                      [JHShowAlert showAlertWithMsg:NSLocalizedString(@"服务器异常", nil)];
                  }];
}
- (UITableView *)mainTableView
{
    _mainTableView = ({
        
        UITableView *table = [[UITableView alloc] initWithFrame:FRAME(0, 0, WIDTH, HEIGHT - 64 -50)
                                                          style:UITableViewStyleGrouped];
        table.delegate = self;
        table.dataSource = self;
        table.separatorColor = LINE_COLOR;
        table.separatorInset = UIEdgeInsetsZero;
        table.layoutMargins = UIEdgeInsetsZero;
        table;
    });
    return _mainTableView;
}
#pragma mark - tableView delegate and dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataSource.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 125;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DeliveryProductGuigeCell *cell = [_mainTableView dequeueReusableCellWithIdentifier:@"DeliveryProductGuigeCellID"];
    if (!cell) {
        cell = [[DeliveryProductGuigeCell alloc] initWithStyle:(UITableViewCellStyleDefault)
                                                reuseIdentifier:@"DeliveryProductGuigeCellID"];
    }
    cell.dataModel = dataSource[indexPath.row];
    [cell.modifyBtn addTarget:self
                       action:@selector(clickCellModifyBtn:)
             forControlEvents:(UIControlEventTouchUpInside)];
    [cell.deleteBtn addTarget:self
                       action:@selector(clickCellDeleteBtn:)
             forControlEvents:(UIControlEventTouchUpInside)];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DeliveryProductGuigeCellModel *cellModel = (DeliveryProductGuigeCellModel *)dataSource[indexPath.row];
    DeliveryProductModifyGuigeVC *vc = [[DeliveryProductModifyGuigeVC alloc] init];
    vc.dataModel = cellModel;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 添加规格
- (void)addGuige:(UIButton *)sender
{
    DeliveryProductAddGuigeVC *vc = [[DeliveryProductAddGuigeVC alloc] init];
    vc.product_id = _product_id;
    vc.titleS = self.navigationItem.title;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 点击cell内的修改按钮
- (void)clickCellModifyBtn:(UIButton *)sender
{
    DeliveryProductGuigeCell *cell = (DeliveryProductGuigeCell *)[sender superview];
    NSInteger row = [_mainTableView indexPathForCell:cell].row;
    DeliveryProductGuigeCellModel *cellModel = (DeliveryProductGuigeCellModel *)dataSource[row];
    DeliveryProductModifyGuigeVC *vc = [[DeliveryProductModifyGuigeVC alloc] init];
    vc.dataModel = cellModel;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 点击cell内的删除按钮
- (void)clickCellDeleteBtn:(UIButton *)sender
{
    DeliveryProductGuigeCell *cell = (DeliveryProductGuigeCell *)[sender superview];
    NSInteger row = [_mainTableView indexPathForCell:cell].row;
    DeliveryProductGuigeCellModel *cellModel = (DeliveryProductGuigeCellModel *)dataSource[row];
    SHOW_HUD
    [HttpTool postWithAPI:@"biz/waimai/product/spec/delete"
               withParams:@{@"spec_id":cellModel.spec_id}
                  success:^(id json) {
                      HIDE_HUD
                      NSLog(@"biz/waimai/product/spec/delete--%@",json);
                      if ([json[@"error"] isEqualToString:@"0"]) {
                          [dataSource removeObject:cellModel];
                          [_mainTableView deleteRowsAtIndexPaths:@[[_mainTableView indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationBottom];
                      }else{
                          [JHShowAlert showAlertWithMsg:json[@"message"]];
                      }
                  }
                  failure:^(NSError *error) {
                      HIDE_HUD
                      [JHShowAlert showAlertWithMsg:NSLocalizedString(@"服务器异常", nil)];
                  }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
