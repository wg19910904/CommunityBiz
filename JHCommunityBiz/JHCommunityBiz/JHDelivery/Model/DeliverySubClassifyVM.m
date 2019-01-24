//
//  DeliverySubClassifyVM.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/6/29.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "DeliverySubClassifyVM.h"

@implementation DeliverySubClassifyVM
+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"items":[DeliverySubClassifyDetailModel class]};
}

@end
