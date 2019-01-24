//
//  DeliveryOrderCellModel.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/7/4.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "DeliveryOrderCellModel.h"

@implementation DeliveryOrderCellModel

- (NSString *)intro{
    if (_intro.length) {
        return _intro;
    }
    return NSLocalizedString(@"无", nil);
}
- (NSString *)pei_time_label{
    if (_pei_time_label.length) {
        return _pei_time_label;
    }
    return NSLocalizedString(@"尽快送达", nil);
}

@end
