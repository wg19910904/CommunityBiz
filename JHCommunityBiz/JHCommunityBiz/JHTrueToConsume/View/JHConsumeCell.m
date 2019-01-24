//
//  JHConsumeCell.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/25.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHConsumeCell.h"
#import "HZQChangeDateLine.h"
@implementation JHConsumeCell
{
    UIImageView * imageView;//显示密码正确的图标的
    UIView * bj_view;//创建中间的白色的区域
    UIView * label_line;//创建第一根分割线
    UIView * label_lineT;//创建第二根分割线
    UILabel * label_title;//显示标题的
    UILabel * label_money;//显示金额的
    UILabel * label_psd;//显示密码的
    UILabel * label_time;//显示有效期的
}
-(void)setModel:(JHConsumeModel *)model{
    _model = model;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    if (imageView == nil) {
        imageView = [[UIImageView alloc]init];
        imageView.frame = FRAME((WIDTH - 40)/2, 20, 40, 40);
        imageView.image = [UIImage imageNamed:@"Logon_success"];
        [self addSubview:imageView];
        //创建显示是否消费label
        UILabel * label = [[UILabel alloc]init];
        label.frame = FRAME(0, 70, WIDTH, 20);
        label.text =  NSLocalizedString(@"密码正确,是否消费此劵?", NSStringFromClass([self class]));
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor colorWithRed:97/255.0 green:206/255.0 blue:24/255.0 alpha:1];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
    }
    //创建中间的白的的区域
    if (bj_view == nil) {
        bj_view = [[UIView alloc]init];
        bj_view.frame = FRAME(10, 108, WIDTH - 20, 120);
        bj_view.backgroundColor = [UIColor whiteColor];
        bj_view.layer.cornerRadius = 3;
        bj_view.layer.masksToBounds = YES;
        bj_view.layer.borderColor = [UIColor colorWithWhite:0.95 alpha:1].CGColor;
        bj_view.layer.borderWidth = 1;
        [self addSubview:bj_view];

    }
    //创建取消和确定的按钮
    if (self.btn_array == nil) {
        UIColor * color = [UIColor colorWithWhite:0.9 alpha:1];
        UIColor * color1 = [UIColor colorWithRed:250/255.0 green:175/255.0 blue:25/255.0 alpha:1];
        NSArray * array = @[ NSLocalizedString(@"取消", NSStringFromClass([self class])), NSLocalizedString(@"确定", NSStringFromClass([self class])),color,color1];
        self.btn_array = [NSMutableArray array];
        for (int i = 0; i < 2; i++) {
            UIButton * btn = [[UIButton alloc]init];
            btn.frame = FRAME(10+((WIDTH - 40)/2+20)*i, 250, (WIDTH - 40)/2, 35);
            [btn setTitle:array[i] forState:UIControlStateNormal];
            [btn setBackgroundColor:array[i+2] forState:UIControlStateNormal];
            btn.layer.cornerRadius = 3;
            btn.layer.masksToBounds = YES;
            btn.tag = i;
            [self addSubview:btn];
            [self.btn_array addObject:btn];
      }
    }
    //创建分割线
    if (label_line == nil) {
        label_line = [[UIView alloc]init];
        label_line.frame = FRAME(10, 40, WIDTH - 40, 0.5);
        label_line.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        [bj_view addSubview:label_line];
        label_lineT = [[UIView alloc]init];
        label_lineT.frame = FRAME((WIDTH - 20)/2 - 0.5, 50, 1, 60);
        label_lineT.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        [bj_view addSubview:label_lineT];
        
    }
    //显示标题的
    if (label_title == nil) {
        label_title = [[UILabel alloc]init];
        label_title.frame = FRAME(10, 10, WIDTH - 40, 20);
        label_title.textColor = [UIColor colorWithWhite:0.2 alpha:1];
        label_title.font = [UIFont systemFontOfSize:16];
        [bj_view addSubview:label_title];
    }
    label_title.text = model.dic[@"result"][@"tuan_title"];
    //显示密码的
    if (label_psd == nil) {
        label_psd  = [[UILabel alloc]init];
        label_psd.frame = FRAME((WIDTH - 20)/2+10, 55, (WIDTH-20)/2-20, 20);
        label_psd.textColor = [UIColor colorWithWhite:0.2 alpha:1];
        label_psd.adjustsFontSizeToFitWidth = YES;
        label_psd.font = [UIFont systemFontOfSize:15];
        [bj_view addSubview:label_psd];
    }
    label_psd.text = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"密码:", NSStringFromClass([self class])),model.dic[@"tuan"][@"number"]];
    //显示有效期的
    if (label_time == nil) {
        label_time = [[UILabel alloc]init];
        label_time.frame = FRAME((WIDTH - 20)/2+10, 85, (WIDTH-20)/2-20, 20);
        label_time.textColor = [UIColor colorWithWhite:0.2 alpha:1];;
        label_time.font = [UIFont systemFontOfSize:15];
        label_time.adjustsFontSizeToFitWidth = YES;
        [bj_view addSubview:label_time];
    }
    label_time.text = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"有效期至:", NSStringFromClass([self class])),[HZQChangeDateLine dateLineExchangeWithTime:model.dic[@"result"][@"ltime"]]];
    if (label_money) {
        [label_money removeFromSuperview];
        label_money = nil;
    }
    //显示金额的
    if (label_money == nil) {
        label_money = [[UILabel alloc]init];
        label_money.frame =FRAME(10, 60, (WIDTH- 20)/2 - 20, 30);
        label_money.font = [UIFont systemFontOfSize:25];
        label_money.textColor = [UIColor orangeColor];
        NSString * str = [NSString stringWithFormat:@"%@ %@ X%@", NSLocalizedString(@"¥", NSStringFromClass([self class])),model.dic[@"result"][@"price"],model.dic[@"result"][@"tuan_number"]];
        NSString *subStr = [[str componentsSeparatedByString:@"X"]lastObject];
        subStr = [@"X" stringByAppendingString:subStr];
        NSRange range = [str rangeOfString:subStr];
        NSMutableAttributedString * attribute = [[NSMutableAttributedString alloc]initWithString:str];
        [attribute addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.7 alpha:1],NSFontAttributeName:[UIFont systemFontOfSize:15]} range:range];
        label_money.attributedText = attribute;
        label_money.textAlignment = NSTextAlignmentCenter;
        [bj_view addSubview:label_money];
    }
}
@end
