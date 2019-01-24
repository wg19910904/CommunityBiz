//
//  JHPerferentialFooterView.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/27.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHPerferentialFooterView.h"

@implementation JHPerferentialFooterView{
    UIView * view ;
    UILabel * label;
}
-(void)setHeight:(float)height{
    _height = height;
    if (view == nil) {
        view = [UIView new];
        view.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
        view.frame = FRAME(0, 0, WIDTH, height + 90);
        [self addSubview: view];
        label  = [[UILabel alloc]init];
        label.frame = FRAME(10, 10, WIDTH - 60, height);
        label.textColor = [UIColor colorWithWhite:0.6 alpha:1];
        label.font = [UIFont systemFontOfSize:14];
        label.numberOfLines = 0;
        [view addSubview:label];
        self.btn_save = [[UIButton alloc]init];
        self.btn_save.frame = FRAME(10, height + 40, WIDTH - 20, 45);
        self.btn_save.layer.cornerRadius = 3;
        self.btn_save.layer.masksToBounds = YES;
        [self.btn_save setTitle: NSLocalizedString(@"保存修改", NSStringFromClass([self class])) forState:UIControlStateNormal];
        [self.btn_save setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.btn_save setBackgroundColor:[UIColor colorWithRed:250/255.0 green:175/255.0 blue:25/255.0 alpha:1] forState:UIControlStateNormal];
        [view addSubview:self.btn_save];
    }
    NSString * str = [NSString stringWithFormat:@"%@\n%@\n%@", NSLocalizedString(@"温馨提示", NSStringFromClass([self class])), NSLocalizedString(@"1.商家设置的优惠活动,优惠金额由商家自行承担", NSStringFromClass([self class])), NSLocalizedString(@"2.酒水不打折", NSStringFromClass([self class]))];
    NSMutableAttributedString * attributed = [[NSMutableAttributedString alloc]initWithString:str];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:8];
    [attributed addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, str.length)];
    label.attributedText = attributed;
}
@end
