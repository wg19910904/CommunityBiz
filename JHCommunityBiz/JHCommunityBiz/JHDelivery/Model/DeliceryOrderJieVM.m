//
//  DeliceryOrderJieVM.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/7/4.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "DeliceryOrderJieVM.h"

@implementation DeliceryOrderJieVM
+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"items":[DeliveryOrderCellModel class]};
}
@end
