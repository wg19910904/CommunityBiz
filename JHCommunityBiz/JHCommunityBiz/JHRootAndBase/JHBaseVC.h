//
//  JHBaseVC.h
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/9.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHBaseVC : UIViewController
@property(nonatomic,strong)UIButton *backBtn;
- (void)touch_BackView;
-(void)clickBackBtn;
/**
 *  用于提示信息(在控制器的View上)
 *
 *  @param title 提示信息
 */
- (void)showToastAlertMessageWithTitle:(NSString *)title;
@end
