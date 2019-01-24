//
//  JHPreferentiaDetailModel.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/27.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHPreferentiaDetailModel.h"
#import "HZQChangeDateLine.h"
@implementation JHPreferentiaDetailModel
-(id)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.photoArray = @[].mutableCopy;
        self.order_id = dic[@"order_id"];
        self.comment = dic[@"comment"];
        self.order_time = [HZQChangeDateLine dateLineExchangeWithTime:dic[@"dateline"]];
        self.name = dic[@"contact"];
        self.mobile = dic[@"mobile"];
        self.total_price = dic[@"total_price"];
        self.youhui_price = @([dic[@"total_price"] floatValue] - [dic[@"amount"] floatValue]).stringValue;
        self.unyouhui_price = dic[@"unyouhui"];
        self.amount = dic[@"amount"];
        self.headUrl = [NSString stringWithFormat:@"%@%@",IMAGEADDRESS,dic[@"comment"][@"member"][@"face"]];
        self.score = dic[@"comment"][@"score"];
        self.content = dic[@"comment"][@"content"];
        self.time_evaluate = dic[@"comment"][@"dateline"];
        self.reply = dic[@"comment"][@"reply"];
        self.comment_id = dic[@"comment"][@"comment_id"];
        self.time_reply = [HZQChangeDateLine dateLineExchangeWithTime:dic[@"comment"][@"reply_time"]];
        for (NSDictionary * dictionary in dic[@"comment"][@"photo"]) {
            NSString * photoUrl = [NSString stringWithFormat:@"%@%@",IMAGEADDRESS,dictionary[@"photo"]];
            [self.photoArray addObject:photoUrl];
        }
        if (self.comment == nil) {
            self.state =  NSLocalizedString(@"等待客户评价", NSStringFromClass([self class]));
        }else if(self.comment&&self.reply.length == 0){
            self.state =  NSLocalizedString(@"待回复", NSStringFromClass([self class]));
        }else if (self.comment&&self.reply.length > 0){
            self.state =  NSLocalizedString(@"已回复", NSStringFromClass([self class]));
        }
        if (self.photoArray.count > 0) {
            self.isPhoto = YES;
        }else{
            self.isPhoto = NO;
        }
    }
    return self;
}
@end
