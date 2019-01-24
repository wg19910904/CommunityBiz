//
//  JHStatiscalMainCell.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/12.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHstatiscalModel.h"
@interface JHStatiscalMainCell : UITableViewCell
@property(nonatomic,retain)JHstatiscalModel * model;
@property(nonatomic,retain)NSArray * titleArray;
@property(nonatomic,retain)NSArray * dataArray;
@property(nonatomic,retain)NSMutableArray * labelArray;
@end
