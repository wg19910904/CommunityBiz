//
//  JHTuangouProductManagerModel.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/7/12.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHTuangouProductManagerModel.h"
#import "HZQChangeDateLine.h"
@implementation JHTuangouProductManagerModel
+(JHTuangouProductManagerModel *)creatJHTuangouProductManagerModelWithDic:(NSDictionary *)dic{
    return [[JHTuangouProductManagerModel alloc]initWithDictionary:dic];
}
-(id)initWithDictionary:(NSDictionary *)dic{
    if (self == [super init]) {
        self.dateline = [HZQChangeDateLine dateLineExchangeWithTime:dic[@"dateline"]];
        self.is_onsale = dic[@"is_onsale"];
        self.ltime = [HZQChangeDateLine ExchangeWithDateline:dic[@"ltime"]];
        self.stime = [HZQChangeDateLine ExchangeWithDateline:dic[@"stime"]];
        self.market_price = dic[@"market_price"];
        self.price = dic[@"price"];
        self.title = dic[@"title"];
        self.photo = [NSString stringWithFormat:@"%@%@",IMAGEADDRESS,dic[@"photo"]];
        self.stock_num = dic[@"stock_num"];
        self.sales = dic[@"sales"];
        self.stock_type = dic[@"stock_type"];
        self.tuan_id = dic[@"tuan_id"];
    }
    return self;
}
@end
