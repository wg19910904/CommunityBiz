//
//  JHCurveCell.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/12.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHCurveCell.h" 

@implementation JHCurveCell
{
   
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (self.view_bj == nil) {
        self.view_bj = [[BEMSimpleLineGraphView alloc]init];
        self.view_bj.frame = FRAME(5, 30, WIDTH - 20, 160);
        [self.view_bj setDataSource:self];
        [self.view_bj setDelegate:self];
        [self addSubview:self.view_bj];
        self.labelDates = [[UILabel alloc]init];
        self.labelDates.frame = FRAME(10, 173, WIDTH - 20, 20);
        self.labelDates.textAlignment = NSTextAlignmentCenter;
        self.labelDates.textColor = [UIColor colorWithWhite:0.4 alpha:1];
        self.labelDates.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.labelDates];
    }
}
-(void)creatNSMutableArray:(NSMutableArray *)infoArray withNSMutableArray:(NSMutableArray *)dateArray{
    if (self.label_title==nil) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.label_title = [[UILabel alloc]init];
        self.label_title.frame = FRAME(10, 5, WIDTH, 20);
        self.label_title.textColor = [UIColor colorWithWhite:0.4 alpha:1];
        self.label_title.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.label_title];
    }
    if (infoArray.count == 0||dateArray.count == 0) {
        return;
    }
    self.view_bj.enableTouchReport = YES;
    self.view_bj.enablePopUpReport = YES;
    self.view_bj.enableYAxisLabel = YES;
    self.view_bj.autoScaleYAxis = YES;
    self.view_bj.alwaysDisplayDots = NO;
    self.view_bj.enableReferenceXAxisLines = YES;
    self.view_bj.enableReferenceYAxisLines = YES;
    self.view_bj.enableReferenceAxisFrame = YES;
    self.view_bj.enableXAxisLabel = YES;
    self.view_bj.enableBezierCurve = YES;
    myInfoArray = infoArray;
    self.arrayOfDates = dateArray;
    [self hydrateDatasets];
    [self.view_bj reloadGraph];
    self.labelDates.text = [NSString stringWithFormat:@"%@ 到 %@",[dateArray[0] substringWithRange:NSMakeRange(5, 5)],[dateArray[dateArray.count - 1] substringWithRange:NSMakeRange(5, 5)]];
    self.labelDates.adjustsFontSizeToFitWidth = YES;
}
- (void)hydrateDatasets {
    if (!self.arrayOfValues) {
        self.arrayOfValues = [NSMutableArray array];
    }
    [self.arrayOfValues removeAllObjects];
    BOOL showNullValue = true;
    for (int i = 0; i < myInfoArray.count; i++) {
        [self.arrayOfValues addObject:@([self getRandomFloatWithNum:i])];
        if (i == 0) {
        } else if (showNullValue && i == 4) {
            self.arrayOfValues[i] = @(BEMNullGraphValue);
        } else {
            
        }
    }
    NSLog(@"......%@.....",self.arrayOfDates);
}
- (NSString *)labelForDateAtIndex:(NSInteger)index {
    NSString * time = [self.arrayOfDates[index] substringWithRange:NSMakeRange(5, 5)];
    return time;
}
- (float)getRandomFloatWithNum:(int)num {
    float i1 = [myInfoArray[num] floatValue];
    NSLog(@"%f====%@",i1,myInfoArray[num] );
    return i1;
}
#pragma mark - SimpleLineGraph Data Source

- (NSInteger)numberOfPointsInLineGraph:(BEMSimpleLineGraphView *)graph {
    return (int)[self.arrayOfValues count];
}

- (CGFloat)lineGraph:(BEMSimpleLineGraphView *)graph valueForPointAtIndex:(NSInteger)index {
    return [[self.arrayOfValues objectAtIndex:index] doubleValue];
}
- (void)lineGraph:(BEMSimpleLineGraphView *)graph didTouchGraphWithClosestIndex:(NSInteger)index {
    self.labelDates.text = [NSString stringWithFormat:@"%@", [self labelForDateAtIndex:index]];
}
- (void)lineGraph:(BEMSimpleLineGraphView *)graph didReleaseTouchFromGraphWithClosestIndex:(CGFloat)index {
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.labelDates.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.labelDates.text = [NSString stringWithFormat:@"%@ 到 %@", [self labelForDateAtIndex:0], [self labelForDateAtIndex:self.arrayOfDates.count - 1]];
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.labelDates.alpha = 1.0;
        } completion:nil];
    }];
}
- (NSString *)lineGraph:(BEMSimpleLineGraphView *)graph labelOnXAxisForIndex:(NSInteger)index {
    NSString *label = [self labelForDateAtIndex:index];
    return [label stringByReplacingOccurrencesOfString:@" " withString:@"\n"];
}

@end
