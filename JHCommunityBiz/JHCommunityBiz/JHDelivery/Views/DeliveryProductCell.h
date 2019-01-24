//
//  DeliveryProductCell.h
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/25.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeliveryProductCellModel.h"
#import "DeliveryProductVC.h"
//按钮类型
typedef NS_ENUM(NSInteger, EDeliveryProductBtnType)
{
    EModifyBtn = 10, //修改
    EShelfBtn,       //上架
    EOffBtn,         //下架
    EDelay           //延期
};
//cell类型
typedef NS_ENUM(NSInteger, EDeliveryProductCellType)
{
    EDeliveryProductCellTypeShelied = 0, //已上架
    EDeliveryProductCellTypeNotShelied,  //未上架
    EDeliveryProductCellTypeOverdue      //已过期
};
@interface DeliveryProductCell : UITableViewCell
@property(nonatomic,assign)EDeliveryProductCellType cellType;
@property(nonatomic,strong)UIView *back_view;
@property(nonatomic,strong)UIButton *modifyBtn;
@property(nonatomic,strong)UIButton *shelfBtn;
@property(nonatomic,strong)UIButton *OffBtn;
@property(nonatomic,strong)UIButton *delayBtn;
@property(nonatomic,strong)UIButton *specBtn;
@property(nonatomic,strong)DeliveryProductCellModel *dataModel;

@property(nonatomic,weak)UINavigationController *navVC;
@end
