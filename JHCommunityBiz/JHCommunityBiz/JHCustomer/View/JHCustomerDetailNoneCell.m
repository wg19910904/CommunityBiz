//
//  JHCustomerDetailNoneCell.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/18.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHCustomerDetailNoneCell.h"

@implementation JHCustomerDetailNoneCell
{
    UILabel * label;//显示该用户在此店未消费
    UIImageView * imageV;//显示图片的
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    self.selectionStyle = UITableViewCellSeparatorStyleNone;
    if (label == nil) {
        label = [[UILabel alloc]init];
        label.frame = FRAME(0, 10, WIDTH, 20);
        label.text = NSLocalizedString(@"该用户在本店暂无消费", nil);
        label.textColor = [UIColor colorWithWhite:0.6 alpha:1];
        label.font = [UIFont systemFontOfSize:16];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
    }
    if (imageV == nil) {
        imageV = [[UIImageView alloc]init];
        imageV.frame = FRAME((WIDTH - 65)/2, 60, 65, 80);
        imageV.image = [UIImage imageNamed:@"mingxinone"];
        [self addSubview:imageV];
    }
   
}

@end
