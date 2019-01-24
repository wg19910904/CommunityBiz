//
//  JHPreferentialSetCellOne.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/27.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHPreferentialSetCellOne.h"

@implementation JHPreferentialSetCellOne
-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:YES];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    if (self.mySwitch == nil) {
//        UILabel * label_line = [[UILabel alloc]init];
//        label_line.frame = FRAME(0, 39.5, WIDTH, 0.5);
//        label_line.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
//        [self addSubview:label_line];
//        UILabel * label = [[UILabel alloc]init];
//        label.frame  = FRAME(10, 10, 100, 20);
//        label.text = NSLocalizedString(@"优惠设置功能", nil);
//        label.textColor = [UIColor colorWithWhite:0.3 alpha:1];
//        label.font = [UIFont systemFontOfSize:15];
//        [self addSubview:label];
//        self.mySwitch = [[UISwitch alloc]init];
//        self.mySwitch.frame = FRAME(WIDTH - 60, 5, 60, 30);
//        self.mySwitch.transform = CGAffineTransformMakeScale(0.8, 0.8);
//        self.mySwitch.onTintColor = THEME_COLOR;
//        self.mySwitch.on = YES;
//        [self addSubview:self.mySwitch];
//    }
}
@end
