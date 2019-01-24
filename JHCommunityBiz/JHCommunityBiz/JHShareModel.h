//
//  JHShareModel.h
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/10.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import "XHBlueToothModel.h"
@interface JHShareModel : NSObject
/**
 *  返回单例
 *
 *  @return 单例
 */
+ (JHShareModel *)shareModel;
/**
 *  网络状态监听
 */
@property(nonatomic,strong)Reachability *hostReach;
/**
 *  保存店铺的id
 */
@property(nonatomic,copy)NSString *shop_id;
/**
 *  保存店铺的id
 */
@property(nonatomic,copy)NSString *shop_name;
/**
 *  商家所在城市的code
 */
@property(nonatomic,copy)NSString *cityCode;
/**
 *  商家联系名称
 */
@property(nonatomic,copy)NSString *contact;
/**
 *  商家电话
 */
@property(nonatomic,copy)NSString *mobile;
/**
 *  当前城市
 */
@property(nonatomic,copy)NSString *cityName;
/**
 *  商家信息
 */
@property(nonatomic,retain)NSDictionary * infoDictionary;
/***************************以下为保存设置的选项******************************/
/**
 *  打印机的选择方式
 *  两种type:blueTooth,yunPrint
 */
@property(nonatomic,copy)NSString *printType;
/**
 *  蓝牙打印model
 */
@property(nonatomic,strong)XHBlueToothModel *blueTooth;
/**
 *  是否开启了免打扰
 */
@property(nonatomic,assign)BOOL noDisturb;
/**
 *  是否开启了优惠买单自动打印
 */
@property(nonatomic,assign)BOOL maidan_autoPrint;
/**
 *  是否开启了外送订单自动打印
 */
@property(nonatomic,assign)BOOL waisong_autoPrint;
/**
 *  外送模板
 */
@property(nonatomic,copy)NSString * tmpl_type;
/**
 *  排队还是订座(0:排队 1:订座)
 */
@property(nonatomic,assign)NSInteger tag;
@property(nonatomic,retain)NSIndexPath *indexP;
/**
 *  支付宝还是微信(0:支付宝 1:微信)
 */
@property(nonatomic,assign)NSInteger index;
/**
 保存当前版本
 */
@property(nonatomic,copy)NSString *version;
@property(nonatomic,assign)BOOL isNotUpdate;//是否强制升级


//存储默认的区号
@property(nonatomic,copy)NSString *def_code;


//开启网络监听
- (void)addReachability;
//获取当前位置
- (void)getCurrentLocation;
//初始化蓝牙model类
-(void)initblueTooth;
@end
