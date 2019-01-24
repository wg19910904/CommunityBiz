//
//  JHAttestationVC.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/23.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHAttestationVC.h"
#import "JHManagerAttestationVC.h"

@implementation JHAttestationVC{
    UITableView * myTableView;//表视图的对象
}
-(void)viewDidLoad{
     [super viewDidLoad];
   //初始化一些方法
    [self initData];
    //创建表视图
    [self creatUITableView];
}
#pragma mark - 初始化一些方法
-(void)initData{
    self.navigationItem.title =  NSLocalizedString(@"门店认证", NSStringFromClass([self class]));
    self.view.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
}
#pragma mark - 创建子视图
-(void)creatSubViewWithCell:(UITableViewCell *)cell{
    UIView * view = [UIView new];
    view.backgroundColor = [UIColor whiteColor];
    view.frame = FRAME(0, 0, WIDTH, 40);
    [cell addSubview:view];
    //创建显示认证资质提交
    UILabel * label_one = [[UILabel alloc]init];
    label_one.frame = FRAME(0, 10, WIDTH/3, 20);
    label_one.text = [NSString stringWithFormat:@"%@%@",@"1.", NSLocalizedString(@"认证资质提交", NSStringFromClass([self class]))];
    label_one.textAlignment = NSTextAlignmentRight;
    label_one.textColor = [UIColor colorWithWhite:0.3 alpha:1];
    label_one.font = [UIFont systemFontOfSize:15];
    [view addSubview:label_one];
    //创建显示等待审核
    UILabel * label_two = [[UILabel alloc]init];
    label_two.frame = FRAME(WIDTH/3*2, 10, WIDTH/3, 20);
    label_two.textColor = [UIColor colorWithWhite:0.3 alpha:1];
    label_two.font = [UIFont systemFontOfSize:15];
    label_two.text = [NSString stringWithFormat:@"%@%@",@"2.", NSLocalizedString(@"等待审核", NSStringFromClass([self class]))];
    [view addSubview:label_two];
    //创建中间的连接线
    UIView * view_line = [UIView new];
    view_line.frame = FRAME(WIDTH/3+5, 19.5, WIDTH/3 - 10, 0.5);
    view_line.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [view addSubview:view_line];
    //创建显示完成实名认证,保障店铺权益的label
    UILabel * label = [[UILabel alloc]init];
    label.frame = FRAME(0, 70,WIDTH, 20);
    label.text =  NSLocalizedString(@"完成实名认证,保障店铺权益", NSStringFromClass([self class]));
    label.font = [UIFont systemFontOfSize:17];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = THEME_COLOR;
    [cell addSubview:label];
    //创建显示图片的imageView
    UIImageView * imageView = [[UIImageView alloc]init];
    imageView.image = [UIImage imageNamed:@"certified_pic"];
    imageView.frame = FRAME(50, 130, WIDTH - 100, HEIGHT/2 - 30);
    [cell addSubview:imageView];
    //创建立即认证的按钮
    UIButton * btn = [[UIButton alloc]init];
    btn.frame = FRAME(20, HEIGHT/2 + 120, WIDTH - 40, 45);
    [btn setTitle: NSLocalizedString(@"去设置", NSStringFromClass([self class])) forState:UIControlStateNormal];
    btn.layer.cornerRadius = 3;
    btn.layer.masksToBounds = YES;
    [btn setBackgroundColor:[UIColor colorWithRed:250/255.0 green:175/255.0 blue:25/255.0 alpha:1] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor colorWithRed:250/255.0 green:175/255.0 blue:25/255.0 alpha:0.5] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(btnClickToAttestation:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:btn];
}
#pragma mark - 这是点击按纽的方法
-(void)btnClickToAttestation:(UIButton *)sender{
    NSLog(@"点击了立即认证的方法");
    JHManagerAttestationVC * vc = [[JHManagerAttestationVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 创建表视图
-(void)creatUITableView{
    myTableView = [[UITableView alloc]initWithFrame:FRAME(0, 0, WIDTH, HEIGHT - 64) style:UITableViewStylePlain];
    myTableView.tableFooterView = [UIView new];
    myTableView.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [self.view addSubview:myTableView];
}
#pragma mark - 这是表视图的代理和数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return HEIGHT - 64;
}
-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    //添加子视图
    [self creatSubViewWithCell:cell];
    return cell;
}
@end
