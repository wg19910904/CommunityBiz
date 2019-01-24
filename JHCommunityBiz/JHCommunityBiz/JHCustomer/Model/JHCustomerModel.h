//
//  JHCustomerModel.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/17.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHCustomerModel : NSObject
+(JHCustomerModel *)showJHCustomerModelWithDictionary:(NSDictionary *)dic;
-(id)initWithDictionary:(NSDictionary *)dic;
@property(nonatomic,copy)NSString * face;//头像
@property(nonatomic,copy)NSString * mobile;//电话号码
@property(nonatomic,copy)NSString * nickname;//客户姓名
@property(nonatomic,copy)NSString * uid;//客户ID
@property(nonatomic,copy)NSString * total_amount;
@property(nonatomic,copy)NSString * total_order;
@end
