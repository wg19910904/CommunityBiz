//
//  JHGroupOrderDetailVC.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/30.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHBaseVC.h"
typedef NS_ENUM(NSInteger,JHGroupDetailType){
    EJHGroupDetailTypeNoConsume = 0,//未消费
    EJHGroupDetailTypeConsume,//已消费
    EJHGroupDetailTypeNeedReply,//待回复
    EJHGroupDetailTypeHadReply,//已回复
    EJHGroupDetailHadDrawBack,//已退款
    EJHGroupDetailHadOverDue,//已过期
    EJHGroupDetailHadCancel,//已取消
};
@interface JHGroupOrderDetailVC : JHBaseVC<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,assign)JHGroupDetailType  type;
@property(nonatomic,copy)NSString * order_id;
@end
