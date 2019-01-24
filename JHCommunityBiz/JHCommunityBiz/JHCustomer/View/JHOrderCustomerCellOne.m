//
//  JHOrderCustomerCellOne.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/17.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHOrderCustomerCellOne.h"

@implementation JHOrderCustomerCellOne
{
    UILabel * label;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
     
    
}
-(void)setNum:(NSInteger)num{
    _num = num;
    self.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if (label == nil) {
        label = [[UILabel alloc]init];
        label.frame = FRAME(0, 10, WIDTH, 20);
        label.textColor = [UIColor colorWithWhite:0.6 alpha:1];
        label.font = [UIFont systemFontOfSize:15];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
    }
    label.text = [NSString stringWithFormat:NSLocalizedString(@"本店下单客户共%ld名", nil),num];
}
@end
