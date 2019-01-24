//
//  JHTakeTheirModel.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/26.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHTakeTheirModel.h"
#import "HZQChangeDateLine.h"
@implementation JHTakeTheirModel
-(id)initJHTakeTheirModelWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.infoArray = @[].mutableCopy;
        self.order_id = dic[@"waimai"][@"order"][@"order_id"];
        self.dateline = [HZQChangeDateLine dateLineExchangeWithTime:dic[@"waimai"][@"order"][@"dateline"]];
        self.spend_number = dic[@"waimai"][@"spend_number"]?dic[@"waimai"][@"spend_number"]:@"";
        self.contact = dic[@"waimai"][@"order"][@"contact"]?dic[@"waimai"][@"order"][@"contact"]:@"";
        self.mobile = dic[@"waimai"][@"order"][@"mobile"]?dic[@"waimai"][@"order"][@"mobile"]:@"";
        self.intro = dic[@"waimai"][@"order"][@"intro"];
        self.intro = self.intro.length > 0? self.intro:NSLocalizedString(@"无", nil);
        self.total_price = dic[@"waimai"][@"order"][@"total_price"];
        self.amount = dic[@"waimai"][@"order"][@"amount"];
        self.order_youhui = dic[@"waimai"][@"order"][@"order_youhui"];
        self.first_youhui = dic[@"waimai"][@"order"][@"first_youhui"];
        self.hongbao_id = dic[@"waimai"][@"order"][@"hongbao_id"];
        self.hongbao = [self.hongbao_id integerValue] > 0? dic[@"waimai"][@"order"][@"hongbao"]:@"0";
        NSArray * tempArray = dic[@"result"];
        for (NSDictionary * dic in tempArray) {
            JHDishModel * model = [[JHDishModel alloc]initJHDishModelWithDictionary:dic];
            [self.infoArray addObject:model];
        }
        self.package_price = dic[@"waimai"][@"order"][@"package_price"];
    }
    return self;
}

@end
@implementation JHDishModel
-(id)initJHDishModelWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.product_name = dic[@"product_name"];
        self.product_number = dic[@"product_number"];
        self.product_price = dic[@"product_price"];
    }
    return self;
}
@end
