//
//  JHGroupListModel.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/28.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHGroupListModel.h"

@implementation JHGroupListModel
+(JHGroupListModel *)creatJHGroupListModelWithDictionary:(NSDictionary *)dic{
    return [[JHGroupListModel alloc]initWithDictionary:dic];
}
-(id)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.from_name = dic[@"from_name"];
        self.order_id = dic[@"order_id"];
        self.order_status = dic[@"order_status"];
        self.comment_reply = dic[@"comment_reply"];
        self.comment_status = dic[@"comment_status"];
        self.ltime = dic[@"tuan"][@"ltime"];
        NSDate * currentDate = [NSDate date];
        NSDate * lDate = [NSDate dateWithTimeIntervalSince1970:[self.ltime integerValue]];
        if ([currentDate compare:lDate] == NSOrderedDescending) {
            self.type = 5;
        }else if ([self.comment_status isEqualToString:@"0"] && [self.order_status isEqualToString:@"8"]) {
            self.type = 1;
        }else if ([self.comment_status isEqualToString:@"1"] && [self.comment_reply isEqualToString:@"0"] && [self.order_status isEqualToString:@"8"]){
            self.type = 2;
        }else if ([self.comment_status isEqualToString:@"1"] && [self.comment_reply isEqualToString:@"1"] && [self.order_status isEqualToString:@"8"]){
            self.type = 3;
        }else if([self.order_status isEqualToString:@"-1"]){
            self.type = 6;
        }else if([self.order_status isEqualToString:@"-2"]){
            self.type = 4;
        }else{
            self.type = 0;
        }
        self.order_status_label = dic[@"order_status_label"];
        self.order_status_warning = dic[@"order_status_warning"];
        self.shop_logo = dic[@"tuan"][@"tuan_photo"];
        self.shop_title = dic[@"shop_title"];
        self.total_price = dic[@"total_price"];
        self.tuan_id = dic[@"taun"][@"tuan_id"];
        self.tuan_number = dic[@"tuan"][@"tuan_number"];
        self.tuan_price = dic[@"tuan"][@"tuan_price"];
        self.tuan_title = dic[@"tuan"][@"tuan_title"];
    }
    return self;
}
@end
