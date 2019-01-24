//
//  JHNotiSetModel.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/7/22.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHNotiSetModel : NSObject
+(JHNotiSetModel *)creatJHNotiSetModelWithDictionary:(NSDictionary *)dic;
-(id)initWithDictionary:(NSDictionary *)dic;
@property(nonatomic,copy)NSString * shop_id;//商户的id
@property(nonatomic,copy)NSString * order_msg;//订单消息设置的状态(0 未打开 1 打开)
@property(nonatomic,copy)NSString * comment_msg;//评价消息设置的状态(0 未打开 1 打开)
@property(nonatomic,copy)NSString * complaint_msg;//投诉消息设置的状态(0 未打开 1 打开)
@property(nonatomic,copy)NSString * system_msg;//系统消息设置的状态(0 未打开 1 打开)
@end
