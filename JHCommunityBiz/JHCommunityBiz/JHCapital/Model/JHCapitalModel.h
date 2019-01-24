//
//  JHCapitalModel.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/19.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHCapitalModel : NSObject
+(JHCapitalModel * )showJHCapitalModelWithDictionary:(NSDictionary *)dic;
-(id)initWithDictionary:(NSDictionary *)dic;
@property(nonatomic,copy)NSString * dateline;//记录的时间
@property(nonatomic,copy)NSString * intro;//描述
@property(nonatomic,copy)NSString * log_id;
@property(nonatomic,copy)NSString * money;//金额
@property(nonatomic,copy)NSString * shop_id;
@end
