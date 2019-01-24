//
//  JHMessageModel.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/11.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHMessageModel : NSObject
+(JHMessageModel * )shareJHMessageModelWithDictionary:(NSDictionary *)dic;
-(id)initWithDictionary:(NSDictionary *)dic;
@property(nonatomic,copy)NSString * content;//消息内容
@property(nonatomic,copy)NSString * dateline;//消息时间
@property(nonatomic,copy)NSString * is_read;//是否已读
@property(nonatomic,copy)NSString * msg_id;//消息id
@property(nonatomic,copy)NSString * order_id;//订单id
@property(nonatomic,copy)NSString * shop_id;//商家id
@property(nonatomic,copy)NSString * title;
@property(nonatomic,copy)NSString * type;//订单类型
@end
