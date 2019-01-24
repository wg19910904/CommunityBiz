//
//  JHGroupDetailModel.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/30.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHGroupDetailModel : NSObject
+(JHGroupDetailModel * )creatJHGroupDetailModelWithDictioanaryWithDic:(NSDictionary *)dic;
-(id)initWithDictionary:(NSDictionary *)dic;
@property(nonatomic,copy)NSString *hongbao;
@property(nonatomic,assign)NSInteger  type;//状态
@property(nonatomic,copy)NSString * order_id;//这是订单号
@property(nonatomic,copy)NSString * dateline;//这是下单时间的
@property(nonatomic,copy)NSString * ltime;//这是显示有效期的
@property(nonatomic,copy)NSString * shop_logo;//这是商家的图标的
@property(nonatomic,copy)NSString * shop_title;//这是商家的名字的
@property(nonatomic,copy)NSString * tuan_number;//这是团购的份数的
@property(nonatomic,copy)NSString * total_price;//这是团购的总价的
@property(nonatomic,copy)NSString * number;//这是验证码的
@property(nonatomic,copy)NSString * count;//这是显示个数的
@property(nonatomic,copy)NSString * content;//这是显示评价的内容的
@property(nonatomic,retain)NSMutableArray  * photoArray;//存放照片的数组
@property(nonatomic,copy)NSString * evaluate_time;//这是显示评价时间的
@property(nonatomic,copy)NSString * reply;//这是回复的内容的
@property(nonatomic,copy)NSString * reply_time;//这是回复时间的
@property(nonatomic,copy)NSString * order_state_label;//这是显示状态的文字
@property(nonatomic,copy)NSString * status;//这是判断团购券是否已经都使用了
@property(nonatomic,copy)NSString * score;//评价的星级
@property(nonatomic,copy)NSString * face;//评价客户的头像
@property(nonatomic,copy)NSString * contact;//客户的姓名
@property(nonatomic,copy)NSString * mobile;//客户的电话
@property(nonatomic,copy)NSString * comment_id;
@end
