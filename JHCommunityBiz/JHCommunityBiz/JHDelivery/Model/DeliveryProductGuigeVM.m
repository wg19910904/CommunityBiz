//
//  DeliveryProductGuigeVM.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/7/7.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "DeliveryProductGuigeVM.h"

@implementation DeliveryProductGuigeVM
+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"items":[DeliveryProductGuigeCellModel class]};
}
@end
