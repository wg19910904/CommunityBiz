//
//  DeliveryQiPeiAmountCell.h
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/23.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeliveryQiPeiDetailModel.h"

@class DeliveryQiPeiAmountCellField;
@interface DeliveryQiPeiAmountCell : UITableViewCell
@property(nonatomic,strong)DeliveryQiPeiDetailModel *dataModel;
@property(nonatomic,strong)DeliveryQiPeiAmountCellField * juliField,* client_pay,* third_pay;
@property(nonatomic,strong)UIButton *deleteBtn;
@property(nonatomic,assign)NSInteger row;
@property(nonatomic,assign)BOOL isThird;
@end

//定义当前cell内是用的textField
@interface DeliveryQiPeiAmountCellField : UITextField

@end
