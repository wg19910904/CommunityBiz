//
//  DeliveryOrderNavView.h
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/24.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeliveryOrderNavView : UIView
@property(nonatomic,strong)UIButton *btn1;
@property(nonatomic,strong)UIButton *btn2;
@property(nonatomic,strong)UIButton *btn3;
@property(nonatomic,strong)UIButton *btn4;
@property(nonatomic,strong)UIView *indicateView;
/**
 *  初始化方法
 *
 *  @param frame      frame
 *  @param titleArray title数组
 *
 *  @return 类实例
 */
- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSArray<NSString *>*)titleArray;
@end
