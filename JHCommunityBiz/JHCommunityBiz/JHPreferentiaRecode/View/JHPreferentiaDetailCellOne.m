//
//  JHPreferentiaDetailCellOne.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/27.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHPreferentiaDetailCellOne.h"

@implementation JHPreferentiaDetailCellOne{
    UILabel * label_order;//显示订单号的
    UILabel * label_state;//显示状态的
    UIView * view;//bj
}
-(void)setModel:(JHPreferentiaDetailModel *)model{
    _model = model;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    if (label_order == nil) {
        view = [UIView new];
        view.frame = FRAME(0, 0, WIDTH, 40);
        view.backgroundColor = [UIColor whiteColor];
        view.layer.borderColor = [UIColor colorWithWhite:0.95 alpha:1].CGColor;
        view.layer.borderWidth = 1;
        [self addSubview:view];
        label_order = [[UILabel alloc]init];
        label_order.frame = FRAME(10, 10, WIDTH - 100, 20);
        label_order.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        label_order.font = [UIFont systemFontOfSize:15];
        [view addSubview:label_order];
    }
    NSString * str = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"订单号:", NSStringFromClass([self class])),model.order_id];
    NSRange range = [str rangeOfString:model.order_id];
    NSMutableAttributedString * attribute = [[NSMutableAttributedString alloc]initWithString:str];
    [attribute addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.6 alpha:1]} range:range];
    label_order.attributedText = attribute;
    if (label_state == nil) {
        label_state  = [[UILabel alloc]init];
        label_state.frame = FRAME(WIDTH - (model.state.length*15+30), 10, model.state.length*15+20, 20);
        label_state.textColor = [UIColor colorWithRed:250/255.0 green:72/255.0 blue:54/255.0 alpha:1];
        label_state.textAlignment = NSTextAlignmentRight;
        label_state.font = [UIFont systemFontOfSize:15];
        [view addSubview:label_state];
    }
    label_state.text = model.state;
}
@end
