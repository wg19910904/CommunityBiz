//
//  DeliveryProductAllModifyBottomView.h
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/27.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, EDeliveryProductAllModifyType)
{
    EStatusShelf = 0, //已上架
    EStatusNotShelf,  //未上架
    EStatusOverdue    //已过期
};
@interface DeliveryProductAllModifyBottomView : UIView
@property(nonatomic,assign)EDeliveryProductAllModifyType bottomViewType;
@property(nonatomic,strong)UIButton *selectAllBtn;
@property(nonatomic,strong)UIButton *shelfBtn;
@property(nonatomic,strong)UIButton *outShelfBtn;
@end
