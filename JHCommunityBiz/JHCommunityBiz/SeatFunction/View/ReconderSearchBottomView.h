//
//  ReconderSearchBottomView.h
//  JHCommunityBiz
//
//  Created by ijianghu on 2017/11/11.
//  Copyright © 2017年 com.jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReconderSearchBottomView : UIControl
-(void)showView;
-(void)clickRemove;

/**
 名字的数组
 */
@property(nonatomic,strong)NSArray *nameArr;

/**
 确定的回调
 */
@property(nonatomic,copy)void(^sureBlock)(NSString *name,NSInteger index);
/**
 之前选中的台卡名称
 */
@property(nonatomic,copy)NSString *seleterStr;
@end
