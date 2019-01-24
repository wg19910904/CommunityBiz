//
//  DeliveryQiPeiVM.h
//  JHCommunityBiz
//
//  Created by xixixi on 16/6/30.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeliveryQiPeiDetailModel.h"
@interface DeliveryQiPeiVM : NSObject
@property(nonatomic,copy)NSArray *freight_stage;
@property(nonatomic,copy)NSString *min_amount;
@property(nonatomic,copy)NSString *pei_distance;
@property(nonatomic,copy)NSString *pei_type;
@end
