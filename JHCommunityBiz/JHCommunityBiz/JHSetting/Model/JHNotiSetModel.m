//
//  JHNotiSetModel.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/7/22.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHNotiSetModel.h"

@implementation JHNotiSetModel
+(JHNotiSetModel *)creatJHNotiSetModelWithDictionary:(NSDictionary *)dic{
    return [[JHNotiSetModel alloc]initWithDictionary:dic];
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
