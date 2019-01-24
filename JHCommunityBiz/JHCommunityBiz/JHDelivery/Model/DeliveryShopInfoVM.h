//
//  DeliveryShopInfoVM.h
//  JHCommunityBiz
//
//  Created by xixixi on 16/7/1.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeliveryShopInfoVM : NSObject
@property(nonatomic,copy)NSString *addr;
@property(nonatomic,copy)NSString *banner;
@property(nonatomic,copy)NSString *cate_id;
@property(nonatomic,copy)NSString *cate_str;
@property(nonatomic,copy)NSArray *freight_stage;
@property(nonatomic,copy)NSString *info;
@property(nonatomic,copy)NSString *is_new;
@property(nonatomic,copy)NSString *lat;
@property(nonatomic,copy)NSString *lng;
@property(nonatomic,copy)NSString *logo;
@property(nonatomic,copy)NSString *online_pay;
@property(nonatomic,copy)NSString *pei_distance;
@property(nonatomic,copy)NSString *pei_time;
@property(nonatomic,copy)NSString *pei_type;
@property(nonatomic,copy)NSString *phone;
@property(nonatomic,copy)NSString *score;
@property(nonatomic,copy)NSString *shop_id;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *yy_ltime;
@property(nonatomic,copy)NSString *yy_status;
@property(nonatomic,copy)NSString *yy_stime;
@property(nonatomic,copy)NSString *yy_xiuxi;
@property(nonatomic,copy)NSArray *yy_peitime; //配送时间

@end
