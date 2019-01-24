//
//  JHConsumeCell.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/25.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHConsumeModel.h"
@interface JHConsumeCell : UITableViewCell
@property(nonatomic,retain)JHConsumeModel * model;
@property(nonatomic,retain)NSMutableArray * btn_array;
@end
