//
//  PaiduiCell.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/9/30.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaiduiModel.h"
@interface PaiduiCell : UITableViewCell
@property(nonatomic,strong)UILabel *status_label;//显示状态的
@property(nonatomic,strong)UILabel *order_label;//显示单号的
@property(nonatomic,strong)UILabel *name_phone_label;//显示姓名和电话的
@property(nonatomic,strong)UIButton *phoneBtn; //显示打电话按钮
@property(nonatomic,strong)UILabel *people_num;//显示就餐人数的
@property(nonatomic,strong)UIButton *btn;//确认就餐的按钮
@property(nonatomic,strong)UIButton *btn_jie;//接单的按钮
@property(nonatomic,strong)UIButton *btn_cancle;//拒绝接单的按钮
@property(nonatomic,strong)UILabel *label_zhuo;//显示就餐人数的
@property(nonatomic,strong)UILabel *label_cancel;//显示取消人数的
@property(nonatomic,retain)PaiduiModel *model;
@property(nonatomic,retain)NSIndexPath *indexPath;
@property(nonatomic,copy)void(^myBlock)(UIButton *sender);
@end