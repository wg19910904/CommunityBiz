//
//  DeliveryProductAddCellOne.h
//  JHCommunityBiz
//
//  Created by xixixi on 16/7/4.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeliveryProductCellOneAddModel.h"
@interface DeliveryProductAddCellOne : UITableViewCell
@property(nonatomic,strong)DeliveryProductCellOneAddModel *dataModel;
@property(nonatomic,strong)UIButton *addBtn;
//获取高度
+ (CGFloat)getHeight:(NSInteger)count;
@end



@interface PhotoIV2 : UIView
@property(nonatomic,strong)UIImageView *img;
@property(nonatomic,strong)UIButton *cancelBtn;
@end
