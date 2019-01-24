//
//  AddSeatModel.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/9/30.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "AddSeatModel.h"

@implementation AddSeatModel
+(AddSeatModel *)shareAddSeatModelWithDic:(NSDictionary*)dic{
    return [[AddSeatModel alloc]initWithDic:dic];
}
-(id)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.order_state_label = dic[@"order_status_label"];
        self.status = [dic[@"order_status"]integerValue];
        self.yuyue_time = dic[@"yuyue_time"];
        self.yuyue_number = dic[@"yuyue_number"];
        self.contact = dic[@"contact"];
        self.mobile = dic[@"mobile"];
        self.dingzuo_id = dic[@"dingzuo_id"];
        self.zhuohao_id = dic[@"zhuohao_id"];
        self.reason = dic[@"reason"];
        self.notice = dic[@"notice"];
        self.height = [self.notice boundingRectWithSize:CGSizeMake(WIDTH - 50, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:FONT(12)} context:nil].size.height;
    }
    return self;
}
@end
