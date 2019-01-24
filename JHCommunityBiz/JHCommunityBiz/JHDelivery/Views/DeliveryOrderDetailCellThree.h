//
//  DeliveryOrderDetailCellThree.h
//  JHCommunityBiz
//
//  Created by xixixi on 16/7/9.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeliveryOrderDetailCellThree : UITableViewCell
@property(nonatomic,strong)UILabel *clientL;
@property(nonatomic,strong)UILabel *phoneL;
@property(nonatomic,strong)UILabel *addrL;
@property(nonatomic,strong)UILabel *noteL;
@property(nonatomic,copy)NSDictionary *dataDic;
@property(nonatomic,weak)UINavigationController *navVC;
+ (CGFloat)getHeight:(NSDictionary *)dic;
@end
