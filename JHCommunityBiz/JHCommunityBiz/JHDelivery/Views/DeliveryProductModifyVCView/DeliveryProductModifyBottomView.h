//
//  DeliveryProductModifyBottomView.h
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/30.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, EDeliveryProductModifyBottomViewType)
{
    EBottomTypeShelf = 0, //已上架
    EBottomTypeNotShelf,  //未上架
    EBottomTypeOverdue    //已过期
};
@interface DeliveryProductModifyBottomView : UIView
@property(nonatomic,assign)EDeliveryProductModifyBottomViewType BottomType;
@end
