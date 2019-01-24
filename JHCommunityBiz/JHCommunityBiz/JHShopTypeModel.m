//
//  JHShopTypeModel.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/6/24.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHShopTypeModel.h"
@implementation JHShopTypeModel
static JHShopTypeModel * model = nil;
+(JHShopTypeModel *)shareShopTypeModel{
   
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[JHShopTypeModel alloc]init];
    });
    return model;
}
@end
