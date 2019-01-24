//
//  JHCapitalModel.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/19.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHCapitalModel.h"
@implementation JHCapitalModel
+(JHCapitalModel * )showJHCapitalModelWithDictionary:(NSDictionary *)dic{
    return [[JHCapitalModel alloc]initWithDictionary:dic];
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
-(NSString *)dateline{
    NSString *str;
    NSDateFormatter *dateF = [[NSDateFormatter alloc]init];
    [dateF setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_dateline.integerValue];
    str = [dateF stringFromDate:date];
    return str;
}
@end
