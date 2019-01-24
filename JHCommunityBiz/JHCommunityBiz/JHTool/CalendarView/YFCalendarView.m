//
//  YFCalenderView.m
//  JHCommunityBiz
//
//  Created by ios_yangfei on 16/12/23.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "YFCalendarView.h"
#import "AppDelegate.h"
#import "GFCalendar.h"

@interface YFCalendarView ()
@property(nonatomic,weak)UIControl *control;
@property(nonatomic,weak)GFCalendarView *calendarView;

@end

@implementation YFCalendarView

-(instancetype)init{
    if (self = [super init]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{
    
    UIControl *control = [[UIControl alloc]init];
    control.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    control.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.4];
    [control addTarget:self action:@selector(hidden) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:control];
    self.control=control;
    
    CGFloat width = WIDTH;
    CGPoint origin = CGPointMake(0.0, HEIGHT);
    
    GFCalendarView *calendar = [[GFCalendarView alloc] initWithFrameOrigin:origin width:width];
    calendar.backgroundColor = [UIColor whiteColor];
    // 点击某一天的回调
    calendar.didSelectDayHandler = ^(NSInteger year, NSInteger month, NSInteger day){
        if (self.selectDayHandler) self.selectDayHandler(year,month,day);
        [self hidden];
    };
    self.calendarView = calendar;
    [control addSubview:calendar];
}

-(void)sheetShow{
    
    self.calendarView.current_date = self.choosedDate;
    AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.window addSubview:self.control];
    self.control.alpha=1;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.calendarView.y=HEIGHT-self.calendarView.height;
    }];
}

-(void)sheetShowInView:(UIView *)view{
    
    self.calendarView.current_date = self.choosedDate;
    [view addSubview:self.control];
    self.control.alpha=1;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.calendarView.y=HEIGHT-self.calendarView.height;
    }];
}


-(void)hidden{
    
    [UIView animateWithDuration:0.25 animations:^{
        self.calendarView.y=HEIGHT;
    }];
    
    [UIView animateWithDuration:0.4 animations:^{
        self.control.alpha=0;
    }];
    [self removeFromSuperview];
    
}

-(NSString *)choosedDate{
    if (!_choosedDate && [_choosedDate length]==0) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        _choosedDate= [dateFormatter stringFromDate:[NSDate date]];
    }
    return _choosedDate;
}
- (void)resetDate{
    _choosedDate = nil;
    self.calendarView.current_date = self.choosedDate;
    
}
@end
