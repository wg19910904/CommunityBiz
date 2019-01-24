//
//  JHFfunctionVC.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/7/29.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHFfunctionVC.h"
#import "JHFunctionCell.h"
#import "JHFunctionModel.h"
@interface JHFfunctionVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView * myTableView;
    NSString *  tuan;
    NSString *  quan;
    NSString *  maidan;
    NSString *  waimai;
}
@end

@implementation JHFfunctionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化一些数据的方法
    [self initData];
    //创建表视图的方法
    [self creatUITableView];
}
#pragma mark - 这是初始化一些数据的方法
-(void)initData{
    self.navigationItem.title =  NSLocalizedString(@"功能开启", NSStringFromClass([self class]));
  
        if ([[JHShareModel shareModel].infoDictionary[@"have_waimai"] isEqualToString:@"1"]) {
            waimai = @"1";
        }else{
            waimai = @"0";
        }
   
        if ([[JHShareModel shareModel].infoDictionary[@"have_maidan"] isEqualToString:@"1"]) {
            maidan = @"1";
        }else{
            maidan = @"0";
        }
        if ([[JHShareModel shareModel].infoDictionary[@"have_tuan"] isEqualToString:@"1"]) {
            tuan = @"1";
        }else{
            tuan = @"0";
        }
        if ([[JHShareModel shareModel].infoDictionary[@"have_quan"] isEqualToString:@"1"]) {
            quan = @"1";
        }else{
            quan = @"0";
        }
}
#pragma mark - 这是创建表视图的方法
-(void)creatUITableView{
    myTableView = [[UITableView alloc]initWithFrame:FRAME(0,0 , WIDTH, HEIGHT - 64) style:UITableViewStyleGrouped];
    myTableView.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    myTableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:myTableView];
    [myTableView registerClass:[JHFunctionCell class] forCellReuseIdentifier:@"cell"];
    myTableView.delegate = self;
    myTableView.dataSource = self;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section < 3) {
        JHFunctionCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.indexPath = indexPath;
        cell.model = [JHFunctionModel new];
        [cell.mySwitch addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
        return cell;
  
    }else{
        UITableViewCell * cell = [[UITableViewCell alloc]init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIButton * btn = [[UIButton alloc]initWithFrame:FRAME(10, 2, WIDTH - 20, 40)];
        [btn setTitle: NSLocalizedString(@"确认提交", NSStringFromClass([self class])) forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor colorWithRed:248/255.0 green:168/255.0 blue:37/255.0 alpha:1] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor colorWithRed:248/255.0 green:168/255.0 blue:37/255.0 alpha:0.5] forState:UIControlStateHighlighted];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        btn.layer.cornerRadius = 3;
        btn.clipsToBounds = YES;
        [btn addTarget:self action:@selector(clickToCompletion:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:btn];
        return cell;
    }
}
-(void)valueChange:(UISwitch *)sender{
     NSDictionary * dic = [JHShareModel shareModel].infoDictionary;
    if (sender.on) {
        if (sender.tag == 0) {
            //外送
            waimai = @"1";
            [dic setValue:@"1" forKey:@"have_waimai"];
        }else if(sender.tag == 1){
            //优惠买单
            maidan = @"1";
            [dic setValue:@"1" forKey:@"have_maidan"];
        }else if(sender.tag == 2){
            //团购
            tuan = @"1";
             [dic setValue:@"1" forKey:@"have_tuan"];
        }else {
            //代金券
            quan  = @"1";
           [dic setValue:@"1" forKey:@"have_quan"];
        }

    }else{
        if (sender.tag == 0) {
            //外送
            waimai = @"0";
             [dic setValue:@"0" forKey:@"have_waimai"];
        }else if(sender.tag == 1){
            //优惠买单
            maidan = @"0";
            [dic setValue:@"0" forKey:@"have_maidan"];
        }else if(sender.tag == 2){
            //团购
            tuan = @"0";
            [dic setValue:@"0" forKey:@"have_tuan"];
        }else {
            //代金券
            quan  = @"0";
            [dic setValue:@"0" forKey:@"have_quan"];
        }
    }
}
-(void)clickToCompletion:(UIButton *)sender{
    SHOW_HUD
    [HttpTool postWithAPI:@"biz/shop/shop/open" withParams:@{@"have_tuan":tuan,
                                                             @"have_quan":quan,
                                                             @"have_maidan":maidan,
                                                             @"have_waimai":waimai} success:^(id json) {
        NSLog(@"json>>>%@",json);
         if ([json[@"error"] isEqualToString:@"0"]) {
             [JHShowAlert showAlertWithMsg: NSLocalizedString(@"提交成功", NSStringFromClass([self class])) withBtnTitle: NSLocalizedString(@"知道了", NSStringFromClass([self class])) withBtnBlock:^{
             [self.navigationController popViewControllerAnimated:YES];
             }];
         }else{
             [JHShowAlert showAlertWithMsg:json[@"message"]];
         }
         HIDE_HUD
    } failure:^(NSError *error) {
        HIDE_HUD
        [JHShowAlert showAlertWithMsg: NSLocalizedString(@"服务器繁忙,请稍后访问", NSStringFromClass([self class]))];
        NSLog(@"%@",error.localizedDescription);
    }];
}
@end
