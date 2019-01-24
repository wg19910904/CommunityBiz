//
//  JHTakeTheirCellTwo.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/26.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHTakeTheirCellTwo.h"
@implementation JHTakeTheirCellTwo{
    UIView * bj_view;//创建白色的背景
    UILabel * label_line;//创建分割线
    UILabel * label_order;//显示订单号的
    UILabel * label_time;//显示下单时间的
    UILabel * label;//显示中间的验证密码和有效期的
}
-(void)setModel:(JHTakeTheirModel *)model{
    _model = model;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    if (bj_view == nil) {
        bj_view = [[UIView alloc]init];
        bj_view.frame = FRAME(10, 0, WIDTH - 20, 120);
        bj_view.backgroundColor = [UIColor whiteColor];
        bj_view.layer.cornerRadius = 3;
        bj_view.layer.masksToBounds = YES;
        bj_view.layer.borderColor = [UIColor colorWithWhite:0.95 alpha:1].CGColor;
        bj_view.layer.borderWidth = 1;
        [self addSubview:bj_view];
    }
    //创建分割线
    label_line  = [[UILabel alloc]init];
    label_line.frame = FRAME(10, 50, WIDTH - 40, 1);
    label_line.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    [bj_view addSubview:label_line];
    //创建显示订单号的
    if (label_order == nil) {
        label_order = [[UILabel alloc]init];
        label_order.frame = FRAME(10, 5, WIDTH - 40, 20);
        label_order.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        label_order.font = [UIFont systemFontOfSize:15];
        [bj_view addSubview:label_order];
    }
    label_order.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"订单号:", NSStringFromClass([self class])),model.order_id];
    //创建显示下单时间的
    if(label_time == nil){
        label_time = [[UILabel alloc]init];
        label_time.frame = FRAME(10, 26, WIDTH - 40, 20);
        label_time.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        label_time.font = [UIFont systemFontOfSize:14];
        [bj_view addSubview:label_time];
    }
    label_time.text = model.dateline;
    //创建显示有效期的
    if (label == nil) {
        label = [[UILabel alloc]init];
        label.frame = FRAME(10, 55, WIDTH - 40, 50);
        label.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        label.font = [UIFont systemFontOfSize:14];
        label.numberOfLines = 0;
        [bj_view addSubview:label];
    }
    NSString * str = [NSString stringWithFormat:@"%@\n%@", NSLocalizedString(@"验证密码", NSStringFromClass([self class])),model.spend_number];
    NSRange range = [str rangeOfString:model.spend_number];
    NSMutableAttributedString * attributed = [[NSMutableAttributedString alloc]initWithString:str];
    [attributed addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:250/255.0 green:175/255.0 blue:25/255.0 alpha:1],NSFontAttributeName:[UIFont systemFontOfSize:18]} range:range];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:6];
    [attributed addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0,str.length)];
    label.attributedText = attributed;
    
}
@end
