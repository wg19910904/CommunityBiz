//
//  JHCludeTableViewCell.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/7/25.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHCludeModel.h"
@interface JHCludeTableViewCell : UITableViewCell
@property(nonatomic,retain)UILabel * title_label;
@property(nonatomic,retain)UIButton * btn_delete;
@property(nonatomic,retain)UIButton * btn_revise;
@property(nonatomic,retain)UIButton * btn_set;
@property(nonatomic,retain)JHCludeModel * model;
@property(nonatomic,retain)NSIndexPath * indexPath;
@end
