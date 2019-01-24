//
//  JHHomeMoneyCell.h
//  JHCommunityBiz
//
//  Created by ijianghu on 2017/11/15.
//  Copyright © 2017年 com.jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHHomeMoneyCell : UITableViewCell
@property(nonatomic,copy)void(^clickBlock)();
@property(nonatomic,strong)NSDictionary *dic;
@end
