//
//  ChoseNumemberModel.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/10/8.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "ChoseNumemberModel.h"

@implementation ChoseNumemberModel
+(ChoseNumemberModel *)shareChoseNumemberModelWithDic:(NSDictionary *)dic{
    return [[ChoseNumemberModel alloc]initWithDic:dic];
}
-(id)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.childrenModelArray = @[].mutableCopy;
        self.cate_id = dic[@"cate_id"];
        self.shop_id = dic[@"shop_id"];
        self.title = dic[@"title"];
        NSArray * tempArray = dic[@"childrens"];
        for (NSDictionary * dic in tempArray) {
            childrenModel * model = [childrenModel creatChildrenWithDic:dic];
            [self.childrenModelArray addObject:model];
        }
    }
    return self;
}
@end
@implementation childrenModel

+(childrenModel *)creatChildrenWithDic:(NSDictionary *)dic{
    return [[childrenModel alloc]initWithDic:dic];
}
-(id)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.cate_id = dic[@"cate_id"];
        self.number = dic[@"number"];
        self.zhuohao_id = dic[@"zhuohao_id"];
        self.title = dic[@"title"];
    }
    return self;
}
@end