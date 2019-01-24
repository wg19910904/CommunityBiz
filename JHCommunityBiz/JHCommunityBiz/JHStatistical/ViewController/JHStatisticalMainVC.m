//
//  JHStatisticalMainVC.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/11.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHStatisticalMainVC.h"
#import "JHBaseVC.h"
#import "JHIncomeStatiscalVC.h"
#import "JHOrderStatiscalVC.h"
#import "JHSourceStatiscalVC.h"
#import "MarketStatiscalVC.h"
@interface JHStatisticalMainVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    NSArray * titleArray;//存放标题的数组
    UIButton * oldBtn;//保存旧的按钮的
    UILabel * label_line;//移动的线
    UICollectionView * myCollectionView;//创建对象
    NSMutableArray * vcArray;//存放三个界面的数组
}
@end

@implementation JHStatisticalMainVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化一些数据
    [self initData];
    //创建头部的三个按钮
    [self creatHeaderUIButton];
    //创建UICollectionv
    [self creatUICollectionView];
}
#pragma mark - 这是初始化一些数据的
-(void)initData{
    //设置标题
    self.navigationItem.title = NSLocalizedString(@"统计报表", nil);
    //初始化数组
    titleArray = @[NSLocalizedString(@"收入统计", nil),NSLocalizedString(@"订单统计", nil),NSLocalizedString(@"订单来源", nil),NSLocalizedString(@"商品销量", nil)];
    JHIncomeStatiscalVC * vc1 = [JHIncomeStatiscalVC new];
    JHOrderStatiscalVC * vc2 = [JHOrderStatiscalVC new];
    JHSourceStatiscalVC * vc3 = [JHSourceStatiscalVC new];
    MarketStatiscalVC * vc4 = [MarketStatiscalVC new];
    vcArray = [NSMutableArray arrayWithObjects:vc1,vc2,vc3,vc4, nil];
}
#pragma mark - 创建头部的三个按钮
-(void)creatHeaderUIButton{
    for (int i = 0; i < 4; i ++) {
        UIButton * btn = [[UIButton alloc]init];
        btn.frame = FRAME(WIDTH/4*i, 0, WIDTH/4, 50);
        if (i == 0) {
            btn.selected = YES;
            oldBtn = btn;
        }
        btn.tag = i;
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithWhite:0.4 alpha:1] forState:UIControlStateNormal];
        [btn setTitleColor:THEME_COLOR forState:UIControlStateSelected];
        btn.titleLabel.font = FONT(16);
        [self.view addSubview:btn];
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        UILabel * line = [[UILabel alloc]init];
        line.frame = FRAME(0, 49.5, WIDTH/3, 0.5);
        line.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        [btn addSubview:line];
    }
    //创建移动的线
    label_line = [[UIView alloc]init];
    label_line.frame = FRAME(0, 49, WIDTH/4, 1);
    label_line.backgroundColor = THEME_COLOR;
    [self.view addSubview:label_line];
}
#pragma mark - 这是点击头部的按钮的方法
-(void)click:(UIButton *)sender{
    oldBtn.selected = NO;
    sender.selected = !sender.selected;
    oldBtn = sender;
    [UIView animateWithDuration:0.3 animations:^{
        label_line.frame = FRAME(WIDTH/4*sender.tag, 49, WIDTH/4, 1);
    }];
    [myCollectionView setContentOffset:CGPointMake(sender.tag*WIDTH, 0) animated:YES];
}
#pragma mark - 创建UICollectionView
-(void)creatUICollectionView{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    myCollectionView = [[UICollectionView alloc]initWithFrame:FRAME(0, 50, WIDTH, HEIGHT - 64- 50) collectionViewLayout:layout];
    myCollectionView.scrollEnabled = NO;
    myCollectionView.bounces = NO;
    myCollectionView.pagingEnabled = YES;
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
    return CGSizeMake(WIDTH, HEIGHT - 64 - 50);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    JHBaseVC * vc = vcArray[indexPath.row];
    [self addChildViewController:vc];
    [cell addSubview:vc.view];
    return cell;
}
@end
