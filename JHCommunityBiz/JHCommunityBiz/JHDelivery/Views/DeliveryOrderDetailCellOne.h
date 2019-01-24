//
//  DeliveryOrderDetailCellOne.h
//  JHCommunityBiz
//
//  Created by xixixi on 16/7/9.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeliveryOrderDetailCellOne : UITableViewCell
@property(nonatomic,strong)UILabel *order_idL;
@property(nonatomic,strong)UILabel *is_zitiL;
@property(nonatomic,strong)UILabel *statusL;
@property(nonatomic,copy)NSDictionary *dataDic;
@end
