//
//  AddSeatModel.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/9/30.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,EAddSeatStatus){
    EAddSeatStatusHasCancel = -1,//已取消
    EAddSeatStatusToSure,//已取号
    EAddSeatStatusHasSure,//已确认
    EAddSeatStatusHasCompletion,//已完成
    
};
@interface AddSeatModel : NSObject
@property(nonatomic,assign)EAddSeatStatus status;//状态
@property(nonatomic,copy)NSString *order_state_label;//状态
@property(nonatomic,copy)NSString *yuyue_time;//预约时间
@property(nonatomic,copy)NSString *contact;//联系人
@property(nonatomic,copy)NSString *mobile;//联系方式
@property(nonatomic,copy)NSString *yuyue_number;//就餐人数
@property(nonatomic,copy)NSString *reason;//取消原因
@property(nonatomic,copy)NSString *dingzuo_id;//id
@property(nonatomic,copy)NSString *zhuohao_id;
@property(nonatomic,copy)NSString *notice;//通知
@property(nonatomic,assign)float height;//高度
+(AddSeatModel *)shareAddSeatModelWithDic:(NSDictionary*)dic;
-(id)initWithDic:(NSDictionary *)dic;
@end
