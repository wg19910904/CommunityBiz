//
//  JHPreferentiaDetailCellTwo.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/27.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHPreferentiaDetailCellTwo.h"
#import "HZQChangeDateLine.h"
@implementation JHPreferentiaDetailCellTwo{
    UILabel * label_time;//显示买单时间的
    UILabel * label_name;//显示客户姓名的
    UILabel * label_phone;//显示手机号码的
    UIView * bj_view;//背景
}
-(void)setModel:(JHPreferentiaDetailModel *)model{
    _model = model;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    if (bj_view == nil) {
        bj_view = [UIView new];
        bj_view.frame = FRAME(0, 0, WIDTH, 90);
        bj_view.backgroundColor = [UIColor whiteColor];
        bj_view.layer.borderWidth = 1;
        bj_view.layer.borderColor = [UIColor colorWithWhite:0.95 alpha:1].CGColor;
        [self addSubview:bj_view];
    }
    //显示买单时间的
    if (label_time == nil) {
        label_time = [[UILabel alloc]init];
        label_time.frame = FRAME(10, 10, WIDTH - 20, 20);
        label_time.font = [UIFont systemFontOfSize:15];
        label_time.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        [bj_view addSubview:label_time];
    }
    NSString * str = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"买单时间:", NSStringFromClass([self class])),model.order_time];
    NSRange range = [str rangeOfString:[HZQChangeDateLine dateLineExchangeWithTime:model.order_time]];
    NSMutableAttributedString * attribute = [[NSMutableAttributedString alloc]initWithString:str];
    [attribute addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.6 alpha:1]} range:range];
    label_time.attributedText = attribute;
    //显示客户姓名的
    if (label_name == nil) {
        label_name = [[UILabel alloc]init];
        label_name.frame = FRAME(10, 35, WIDTH - 20, 20);
        label_name.font = [UIFont systemFontOfSize:15];
        label_name.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        [bj_view addSubview:label_name];
    }
    NSString * str1 = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"客户姓名:", NSStringFromClass([self class])),model.name];
    NSRange range1 = [str1 rangeOfString:model.name];
    NSMutableAttributedString * attribute1 = [[NSMutableAttributedString alloc]initWithString:str1];
    [attribute1 addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.6 alpha:1]} range:range1];
    label_name.attributedText = attribute1;
    //显示手机号码的
    if (label_phone == nil) {
        label_phone = [[UILabel alloc]init];
        label_phone.frame = FRAME(10, 60, WIDTH - 20, 20);
        label_phone.font = [UIFont systemFontOfSize:15];
        label_phone.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        [bj_view addSubview:label_phone];
    }
    NSString * str2 = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"手机号码:", NSStringFromClass([self class])),model.mobile];
    NSRange range2 = [str2 rangeOfString:model.mobile];
    NSMutableAttributedString * attribute2 = [[NSMutableAttributedString alloc]initWithString:str2];
    [attribute2 addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.6 alpha:1]} range:range2];
    label_phone.attributedText = attribute2;
}
@end
