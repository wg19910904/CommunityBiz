//
//  JHPreferentiaListModel.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/26.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHPreferentiaListModel.h"

@implementation JHPreferentiaListModel
+(JHPreferentiaListModel *)creatJHPreferentiaListModelWithDictionary:(NSDictionary *)dic{
    return [[JHPreferentiaListModel alloc]initWithDictionary:dic];
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
