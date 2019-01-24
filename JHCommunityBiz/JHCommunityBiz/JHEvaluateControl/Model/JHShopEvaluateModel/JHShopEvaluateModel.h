//
//  JHShopEvaluateModel.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/25.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHShopEvaluateModel : NSObject
+(JHShopEvaluateModel *)creatJHShopEvaluateModelWithDictiionary:(NSDictionary *)dic;
-(id)initWithDictioanry:(NSDictionary *)dic;
@property(nonatomic,copy)NSString * comment_id;
@property(nonatomic,copy)NSString * face;//用户头像
@property(nonatomic,copy)NSString * nickname;//用户昵称
@property(nonatomic,copy)NSString * score;//评价的星星数
@property(nonatomic,copy)NSString * content;//评价的内容
@property(nonatomic,retain)NSMutableArray * photoArray;//存放图片的数组
@property(nonatomic,copy)NSString * time_evaluate;//评价的时间
@property(nonatomic,copy)NSString * reply;//回复的内容
@property(nonatomic,copy)NSString * time_reply;//回复的时间
@end
