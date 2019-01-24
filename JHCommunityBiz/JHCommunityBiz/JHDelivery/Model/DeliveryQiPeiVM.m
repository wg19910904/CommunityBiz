//
//  DeliveryQiPeiVM.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/6/30.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "DeliveryQiPeiVM.h"

@implementation DeliveryQiPeiVM
+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"freight_stage":[DeliveryQiPeiDetailModel class]};
}
@end
