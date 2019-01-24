//
//  JHGroupOrderListOtherCell.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/30.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHGroupOrderListOtherModel.h"
@interface JHGroupOrderListOtherCell : UITableViewCell
@property(nonatomic,retain)JHGroupOrderListOtherModel * model;
@property(nonatomic,retain)NSIndexPath * indexPath;
@property(nonatomic,retain)UIButton * btn;

@end
