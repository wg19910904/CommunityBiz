//
//  DeliveryProductVM.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/7/2.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "DeliveryProductVM.h"
@implementation DeliveryProductVM
+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"items":[DeliveryProductCellModel class]};
}
@end
