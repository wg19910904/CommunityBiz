//
//  JHCludeModel.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/7/25.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHCludeModel.h"

@implementation JHCludeModel
+(JHCludeModel *)creatJHCludeModelWithDic:(NSDictionary *)dic{
    return [[JHCludeModel alloc]initWithDic:dic];
}
-(id)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
@end
