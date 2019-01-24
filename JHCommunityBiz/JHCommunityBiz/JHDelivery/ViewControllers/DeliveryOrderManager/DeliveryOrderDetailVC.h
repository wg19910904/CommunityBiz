//
//  DeliveryOrderDetailVC.h
//  JHCommunityBiz
//
//  Created by xixixi on 16/7/8.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHBaseVC.h"

@interface DeliveryOrderDetailVC : JHBaseVC
@property(nonatomic,copy)NSString *order_id;
@property(nonatomic,copy)void(^myBlock)();
@end
