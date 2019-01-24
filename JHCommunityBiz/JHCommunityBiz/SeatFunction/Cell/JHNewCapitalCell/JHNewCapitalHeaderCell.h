//
//  JHNewCapitalHeaderCell.h
//  JHCommunityBiz
//
//  Created by ijianghu on 2017/11/29.
//  Copyright © 2017年 com.jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHNewCapitalHeaderCell : UITableViewCell
@property(nonatomic,copy)void(^clickBlock)();
@property(nonatomic,copy)NSString *money;
@end
