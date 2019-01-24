//
//  DeliveryOrderCellModel.h
//  JHCommunityBiz
//
//  Created by xixixi on 16/7/4.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeliveryOrderCellModel : NSObject
@property(nonatomic,copy)NSString *addr;
@property(nonatomic,copy)NSDictionary *comment_info;
@property(nonatomic,copy)NSString *comment_status;
@property(nonatomic,copy)NSString *contact;
@property(nonatomic,copy)NSString *cui_count;
@property(nonatomic,copy)NSString *cui_time;
@property(nonatomic,copy)NSString *dateline;
@property(nonatomic,copy)NSString *intro;
@property(nonatomic,copy)NSString *juli;
@property(nonatomic,copy)NSString *mobile;
@property(nonatomic,copy)NSString *online_pay;
@property(nonatomic,copy)NSString *order_id;
@property(nonatomic,copy)NSString *order_status;
@property(nonatomic,copy)NSString *order_status_label;
@property(nonatomic,copy)NSString *order_status_warning;
@property(nonatomic,copy)NSString *pei_time;
@property(nonatomic,copy)NSString *pei_time_label;
@property(nonatomic,copy)NSString *pei_time_print;
@property(nonatomic,copy)NSString *pei_type;
@property(nonatomic,copy)NSDictionary *staff;
@property(nonatomic,copy)NSString * shop_title;
@property(nonatomic,copy)NSString * pay_code;
@property(nonatomic,retain)NSArray * products;
@property(nonatomic,copy)NSString * first_youhui;
@property(nonatomic,copy)NSString * hongbao;
@property(nonatomic,copy)NSString * order_youhui;
@property(nonatomic,copy)NSString * amount;
@property(nonatomic,copy)NSString * freight;
@property(nonatomic,copy)NSString *waimai_title;
@property(nonatomic,copy)NSString *house;
@end
