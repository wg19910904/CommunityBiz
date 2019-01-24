//
//  JHCustomerDetailModel.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/18.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHCustomerDetailModel.h"

@implementation JHCustomerDetailModel
+(JHCustomerDetailModel * )showJHCustomerDetailModelWithDictionary:(NSDictionary *)dic{
    return [[JHCustomerDetailModel alloc]initWithDictionay:dic];
}
-(id)initWithDictionay:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
@end
