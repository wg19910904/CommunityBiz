//
//  JHFunctionCell.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/7/29.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHFunctionModel.h"
@interface JHFunctionCell : UITableViewCell
@property(nonatomic,retain)UIImageView * imageV;
@property(nonatomic,retain)UILabel * title_label;
@property(nonatomic,retain)JHFunctionModel * model;
@property(nonatomic,retain)NSIndexPath * indexPath;
@property(nonatomic,retain)UISwitch * mySwitch;
@end
