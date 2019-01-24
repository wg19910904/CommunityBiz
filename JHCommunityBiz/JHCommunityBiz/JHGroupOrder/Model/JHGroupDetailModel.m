//
//  JHGroupDetailModel.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/30.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHGroupDetailModel.h"
#import "HZQChangeDateLine.h"
@implementation JHGroupDetailModel
+(JHGroupDetailModel * )creatJHGroupDetailModelWithDictioanaryWithDic:(NSDictionary *)dic{
    return [[JHGroupDetailModel alloc]initWithDictionary:dic];
}
-(id)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.photoArray = @[].mutableCopy;
        self.order_id = dic[@"order_id"];
        self.dateline = [HZQChangeDateLine dateLineExchangeWithTime:dic[@"dateline"]];
        self.ltime = [HZQChangeDateLine dateLineExchangeWithTime:dic[@"ticket"][@"ltime"]];
        //self.ltime = [HZQChangeDateLine dateLineExchangeWithTime:dic[@"ticket"][@"ltime"]];
        self.order_state_label = dic[@"order_status_label"];
        self.contact = dic[@"contact"];
        self.mobile = dic[@"mobile"];
        self.comment_id = dic[@"comment_info"][@"comment_id"];
        self.face = [NSString stringWithFormat:@"%@%@",IMAGEADDRESS,dic[@"comment_info"][@"face"]];
        self.shop_title = dic[@"shop_title"];
        self.tuan_number = dic[@"tuan"][@"tuan_number"];
        self.shop_logo = dic[@"tuan"][@"tuan_photo"];
        self.total_price = dic[@"total_price"];
        self.number = dic[@"ticket"][@"number"];
        self.count = dic[@"ticket"][@"count"];
        self.content = dic[@"comment_info"][@"content"];
        NSArray * tempArray = dic[@"comment_info"][@"photo_list"];
        for (NSString * str in tempArray) {
            NSString * urlString = [NSString stringWithFormat:@"%@%@",IMAGEADDRESS,str];
            [self.photoArray addObject:urlString];
        }
        self.evaluate_time = dic[@"comment_info"][@"dateline"];
        //[HZQChangeDateLine dateLineExchangeWithTime:dic[@"comment_info"][@"dateline"]];
        self.reply = dic[@"comment_info"][@"reply"];
        self.reply_time = [HZQChangeDateLine dateLineExchangeWithTime:dic[@"comment_info"][@"reply_time"]];
        self.status = dic[@"ticket"][@"status"];
        self.hongbao = dic[@"hongbao"];
        self.score = dic[@"comment_info"][@"score"];
    }
    return self;
}
@end
