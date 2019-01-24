//
//  PaiduiModel.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/9/30.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,EPaiduiStatus){
    EPaiduiStatusHasCancel =-1,//已取消
    EPaiduiStatusHasGetNummenber,//排队中
    EPaiduiStatusHasMakeOrder,//已接单
    EPaiduiStatusHasEat,//已就餐
};
@interface PaiduiModel : NSObject
@property(nonatomic,assign)EPaiduiStatus status;//状态
@property(nonatomic,copy)NSString *order_state_label;//状态
@property(nonatomic,copy)NSString *paidui_id;//排队ID
@property(nonatomic,copy)NSString *zhuohao_id;
@property(nonatomic,copy)NSString *contact;//联系人
@property(nonatomic,copy)NSString *mobile;//联系方式
@property(nonatomic,copy)NSString *paidui_number;//就餐人数
@property(nonatomic,copy)NSString *title;//桌号信息
@property(nonatomic,copy)NSString *reason;//取消理由

+(PaiduiModel *)sharePaiduiModelWithDic:(NSDictionary*)dic;
-(id)initWithDic:(NSDictionary *)dic;
@end
