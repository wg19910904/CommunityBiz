//
//  DeliveryOrderListVC.h
//  JHCommunityBiz
//
//  Created by xixixi on 2017/12/20.
//  Copyright © 2017年 com.jianghu. All rights reserved.
//

#import "JHBaseVC.h"

typedef NS_ENUM(NSUInteger,EWaimai_OrderList_type){
    EWaimai_OrderList_type_daijiedan = 1, //待接单
    EWaimai_OrderList_type_delivering,    //进行中
    EWaimai_OrderList_type_complete,      //已完成
    EWaimai_OrderList_type_cancel         //已取消
};
@interface DeliveryOrderListVC : JHBaseVC
@property(nonatomic,assign)EWaimai_OrderList_type listType;
@property(nonatomic,retain)NSMutableDictionary *addCondition;
@property(nonatomic,weak)JHBaseVC *superVC;
-(void)loadNewData;
@end
