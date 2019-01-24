//
//  DeliveryOrderDetailCellOne.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/7/9.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "DeliveryOrderDetailCellOne.h"

@implementation DeliveryOrderDetailCellOne
{
    UILabel *_order_idL;
    UILabel *_is_zitiL;
    UILabel *_statusL;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = 0;
        //make ui
        [self makeUI];
        
    }
    return self;
}
- (void)makeUI
{
    _order_idL = [[UILabel alloc] initWithFrame:FRAME(10, 0, 100, 44)];
    _order_idL.font = FONT(14);
    _order_idL.textColor = HEX(@"333333", 1.0);
    
    _is_zitiL = [[UILabel alloc] initWithFrame:FRAME(0, 9.5, 50, 25)];
    _is_zitiL.backgroundColor = THEME_COLOR;
    _is_zitiL.font = FONT(14);
    _is_zitiL.textColor = [UIColor whiteColor];
    _is_zitiL.layer.cornerRadius = 3;
    _is_zitiL.layer.masksToBounds = YES;
    _is_zitiL.textAlignment = NSTextAlignmentCenter;
    
    _statusL = [[UILabel alloc] initWithFrame:FRAME(WIDTH - 70, 0, 60, 44)];
    _statusL.font = FONT(14);
    _statusL.textColor = HEX(@"fd432b", 1.0);
    _statusL.textAlignment = NSTextAlignmentRight;
    
    [self addSubview:_order_idL];
    [self addSubview:_is_zitiL];
    [self addSubview:_statusL];
}
- (void)setDataDic:(NSDictionary *)dataDic
{
    NSString *order_idStr = [NSLocalizedString(@"订单号:", nil) stringByAppendingString:dataDic[@"order_id"]?dataDic[@"order_id"]:@""];
    _order_idL.text = order_idStr;
    _order_idL.frame = FRAME(10, 0, getSize(order_idStr, 44, 14).width, 44);
    
    _statusL.text = dataDic[@"order_status_label"] ? dataDic[@"order_status_label"] : @"";
    _statusL.adjustsFontSizeToFitWidth = YES;
    NSString *ziti = dataDic[@"is_ziti"];
    if ([ziti  isEqualToString:@"1"]) {
        _is_zitiL.hidden = NO;
        _is_zitiL.frame = FRAME(_order_idL.frame.size.width + 15, 9.5, 50, 25);
        _is_zitiL.text = NSLocalizedString(@"自提单", nil);
        
    }else{
        _is_zitiL.hidden = YES;
    }
    
}
@end
