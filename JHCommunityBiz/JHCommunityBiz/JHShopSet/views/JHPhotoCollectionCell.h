//
//  JHPhotoCollectionCell.h
//  JHCommunityClient
//
//  Created by xixixi on 16/3/8.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHPhotoCollectionCellModel.h"
@interface JHPhotoCollectionCell : UICollectionViewCell
@property(nonatomic,strong)JHPhotoCollectionCellModel *dataModel;
@property(nonatomic,strong)UIImageView *iv;
@property(nonatomic,strong)UIImageView *indicateIV;
@end
