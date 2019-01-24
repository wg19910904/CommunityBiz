//
//  DeliveryOrderPeiCell.h
//  JHCommunityBiz
//
//  Created by xixixi on 16/7/8.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeliveryOrderCellModel.h"
@interface DeliveryOrderPeiCell : UITableViewCell
@property(nonatomic,strong)UIButton *replyBtn;
@property(nonatomic,strong)UIButton *deliveryBtn;
@property(nonatomic,strong)DeliveryOrderCellModel *dataModel;
@end
