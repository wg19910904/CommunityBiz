//
//  JHCustomerDetailModel.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/18.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHCustomerDetailModel : NSObject
+(JHCustomerDetailModel * )showJHCustomerDetailModelWithDictionary:(NSDictionary *)dic;
-(id)initWithDictionay:(NSDictionary *)dic;
@property(nonatomic,copy)NSString * amount;
@property(nonatomic,copy)NSString * dateline;
@property(nonatomic,copy)NSString * order_id;
@end
