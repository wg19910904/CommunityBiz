//
//  JHIncomeModel.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/12.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHIncomeModel.h"

@implementation JHIncomeModel
+(JHIncomeModel *)creatJHIncomeModelWithDictionary:(NSDictionary *)dic{
    return [[JHIncomeModel alloc]initWithDictionary:dic];
}
-(id)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
@end
