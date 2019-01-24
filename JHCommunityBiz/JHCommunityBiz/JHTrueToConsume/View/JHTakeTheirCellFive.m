//
//  JHTakeTheirCellFive.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/26.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHTakeTheirCellFive.h"

@implementation JHTakeTheirCellFive{
    UIView * bj_view;//创建白色的背景
    UILabel * label_total;//显示总价的
    UILabel * label_actual;//显示实际支付的
    UILabel * label_one;//显示满减优惠的
    UILabel * label_two;//显示首单立减的
    UILabel * label_three;//显示红包抵扣的
    NSMutableArray * youhuiArray;//存放优惠方式的
    NSMutableArray * colorArray;//存放颜色数组的
}
-(void)setModel:(JHTakeTheirModel *)model{
    _model = model;
    self.backgroundColor =[UIColor colorWithWhite:0.98 alpha:1];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if (bj_view == nil) {
        youhuiArray = @[].mutableCopy;
        colorArray = @[].mutableCopy;
        bj_view = [[UIView alloc]init];
        bj_view.frame = FRAME(10, 0, WIDTH - 20, 70);
        bj_view.backgroundColor = [UIColor whiteColor];
        bj_view.layer.cornerRadius = 3;
        bj_view.layer.masksToBounds = YES;
        bj_view.layer.borderColor = [UIColor colorWithWhite:0.95 alpha:1].CGColor;
        bj_view.layer.borderWidth = 1;
        [self addSubview:bj_view];
        if ([model.order_youhui integerValue] > 0) {
            NSString * str = [NSString stringWithFormat:@"%@%ld%@", NSLocalizedString(@"满减优惠", NSStringFromClass([self class])),[model.order_youhui integerValue], NSLocalizedString(@"元", NSStringFromClass([self class]))];
            [youhuiArray addObject:str];
            [colorArray addObject:[UIColor colorWithRed:255/255.0 green:105/255.0 blue:1/255.0 alpha:1]];
        }
        if ([model.first_youhui integerValue] > 0) {
            NSString * str = [NSString stringWithFormat:@"%@%ld%@", NSLocalizedString(@"首单立减", NSStringFromClass([self class])),[model.first_youhui integerValue], NSLocalizedString(@"元", NSStringFromClass([self class]))];
            [youhuiArray addObject:str];
            [colorArray addObject:[UIColor colorWithRed:0 green:15/255.0 blue:104/255.0 alpha:1]];
        }
        if ([model.hongbao integerValue] > 0) {
            NSString * str = [NSString stringWithFormat:@"%ld%@%@",[model.hongbao integerValue], NSLocalizedString(@"元", NSStringFromClass([self class])), NSLocalizedString(@"红包抵扣", NSStringFromClass([self class]))];
            [colorArray addObject:[UIColor colorWithRed:250/255.0 green:63/255.0 blue:46/255.0 alpha:1]];
            [youhuiArray addObject:str];
        }
        
    }
    //创建显示总价的
    if(label_total == nil){
        label_total = [[UILabel alloc]init];
        label_total.frame = FRAME(WIDTH - 80, 10, 70, 20);
        label_total.textColor = [UIColor colorWithRed:250/255.0 green:175/255.0 blue:25/255.0 alpha:1];
        label_total.font = [UIFont systemFontOfSize:15];
        label_total.adjustsFontSizeToFitWidth = YES;
        [bj_view addSubview:label_total];
        UILabel * lab = [[UILabel alloc]init];
        lab.frame = FRAME(10, 10, 50, 20);
        lab.text =  NSLocalizedString(@"合计", NSStringFromClass([self class]));
        lab.font = [UIFont systemFontOfSize:14];
        lab.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        [bj_view addSubview:lab];
    }
    NSString * str = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"¥", NSStringFromClass([self class])),model.total_price];
    NSRange range = [str rangeOfString: NSLocalizedString(@"¥", NSStringFromClass([self class]))];
    NSMutableAttributedString * attribute = [[NSMutableAttributedString alloc]initWithString:str];
    [attribute addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.3 alpha:1]} range:range];
    label_total.attributedText = attribute;
    //显示实际支付的
    if (label_actual == nil) {
        label_actual = [[UILabel alloc]init];
        label_actual.frame = FRAME(WIDTH - 80, 40, 70, 20);
        label_actual.textColor = [UIColor colorWithRed:250/255.0 green:175/255.0 blue:25/255.0 alpha:1];
        label_actual.font = [UIFont systemFontOfSize:15];
        label_actual.adjustsFontSizeToFitWidth = YES;
        [bj_view addSubview:label_actual];
        UILabel * lab = [[UILabel alloc]init];
        lab.frame = FRAME(10, 40, 50, 20);
        lab.text =  NSLocalizedString(@"结算价", NSStringFromClass([self class]));
        lab.font = [UIFont systemFontOfSize:14];
        lab.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        [bj_view addSubview:lab];

    }
    NSString * str1 = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"¥", NSStringFromClass([self class])),model.amount];
    NSRange range1 = [str1 rangeOfString: NSLocalizedString(@"¥", NSStringFromClass([self class]))];
    NSMutableAttributedString * attributed = [[NSMutableAttributedString alloc]initWithString:str1];
    [attributed addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.3 alpha:1]} range:range1];
    label_actual.attributedText = attributed;
    if (youhuiArray.count > 0) {
        for (int i = 0; i < youhuiArray.count; i ++) {
            UILabel * label = [[UILabel alloc]init];
            label.frame = FRAME(WIDTH - (150 + i*65), 13,60, 15);
            label.backgroundColor = colorArray[i];
            label.font = [UIFont systemFontOfSize:10];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor whiteColor];
            label.adjustsFontSizeToFitWidth = YES;
            [bj_view addSubview:label];
            label.text = youhuiArray[i];
        }
    }
//    //显示满减优惠的
//    if(label_one == nil){
//        label_one = [[UILabel alloc]init];
//        label_one.frame = FRAME(WIDTH - 270, 13, 60, 15);
//        label_one.backgroundColor = [UIColor colorWithRed:255/255.0 green:105/255.0 blue:1/255.0 alpha:1];
//        label_one.font = [UIFont systemFontOfSize:10];
//        label_one.textAlignment = NSTextAlignmentCenter;
//        label_one.textColor = [UIColor whiteColor];
//        label_one.adjustsFontSizeToFitWidth = YES;
//        [bj_view addSubview:label_one];
//    }
//    label_one.text = [NSString stringWithFormat:@"%@%ld%@",NSLocalizedString(@"满减优惠", nil),[model.order_youhui integerValue],NSLocalizedString(@"元", nil)];
//    if ([model.order_youhui integerValue] > 0) {
//        
//    }
//    //显示首单立减的
//    if (label_two == nil) {
//        label_two = [[UILabel alloc]init];
//        label_two.frame = FRAME(WIDTH - 205, 13, 60, 15);
//        label_two.backgroundColor = [UIColor colorWithRed:0 green:15/255.0 blue:104/255.0 alpha:1];
//        label_two.font = [UIFont systemFontOfSize:10];
//        label_two.text = NSLocalizedString(@"首单立减5元", nil);
//        label_two.textAlignment = NSTextAlignmentCenter;
//        label_two.textColor = [UIColor whiteColor];
//        label_two.adjustsFontSizeToFitWidth = YES;
//        [bj_view addSubview:label_two];
//
//    }
//    //显示红包抵扣的
//    if (label_three == nil) {
//        label_three = [[UILabel alloc]init];
//        label_three.frame = FRAME(WIDTH - 140, 13, 60, 15);
//        label_three.backgroundColor = [UIColor colorWithRed:250/255.0 green:63/255.0 blue:46/255.0 alpha:1];
//        label_three.font = [UIFont systemFontOfSize:10];
//        label_three.text = NSLocalizedString(@"5元红包抵扣", nil);
//        label_three.textAlignment = NSTextAlignmentCenter;
//        label_three.textColor = [UIColor whiteColor];
//        label_three.adjustsFontSizeToFitWidth = YES;
//        [bj_view addSubview:label_three];
//    }
}
@end
