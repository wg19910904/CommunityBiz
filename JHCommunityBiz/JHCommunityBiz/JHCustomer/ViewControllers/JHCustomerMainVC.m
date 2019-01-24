//
//  JHCustomerMainVC.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/17.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHCustomerMainVC.h"
#import "JHOrderCustomerVC.h"
#import "JHMyFansVC.h"
@interface JHCustomerMainVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UIButton * oldBtn;//保存旧的按钮
    UIView * label_line;//移动的线
    UICollectionView * myCollectionView;//UICollectionView的对象
    NSMutableArray * vcArray;//存放三个界面的数组

}
@end

@implementation JHCustomerMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化一些数据
    [self initData];
    //创建头上的点击按钮
    [self creatUIButton];
    //创建UICollectionView
    [self creatUICollectionView];
    
}
#pragma mark - 这是初始化一些数据的方法
-(void)initData{
    self.navigationItem.title = NSLocalizedString(@"客户管理", nil);
    JHOrderCustomerVC * vc1 = [[JHOrderCustomerVC alloc]init];
    JHMyFansVC * vc2 = [[JHMyFansVC alloc]init];
    vcArray = [NSMutableArray arrayWithObjects:vc1,vc2, nil];
}
#pragma mark - 这是创建点击按钮的方法
-(void)creatUIButton{
    for (int i = 0; i < 2; i ++) {
        UIButton * btn = [[UIButton alloc]init];
        btn.frame = FRAME(WIDTH/2*i, 0, WIDTH/2, 40);
        if (i == 0) {
            [btn setTitle:NSLocalizedString(@"下单客户", nil) forState:UIControlStateNormal];
            btn.selected = YES;
            oldBtn = btn;
        }else{
            [btn setTitle:NSLocalizedString(@"我的粉丝", nil) forState:UIControlStateNormal];
        }
        btn.tag = i;
        [btn setTitleColor:THEME_COLOR forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor colorWithWhite:0.6 alpha:1] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    if (label_line == nil) {
        label_line = [[UIView alloc]init];
        label_line.backgroundColor = THEME_COLOR;
        label_line.frame = FRAME(0, 39, WIDTH/2, 0.5);
        [self.view addSubview:label_line];
    }
}
#pragma mark - 这是点击按钮调用的方法
-(void)clickBtn:(UIButton *)sender{
    oldBtn.selected = NO;
    sender.selected = !sender.selected;
    oldBtn = sender;
    [UIView animateWithDuration:0.2 animations:^{
        label_line.frame = FRAME(WIDTH/2*sender.tag,39, WIDTH/2, 0.5);
    }];
    [myCollectionView setContentOffset:CGPointMake(WIDTH*sender.tag, 0) animated:YES];

}
#pragma mark - 这是创建UICollectionView
-(void)creatUICollectionView{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumLineSpacing =  0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    myCollectionView = [[UICollectionView alloc]initWithFrame:FRAME(0, 40, WIDTH, HEIGHT - 104) collectionViewLayout:layout];
    [myCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    myCollectionView.pagingEnabled = YES;
    myCollectionView.bounces = NO;
    myCollectionView.scrollEnabled = NO;
    myCollectionView.delegate = self;
    myCollectionView.dataSource = self;
    [self.view addSubview:myCollectionView];
}
#pragma mark - 这是UICollectionView的代理和数据源方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 2;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(WIDTH, HEIGHT - 104);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    JHBaseVC * vc = vcArray[indexPath.row];
    [self addChildViewController:vc];
    [cell addSubview:vc.view];
    return cell;
}

@end
