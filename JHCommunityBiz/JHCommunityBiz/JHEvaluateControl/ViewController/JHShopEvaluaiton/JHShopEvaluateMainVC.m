//
//  JHShopEvaluateMainVC.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/25.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHShopEvaluateMainVC.h"
#import "StarView.h"
#import "JHShopEvaluateAllVC.h"
#import "JHShopEvaluateGreatVC.h"
#import "JHShopEvaluateMediulVC.h"
#import "JHShopEvaluatePoorVC.h"

@interface JHShopEvaluateMainVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UILabel * label;//按钮底部移动的线
    UIButton * oldBtn;//指向旧的按钮的
    UICollectionView * myCollectionView;
    NSArray * vcArray;
    UIView * view_bj;
}
@end
@implementation JHShopEvaluateMainVC
-(void)viewDidLoad{
    [super viewDidLoad];
    //这是初始化一些数据的方法
    [self initData];
    //添加一些子控件
    [self creatSubView];
    //创建UICollectionView
    [self creatUICollectionView];
    //发送请求
    [self postHttpWithPage];
}
#pragma mark - 这是发送请求的方法
-(void)postHttpWithPage{
    [HttpTool postWithAPI:@"biz/comment/items" withParams:@{@"page":@"1"} success:^(id json) {
        NSLog(@"%@",json);
        if ([json[@"error"] isEqualToString:@"0"]) {
            //创建总体星星评价的
            UIView * starView1 = [StarView addEvaluateViewWithStarNO:[json[@"data"][@"avg_score"] floatValue] >5?5.0:[json[@"data"][@"avg_score"] floatValue] withStarSize:17 withBackViewFrame:FRAME(115, 10, WIDTH/3, 17)];
            [view_bj addSubview:starView1];
            //创建头部的四个按钮
            [self creatUIButtonWithDictionary:json[@"data"][@"comment"]];
        }else{
            [JHShowAlert showAlertWithMsg:json[@"message"]];
            
        }
       
    } failure:^(NSError *error) {
      
        [JHShowAlert showAlertWithMsg:NSLocalizedString(@"服务器繁忙,请稍后访问", nil)];
        NSLog(@"%@",error.localizedDescription);
    }];
}

#pragma mark - 这是初始化一些数据的方法
-(void)initData{
    self.navigationItem.title = NSLocalizedString(@"评价管理", nil);
    self.view.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    JHShopEvaluateAllVC * vc1 = [[JHShopEvaluateAllVC alloc]init];
    JHShopEvaluateGreatVC * vc2 =  [[JHShopEvaluateGreatVC alloc]init];
    JHShopEvaluateMediulVC * vc3 = [[JHShopEvaluateMediulVC alloc]init];
    JHShopEvaluatePoorVC * vc4 = [[JHShopEvaluatePoorVC alloc]init];
    vcArray = @[vc1,vc2,vc3,vc4];
}
#pragma mark - 这是创建一些子控件的方法
-(void)creatSubView{
    //创建头部白色的背景
    view_bj = [[UIView alloc]init];
    view_bj.backgroundColor = [UIColor whiteColor];
    view_bj.frame = FRAME(0, 0, WIDTH, 40);
    [self.view addSubview:view_bj];
    //创建图标
    UIImageView * imageView = [[UIImageView alloc]init];
    imageView.frame = FRAME(10, 5, 30, 30);
    imageView.image = [UIImage imageNamed:@"Evaluation_write"];
    [view_bj addSubview:imageView];
    //创建显示
    UILabel * label_title = [[UILabel alloc]init];
    label_title.frame = FRAME(45, 10, 70, 20);
    label_title.text = NSLocalizedString(@"总体评价", nil);
    label_title.textColor = [UIColor colorWithWhite:0.3 alpha:1];
    label_title.font = [UIFont systemFontOfSize:15];
    [view_bj addSubview:label_title];
   
    
}
#pragma mark - 创建头部的四个个按钮
-(void)creatUIButtonWithDictionary:(NSDictionary *)dic{
    NSArray * array = @[[NSString stringWithFormat:@"%@(%@)",NSLocalizedString(@"全部", nil),dic[@"all_comment"]],
                        [NSString stringWithFormat:@"%@(%@)",NSLocalizedString(@"好评", nil),dic[@"g_comment"]],
                        [NSString stringWithFormat:@"%@(%@)",NSLocalizedString(@"中评", nil),dic[@"z_comment"]],
                        [NSString stringWithFormat:@"%@(%@)",NSLocalizedString(@"差评", nil),dic[@"b_comment"]]];
    for (int i = 0; i < 4; i++){
        UIButton * btn = [[UIButton alloc]init];
        btn.frame = FRAME(WIDTH/4*i, 50, WIDTH/4, 50);
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
    label.frame = FRAME(0, 99, WIDTH/4, 1);
    label.backgroundColor = THEME_COLOR;
    [self.view addSubview:label];
}
#pragma mark - 这是点击选择的方法
-(void)clickToChose:(UIButton *)sender{
    oldBtn.selected = NO;
    sender.selected = !sender.selected;
    oldBtn = sender;
    [UIView animateWithDuration:0.2 animations:^{
        label.frame = FRAME(WIDTH/4*sender.tag, 99, WIDTH/4, 1);
    }];
    [myCollectionView setContentOffset:CGPointMake(WIDTH*sender.tag, 0) animated:YES];
}
#pragma mark - 创建UICollectionView
-(void)creatUICollectionView{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    myCollectionView = [[UICollectionView alloc]initWithFrame:FRAME(0, 100, WIDTH, HEIGHT - 100 - 64) collectionViewLayout:layout];
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
    return CGSizeMake(WIDTH, HEIGHT - 100 - 64);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    JHBaseVC * vc = vcArray[indexPath.row];
    [cell addSubview:vc.view];
    [self addChildViewController:vc];
    return cell;
}
@end
