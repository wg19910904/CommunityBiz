//
//  JHTrueToConsumeVC.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/25.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHTrueToConsumeVC.h"
#import "JHConsumeCell.h"
#import "JHConsumeModel.h"
#import "JHGroupOrderListMainVC.h"
@implementation JHTrueToConsumeVC{
    UITableView * myTableView;
    JHConsumeModel * detailModel;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    //这是初始化一些数据的方法
    [self initData];
    //添加表视图
    [self creatUITableView];
}
#pragma mark - 这是初始化一些数据的方法
-(void)initData{
    detailModel = [[JHConsumeModel alloc]init];
    detailModel.dic = self.dictionary;
    self.navigationItem.title =  NSLocalizedString(@"确认消费", NSStringFromClass([self class]));
}
#pragma mark - 这是创建表格的方法
-(void)creatUITableView{
    myTableView = [[UITableView alloc]initWithFrame:FRAME(0, 0, WIDTH, HEIGHT - 64) style:UITableViewStylePlain];
    myTableView.tableFooterView = [UIView new];
    myTableView.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //myTableView.scrollEnabled = NO;
    [self.view addSubview:myTableView];
    [myTableView registerClass:[JHConsumeCell class] forCellReuseIdentifier:@"cell"];
    myTableView.delegate = self;
    myTableView.dataSource = self;
}
#pragma mark - 这是表的代理和数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HEIGHT - 64;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JHConsumeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.model = detailModel;
    for (UIButton * btn in cell.btn_array) {
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}
#pragma mark - 这是点击取消或者确定调用的方法
-(void)clickBtn:(UIButton *)sender{
    if (sender.tag == 0) {
        NSLog(@"点击的是取消");
        [self.navigationController popViewControllerAnimated:YES];
    }else{
          SHOW_HUD
        NSLog(@"点击的是确定");
        [HttpTool postWithAPI:@"biz/quan/set" withParams:@{@"code":self.dictionary[@"tuan"][@"number"]} success:^(id json) {
            HIDE_HUD
            if ([json[@"error"] isEqualToString:@"0"]) {
                [JHShowAlert showAlertWithMsg: NSLocalizedString(@"核销成功", NSStringFromClass([self class])) withBtnTitle: NSLocalizedString(@"知道了", NSStringFromClass([self class])) withBtnBlock:^{
                    if (self.isFromTuanOrderDetai) {
                        NSArray * tempArray = self.navigationController.viewControllers;
                        for (JHBaseVC * vc in tempArray) {
                            if ([vc isKindOfClass:[JHGroupOrderListMainVC class]]) {
                                [self.navigationController popToViewController:vc animated:YES];
                            }
                        }
                    }else{
                        [self.navigationController popViewControllerAnimated:YES];   
                    }
                    
                }];
            }else{
                [JHShowAlert showAlertWithMsg:json[@"message"]];
            }
        } failure:^(NSError *error) {
            HIDE_HUD
            [JHShowAlert showAlertWithMsg: NSLocalizedString(@"服务器繁忙,请稍后访问", NSStringFromClass([self class]))];
            NSLog(@"%@",error.localizedDescription);
        }];
    }
}
@end
