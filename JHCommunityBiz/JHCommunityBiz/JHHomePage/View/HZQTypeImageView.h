//
//  HZQTypeImageView.h
//  JHLive
//
//  Created by ijianghu on 16/8/18.
//  Copyright © 2016年 ijianghu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HZQButton.h"
@protocol HZQTypeImageViewDelegate<NSObject>
@optional
-(void)clickToButton:(HZQButton *)sender;
@end
@interface HZQTypeImageView : UIView
/**
 *  重写初始化方法
 *
 *  @param size       size
 *  @param imageArray 图片的数组
 *  @param titleArray 文本的数组
 *
 *  @return
 */
@property(nonatomic,assign)id<HZQTypeImageViewDelegate>delegate;
-(id)initwithSize:(CGSize)size
   withImageArray:(NSArray *)imageArray
   withTitleArray:(NSArray *)titleArray
   withNumArray:(NSArray *)numArray;
@end
