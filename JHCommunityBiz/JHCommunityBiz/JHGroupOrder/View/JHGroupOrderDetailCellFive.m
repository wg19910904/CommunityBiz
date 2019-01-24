//
//  JHGroupOrderDetailCellFive.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/31.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHGroupOrderDetailCellFive.h"

@implementation JHGroupOrderDetailCellFive{
    UIImageView * bj_view;
    UILabel * label_code;
    UILabel * label_state;
    UILabel * label_num;//显示份数的
}
-(void)setModel:(JHGroupDetailModel *)model{
    _model = model;
    self.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if (bj_view == nil) {
        bj_view = [UIImageView new];
        bj_view.frame = FRAME(5, 10, WIDTH - 10, 102);
        bj_view.backgroundColor = [UIColor whiteColor];
        bj_view.layer.cornerRadius = 3;
        bj_view.layer.masksToBounds = YES;
        bj_view.layer.borderColor = [UIColor colorWithWhite:0.95 alpha:1].CGColor;
        bj_view.layer.borderWidth = 1;
        bj_view.image = [UIImage imageNamed:@"ma_box"];
        [self addSubview:bj_view];
        UILabel * label = [[UILabel alloc]init];
        label.frame = FRAME(75, 20, 60, 20);
        label.text =  NSLocalizedString(@"验证码", NSStringFromClass([self class]));
        label.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        label.font = [UIFont systemFontOfSize:15];
        [bj_view addSubview:label];
    }
    if (label_code == nil) {
        label_code = [[UILabel alloc]init];
        label_code.frame = FRAME(75, 60, WIDTH - 85, 20);
        label_code.textColor = [UIColor colorWithWhite:0.6 alpha:1];
        label_code.font = [UIFont systemFontOfSize:17];
        label_code.adjustsFontSizeToFitWidth = YES;
        [bj_view addSubview:label_code];
    }
     label_code.text = model.number;
    if (label_state == nil) {
        label_state = [[UILabel alloc]init];
        label_state.frame = FRAME(WIDTH - 100, 20, 60, 20);
        label_state.backgroundColor = [UIColor colorWithRed:255/255.0 green:177/255.0 blue:0 alpha:1];
        label_state.layer.cornerRadius = 3;
        label_state.layer.masksToBounds = YES;
        label_state.textColor = [UIColor colorWithWhite:0.2 alpha:1];
        label_state.font = [UIFont systemFontOfSize:14];
        label_state.textAlignment = NSTextAlignmentCenter;
        [bj_view addSubview:label_state];
    }
//    if ([model.status isEqualToString:@"1"]) {
//        label_state.text = NSLocalizedString(@"已使用", nil);
//    }else{
//        label_state.text = NSLocalizedString(@"未使用", nil);
//    }
    label_state.text =  NSLocalizedString(@"已使用", NSStringFromClass([self class]));
    if (label_num == nil) {
        label_num = [[UILabel alloc]init];
        label_num.frame = FRAME(0, 5, 70, 95);
        label_num.textAlignment = NSTextAlignmentCenter;
        label_num.font = [UIFont systemFontOfSize:20];
        label_num.textColor = [UIColor colorWithRed:240/255.0 green:92/255.0 blue:92/255.0 alpha:1];
        [bj_view addSubview:label_num];
    }
    label_num.text = [NSString stringWithFormat:@"x%@",model.count];
}
@end
