//
//  JHMessageCell.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/11.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHMessageCell.h"
#import "HZQChangeDateLine.h"
@implementation JHMessageCell
{
    UIView * backView;
    UILabel * label_date;//显示日期的
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}
-(void)setModel:(JHMessageModel *)model{
    _model = model;
    self.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if (backView == nil) {
        backView = [UIView new];
        backView.backgroundColor = [UIColor whiteColor];
        backView.frame = FRAME(0, 0, WIDTH, 83);
        [self addSubview:backView];
        //小红点
        self.label_point = [[UILabel alloc]init];
        self.label_point.backgroundColor =  [UIColor redColor];
        self.label_point.frame = FRAME(5, 12, 10, 10);
        self.label_point.layer.cornerRadius = 5;
        self.label_point.layer.masksToBounds = YES;
        [backView addSubview:self.label_point];
        //显示消息内容
        self.label_message = [[UILabel alloc]init];
        self.label_message.frame = FRAME(20, 0, WIDTH - 50, 50);
        [backView addSubview:self.label_message];
        //显示日期的
        label_date = [[UILabel alloc]init];
        label_date.frame = FRAME(20, 55, WIDTH - 50, 20);
        label_date.textColor = [UIColor colorWithWhite:0.6 alpha:1];
        label_date.text = [HZQChangeDateLine dateLineExchangeWithTime:model.dateline];
        label_date.font = [UIFont systemFontOfSize:15];
        [backView addSubview:label_date];
    }
    NSString * str = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"订单消息提示:", nil),model.content];
    NSRange range = [str rangeOfString:NSLocalizedString(@"订单消息提示:", nil)];
    NSMutableAttributedString * attributed = [[NSMutableAttributedString alloc]initWithString:str];
    if ([model.is_read isEqualToString:@"0"]) {
        self.label_point.hidden = NO;
        [attributed addAttributes:@{NSForegroundColorAttributeName:THEME_COLOR} range:range];
    }else{
        self.label_point.hidden = YES;
        [attributed addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.4
                                                                                     alpha:1]} range:range];
    }
    self.label_message.font = [UIFont systemFontOfSize:15];
    self.label_message.textColor = [UIColor colorWithWhite:0.4 alpha:1];
    self.label_message.numberOfLines = 0;
    self.label_message.attributedText = attributed;
}
@end
