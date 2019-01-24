//
//  JHManagerOtherCell.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/23.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHManagerOtherCell : UITableViewCell
@property(nonatomic,retain)NSIndexPath * indexPath;
@property(nonatomic,retain)UILabel * label_left;
@property(nonatomic,retain)UILabel * label_right;
@property(nonatomic,retain)NSMutableArray * detailArray;

@end
