//
//  PaiduiModel.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/9/30.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "PaiduiModel.h"

@implementation PaiduiModel
+(PaiduiModel *)sharePaiduiModelWithDic:(NSDictionary*)dic{
    return [[PaiduiModel alloc]initWithDic:dic];
}
-(id)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.status = [dic[@"order_status"] integerValue];
        self.order_state_label = dic[@"order_status_label"];
        self.paidui_id = dic[@"paidui_id"];
        self.contact = dic[@"contact"];
        self.mobile = dic[@"mobile"];
        self.zhuohao_id = dic[@"zhuohao_id"];
        self.paidui_number = dic[@"paidui_number"];
        self.title = dic[@"zhuohao_detail"][@"title"];
        self.reason = dic[@"reason"];
    }
    return self;
}
@end
