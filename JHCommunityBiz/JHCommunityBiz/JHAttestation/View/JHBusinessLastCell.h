//
//  JHBusinessLastCell.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/23.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHBaseVC.h"

@interface JHBusinessLastCell : UITableViewCell
@property(nonatomic,copy)NSString * area;//地址
@property(nonatomic,retain)UILabel * label_area;//显示地址的
@property(nonatomic,retain)UITextView * myTextView;//输入框
@property(nonatomic,retain)UIButton * btn;//确定的按钮
@end
