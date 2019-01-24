//
//  JHGroupOrderDetailCellTwo.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/30.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHGroupOrderDetailCellTwo.h"

@implementation JHGroupOrderDetailCellTwo
{
    UIView * label_line;
    UILabel * label1;
    UILabel * label2;
}
-(void)setModel:(JHGroupDetailModel *)model{
    _model = model;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if (label_line == nil) {
        label_line = [[UIView alloc]init];
        label_line.frame = FRAME(0, 69.5, WIDTH, 0.5);
        label_line.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        [self addSubview:label_line];
    }
    if (label1 == nil) {
        label1 = [[UILabel alloc]init];
        label1.frame = FRAME(10, 10,WIDTH - 10, 20);
        label1.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        label1.font = [UIFont systemFontOfSize:15];
        [self addSubview:label1];
    }
    NSString * str = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"下单时间:", NSStringFromClass([self class])),model.dateline];
    NSRange range = [str rangeOfString:model.dateline];
    NSMutableAttributedString * attributed = [[NSMutableAttributedString alloc]initWithString:str];
    [attributed addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.6 alpha:1]} range:range];
    label1.attributedText = attributed;
    if (label2 == nil) {
        label2 = [[UILabel alloc]init];
        label2.frame = FRAME(10, 35,WIDTH - 10, 20);
        label2.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        label2.font = [UIFont systemFontOfSize:15];
        [self addSubview:label2];
    }
    NSString * str1 = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"有效期:", NSStringFromClass([self class])),model.ltime];
    NSRange range1 = [str1 rangeOfString:model.ltime];
    NSMutableAttributedString * attributed1 = [[NSMutableAttributedString alloc]initWithString:str1];
    [attributed1 addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.6 alpha:1]} range:range1];
    label2.attributedText = attributed1;

}
@end
