//
//  JHCustomerDetailCellTwo.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/18.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHCustomerDetailCellTwo.h"
#import "HZQChangeDateLine.h"
@implementation JHCustomerDetailCellTwo
{
    UILabel * label_text;//显示内容的
    UILabel * label_date;//显示日期时间的
    UILabel * label_money;//显示消费金额的
    UIView * label_line;//创建分割线
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(JHCustomerDetailModel *)model{
    _model = model;
    self.selectionStyle = UITableViewCellSeparatorStyleNone;
    //显示内容的
    if (label_text == nil) {
        label_text = [[UILabel alloc]init];
        label_text.frame = FRAME(10, 10, WIDTH - 100, 20);
        label_text.font = [UIFont systemFontOfSize:14];
        label_text.textColor = [UIColor colorWithWhite:0.4 alpha:1];
        [self addSubview:label_text];
    }
     label_text.text = [NSString stringWithFormat:@"%@%@(%@)",NSLocalizedString(@"订单号:", nil),model.order_id,NSLocalizedString(@"完成", nil)];
    //显示时间的
    if(label_date == nil){
        label_date = [[UILabel alloc]init];
        label_date.frame = FRAME(10, 35, WIDTH - 100, 20);
        label_date.textColor = [UIColor colorWithWhite:0.6 alpha:1];
        label_date.font = [UIFont systemFontOfSize:13];
       
        [self addSubview:label_date];
    }
     label_date.text = [HZQChangeDateLine dateLineExchangeWithTime:model.dateline];
    //显示消费金额的
    if (label_money == nil) {
        label_money = [[UILabel alloc]init];
        label_money.frame = FRAME(WIDTH - 110, 20, 100, 20);
        label_money.font = [UIFont systemFontOfSize:16];
        label_money.textAlignment = NSTextAlignmentRight;
        label_money.adjustsFontSizeToFitWidth = YES;
        [self addSubview:label_money];
    }
    if ([model.amount integerValue] <  0) {
        label_money.textColor = [UIColor redColor];
        label_money.text = model.amount;
    }else{
        label_money.textColor = [UIColor greenColor];
        label_money.text = [NSString stringWithFormat:@"+%@",model.amount];
    }
    //创建分割线
    label_line = [[UIView alloc]init];
    label_line.frame = FRAME(0, 59.5, WIDTH, 0.5);
    label_line.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    [self addSubview:label_line];
}
@end
