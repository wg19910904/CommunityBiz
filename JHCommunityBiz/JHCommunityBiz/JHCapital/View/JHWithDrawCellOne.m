//
//  JHWithDrawCellOne.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/20.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHWithDrawCellOne.h"

@implementation JHWithDrawCellOne

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (self.label_bank == nil) {
        UILabel * label = [[UILabel alloc]init];
        label.frame = FRAME(10, 10, 60, 20);
        label.text = NSLocalizedString(@"提现账户", nil);
        label.textColor = [UIColor colorWithWhite:0.4 alpha:1];
        label.font = [UIFont systemFontOfSize:14];
        [self addSubview:label];
        self.label_bank = [[UILabel alloc]init];
        self.label_bank.frame = FRAME(70, 10, WIDTH - 80, 20);
        self.label_bank.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        self.label_bank.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.label_bank];
        //创建分割线
        UIView * label_line = [[UIView alloc]init];
        label_line.frame = FRAME(0, 39.5, WIDTH, 0.5);
        label_line.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        [self addSubview:label_line];
    }
    
}

@end
