//
//  JHTakeTheirCellThree.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/26.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHTakeTheirCellThree.h"

@implementation JHTakeTheirCellThree{
    UIView * bj_view;//创建白色的背景
    UILabel * label;//显示客户名 手机号 地址的label
    UILabel * label_one;//显示备注
    UILabel * label_text;//显示备注内容的
}
-(void)setModel:(JHTakeTheirModel *)model{
    _model = model;
    self.backgroundColor =[UIColor colorWithWhite:0.98 alpha:1];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if (bj_view == nil) {
        bj_view = [[UIView alloc]init];
        bj_view.frame = FRAME(10, 0, WIDTH - 20, self.frame.size.height - 10);
        bj_view.backgroundColor = [UIColor whiteColor];
        bj_view.layer.cornerRadius = 3;
        bj_view.layer.masksToBounds = YES;
        bj_view.layer.borderColor = [UIColor colorWithWhite:0.95 alpha:1].CGColor;
        bj_view.layer.borderWidth = 1;
        [self addSubview:bj_view];
    }
    //显示客户名 手机号 地址的label
    if (label == nil) {
        label = [[UILabel alloc]init];
        label.frame = FRAME(10, 10, WIDTH - 40, 80);
        label.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        label.font = [UIFont systemFontOfSize:14];
        label.numberOfLines = 0;
        [bj_view addSubview:label];
    }
    NSString * str = [NSString stringWithFormat:@"%@    %@\n%@    %@", NSLocalizedString(@"客户名", NSStringFromClass([self class])),model.contact, NSLocalizedString(@"手机号", NSStringFromClass([self class])),model.mobile];
    NSRange range1 = [str rangeOfString:model.contact];
    NSRange range2 = [str rangeOfString:model.mobile];
    //NSRange range3 = [str rangeOfString:NSLocalizedString(@"蜀山区华润五彩国际904", nil)];
    NSMutableAttributedString * attribute = [[NSMutableAttributedString alloc]initWithString:str];
    [attribute addAttributes:@{NSForegroundColorAttributeName:THEME_COLOR} range:range1];
    [attribute addAttributes:@{NSForegroundColorAttributeName:THEME_COLOR} range:range2];
    //[attribute addAttributes:@{NSForegroundColorAttributeName:THEME_COLOR} range:range3];
    NSMutableParagraphStyle * paragraphStyle =  [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:10];
    [attribute addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, str.length)];
    label.attributedText = attribute;
    //显示备注
    if(label_one == nil){
        label_one = [[UILabel alloc]init];
        label_one.frame = FRAME(10, 85, 30, 20);
        label_one.text =  NSLocalizedString(@"备注", NSStringFromClass([self class]));
        label_one.font = [UIFont systemFontOfSize:14];
        label_one.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        [bj_view addSubview:label_one];
    }
    //显示备注内容的
    if (label_text == nil) {
        label_text  = [[UILabel alloc]init];
        label_text.frame = FRAME(65, 85, WIDTH - 90, self.height);
        label_text.font = [UIFont systemFontOfSize:14];
        label_text.textColor = THEME_COLOR;
        label_text.numberOfLines = 0;
        [bj_view addSubview:label_text];
    }
    label_text.text =  model.intro;
}
@end
