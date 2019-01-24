//
//  DeliveryYouhuiCell.h
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/24.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeliveryYouhuiDetailModel.h"
@class DeliveryYouhuiCellField;
@interface DeliveryYouhuiCell : UITableViewCell
@property(nonatomic,strong)DeliveryYouhuiDetailModel *dataModel;
@property(nonatomic,assign)NSInteger row;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,strong)UIButton *deleteBtn;
@property(nonatomic,strong)DeliveryYouhuiCellField *man_field,*jian_field;
@end

//cell内field
@interface DeliveryYouhuiCellField : UITextField
@end