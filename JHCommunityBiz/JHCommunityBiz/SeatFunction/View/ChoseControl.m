//
//  ChoseControl.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/9/30.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "ChoseControl.h"
#import "CollectionViewCell_dingzuo.h"
#import "CollectionHeaderView.h"
#import "ChoseNumemberModel.h"
@implementation ChoseControl{
    NSMutableArray * dataArray;
    ChoseControl * _control;
    CollectionViewCell_dingzuo * oldCell;
    childrenModel * oldModel;
    NSIndexPath * _indexPath;
}
+(ChoseControl *)showChoseControlWithArray:(NSMutableArray *)infoArray{
    ChoseControl * control = [[ChoseControl alloc]init];
    [control showChoseControlWithArray:infoArray  withView:control];
    return control;
}
-(void)showChoseControlWithArray:(NSMutableArray *)infoArray withView:(ChoseControl *)control{
    _control = control;
    dataArray = infoArray;
    control.frame = FRAME(0, 0, WIDTH, HEIGHT);
    UIWindow * window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:control];
    control.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.3];
    [control addTarget:self action:@selector(clickToRemove) forControlEvents:UIControlEventTouchUpInside];
    [control addSubview:self.view_bj];
    [UIView animateWithDuration:0.3 animations:^{
      _view_bj.frame = FRAME(0, HEIGHT/2, WIDTH, HEIGHT/2);
    }];
    //创建底部的两个按钮
    for (int i = 0; i < 2; i ++) {
        UIButton * btn = [[UIButton alloc]init];
        btn.frame = FRAME((WIDTH/2 + 0.5)*i, HEIGHT/2-40, WIDTH/2-0.5, 40);
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor whiteColor];
        [_view_bj addSubview:btn];
       if (i == 0) {
            [btn setTitle: NSLocalizedString(@"取消", NSStringFromClass([self class])) forState:UIControlStateNormal];
        }else{
             [btn setTitle: NSLocalizedString(@"确定", NSStringFromClass([self class])) forState:UIControlStateNormal];
        }
        btn.tag = i;
        [btn setTitleColor:THEME_COLOR forState:UIControlStateNormal];
        btn.titleLabel.font = FONT(16);
        
    }
    //创建按钮的中间的分割线
    CALayer * layer = [[CALayer alloc]init];
    layer.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1].CGColor;
    layer.frame = FRAME(WIDTH/2-0.5, HEIGHT/2-40, 1, 40);
    [_view_bj.layer addSublayer:layer];
}
#pragma mark - 这是点击取消或者确定的方法
-(void)clickBtn:(UIButton *)sender{
    if (sender.tag == 0) {
        [_control removeFromSuperview];
        _control = nil;
    }else{
        if ([JHShareModel shareModel].indexP == nil) {
            return;
        }
        if (self.myBlock) {
            self.myBlock([JHShareModel shareModel].indexP);
        }
        [_control removeFromSuperview];
        _control = nil;
    }
}
#pragma - mark 这是点击背景让其消失的方法
-(void)clickToRemove{
    [_control removeFromSuperview];
    _control = nil;
}
//添加底部弹出的背景
-(UIView *)view_bj{
    if (!_view_bj) {
        _view_bj = [[UIView alloc]init];
        _view_bj.frame = FRAME(0, HEIGHT, WIDTH, HEIGHT/2);
        _view_bj.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
        [_view_bj addSubview:self.label_title];
        [_view_bj addSubview:self.myCollectionView];
    }
    return _view_bj;
}
//添加头部的标题
-(UILabel *)label_title{
    if (!_label_title) {
        _label_title = [[UILabel alloc]init];
        _label_title.frame = FRAME(0, 0, WIDTH, 40);
        _label_title.text = NSLocalizedString(@"可选桌号", NSStringFromClass([self class]));
        _label_title.textColor = HEX(@"333333", 1.0);
        _label_title.font = FONT(16);
        _label_title.textAlignment = NSTextAlignmentCenter;
        _label_title.backgroundColor = [UIColor whiteColor];
    }
    return _label_title;
}
//添加中间的选择去
-(UICollectionView *)myCollectionView{
    if (!_myCollectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _myCollectionView = [[UICollectionView alloc]initWithFrame:FRAME(0, 40, WIDTH, HEIGHT/2 - 80) collectionViewLayout:layout];
        _myCollectionView.alwaysBounceVertical = YES;
        _myCollectionView.pagingEnabled = YES;
        _myCollectionView.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
        _myCollectionView.showsVerticalScrollIndicator = NO;
        [_myCollectionView registerClass:[CollectionViewCell_dingzuo class] forCellWithReuseIdentifier:@"cell"];
        [_myCollectionView registerClass:[CollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView"];
        _myCollectionView.dataSource = self;
        _myCollectionView.delegate = self;
    }
    return _myCollectionView;
}
//这是UICollectionView的代理和数据源方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    ChoseNumemberModel * model = dataArray[section];
    if (model.isSelecter) {
        return model.childrenModelArray.count;
    }else{
        return 0;
    }
    
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return dataArray.count;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((WIDTH - 60)/3, 40);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(WIDTH, 0.01);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
     return CGSizeMake(WIDTH, 40);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath

{
    CollectionHeaderView * view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headerView" forIndexPath:indexPath];
    view.model = dataArray[indexPath.section];
    view.btn.tag = indexPath.section;
    [view.btn addTarget:self action:@selector(clickHeaderBtn:) forControlEvents:UIControlEventTouchUpInside];
    return view;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewCell_dingzuo * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    ChoseNumemberModel * model = dataArray[indexPath.section];
    cell.model = model.childrenModelArray[indexPath.item];
    if (cell.model.isSelecter) {
        oldModel = cell.model;
        oldCell = cell;
    }
    return cell;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 15, 10, 15);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    oldCell.backgroundColor = [UIColor whiteColor];
    oldCell.label.textColor = THEME_COLOR;
    oldModel.isSelecter = NO;
    CollectionViewCell_dingzuo * cell = (CollectionViewCell_dingzuo *)[_myCollectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = THEME_COLOR;
    cell.label.textColor = [UIColor whiteColor];
    cell.model.isSelecter = !cell.model.isSelecter;
    oldCell = cell;
    oldModel = cell.model;
    _indexPath = indexPath;
    [JHShareModel shareModel].indexP = indexPath;
}
#pragma mark - 这是点击每个类的区头的方法
-(void)clickHeaderBtn:(UIButton *)sender{
    NSLog(@"点击了第%ld个区",sender.tag);
    ChoseNumemberModel * model = dataArray[sender.tag];
    model.isSelecter = !model.isSelecter;
    CollectionHeaderView * headerView = (CollectionHeaderView*)[_myCollectionView supplementaryViewForElementKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:sender.tag]];
    if (model.isSelecter) {
        headerView.imageV.image = [UIImage imageNamed:@"jiantou"];
    }else{
        headerView.imageV.image = [UIImage imageNamed:@"home_go"];
    }
    [_myCollectionView reloadData];
}
@end
