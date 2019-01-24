//
//  DeliveryProductModifyCellOne.h
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/28.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeliveryProductCellOneAddModel.h"
@interface DeliveryProductModifyCellOne : UITableViewCell
@property(nonatomic,strong)DeliveryProductCellOneAddModel *dataModel;
@property(nonatomic,strong)UIButton *addBtn;
//获取高度
+ (CGFloat)getHeight:(NSInteger)count;
@end



@interface PhotoIV : UIView
@property(nonatomic,strong)UIImageView *img;
@property(nonatomic,strong)UIButton *cancelBtn;
@end
