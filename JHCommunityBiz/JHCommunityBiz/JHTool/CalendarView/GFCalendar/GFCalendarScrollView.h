//
//  GFCalendarScrollView.h
//
//  Created by Mercy on 2016/11/9.
//  Copyright © 2016年 Mercy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^DidSelectDayHandler)(NSInteger, NSInteger, NSInteger);

@interface GFCalendarScrollView : UIScrollView


@property (nonatomic, copy) DidSelectDayHandler didSelectDayHandler; // 日期点击回调

- (void)refreshToCurrentMonth; // 刷新 calendar 回到当前日期月份

/**
 *  选中的日期
 */
@property(nonatomic,copy)NSString *current_date;
@end
