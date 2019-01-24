//
//  JHPreferentiaListCell.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/26.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHPreferentiaListModel.h"
#import "JHPreferentiaListVC.h"
#import "JHPreferentiaDetailVC.h"
@interface JHPreferentiaListCell : UITableViewCell
@property(nonatomic,weak)JHPreferentiaListVC * vc;
@property(nonatomic,retain)JHPreferentiaListModel * model;
@property(nonatomic,retain)NSIndexPath * indexPath;
@property(nonatomic,retain)UIButton * btn;//点击进入订单详情的
@end
