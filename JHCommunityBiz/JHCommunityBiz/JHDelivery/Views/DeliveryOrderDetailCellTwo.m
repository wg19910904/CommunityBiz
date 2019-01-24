//
//  DeliveryOrderDetailCellTwo.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/7/9.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "DeliveryOrderDetailCellTwo.h"
#import "NSDateToString.h"
@implementation DeliveryOrderDetailCellTwo
{
    UILabel *_order_timeL;
    UILabel *_delivery_timeL;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = 0;
        //make ui
        [self makeUI];
    }
    return self;
}
- (void)makeUI
{
    _order_timeL = [[UILabel alloc] initWithFrame:FRAME(10, 0, WIDTH - 90, 35)];
    _order_timeL.font = FONT(14);
    _order_timeL.textColor = HEX(@"333333", 1.0);
    [self addSubview:_order_timeL];
    
    _delivery_timeL = [UILabel new];
    _delivery_timeL.frame = FRAME(10, 35, 60, 25);
    _delivery_timeL.textColor = [UIColor whiteColor];
    _delivery_timeL.font = FONT(14);
    _delivery_timeL.backgroundColor = HEX(@"faaf19",1.0f);
    _delivery_timeL.layer.cornerRadius = 10;
    _delivery_timeL.layer.masksToBounds = YES;
    _delivery_timeL.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_delivery_timeL];
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    _order_timeL.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"下单时间:", nil),
                         [NSDateToString stringFromUnixTime:dataDic[@"dateline"]]];
    
    _delivery_timeL.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"送达时间:", nil),dataDic[@"pei_time"]];
    _delivery_timeL.frame = FRAME(10, 35, getSize(_delivery_timeL.text, 25, 14).width + 15, 20);
}
@end
