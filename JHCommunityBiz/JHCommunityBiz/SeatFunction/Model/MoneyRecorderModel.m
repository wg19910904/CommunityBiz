//
//  MoneyRecorderModel.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/10/11.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "MoneyRecorderModel.h"
#import "HZQChangeDateLine.h"
@implementation MoneyRecorderModel
+(MoneyRecorderModel *)creatMoneyRecorderModelWithDic:(NSDictionary *)dic{
    return [[MoneyRecorderModel alloc]initWithDic:dic];
}
-(id)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.amount = dic[@"amount"];
        self.order_type = dic[@"order_type"];
        self.type = dic[@"type"];
        self.time = [HZQChangeDateLine dateLineExchangeWithTime:dic[@"dateline"] withString:@"HH:mm"];
        self.date = [HZQChangeDateLine dateLineExchangeWithTime:dic[@"dateline"] withString:@"yyyy/MM/dd"];
        self.type_code = dic[@"type_code"];
        if ([self.type_code isEqualToString:@"deccapay"]) {
            self.image = IMAGE(@"icon_pay03");
        }else if ([self.type_code isEqualToString:@"wxpay"]){
            self.image = IMAGE(@"icon_pay01");
        }else{
            self.image = IMAGE(@"icon_pay02");
        }
        self.po_id = dic[@"po_id"];
        
    }
    return self;
}
@end
