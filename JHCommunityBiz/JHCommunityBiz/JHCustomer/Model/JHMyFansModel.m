//
//  JHMyFansModel.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/17.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHMyFansModel.h"

@implementation JHMyFansModel
+(JHMyFansModel *)showJHMyFansModelWithDictionary:(NSDictionary *)dic{
    return [[JHMyFansModel alloc]initWithDictionary:dic];
}
-(id)initWithDictionary:(NSDictionary *)dic{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
@end
