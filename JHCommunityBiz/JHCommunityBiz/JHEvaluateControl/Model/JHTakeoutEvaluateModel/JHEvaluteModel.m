//
//  JHEvaluteModel.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/13.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHEvaluteModel.h"

@implementation JHEvaluteModel
+(JHEvaluteModel *)creatJHEvaluteModelWithDictionary:(NSDictionary *)dic{
    return [[JHEvaluteModel alloc]initWithDictionary:dic];
}
-(id)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.photoArray = @[].mutableCopy;
        self.comment_id = dic[@"comment_id"];
        self.face = [NSString stringWithFormat:@"%@%@",IMAGEADDRESS,dic[@"member"][@"face"]];
        self.nickname = dic[@"member"][@"nickname"];
        self.score_fuwu = dic[@"score_fuwu"];
        self.score_kouwei = dic[@"score_kouwei"];
        self.score = dic[@"score"];
        self.time_pei = dic[@"pei_time"];
        self.content = dic[@"content"];
        NSArray  * tempArray = dic[@"photo_list"];
        if (tempArray.count > 0) {
            for (NSString * str in tempArray) {
                NSString * urlString  = [NSString stringWithFormat:@"%@%@",IMAGEADDRESS,str];
                [self.photoArray addObject:urlString];
            }
        }
        self.pei_time_label = dic[@"pei_time_label"];
        self.time_evaluate = dic[@"dateline"];
        self.reply = dic[@"reply"];
        self.time_reply = dic[@"reply_time"];
    }
    return self;
}
@end
