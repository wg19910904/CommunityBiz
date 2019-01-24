//
//  DeliveryIntroCell.h
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/19.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface DeliveryIntroCell : UITableViewCell<UITextViewDelegate>
//店铺简介
@property(nonatomic,strong)UITextView *introTextView;
@property(nonatomic,assign)BOOL isShop;
+ (CGFloat)getHeightWith:(NSString *)introString;

@end
