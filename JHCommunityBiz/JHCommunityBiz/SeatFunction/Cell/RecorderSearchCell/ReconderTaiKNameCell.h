//
//  ReconderTaiKNameCell.h
//  JHCommunityBiz
//
//  Created by ijianghu on 2017/11/11.
//  Copyright © 2017年 com.jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReconderTaiKNameCell : UITableViewCell
@property(nonatomic,strong)NSArray *nameArr;
@property(nonatomic,copy)void(^clickBlock)(NSInteger index);
@end
