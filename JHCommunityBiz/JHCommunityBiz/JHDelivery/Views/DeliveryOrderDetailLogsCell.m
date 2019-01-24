//
//  DeliveryOrderDetailLogsCell.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/7/14.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "DeliveryOrderDetailLogsCell.h"
#import "NSDateToString.h"
@implementation DeliveryOrderDetailLogsCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)setDataArr:(NSArray *)dataArr
{
    for (__strong UIView *view in self.subviews) {
        [view removeFromSuperview];
        view = nil;
    }
    for (int i = 0; i < dataArr.count; i ++) {
        NSDictionary *dic = (NSDictionary *)dataArr[i];
        UILabel *logL = [[UILabel alloc] initWithFrame:FRAME(10, 44*i, WIDTH - 20, 44)];
        logL.textColor = HEX(@"666666", 1.0);
        logL.font = FONT(14);
        logL.text = [NSString stringWithFormat:@"%@-%@",[NSDateToString stringFromUnixTime:dic[@"dateline"]],
                     dic[@"log"]];
        [self addSubview:logL];
    }
    
}
@end
