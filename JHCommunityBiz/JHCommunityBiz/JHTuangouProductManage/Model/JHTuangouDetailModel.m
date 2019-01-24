//
//  JHTuangouDetailModel.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/7/18.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHTuangouDetailModel.h"
#import "HZQChangeDateLine.h"
@implementation JHTuangouDetailModel
+(JHTuangouDetailModel *)creatJHTuangouDetailModelWithDictionary:(NSDictionary *)dic{
    return [[JHTuangouDetailModel alloc]initWithDictionary:dic];
}
-(id)initWithDictionary:(NSDictionary *)dic{
    if (self = [super init]) {

        self.photo = [NSString stringWithFormat:@"%@%@",IMAGEADDRESS,dic[@"photo"]];
        self.title = dic[@"title"];
        self.min_buy = dic[@"min_buy"];
        self.max_buy = dic[@"max_buy"];
        self.stock_type = dic[@"stock_type"];
        self.stock_num = dic[@"stock_num"];
        self.orderby = dic[@"orderby"];
        self.price = dic[@"price"];
        self.market_price = dic[@"market_price"];
        self.stime = [HZQChangeDateLine ExchangeWithDateline:dic[@"stime"]];
        self.ltime = [HZQChangeDateLine ExchangeWithDateline:dic[@"ltime"]];
        self.notice = dic[@"notice"];
        self.detail = dic[@"detail"];
        self.type = dic[@"type"];
        self.sales = dic[@"sales"];
        self.is_onsale = dic[@"is_onsale"];
        self.desc = dic[@"desc"];
    }
    return self;
}
@end
