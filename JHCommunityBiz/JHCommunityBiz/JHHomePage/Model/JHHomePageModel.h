//
//  JHHomePageModel.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/18.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHHomePageModel : NSObject
+(JHHomePageModel *)creatJHHomePageModelWithDictionary:(NSDictionary *)dic;
-(id)initWithDictionary:(NSDictionary *)dic;
@property(nonatomic,copy)NSString * money;//账户余额
@property(nonatomic,copy)NSString * today_amount;//今日营业额
@property(nonatomic,copy)NSString * today_order;//今日完成订单
@property(nonatomic,copy)NSString * have_waimai;//是否有外卖
@property(nonatomic,copy)NSString * verify;//是否认证通过
@property(nonatomic,strong)NSDictionary *count;
@end
