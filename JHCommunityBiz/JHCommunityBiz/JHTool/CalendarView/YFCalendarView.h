//
//  YFCalenderView.h
//  JHCommunityBiz
//
//  Created by ios_yangfei on 16/12/23.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SelectDayHandler)(NSInteger, NSInteger, NSInteger);

@interface YFCalendarView : UIView
@property(nonatomic,copy)SelectDayHandler selectDayHandler;
//@"2016-12-23"
@property(nonatomic,copy)NSString *choosedDate;

-(void)sheetShow;

-(void)sheetShowInView:(UIView *)view;

- (void)resetDate;
@end
