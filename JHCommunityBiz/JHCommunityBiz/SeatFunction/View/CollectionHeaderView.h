//
//  CollectionHeaderView.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/10/8.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChoseNumemberModel.h"
@interface CollectionHeaderView : UICollectionReusableView
@property(nonatomic,retain)ChoseNumemberModel *model;
@property(nonatomic,retain)UILabel *label;//显示类别
@property(nonatomic,retain)UIButton *btn;//点击的按钮
@property(nonatomic,retain)UIImageView *imageV;//显示箭头的
@end
