//
//  DeliverySubClassifyCell.h
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/23.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeliverySubClassifyDetailModel.h"
@interface DeliverySubClassifyCell : UITableViewCell
@property(nonatomic,strong)DeliverySubClassifyDetailModel *dataModel;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIButton *editBtn;
@end
