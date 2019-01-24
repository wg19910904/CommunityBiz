//
//  JHGroupChitRecordModel.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/25.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHGroupChitRecordModel.h"

@implementation JHGroupChitRecordModel
+(JHGroupChitRecordModel * )creatJHGroupChitRecordModelWithDictionary:(NSDictionary *)dic{
    return [[JHGroupChitRecordModel alloc]initWithDictionary:dic];
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
