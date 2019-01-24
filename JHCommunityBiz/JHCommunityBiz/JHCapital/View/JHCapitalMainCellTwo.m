//
//  JHCapitalMainCellTwo.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/19.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHCapitalMainCellTwo.h"
#import "HZQChangeDateLine.h"
@implementation JHCapitalMainCellTwo
{
    UILabel * label_title;//第三方支付收入
    UILabel * label_time;//显示时间的
    UILabel * label_money;//显示金额的
    UIView * view;
}
- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(JHCapitalModel *)model{
    _model = model;
    self.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
     //self.selectionStyle = UITableViewCellSelectionStyleNone;
    if (label_title == nil) {
        view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        view.frame = FRAME(0, 0, WIDTH, 60);
        [self addSubview:view];
        label_title = [[UILabel alloc]init];
        label_title.frame = FRAME(10, 10, WIDTH - 100, 20);
        label_title.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        label_title.font = [UIFont systemFontOfSize:15];
                [view addSubview:label_title];
        label_time = [[UILabel alloc]init];
        label_time.frame = FRAME(10, 35, WIDTH - 100, 20);
        label_time.font = [UIFont systemFontOfSize:13];
        label_time.textColor = [UIColor colorWithWhite:0.7 alpha:1];
        [view addSubview:label_time];
        label_money = [[UILabel alloc]init];
        label_money.frame = FRAME(WIDTH - 110, 20, 100, 20);
        label_money.textAlignment = NSTextAlignmentRight;
        label_money.adjustsFontSizeToFitWidth = YES;
        [view addSubview:label_money];
    }
    label_time.text = [HZQChangeDateLine dateLineExchangeWithTime:model.dateline];
    label_title.text = model.intro;
    if ([model.money integerValue] < 0) {
         label_money.textColor = [UIColor redColor];
         label_money.text = model.money;
    }else{
        label_money.textColor = [UIColor greenColor];
         label_money.text = [NSString stringWithFormat:@"+%@",model.money];
    }
    
}
@end
