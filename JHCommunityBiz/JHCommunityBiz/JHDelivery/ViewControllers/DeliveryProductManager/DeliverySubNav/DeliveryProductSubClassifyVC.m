//
//  JHSubNavClassifyVC.m
//  JHCommunityClient
//
//  Created by xixixi on 16/2/27.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "DeliveryProductSubClassifyVC.h"
#import "HttpTool.h"
@interface DeliveryProductSubClassifyVC ()<UITableViewDelegate, UITableViewDataSource>
@end

@implementation DeliveryProductSubClassifyVC
{
    //全部数据源
    NSArray *waimaiShopCateArray;
    //右侧表视图数据源
    NSMutableArray *rightDataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self createLeftTable];
    [self createRightTable];
    //请求新数据
    [self loadNewData];
}
- (void)initData
{
    self.view.frame = FRAME(0, 40, WIDTH, HEIGHT -104);
    self.view.backgroundColor = HEX(@"000000", 0.3);
    rightDataArray = @[].mutableCopy;
}
#pragma mark - 请求新数据
- (void)loadNewData
{
    //请求数据
    [HttpTool postWithAPI:@"biz/waimai/product/cate/items"
               withParams:@{}
                  success:^(id json) {
                      NSLog(@"biz/waimai/product/cate/all---%@",json);
                      if ([json[@"error"] isEqualToString:@"0"]) {
                          waimaiShopCateArray = json[@"data"][@"items"];
                          [_leftTable reloadData];
                          [_rightTable reloadData];
                      }else{
                          [JHShowAlert showAlertWithMsg:json[@"measage"]];
                      }
                  }
                  failure:^(NSError *error) {
                      NSLog(@"%@",error.localizedDescription);
                  }];
}
#pragma mark - 创建左侧表视图
- (void)createLeftTable
{
    if (!_leftTable) {
        _leftTable = [[UITableView alloc] initWithFrame:FRAME(0, 0, WIDTH *0.4, 250)
                                                  style:(UITableViewStylePlain)];
        _leftTable.delegate = self;
        _leftTable.dataSource = self;
        _leftTable.showsVerticalScrollIndicator = YES;
        _leftTable.tag = 100;
        _leftTable.backgroundColor = HEX(@"f5f5f5", 1.0f);
        _leftTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _leftTable.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_leftTable];
    }else{
        
    }
}
#pragma mark - 创建右侧表视图
- (void)createRightTable
{
    if (!_rightTable) {
        _rightTable = [[UITableView alloc] initWithFrame:FRAME(WIDTH *0.4, 0, WIDTH-120, 250)
                                                   style:(UITableViewStylePlain)];
        _rightTable.delegate = self;
        _rightTable.dataSource = self;
        _rightTable.showsVerticalScrollIndicator = NO;
        _rightTable.tag = 200;
        _rightTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _rightTable.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_rightTable];
    }else{
        [_rightTable reloadData];
    }
}
#pragma mark - UITableViewDelegate and datasoure
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (tableView.tag) {
        case 100:  //左
            return waimaiShopCateArray.count>0 ? waimaiShopCateArray.count+1:0;
            break;
        case 200:  //右
            return rightDataArray.count;
            break;
        default:
            return 0;
            break;
    }
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
    NSInteger row = indexPath.row;
    CGFloat width = CGRectGetWidth(tableView.bounds);
    switch (tableView.tag) {
        case 100:
        {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:FRAME(0, 0, WIDTH * 0.4, 44)];
            cell.backgroundColor = HEX(@"f5f5f5", 1.0f);
            UIView *selectedBV = [[UIView alloc] initWithFrame:cell.bounds];
            selectedBV.backgroundColor = [UIColor whiteColor];
            cell.selectedBackgroundView = selectedBV;
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(20, 0, width-20, 44)];
            titleLabel.font = FONT(15);
            titleLabel.textColor = HEX(@"666666", 1.0f);
            titleLabel.tag = 100;
            if (row == 0) {
                titleLabel.text = NSLocalizedString(@"全部分类", nil);
            }else{
                titleLabel.text = waimaiShopCateArray[row - 1][@"title"];
            }
            //添加下边线
            CALayer *lineLayer = [[CALayer alloc] init];
            lineLayer.frame = FRAME(0, 43.3, width, 0.7);
            lineLayer.backgroundColor = LINE_COLOR.CGColor;
            [cell.layer addSublayer:lineLayer];
            [cell addSubview:titleLabel];
            return cell;
        }
            break;
        case 200:
        {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:FRAME(0, 0, width, 40)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel * titleLabel = [[UILabel alloc] initWithFrame:FRAME(20, 0, width-20, 40)];
            titleLabel.font = FONT(15);
            titleLabel.textColor = HEX(@"666666", 1.0f);
            titleLabel.text = rightDataArray[row][@"title"];
            titleLabel.tag = 100;
            //添加下边线
            CALayer * lineLayer = [[CALayer alloc] init];
            lineLayer.frame = FRAME(0, 39.3, width, 0.7);
            lineLayer.backgroundColor = LINE_COLOR.CGColor;
            [cell.layer addSublayer:lineLayer];
            [cell addSubview:titleLabel];
            return cell;
        }
            break;
        default:
            return nil;
            break;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:100];
    titleLabel.textColor = THEME_COLOR;
    if (tableView == _leftTable) {
        if (row == 0) {
            //刷新商家列表
            rightDataArray = @[].mutableCopy;
            [_rightTable reloadData];
            //获取要添加的字典
            NSDictionary *paramDic = @{@"cate_id":@(0)};
            //block回调
            _refreshBlock(paramDic);
            _refreshBtnTitleBlock(@"全部分类");
            [self touch_BackView];
        }else{
            rightDataArray = waimaiShopCateArray[row - 1][@"childrens"];
            if (rightDataArray.count == 0) {
                //获取要添加的字典
                NSDictionary *temDic = waimaiShopCateArray[row-1];
                NSDictionary *paramDic = @{@"cate_id":temDic[@"cate_id"]};
                //block回调
                _refreshBlock(paramDic);
                _refreshBtnTitleBlock(temDic[@"title"]);
                [self touch_BackView];
            }
            [_rightTable reloadData];
        }
    }else{
        //获取分类id
        NSDictionary *temDic = rightDataArray[row];
        NSDictionary *paramDic = @{@"cate_id":temDic[@"cate_id"]};
        //block回调
        _refreshBlock(paramDic);
        _refreshBtnTitleBlock(temDic[@"title"]);
        [self touch_BackView];
    }
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

