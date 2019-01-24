//
//  JHWaiMaiSubNavClassifyVC.m
//  JHCommunityClient
//
//  Created by xixixi on 16/3/11.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "DeliverySubShelfVC.h"

@interface DeliverySubShelfVC ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic,copy)NSArray *dataArray;
@property(nonatomic,assign)NSInteger selectRow;
@end

@implementation DeliverySubShelfVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    //创建左右表视图
    [self createTables];
    
}
- (void)initData
{
    self.backBtn.hidden = YES;
    self.view.frame = FRAME(0, 40, WIDTH, HEIGHT - 104);
    self.view.backgroundColor = HEX(@"000000", 0.3);
}
#pragma mark - 处理数据源
- (NSArray *)dataArray
{
    return @[NSLocalizedString(@"未上架", nil),NSLocalizedString(@"已上架", nil)];
//    return @[NSLocalizedString(@"未上架", nil),NSLocalizedString(@"已上架", nil),NSLocalizedString(@"已过期", nil)];
}
#pragma mark - 创建表视图
- (void)createTables
{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:FRAME(0, 0, WIDTH, 88)
                                                      style:(UITableViewStyleGrouped)];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = [UIColor whiteColor];
        _mainTableView.separatorColor = LINE_COLOR;
        _mainTableView.showsVerticalScrollIndicator = YES;
        _mainTableView.layoutMargins = UIEdgeInsetsZero;
        _mainTableView.separatorInset = UIEdgeInsetsZero;
        [self.view addSubview:_mainTableView];
    }
}
#pragma mark - UITableViewDelegate and datasoure

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.backgroundColor = HEX(@"f5f5f5", 1.0f);
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(0, 0, WIDTH, 44)];
    UIView *selectedBV = [[UIView alloc] initWithFrame:cell.bounds];
    selectedBV.backgroundColor = [UIColor whiteColor];
    cell.selectedBackgroundView = selectedBV;
    titleLabel.text = self.dataArray[indexPath.row];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = FONT(15);
    titleLabel.textColor = HEX(@"666666", 1.0f);
    titleLabel.tag = 100;
    if (_selectRow && (indexPath.row == _selectRow)) {
        titleLabel.textColor = THEME_COLOR;
    }
    //添加下划线
    CALayer *lineLayer = [[CALayer alloc] init];
    lineLayer.backgroundColor = LINE_COLOR.CGColor;
    lineLayer.frame = FRAME(0, 43.5, WIDTH, 0.5);
    [cell.layer addSublayer:lineLayer];
    [cell addSubview:titleLabel];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:100];
    titleLabel.textColor = THEME_COLOR;
    UIView *bg_view = [[UIView alloc] initWithFrame:cell.bounds];
    bg_view.backgroundColor = HEX(@"e4e7f7", 1.0f);
    cell.selectedBackgroundView = bg_view;
    NSArray *paramArray = @[@"0",@"1"];
    //构建参数
    NSDictionary *paramDic = @{@"status":paramArray[indexPath.row]};
    _refreshBlock(paramDic);
    _refreshBtnTitleBlock(self.dataArray[indexPath.row]);
    [self touch_BackView];
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:100];
    titleLabel.textColor = HEX(@"666666", 1.0f);
}
- (void)touch_BackView
{
    [self removeFromParentViewController];
    [self.view removeFromSuperview];
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:@"JHDeleteNavVCNotificationName" object:self userInfo:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
