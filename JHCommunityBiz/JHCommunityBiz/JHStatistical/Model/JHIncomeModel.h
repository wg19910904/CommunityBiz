//
//  JHIncomeModel.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/12.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHIncomeModel : NSObject
+(JHIncomeModel *)creatJHIncomeModelWithDictionary:(NSDictionary *)dic;
-(id)initWithDictionary:(NSDictionary *)dic;
@property(nonatomic,copy)NSString * count;
@property(nonatomic,copy)NSString * date;
@property(nonatomic,copy)NSString * day;
@property(nonatomic,copy)NSString * money;
@end
