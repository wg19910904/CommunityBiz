//
//  JHGroupChitRecordCell.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/25.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHGroupChitRecordCell.h"
#import "HZQChangeDateLine.h"
@implementation JHGroupChitRecordCell{
    UIImageView * imageView_header;//头像
    UIView * label_line;//分割线
    UILabel * label_code;//展示劵码的
    UILabel * label_text;//显示代金券名字的
    UILabel * label_money;//显示价格的
    UILabel * label_time;//显示时间的
}
-(void)setModel:(JHGroupChitRecordModel *)model{
    _model = model;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if (imageView_header) {
        [imageView_header removeFromSuperview];
        imageView_header = nil;
    }
    if (imageView_header == nil) {
        imageView_header = [[UIImageView alloc]init];
        imageView_header.frame = FRAME(10, 10, 30, 30);
        imageView_header.image = [UIImage imageNamed:@"home_ticket"];
        [self addSubview:imageView_header];
    }
    //创建分割线
    if (label_line) {
        [label_line removeFromSuperview];
        label_line = nil;
    }
    if (label_line == nil) {
        label_line = [[UIView alloc]init];
        label_line.frame = FRAME(0, 99.5, WIDTH, 0.5);
        label_line.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        [self addSubview:label_line];
    }
    //展示劵码的
    if (label_code == nil) {
        label_code = [[UILabel alloc]init];
        label_code.frame = FRAME(50, 15, WIDTH-50 -120, 20);
        label_code.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        label_code.font = [UIFont systemFontOfSize:15];
        [self addSubview:label_code];
    }
    label_code.text = model.number;
    //显示代金券名字的
    if (label_text == nil) {
        label_text = [[UILabel alloc]init];
        label_text.frame = FRAME(50, 45, WIDTH - 50, 20);
        label_text.textColor = [UIColor colorWithWhite:0.6 alpha:1];
        label_text.font = [UIFont systemFontOfSize:15];
        [self addSubview:label_text];
    }
    label_text.text = model.title;
    //显示价格的
    if(label_money == nil){
        label_money = [[UILabel alloc]init];
        label_money.frame = FRAME(50, 65, WIDTH - 50, 35);
        label_money.font = [UIFont systemFontOfSize:17];
        label_money.textColor = [UIColor colorWithWhite:0.6 alpha:1];
               [self addSubview:label_money];
    }
    NSString * str = [NSString stringWithFormat:@"%@%@    x%@", NSLocalizedString(@"¥", NSStringFromClass([self class])),model.price,model.count];
    NSRange range = [str rangeOfString: NSLocalizedString(@"¥", NSStringFromClass([self class]))];
    NSMutableAttributedString  * attribute = [[NSMutableAttributedString alloc]initWithString:str];
    [attribute addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} range:range];
    label_money.attributedText = attribute;

    //显示时间的
    if (label_time == nil) {
        label_time = [[UILabel alloc]init];
        label_time.frame = FRAME(WIDTH - 120, 15, 110, 20);
        label_time.textColor = [UIColor colorWithWhite:0.6 alpha:1];
        label_time.font = [UIFont systemFontOfSize:12];
        [self addSubview:label_time];
    }
    label_time.text = [HZQChangeDateLine dateLineExchangeWithTime:model.dateline];
}
@end
