//
//  JHGroupOrderListMainVC.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/28.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHGroupOrderListMainVC.h"
#import "JHGroupOrderListVC.h"
#import "JHGroupListCompletionVC.h"
#import "JHGlobalSearchVC.h"
#import "DeliveryOrderNavView.h"
@implementation JHGroupOrderListMainVC{
    DeliveryOrderNavView *navV;
    UIButton * oldBtn;
    UIButton *rightBtn1;
    UICollectionView * myCollectionView;
    NSMutableArray * vcArray;
    NSMutableDictionary *addCondition;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    //初始化的一些方法
    [self initData];
    //添加分页导航栏
    [self makeNav];
    //添加UICollectionView
    [self CreatUICollectionView];
}
- (void)makeNav
{
    if (!navV) {
        navV =  [[DeliveryOrderNavView alloc] initWithFrame:FRAME(0, 0, WIDTH, 40)
                                                  withTitle:@[ NSLocalizedString(@"待消费", NSStringFromClass([self class])), NSLocalizedString(@"已完成", NSStringFromClass([self class]))]];
        navV.btn1.selected = YES;
        oldBtn = navV.btn1;
        navV.btn1.tag = 10;
        navV.btn2.tag = 20;
        [navV.btn1 addTarget:self action:@selector(clickToChange:) forControlEvents:UIControlEventTouchUpInside];
        [navV.btn2 addTarget:self action:@selector(clickToChange:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:navV];
    }
//    IncompleteJieVC *vc1 = [[IncompleteJieVC alloc] init];
//    IncompletePeiVC *vc2 = [[IncompletePeiVC alloc] init];
//    [self addChildViewController:vc1];
//    [self addChildViewController:vc2];
//    vcArray = @[vc1,vc2];
    
}
#pragma mark - 这是初始化的一些方法
-(void)initData{
    addCondition = @{}.mutableCopy;
    self.navigationItem.title =  NSLocalizedString(@"团购订单", NSStringFromClass([self class]));
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(0, 0, 20, 20)];
    [rightBtn addTarget:self action:@selector(clickRightBnt)
       forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"btn_shaixuan"] forState:UIControlStateNormal];
    UIBarButtonItem *rightBtnItem2 = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItems =@[rightBtnItem2];
    
    
    JHGroupOrderListVC * vc = [[JHGroupOrderListVC alloc]init];
    JHGroupListCompletionVC * vc1 = [[JHGroupListCompletionVC alloc]init];
    vcArray  = [NSMutableArray arrayWithObjects:vc,vc1, nil];
}

#pragma mark==导航栏右侧按钮=====
- (void)clickRightBnt{
    __weak typeof(self)weakself = self;
    JHGlobalSearchVC *vc = [[JHGlobalSearchVC alloc]init];
    vc.cacheDic = addCondition;
    vc.searchImgStr = @"btn_search";
    vc.choseTimeArrow = @"btn_arrow_r";
    vc.tintColor = HEX(@"ff9900", 1);
    vc.searchType = ESearch_tuangou;
    [vc setClickBlock:^(NSMutableDictionary *dic) {
        //循环添加新增的筛选字段,刷新界面
        NSArray *keys = [dic allKeys];
        for (NSString *key in keys) {
            [addCondition setObject:dic[key] forKey:key];
        }
        [weakself reloadVC_withCondition:addCondition];
    }];
    
    [self.navigationController pushViewController:vc animated:YES];
}
//刷新当前的展示的列表的
- (void)reloadVC_withCondition:(NSMutableDictionary *)condition{
    CGFloat offset_x = myCollectionView.contentOffset.x;
    if (offset_x) {
        //当前页面为已完成订单界面
        JHGroupListCompletionVC *vc = (JHGroupListCompletionVC *)vcArray[1];
        [vc reloadTableViewCondition:addCondition];
    }else{
        //当前页面为未完成订单界面
        JHGroupOrderListVC *vc = (JHGroupOrderListVC *)vcArray[0];
        [vc reloadTableViewCondition:addCondition];
    }
    
}

#pragma mark - 这是点击切换完成和未完成的方法
-(void)clickChange{
    [addCondition removeAllObjects];
    if ([rightBtn1.titleLabel.text isEqualToString: NSLocalizedString(@"已完成", NSStringFromClass([self class]))]) {
        [rightBtn1 setTitle: NSLocalizedString(@"未完成", NSStringFromClass([self class])) forState:UIControlStateNormal];
        self.navigationItem.title =  NSLocalizedString(@"已完成订单", NSStringFromClass([self class]));
        [myCollectionView setContentOffset:CGPointMake(WIDTH, 0) animated:YES];
        JHGroupOrderListVC *vc = (JHGroupOrderListVC *)vcArray[0];
        [vc reloadTableViewCondition:addCondition];
    }else{
       [rightBtn1 setTitle: NSLocalizedString(@"已完成", NSStringFromClass([self class])) forState:UIControlStateNormal];
        self.navigationItem.title =  NSLocalizedString(@"未完成订单", NSStringFromClass([self class]));
        [myCollectionView setContentOffset:CGPointMake(0,0) animated:YES];
        JHGroupListCompletionVC *vc = (JHGroupListCompletionVC *)vcArray[1];
        [vc reloadTableViewCondition:addCondition];
    }
}
#pragma mark - 创建UICollectionView
-(void)CreatUICollectionView{
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0 ;
    myCollectionView = [[UICollectionView alloc]initWithFrame:FRAME(0, 40, WIDTH, HEIGHT - 104) collectionViewLayout:layout];
    myCollectionView.pagingEnabled = YES;
    myCollectionView.scrollEnabled = NO;
    [myCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    myCollectionView.delegate = self;
    myCollectionView.dataSource = self;
    [self.view addSubview:myCollectionView];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 2;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(WIDTH, HEIGHT - 104);
}
-(UICollectionViewCell * )collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    JHBaseVC * vc = vcArray[indexPath.row];
    [vc viewWillAppear:YES];
    [self addChildViewController:vc];
    [cell addSubview:vc.view];
    return cell;
}
#pragma mark - 这是点击改变页面的按钮调用的方法
-(void)clickToChange:(UIButton *)sender{
    oldBtn.selected = NO;
    sender.selected = !sender.selected;
    oldBtn = sender;
    if (sender.tag == 10) {
        [UIView animateWithDuration:0.3 animations:^{
            navV.indicateView.center = CGPointMake(WIDTH/4 , navV.indicateView.center.y);
        }];
        [myCollectionView setContentOffset:CGPointMake(0, 0) animated:YES];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            navV.indicateView.center = CGPointMake(WIDTH/4*3, navV.indicateView.center.y);
        }];
        [myCollectionView setContentOffset:CGPointMake(WIDTH, 0) animated:YES];
    }
}

@end
