//
//  JHGroupOrderListCell.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/28.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHGroupListModel.h"
@interface JHGroupOrderListCell : UITableViewCell
@property(nonatomic,retain)JHGroupListModel * model;
@property(nonatomic,retain)UIButton * btn_cancel;//取消按钮
@property(nonatomic,retain)UIButton * btn_Verification;//验证按钮
@end
