//
//  JHMessageModel.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/11.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHMessageModel.h"

@implementation JHMessageModel
+(JHMessageModel * )shareJHMessageModelWithDictionary:(NSDictionary *)dic{
    return [[JHMessageModel alloc]initWithDictionary:dic];
}
-(id)initWithDictionary:(NSDictionary *)dic{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"key====>%@",key);
}
@end
