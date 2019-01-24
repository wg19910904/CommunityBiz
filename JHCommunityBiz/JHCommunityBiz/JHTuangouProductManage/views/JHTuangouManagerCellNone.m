//
//  JHTuangouManagerCellNone.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/7/15.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHTuangouManagerCellNone.h"

@implementation JHTuangouManagerCellNone
{
    UIImageView * imageV;
}
- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (imageV == nil) {
        imageV = [[UIImageView alloc]init];
        imageV.frame = FRAME((WIDTH - 130)/2, 100, 130, 110);
        imageV.image = [UIImage imageNamed:@"Group-purchase_no"];
        [self addSubview:imageV];
    }
    self.backgroundColor = [UIColor colorWithWhite:0.96 alpha:1];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

@end
