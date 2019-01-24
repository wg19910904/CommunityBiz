//
//  DeliveryProductModifyVC.h
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/28.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHBaseVC.h"
#import "DeliveryProductCellModel.h"
@interface DeliveryProductModifyVC : JHBaseVC
@property(nonatomic,strong)DeliveryProductCellModel *dataModel;
@property(nonatomic,copy)void(^refreshBlock)();
@end
