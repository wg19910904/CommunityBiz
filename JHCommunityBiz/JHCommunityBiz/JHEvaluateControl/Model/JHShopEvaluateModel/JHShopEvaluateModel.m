//
//  JHShopEvaluateModel.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/25.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHShopEvaluateModel.h"

@implementation JHShopEvaluateModel
+(JHShopEvaluateModel *)creatJHShopEvaluateModelWithDictiionary:(NSDictionary *)dic{
    return [[JHShopEvaluateModel alloc]initWithDictioanry:dic];
}
-(id)initWithDictioanry:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.photoArray = @[].mutableCopy;
        self.comment_id = dic[@"comment_id"];
        self.face = [NSString stringWithFormat:@"%@%@",IMAGEADDRESS,dic[@"member"][@"face"]];
        self.nickname = dic[@"member"][@"nickname"];
        self.score = dic[@"score"];
        self.content = dic[@"content"];
        NSArray  * tempArray = dic[@"photo_list"];
        if (tempArray.count > 0) {
            for (NSString * str in tempArray) {
                NSString * urlString  = [NSString stringWithFormat:@"%@%@",IMAGEADDRESS,str];
                [self.photoArray addObject:urlString];
            }
  
        }
        self.time_evaluate = dic[@"dateline"];
        self.reply = dic[@"reply"];
        self.time_reply = dic[@"reply_time"];
        
    }
    return self;
}
@end
