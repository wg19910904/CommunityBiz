//
//  JHHomePageCellOne.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/18.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHHomePageModel.h"
#import "HZQTypeImageView.h"
#import "HZQButton.h"
@interface JHHomePageCellOne : UITableViewCell<HZQTypeImageViewDelegate>
@property(nonatomic,retain)JHHomePageModel * model;
@property(nonatomic,retain)UIButton * btn;
@property(nonatomic,retain)UIButton * btn_group;
@property(nonatomic,retain)UIButton * btn_hui;
@property(nonatomic,retain)UIButton * btn_bill;
@property(nonatomic,retain)UIButton * btn_TodayOrder;
@property(nonatomic,retain)UIButton * btn_TodayIncome;
@property(nonatomic,retain)UITextField * textFiled;//输入框
@property(nonatomic,copy)void(^(myBlock))(NSInteger num);
@end
