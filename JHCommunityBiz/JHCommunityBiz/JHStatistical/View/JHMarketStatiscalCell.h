//
//  JHMarketStatiscalCell.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/7/1.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHMarketModel.h"
#import "XYPieChart.h"
@interface JHMarketStatiscalCell : UITableViewCell<XYPieChartDataSource,XYPieChartDelegate>
@property(nonatomic,retain)JHMarketModel * model;
@property(nonatomic,retain)NSIndexPath * indexpath;
@property(nonatomic,retain)XYPieChart * view_bj;
@property(nonatomic, strong) NSMutableArray *slices;
@property(nonatomic, strong) NSArray        *sliceColors;
@property(nonatomic, strong) NSMutableArray *array;
@property(nonatomic, strong) NSMutableArray *nameArray;
@property(nonatomic, strong) NSMutableArray *infoArray;
@end
