//
//  JHMainMessageVC.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/10.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHMainMessageVC.h"
#import "UIButton+BackgroundColor.h"
#import "JHOrderMessageVC.h"
#import "JHEvaluateMessageVC.h"
#import "JHComplainMessageVC.h"
#import "JHSystemMessageVC.h"
#import "JHBaseVC.h"
#import "JHMessageModel.h"
@interface JHMainMessageVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,JHOrderMessageDelegate>
{
    NSArray * titleArray;//存放四个小标题的
    NSArray * imageArray;//存放四张图片的
    UICollectionView * myCollectionView;//创建对象
    UILabel * label_orderMsg;//指向订单消息总数的
    UILabel * label_evaluateMsg;//指向评价消息总数的
    UILabel * label_complainMsg;//指向投诉消息总数的
    UILabel * label_systemMsg;//指向系统消息总数的
    JHOrderMessage * vc_order;
    JHEvaluateMessageVC * vc_evalutate;
    JHComplainMessageVC * vc_complain;
    JHSystemMessageVC * vc_system;
    NSString * type;
}
@end

@implementation JHMainMessageVC
//界面将要出现的时候调用的方法
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //隐藏tabbar
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //标题
    self.navigationItem.title = NSLocalizedString(@"消息管理", nil);
    //初始化
    [self initData];
    //创建头上的四个按钮
    [self creatHeaderUIButton];
    //创建UICollectionView
    [self creatUICollectionView];
    //发送请求
    [self postHttpWithPage:@"1" withType:type];
}
#pragma mark - 这是请求各个数据的总数的方法
-(void)postHttpWithPage:(NSString *)newPage withType:(NSString *)newType{
       [HttpTool postWithAPI:@"biz/shop/msg/items" withParams:@{@"page":newPage,@"type":newType} success:^(id json) {
        NSLog(@"%@",json);
        if ([json[@"error"] isEqualToString:@"0"]) {
            if ([json[@"data"][@"odrmsg_count"] isEqualToString:@"0"]) {
                label_orderMsg.hidden = YES;
            }else{
                label_orderMsg.text = json[@"data"][@"odrmsg_count"];
                label_orderMsg.hidden = NO;
            }
            if ([json[@"data"][@"pijmsg_count"] isEqualToString:@"0"]) {
                label_evaluateMsg.hidden = YES;
            }else{
                label_evaluateMsg.text = json[@"data"][@"pijmsg_count"];
                label_evaluateMsg.hidden = NO;
            }
            if ([json[@"data"][@"tsumsg_count"] isEqualToString:@"0"]) {
                label_complainMsg.hidden = YES;
            }else{
                label_complainMsg.text = json[@"data"][@"tsumsg_count"];
                label_complainMsg.hidden = NO;
            }
            if ([json[@"data"][@"sysmsg_count"] isEqualToString:@"0"]) {
                label_systemMsg.hidden = YES;
            }else{
                label_systemMsg.text = json[@"data"][@"sysmsg_count"];
                label_systemMsg.hidden = NO;
            }
        }else{
          [JHShowAlert showAlertWithMsg:json[@"message"]];
        }
    } failure:^(NSError *error) {
       [JHShowAlert showAlertWithMsg:NSLocalizedString(@"服务器繁忙,请稍后访问", nil)];
        NSLog(@"%@",error.localizedDescription);
    }];
}
#pragma mark - 初始化一些对象
-(void)initData{
    type = @"1";
    //初始化数组
    titleArray = @[NSLocalizedString(@"订单消息", nil),NSLocalizedString(@"评价消息", nil),NSLocalizedString(@"投诉消息", nil),NSLocalizedString(@"系统消息", nil)];
    imageArray = @[@"news_",@"news_evaluate",@"news_complaint",@"news_system"];
}
#pragma mark - 创建头上的四个按钮
-(void)creatHeaderUIButton{
    for (int i = 0; i < 4; i++ ) {
        UIButton * btn = [[UIButton alloc]init];
        btn.frame = CGRectMake(WIDTH/4*i, 0, WIDTH/4, 85);
        btn.tag = i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0.2] forState:UIControlStateHighlighted];
        [self.view addSubview:btn];
        //显示图片的
        UIImageView * imageView = [[UIImageView alloc]init];
        imageView.frame = FRAME((WIDTH/4-30)/2, 15, 33, 35);
        imageView.image = [UIImage imageNamed:imageArray[i]];
        [btn addSubview:imageView];
        //显示四个小标题的
        UILabel * label = [[UILabel alloc]init];
        label.frame = FRAME(0, 60, WIDTH/4, 20);
        label.text = titleArray[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        [btn addSubview:label];
        //显示未读信息的
        UILabel * label_msg = [[UILabel alloc]init];
        label_msg.backgroundColor = [UIColor redColor];
        label_msg.frame = FRAME((WIDTH/4-30)/2 - 5, 8, 15, 15);
        label_msg.layer.cornerRadius = 7.5;
        label_msg.layer.masksToBounds = YES;
        label_msg.textAlignment = NSTextAlignmentCenter;
        label_msg.adjustsFontSizeToFitWidth = YES;
        label_msg.textColor = [UIColor whiteColor];
        label_msg.font = [UIFont systemFontOfSize:11];
        label_msg.hidden = YES;
        if (i == 0) {
             label_orderMsg = label_msg;
        }else if (i == 1){
             label_evaluateMsg = label_msg;
        }else if (i == 2){
             label_complainMsg = label_msg;
        }else{
             label_systemMsg = label_msg;
        }
        [btn addSubview:label_msg];
    }
}
#pragma mark - 这是按钮的点击方法
-(void)btnClick:(UIButton *)sender{
    NSLog(@"点击了%ld",sender.tag);
    [myCollectionView setContentOffset:CGPointMake(WIDTH*sender.tag, 0)];
}
#pragma mark - 创建UICollectionView
-(void)creatUICollectionView{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
     layout.minimumLineSpacing = 0;
    myCollectionView = [[UICollectionView alloc]initWithFrame:FRAME(0, 85, WIDTH, HEIGHT - 64- 85) collectionViewLayout:layout];
    myCollectionView.scrollEnabled = NO;
    myCollectionView.bounces = NO;
    myCollectionView.pagingEnabled = YES;
    myCollectionView.backgroundColor = [UIColor whiteColor];
    [myCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    myCollectionView.dataSource = self;
    myCollectionView.delegate = self;
    [self.view addSubview:myCollectionView];
}
#pragma mark - UICollectionView的代理和数据源方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 4;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(WIDTH, HEIGHT - 64 - 85);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    __weak JHMainMessageVC * vcSelf = self;
    JHBaseVC * vc = nil;
    if (indexPath.row == 0) {
        if (vc_order == nil) {
        vc_order = [[JHOrderMessage alloc]init];
         vc_order.delegate = self;
        }
         vc= vc_order;
        
    }else if (indexPath.row == 1){
        if (vc_evalutate == nil) {
            vc_evalutate = [[JHEvaluateMessageVC alloc]init];
        }
        vc = vc_evalutate;
        [vc_evalutate setMyBlock:^(void){
           [vcSelf postHttpWithPage:@"1" withType:@"2"];
        }];
    }else if (indexPath.row ==2){
        if (vc_complain == nil) {
            vc_complain = [[JHComplainMessageVC alloc]init];
        }
        vc = vc_complain;
        [vc_complain setMyBlock:^(void){
            [vcSelf postHttpWithPage:@"1" withType:@"3"];
        }];
    }else{
        if (vc_system == nil) {
            vc_system = [[JHSystemMessageVC alloc]init];
        }
        vc = vc_system;
        [vc_system setMyBlock:^(void){
            [vcSelf postHttpWithPage:@"1" withType:@"4"];
        }];
    }
    [self addChildViewController:vc];
    [cell addSubview:vc.view];
    return cell;
}
-(void)refresh{
     [self postHttpWithPage:@"1" withType:@"1"];
}
@end
