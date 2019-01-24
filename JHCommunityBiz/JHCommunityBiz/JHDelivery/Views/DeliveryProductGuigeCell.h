//
//  DeliveryProductGuigeCell.h
//  JHCommunityBiz
//
//  Created by xixixi on 16/7/7.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeliveryProductGuigeCellModel.h"
@interface DeliveryProductGuigeCell : UITableViewCell
@property(nonatomic,strong)DeliveryProductGuigeCellModel *dataModel;
@property(nonatomic,strong)UIButton *modifyBtn;
@property(nonatomic,strong)UIButton *deleteBtn;
@end
