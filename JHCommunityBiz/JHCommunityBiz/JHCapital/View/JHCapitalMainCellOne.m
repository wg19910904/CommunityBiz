//
//  JHCapitalMainCellOne.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/19.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHCapitalMainCellOne.h"

@implementation JHCapitalMainCellOne
{
    UILabel * label;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    }
-(void)setNum:(NSString *)num{
    _num = num;
    self.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if (label == nil) {
        label = [[UILabel alloc]init];
        label.frame = FRAME(0, 10, WIDTH, 20);
        label.textColor = [UIColor colorWithWhite:0.7 alpha:1];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:15];
        [self addSubview:label];
    }
     label.text = [NSString stringWithFormat:NSLocalizedString(@"最近%@天资金明细", nil),num];
}
@end
