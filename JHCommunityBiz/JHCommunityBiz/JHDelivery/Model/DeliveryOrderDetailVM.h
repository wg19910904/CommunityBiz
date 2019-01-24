//
//  DeliveryOrderDetailVM.h
//  JHCommunityBiz
//
//  Created by xixixi on 16/7/11.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeliveryOrderDetailVM : NSObject
@property(nonatomic,copy)NSString *addr;
@property(nonatomic,copy)NSString *amount;
@property(nonatomic,copy)NSString *clientip;
@property(nonatomic,copy)NSString *closed;
@property(nonatomic,copy)NSDictionary *comment_info;
@property(nonatomic,copy)NSString *comment_status;
@property(nonatomic,copy)NSString *complaint;
@property(nonatomic,copy)NSString *contact;
@property(nonatomic,copy)NSString *cui_time;
@property(nonatomic,copy)NSString *dateline;
@property(nonatomic,copy)NSString *day;
@property(nonatomic,copy)NSString *first_youhui;
@property(nonatomic,copy)NSString *from;
@property(nonatomic,copy)NSString *from_name;
@property(nonatomic,copy)NSString *hongbao;
@property(nonatomic,copy)NSString *hongbao_id;
@property(nonatomic,copy)NSString *house;
@property(nonatomic,copy)NSString *intro;
@property(nonatomic,copy)NSString *jd_time;
@property(nonatomic,copy)NSString *lasttime;
@property(nonatomic,copy)NSString *lat;
@property(nonatomic,copy)NSString *lng;
@property(nonatomic,copy)NSArray  *logs;
@property(nonatomic,copy)NSString *mobile;
@property(nonatomic,copy)NSString *money;
@property(nonatomic,copy)NSString *o_lat;
@property(nonatomic,copy)NSString *o_lng;
@property(nonatomic,copy)NSString *online_pay;
@property(nonatomic,copy)NSString *order_from;
@property(nonatomic,copy)NSString *order_id;
@property(nonatomic,copy)NSString *order_status;
@property(nonatomic,copy)NSString *order_status_label;
@property(nonatomic,copy)NSString *order_status_warning;
@property(nonatomic,copy)NSString *order_youhui;
@property(nonatomic,copy)NSString *pay_code;
@property(nonatomic,copy)NSString *pay_status;
@property(nonatomic,copy)NSString *pay_time;
@property(nonatomic,copy)NSString *pei_amount;
@property(nonatomic,copy)NSString *pei_time_label;
@property(nonatomic,copy)NSString *pei_time_print;
@property(nonatomic,copy)NSString *pei_time;
@property(nonatomic,copy)NSString *pei_type;
@property(nonatomic,copy)NSArray *products;
@property(nonatomic,copy)NSString *shop_id;
@property(nonatomic,copy)NSString *shop_logo;
@property(nonatomic,copy)NSString *shop_title;
@property(nonatomic,copy)NSDictionary *staff;
@property(nonatomic,copy)NSString *staff_id;
@property(nonatomic,copy)NSString *total_price;
@property(nonatomic,copy)NSString *trade_no;
@property(nonatomic,copy)NSString *uid;
@property(nonatomic,copy)NSString *wx_openid;
@property(nonatomic,copy)NSString *waimai_title;
@property(nonatomic,copy)NSString * freight;
@property(nonatomic,copy)NSString * spend_number;
@property(nonatomic,copy)NSString * spend_status;
@end
