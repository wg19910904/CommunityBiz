//
//  JHGroupOrderListOtherModel.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/30.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHGroupOrderListOtherModel : NSObject
+(JHGroupOrderListOtherModel *)creatJHGroupOrderListOtherModelWithDictionary:(NSDictionary *)dic;
-(id)initWithDictionary:(NSDictionary *)dic;
@property(nonatomic,copy)NSString * from_name;
@property(nonatomic,copy)NSString * order_id;//订单号
@property(nonatomic,copy)NSString * order_status;//状态()
@property(nonatomic,copy)NSString * order_status_label;//可以显示的状态
@property(nonatomic,copy)NSString * order_status_warning;//在当前的状态下的提示
@property(nonatomic,copy)NSString * shop_logo;//商店图片的logo
@property(nonatomic,copy)NSString * shop_title;//商店的名字
@property(nonatomic,copy)NSString * total_price;//总价
@property(nonatomic,copy)NSString * ltime;//过期时间
@property(nonatomic,copy)NSString * tuan_id;//团购id
@property(nonatomic,copy)NSString * tuan_number;//团购的份数
@property(nonatomic,copy)NSString * tuan_price;//团购的单价
@property(nonatomic,copy)NSString * tuan_title;
@property(nonatomic,copy)NSString * comment_reply;//判断是否已经回复的
@property(nonatomic,copy)NSString * comment_status;//判断是否已经评价的
@property(nonatomic,assign)NSInteger  type;//订单的类型
@end
