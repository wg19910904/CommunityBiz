//
//  JHBrokenLineCell.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/12.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHIncomeModel.h"
#import "JHOrderModel.h"
#import "XYPieChart.h"
#import "UUChart.h"
@interface JHBrokenLineCell : UITableViewCell<UUChartDataSource>
- (void)configUI:(NSIndexPath *)indexPath withInfoArray:(NSMutableArray *)infoArray withNum:(int)num;
@end
