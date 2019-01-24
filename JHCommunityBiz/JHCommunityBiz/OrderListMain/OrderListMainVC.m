//
//  OrderListMainVC.m
//  JHCommunityBiz
//
//  Created by ijianghu on 2017/11/15.
//  Copyright © 2017年 com.jianghu. All rights reserved.
//

#import "OrderListMainVC.h"
#import "OrderListMainCell.h"
#import "DeliveryOrderVC.h"
#import "JHGroupOrderListMainVC.h"
#import "JHPreferentiaListVC.h"

@interface OrderListMainVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@end

@implementation OrderListMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
    [self tableView];
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
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
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
    static NSString *str = @"OrderListMainCell";
    OrderListMainCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[OrderListMainCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    NSArray *titleArr = @[ NSLocalizedString(@"外送订单", NSStringFromClass([self class])), NSLocalizedString(@"团购订单", NSStringFromClass([self class])), NSLocalizedString(@"优惠买单订单", NSStringFromClass([self class]))];
    
    NSArray *imgArr = @[IMAGE(@"icon_reconciliation01"),
                        IMAGE(@"icon_reconciliation02"),
                        IMAGE(@"icon_reconciliation03")];
    cell.imgV.image = imgArr[indexPath.section];
    cell.titleL.text = titleArr[indexPath.section];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
    if ([[JHShareModel shareModel].infoDictionary[@"waimai_open"] isEqualToString:@"1"]) {
            DeliveryOrderVC * vc = [[DeliveryOrderVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [JHShowAlert showAlertWithMsg: NSLocalizedString(@"您还没有开通外送,请先去开通外送", NSStringFromClass([self class])) withBtnTitle: NSLocalizedString(@"知道了", NSStringFromClass([self class])) withBtnBlock:^{
                Class  vcClass = NSClassFromString(@"JHdeliveryOpenVC");
                [self.navigationController pushViewController:[vcClass new] animated:YES];
            }];
       }
    }else if (indexPath.section == 1){
        JHGroupOrderListMainVC * vc = [[JHGroupOrderListMainVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        JHPreferentiaListVC * vc = [[JHPreferentiaListVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
