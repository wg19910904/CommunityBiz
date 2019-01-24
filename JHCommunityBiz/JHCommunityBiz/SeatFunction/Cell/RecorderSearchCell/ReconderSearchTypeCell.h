//
//  ReconderSearchTypeCell.h
//  JHCommunityBiz
//
//  Created by ijianghu on 2017/11/11.
//  Copyright © 2017年 com.jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReconderSearchTypeCell : UITableViewCell
@property(nonatomic,copy)void(^choseBlock)(NSInteger index,NSString *type);
-(void)removeSelectorIndex;
@end
