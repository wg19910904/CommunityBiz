//
//  DeliveryOrderManagerVC.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/19.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "DeliveryOrderVC.h"
#import "DeliveryOrderListVC.h"
#import "JHGlobalSearchVC.h"
#import "DeliveryOrderNavView.h"
@interface DeliveryOrderVC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)UICollectionView *collectionView;
@end

@implementation DeliveryOrderVC
{
    NSMutableDictionary *addCondition;
    DeliveryOrderNavView *navV;
    UIButton * oldBtn;
    BOOL isScroll;
    NSArray *vcArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"外卖订单", nil);
    [self makeNav];
    //添加右侧按钮
    [self addRightBtn];
    [self createVCArr];
    [self createMainCollection];
}
- (void)createVCArr{
    DeliveryOrderListVC *daijiedan = [[DeliveryOrderListVC alloc] init];
    daijiedan.listType = EWaimai_OrderList_type_daijiedan;
    DeliveryOrderListVC *delivering = [[DeliveryOrderListVC alloc] init];
    delivering.listType = EWaimai_OrderList_type_delivering;
    DeliveryOrderListVC *complete = [[DeliveryOrderListVC alloc] init];
    complete.listType = EWaimai_OrderList_type_complete;
    DeliveryOrderListVC *cancel = [[DeliveryOrderListVC alloc] init];
    cancel.listType = EWaimai_OrderList_type_cancel;
    vcArray = @[daijiedan,delivering,complete,cancel];
    for (DeliveryOrderListVC *vc in vcArray) {
        vc.superVC = self;
    }
}
#pragma mark - 初始化表视图
- (void)createMainCollection
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(WIDTH, HEIGHT - 64 - 40);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        //设置上下左右的留白
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:FRAME(0, 40, WIDTH, HEIGHT - 64 - 40) collectionViewLayout:layout];
        //注册Cell
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"DeliveryOrderVC_collectionCellID"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.bounces = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        [self.view addSubview:_collectionView];
    }
}
- (void)addRightBtn{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(0, 0, 20, 20)];
    [rightBtn addTarget:self action:@selector(clickSearch)
       forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"btn_shaixuan"] forState:UIControlStateNormal];
    UIBarButtonItem *rightBtnItem2 = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItems =@[rightBtnItem2];
}

#pragma mark - 返回多少单元格
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"DeliveryOrderVC_collectionCellID" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    DeliveryOrderListVC *controller = vcArray[indexPath.row];
    controller.view.frame = cell.bounds;
    [cell addSubview:controller.view];
    [controller viewWillAppear:YES];
    return cell;
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    isScroll = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSArray *btnArr = @[navV.btn1,navV.btn2,navV.btn3,navV.btn4];
    if (isScroll) {
        CGFloat offset_x = scrollView.contentOffset.x;
        NSInteger index = offset_x/WIDTH;
        UIButton *btn = (UIButton *)btnArr[index];
         [self loadData:index];
        navV.indicateView.center = CGPointMake(btn.centerX, navV.indicateView.center.y);
        for (int i = 0; i < 4; i++) {
            UIButton *tempBtn = (UIButton *)btnArr[i];
            if (i == index) {
                tempBtn.selected = YES;
            }else{
                tempBtn.selected = NO;
            }
        }
    }
}
#pragma mark==导航栏右侧按钮=====
- (void)clickSearch{
    __weak typeof(self)weakself = self;
    JHGlobalSearchVC *vc = [[JHGlobalSearchVC alloc]init];
    vc.cacheDic = addCondition;
    vc.searchImgStr = @"btn_search";
    vc.choseTimeArrow = @"btn_arrow_r";
    vc.tintColor = HEX(@"ff9900", 1);
    vc.searchType = ESearch_waimai;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)makeNav
{
    if (!navV) {
        navV =  [[DeliveryOrderNavView alloc] initWithFrame:FRAME(0, 0, WIDTH, 40)
                                                  withTitle:@[NSLocalizedString(@"待接单", nil),NSLocalizedString(@"进行中", nil),NSLocalizedString(@"已完成", nil),NSLocalizedString(@"已取消", nil)]];
        navV.btn1.selected = YES;
        oldBtn = navV.btn1;
        navV.btn1.tag = 10;
        navV.btn2.tag = 20;
        navV.btn3.tag = 30;
        navV.btn4.tag = 40;
        [navV.btn1 addTarget:self action:@selector(clickToChange:) forControlEvents:UIControlEventTouchUpInside];
        [navV.btn2 addTarget:self action:@selector(clickToChange:) forControlEvents:UIControlEventTouchUpInside];
        [navV.btn3 addTarget:self action:@selector(clickToChange:) forControlEvents:UIControlEventTouchUpInside];
        [navV.btn4 addTarget:self action:@selector(clickToChange:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:navV];
    }
}

#pragma mark - 这是点击改变页面的按钮调用的方法
-(void)clickToChange:(UIButton *)sender{
    oldBtn.selected = NO;
    sender.selected = !sender.selected;
    oldBtn = sender;
    [UIView animateWithDuration:0.3 animations:^{
        navV.indicateView.center = CGPointMake(oldBtn.centerX, navV.indicateView.center.y);
    }];
    NSInteger index = sender.tag/10 - 1;
    [UIView animateWithDuration:0.3 animations:^{
        [_collectionView setContentOffset:CGPointMake(WIDTH*index, 0) animated:YES];
    }];
    [self loadData:index];
}
-(void)loadData:(NSInteger)index{
    DeliveryOrderListVC *vc = vcArray[index];
    [vc loadNewData];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
