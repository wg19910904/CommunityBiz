//
//  JHEvaluateMainVC.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/13.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHEvaluateMainVC.h"
#import "StarView.h"
#import "UIButton+BackgroundColor.h"
#import "JHAllEvaluationVC.h"
#import "JHMediumEvaluationVC.h"
#import "JHGreatEvaluationVC.h"
#import "JHPoorEvaluationVC.h"
@interface JHEvaluateMainVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UILabel * label;//按钮底部移动的线
    UIButton * oldBtn;//指向旧的按钮的
    UICollectionView * myCollectionView;
    NSArray * vcArray;
    UILabel * label_percent;
    UIView * view;
}
@end

@implementation JHEvaluateMainVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化一些数据
    [self initData];
    //创建头部的View
    [self creatHeadView];
    //创建UICollectionView
    [self creatUICollectionView];
    //发送请求
    [self postHttp];
}
#pragma mark - 这是发送请求的方法
-(void)postHttp{
    [HttpTool postWithAPI:@"biz/waimai/comment/comment/items" withParams:@{@"page":@"1"} success:^(id json) {
        NSLog(@"%@",json);
        if ([json[@"error"] isEqualToString:@"0"]) {
           label_percent.text = [NSString stringWithFormat:@"%@％",json[@"data"][@"shop_info"][@"praise_bl"]];
            //创建显示星级的view
            UIView * starView = [StarView addEvaluateViewWithStarNO:[json[@"data"][@"shop_info"][@"avg_score"] floatValue]withStarSize:17 withBackViewFrame:FRAME(WIDTH/3 + 90, 5, WIDTH/3, 17)];
            [view addSubview:starView];
            UIView * starView1 = [StarView addEvaluateViewWithStarNO:[json[@"data"][@"shop_info"][@"fuwu"] floatValue]withStarSize:17 withBackViewFrame:FRAME(WIDTH/3 + 90, 30, WIDTH/3, 17)];
            [view addSubview:starView1];
            UIView * starView2 = [StarView addEvaluateViewWithStarNO:[json[@"data"][@"shop_info"][@"kouwei"] floatValue] withStarSize:17 withBackViewFrame:FRAME(WIDTH/3 + 90, 55, WIDTH/3, 17)];
            [view addSubview:starView2];
            [self creatUIButtonWithDictionary:json[@"data"][@"comment"]];
        }else{
            [JHShowAlert showAlertWithMsg:json[@"message"]];
        }
    } failure:^(NSError *error) {
        [JHShowAlert showAlertWithMsg:NSLocalizedString(@"服务器繁忙,请稍后访问", nil)];
        NSLog(@"%@",error.localizedDescription);
    }];
}
#pragma mark - 初始化一些数据
-(void)initData{
    self.navigationItem.title = NSLocalizedString(@"评价管理", nil);
    self.view.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    JHAllEvaluationVC * vc1 = [JHAllEvaluationVC new];
    JHGreatEvaluationVC * vc2 = [JHGreatEvaluationVC new];
    JHMediumEvaluationVC * vc3 =  [JHMediumEvaluationVC new];
    JHPoorEvaluationVC * vc4 = [JHPoorEvaluationVC new];
    vcArray = @[vc1,vc2,vc3,vc4];
}
#pragma mark - 这是创建头部的View
-(void)creatHeadView{
    view = [[UIView alloc]init];
    view.frame = FRAME(0, 0, WIDTH, 80);
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    //创建中间的分割线
    UILabel * label_line = [[UILabel alloc]init];
    label_line.frame = FRAME(WIDTH/3, 10, 1, 60);
    label_line.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    [view addSubview:label_line];
    //创建显示好评率百分比的label
    label_percent = [[UILabel alloc]init];
    label_percent.frame = FRAME(1, 15, WIDTH/3 - 2, 20);
    label_percent.text = @"0";
    label_percent.textColor = [UIColor colorWithRed:248/255.0 green:168/255.0 blue:37/255.0 alpha:1];
    label_percent.textAlignment = NSTextAlignmentCenter;
    label_percent.font = [UIFont systemFontOfSize:20];
    [view addSubview:label_percent];
    //创建显示好评的三个字的label
    UILabel * label_text = [[UILabel alloc]init];
    label_text.frame = FRAME(1, 45, WIDTH/3- 2, 20);
    label_text.text = NSLocalizedString(@"好评率", nil);
    label_text.textColor = [UIColor colorWithWhite:0.6 alpha:1];
    label_text.textAlignment = NSTextAlignmentCenter;
    label_text.font = [UIFont systemFontOfSize:15];
    [view addSubview:label_text];
    //创建后面显示服务态度和菜品口味的星级
    for(int i = 0; i < 3; i ++){
        //创建显示字体的两个label
        UILabel * label_title = [[UILabel alloc]init];
        label_title.frame = FRAME(WIDTH/3+20, 5+(15+10)*i, 60, 20);
        label_title.font = [UIFont systemFontOfSize:14];
        label_title.textColor = [UIColor colorWithWhite:0.2 alpha:1];
        [view addSubview:label_title];
        if (i == 0) {
            label_title.text = NSLocalizedString(@"综合", nil);
        }else if(i == 1){
             label_title.text = NSLocalizedString(@"服务", nil);
        }else{
             label_title.text = NSLocalizedString(@"商品", nil);
        }
    }
    }
#pragma mark - 创建头部的四个个按钮
-(void)creatUIButtonWithDictionary:(NSDictionary *)dic{
    NSArray * array = @[[NSString stringWithFormat:@"%@(%@)",NSLocalizedString(@"全部", nil),dic[@"all_comment"]],
                        [NSString stringWithFormat:@"%@(%@)",NSLocalizedString(@"好评", nil),dic[@"g_comment"]],
                        [NSString stringWithFormat:@"%@(%@)",NSLocalizedString(@"中评", nil),dic[@"z_comment"]],
                        [NSString stringWithFormat:@"%@(%@)",NSLocalizedString(@"差评", nil),dic[@"b_comment"]]];
    for (int i = 0; i < 4; i++) {
        UIButton * btn = [[UIButton alloc]init];
        btn.frame = FRAME(WIDTH/4*i, 90, WIDTH/4, 50);
        [btn setTitle:array[i] forState:UIControlStateNormal];
        if (i == 0) {
            btn.selected = YES;
            oldBtn = btn;
        }
        [btn setTitleColor:THEME_COLOR forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor colorWithWhite:0.6 alpha:1] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        btn.titleLabel.adjustsFontSizeToFitWidth = YES;
        btn.tag = i;
        btn.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:btn];
        [btn addTarget:self action:@selector(clickToChose:) forControlEvents:UIControlEventTouchUpInside];
    }
    //创建按钮底部移动的线
    label = [[UILabel alloc]init];
    label.frame = FRAME(0, 139, WIDTH/4, 1);
    label.backgroundColor = THEME_COLOR;
    [self.view addSubview:label];
}
#pragma mark - 这是点击选择的方法
-(void)clickToChose:(UIButton *)sender{
    oldBtn.selected = NO;
    sender.selected = !sender.selected;
    oldBtn = sender;
    [UIView animateWithDuration:0.2 animations:^{
        label.frame = FRAME(WIDTH/4*sender.tag, 139, WIDTH/4, 1);
    }];
    [myCollectionView setContentOffset:CGPointMake(WIDTH*sender.tag, 0) animated:YES];
}
#pragma mark - 创建UICollectionView
-(void)creatUICollectionView{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    myCollectionView = [[UICollectionView alloc]initWithFrame:FRAME(0, 140, WIDTH, HEIGHT - 140 - 64) collectionViewLayout:layout];
    myCollectionView.pagingEnabled = YES;
    myCollectionView.bounces = NO;
    myCollectionView.scrollEnabled = NO;
    [myCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    myCollectionView.delegate = self;
    myCollectionView.dataSource = self;
    [self.view addSubview:myCollectionView];
}
#pragma mark - UICollectionView的代理和数据源方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 4;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(WIDTH, HEIGHT - 140 - 64);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    JHBaseVC * vc = vcArray[indexPath.row];
    [self addChildViewController:vc];
    [cell addSubview:vc.view];
    return cell;
}

@end
