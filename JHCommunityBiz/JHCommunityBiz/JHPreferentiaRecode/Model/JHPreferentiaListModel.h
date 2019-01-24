//
//  JHPreferentiaListModel.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/26.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHPreferentiaListModel : NSObject
+(JHPreferentiaListModel *)creatJHPreferentiaListModelWithDictionary:(NSDictionary *)dic;
-(id)initWithDictionary:(NSDictionary *)dic;
@property(nonatomic,copy)NSString * amount;//实际支付的价格
@property(nonatomic,copy)NSString * comment;//是否评价(0未评价 1已评价)
@property(nonatomic,copy)NSString * contact;//客户姓名
@property(nonatomic,copy)NSString * dateline;//下单时间
@property(nonatomic,copy)NSString * mobile;//用户电话
@property(nonatomic,copy)NSString * order_id;//订单号
@property(nonatomic,copy)NSString * reply;//是否回复
@property(nonatomic,copy)NSString * total_price;//原价
@end
