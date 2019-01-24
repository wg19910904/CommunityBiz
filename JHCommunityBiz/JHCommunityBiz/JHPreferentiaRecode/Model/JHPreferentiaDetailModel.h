//
//  JHPreferentiaDetailModel.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/27.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHPreferentiaDetailModel : NSObject
@property(nonatomic,copy)NSString * order_id;//订单号
@property(nonatomic,copy)NSString * order_time;//买单时间
@property(nonatomic,copy)NSString * name;//客户姓名
@property(nonatomic,copy)NSString * mobile;//用户电话
@property(nonatomic,copy)NSString * total_price;//消费金额
@property(nonatomic,copy)NSString * youhui_price;//享受优惠金额
@property(nonatomic,copy)NSString * unyouhui_price;//不享受优惠金额
@property(nonatomic,copy)NSString * amount;//实际支付的金额
@property(nonatomic,copy)NSString * headUrl;//用户头像的网址
@property(nonatomic,copy)NSString * score;//星星的评价数
@property(nonatomic,copy)NSString * content;//评价的内容
@property(nonatomic,copy)NSString * time_evaluate;//评价的时间
@property(nonatomic,copy)NSString * comment_id;
@property(nonatomic,copy)NSString * reply;//回复的内容
@property(nonatomic,copy)NSString * time_reply;//回复的内容的时间
@property(nonatomic,retain)NSDictionary * comment;//是否存在评价
@property(nonatomic,retain)NSMutableArray * photoArray;//存放的是评价的图片的网址
@property(nonatomic,copy)NSString * state;
@property(nonatomic,assign)BOOL isPhoto;
-(id)initWithDictionary:(NSDictionary *)dic;
@end
