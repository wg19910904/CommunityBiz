//
//  DeliveryOrderCell.h
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/24.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeliveryOrderCellModel.h"
@interface DeliveryOrderCell : UITableViewCell
//out
@property(nonatomic,strong)UIButton *replyBtn;
@property(nonatomic,strong)UIButton *giveUpBtn;
@property(nonatomic,strong)UIButton *actionBtn;
@property(nonatomic,strong)DeliveryOrderCellModel *dataModel;
@end
