//
//  JHMessageCell.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/11.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHMessageModel.h"
@interface JHMessageCell : UITableViewCell
@property(nonatomic,retain)JHMessageModel * model;
@property(nonatomic,retain)UILabel * label_point;//最新消息的小红点;
@property(nonatomic,retain)UILabel * label_message;//显示信息的
@end
