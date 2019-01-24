//
//  JHGroupOrderDetailCellFour.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/31.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHGroupOrderDetailCellFour.h"

@implementation JHGroupOrderDetailCellFour{
    UIView * bj_view;
    UILabel * label_resson;
    UILabel * label_way;
    UILabel * label_money;
}
-(void)setModel:(JHGroupDetailModel *)model{
    _model = model;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    if (bj_view == nil) {
        bj_view = [UIView new];
        bj_view.frame = FRAME(0, 10, WIDTH, 120);
        bj_view.backgroundColor = [UIColor whiteColor];
        bj_view.layer.borderColor = [UIColor colorWithWhite:0.95 alpha:1].CGColor;
        bj_view.layer.borderWidth = 1;
        [self addSubview:bj_view];
        //创建第一根分割线
        UIView * label_line = [[UIView alloc]init];
        label_line.frame = FRAME(0, 39.5, WIDTH, 0.5);
        label_line.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        [bj_view addSubview:label_line];
        //创建第二根分割线
        UIView * label_l = [[UIView alloc]init];
        label_l.frame = FRAME(0, 79.5, WIDTH, 0.5);
        label_l.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        [bj_view addSubview:label_l];
    }
    if (label_resson == nil) {
        label_resson = [[UILabel alloc]init];
        label_resson.frame = FRAME(10, 10, WIDTH - 10, 20);
        label_resson.adjustsFontSizeToFitWidth = YES;
        label_resson.font = [UIFont systemFontOfSize:15];
        label_resson.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        [bj_view addSubview:label_resson];
    }
    NSString * str =  NSLocalizedString(@"退款原因: 计划改变", NSStringFromClass([self class]));
    NSRange range = [str rangeOfString: NSLocalizedString(@"计划改变", NSStringFromClass([self class]))];
    NSMutableAttributedString * attributed = [[NSMutableAttributedString alloc]initWithString:str];
    [attributed addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.6 alpha:1]} range:range];
    label_resson.attributedText = attributed;
    if (label_way == nil) {
        label_way = [[UILabel alloc]init];
        label_way.frame = FRAME(10, 50, WIDTH - 10, 20);
        label_way.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        label_way.adjustsFontSizeToFitWidth = YES;
        label_way.font = [UIFont systemFontOfSize:15];
        [bj_view addSubview:label_way];
    }
    NSString * str1 =  NSLocalizedString(@"现金退还方式: 原路退还", NSStringFromClass([self class]));
    NSRange range1 = [str1 rangeOfString: NSLocalizedString(@"原路退还", NSStringFromClass([self class]))];
    NSMutableAttributedString * attributed1 = [[NSMutableAttributedString alloc]initWithString:str1];
    [attributed1 addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.6 alpha:1]} range:range1];
    label_way.attributedText = attributed1;
    if (label_money == nil) {
        label_money =[[UILabel alloc]init];
        label_money.frame = FRAME(10, 90, WIDTH - 10, 20);
        label_money.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        label_money.font = [UIFont systemFontOfSize:15];
        [bj_view addSubview:label_money];
    }
    NSString * str2 =  NSLocalizedString(@"退款金额: 20元 (已退款)", NSStringFromClass([self class]));
    NSRange range2 = [str2 rangeOfString: NSLocalizedString(@"20元 (已退款)", NSStringFromClass([self class]))];
    NSMutableAttributedString * attributed2 = [[NSMutableAttributedString alloc]initWithString:str2];
    [attributed2 addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:250/255.0 green:175/255.0 blue:25/255.0 alpha:1]} range:range2];
    label_money.attributedText = attributed2;
}
@end
