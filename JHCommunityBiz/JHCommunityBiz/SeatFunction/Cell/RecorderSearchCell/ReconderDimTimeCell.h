//
//  ReconderDimTimeCell.h
//  JHCommunityBiz
//
//  Created by ijianghu on 2017/11/11.
//  Copyright © 2017年 com.jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReconderDimTimeCell : UITableViewCell
//删除选中的状态
-(void)removeSelecter;
@property(nonatomic,copy)void(^clickBlock)(NSInteger tag);
@end