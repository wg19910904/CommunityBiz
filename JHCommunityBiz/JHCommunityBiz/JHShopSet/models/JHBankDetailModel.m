//
//  JHBankDetailModel.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/7/22.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHBankDetailModel.h"

@implementation JHBankDetailModel
+(JHBankDetailModel * )creatJHBankDetailModelWithDic:(NSDictionary *)dic{
    return [[JHBankDetailModel alloc]initWithDictionary:dic];
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
