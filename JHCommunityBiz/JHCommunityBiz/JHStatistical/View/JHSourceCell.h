//
//  JHSourceCell.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/12.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHSourceModel.h"
#import "XYPieChart.h"
@interface JHSourceCell : UITableViewCell<XYPieChartDataSource,XYPieChartDelegate>
@property(nonatomic,retain)JHSourceModel * model;
@property(nonatomic,retain)NSIndexPath * indexpath;
@property(nonatomic,retain)XYPieChart * view_bj;
@property(nonatomic, strong) NSMutableArray *slices;
@property(nonatomic, strong) NSArray        *sliceColors;
@property(nonatomic, strong) NSMutableArray *array;
@property(nonatomic, strong) NSMutableArray *nameArray;
@end
