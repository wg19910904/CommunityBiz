//
//  JHCludeModel.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/7/25.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHCludeModel : NSObject
+(JHCludeModel *)creatJHCludeModelWithDic:(NSDictionary *)dic;
-(id)initWithDic:(NSDictionary *)dic;
@property(nonatomic,copy)NSString * apikey;
@property(nonatomic,copy)NSString * dateline;
@property(nonatomic,copy)NSString * ylyun;
@property(nonatomic,copy)NSString * machine_code;
@property(nonatomic,copy)NSString * mkey;
@property(nonatomic,copy)NSString * partner;
@property(nonatomic,copy)NSString * plat_id;
@property(nonatomic,copy)NSString * shop_id;
@property(nonatomic,copy)NSString * status;
@property(nonatomic,copy)NSString * title;
@end
