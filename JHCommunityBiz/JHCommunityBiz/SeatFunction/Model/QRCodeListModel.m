//
//  QRCodeListModel.m
//  JHCommunityBiz
//
//  Created by ijianghu on 2017/11/18.
//  Copyright © 2017年 com.jianghu. All rights reserved.
//

#import "QRCodeListModel.h"

@implementation QRCodeListModel
+(QRCodeListModel *)getDataWithDic:(NSDictionary *)dic{
   return [[QRCodeListModel alloc]initWithDic:dic];
}
-(instancetype)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
@end
