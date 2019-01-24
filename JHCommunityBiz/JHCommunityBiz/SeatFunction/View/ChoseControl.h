//
//  ChoseControl.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/9/30.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChoseControl : UIControl<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic,retain)UIView * view_bj;
@property(nonatomic,retain)UILabel * label_title;
@property(nonatomic,retain)UICollectionView * myCollectionView;
@property(nonatomic,copy)void(^(myBlock))(NSIndexPath *indexPath);
+(ChoseControl *)showChoseControlWithArray:(NSMutableArray *)infoArray;
@end
