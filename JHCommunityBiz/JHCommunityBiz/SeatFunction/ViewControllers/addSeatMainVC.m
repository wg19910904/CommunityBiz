//
//  addSeatMainVC.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/9/30.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "addSeatMainVC.h"
#import "paiduiGetNummenberVC.h"
#import "AddSeatVC.h"
#import "AddTableTypeVC.h"
@interface addSeatMainVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)UISegmentedControl *segMentControl;
@property(nonatomic,retain)UICollectionView *myCollectionView;
@end
@implementation addSeatMainVC
-(void)viewWillDisappear:(BOOL)animated{
    [_segMentControl removeFromSuperview];
    _segMentControl = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化一些数据的方法
    [self initData];
    //添加UICollectionView
    [self.view addSubview:self.myCollectionView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //添加segMentControl
    [self.navigationController.view addSubview:self.segMentControl];
}
#pragma mark - 这是初始化一些数据的方法
-(void)initData{
    //添加右边的按钮
    UIButton * btn = [[UIButton alloc]init];
    btn.frame = FRAME(0, 0, 60, 30);
    [btn setTitle: NSLocalizedString(@"桌号管理", NSStringFromClass([self class])) forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = FONT(14);
    [btn addTarget:self action:@selector(clickRightItem) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightItem;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
}
#pragma mark - 这是点击桌号管理的方法
-(void)clickRightItem{
    NSLog(@"点击了桌号管理");
    AddTableTypeVC *vc=[[AddTableTypeVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 这是创建选择支付宝还是微信
-(UISegmentedControl *)segMentControl{
    if (!_segMentControl) {
        _segMentControl = [[UISegmentedControl alloc]initWithItems:@[ NSLocalizedString(@"排队取号", NSStringFromClass([self class])), NSLocalizedString(@"预约订座", NSStringFromClass([self class]))]];
        _segMentControl.layer.borderColor = [UIColor whiteColor].CGColor;
        _segMentControl.layer.borderWidth = 1;
        _segMentControl.layer.cornerRadius = 5;
        _segMentControl.layer.masksToBounds = YES;
        _segMentControl.selectedSegmentIndex = [JHShareModel shareModel].tag;
        _segMentControl.backgroundColor = THEME_COLOR;
        _segMentControl.tintColor = [UIColor whiteColor];
        _segMentControl.frame = FRAME(90, 26, WIDTH - 180, 30);
        [_segMentControl addTarget:self action:@selector(clickSelegmentControl:) forControlEvents:UIControlEventValueChanged];
    }
    return _segMentControl;
}
#pragma mark - 这是点击_segMentControl的方法
-(void)clickSelegmentControl:(UISegmentedControl *)seg{
    if (seg.selectedSegmentIndex == 0) {
        //排队取号
        NSLog(@"排队取号");
       
    }else{
        //预约订座
        NSLog(@"预约订座");
    }
    [JHShareModel shareModel].tag = seg.selectedSegmentIndex;
    [_myCollectionView setContentOffset:CGPointMake(WIDTH*seg.selectedSegmentIndex, 0) animated:YES];
}
#pragma mark - 创建UICollectionView
-(UICollectionView *)myCollectionView{
    if (!_myCollectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        _myCollectionView = [[UICollectionView alloc]initWithFrame:FRAME(0, 0, WIDTH, HEIGHT - 64) collectionViewLayout:layout];
        _myCollectionView.scrollEnabled = NO;
        _myCollectionView.bounces = NO;
        _myCollectionView.pagingEnabled = YES;
        _myCollectionView.backgroundColor = [UIColor whiteColor];
        [_myCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        _myCollectionView.dataSource = self;
        _myCollectionView.delegate = self;
    }
    return _myCollectionView;
}
#pragma mark - UICollectionView的代理和数据源方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 2;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(WIDTH, HEIGHT - 64);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    JHBaseVC * vc = nil;
    if (indexPath.row == 0) {
        vc = [[paiduiGetNummenberVC alloc]init];
    }else{
        vc = [[AddSeatVC alloc]init];
    }
    [self addChildViewController:vc];
    [cell addSubview:vc.view];
    return cell;
}

@end
