//
//  JHHomePageModel.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/18.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHHomePageModel.h"

@implementation JHHomePageModel
+(JHHomePageModel *)creatJHHomePageModelWithDictionary:(NSDictionary *)dic{
    return [[JHHomePageModel alloc]initWithDictionary:dic];
}
-(id)initWithDictionary:(NSDictionary *)dic{
    if (self = [super init]) {
        self.money = dic[@"money"];
        self.today_amount = dic[@"today_amount"];
        self.today_order = dic[@"today_order"];
        self.have_waimai = dic[@"have_waimai"];
        self.verify = dic[@"verify"][@"verify"];
        self.count = dic[@"count"];
    }
    return self;
}
@end
