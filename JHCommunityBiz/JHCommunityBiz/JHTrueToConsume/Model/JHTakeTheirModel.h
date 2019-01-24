//
//  JHTakeTheirModel.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/26.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHTakeTheirModel : NSObject
-(id)initJHTakeTheirModelWithDictionary:(NSDictionary *)dic;
@property(nonatomic,copy)NSString * order_id;//订单号
@property(nonatomic,copy)NSString * dateline;//下单时间
@property(nonatomic,copy)NSString * spend_number;//密码
@property(nonatomic,copy)NSString * contact;//客户名
@property(nonatomic,copy)NSString * mobile;//电话号码
@property(nonatomic,copy)NSString * intro;//备注
@property(nonatomic,retain)NSMutableArray * infoArray;//存放菜的数组
@property(nonatomic,copy)NSString * total_price;//总价
@property(nonatomic,copy)NSString * amount;//结算价
@property(nonatomic,copy)NSString * order_youhui;//满减优惠
@property(nonatomic,copy)NSString * first_youhui;//首单立减
@property(nonatomic,copy)NSString * hongbao;//红包
@property(nonatomic,copy)NSString * hongbao_id;//红包id
@property(nonatomic,copy)NSString * package_price;//打包费
@end
@interface JHDishModel : NSObject
-(id)initJHDishModelWithDictionary:(NSDictionary *)dic;
@property(nonatomic,copy)NSString * product_name;//菜的名字
@property(nonatomic,copy)NSString * product_number;//份数
@property(nonatomic,copy)NSString * product_price;//单价
@end
