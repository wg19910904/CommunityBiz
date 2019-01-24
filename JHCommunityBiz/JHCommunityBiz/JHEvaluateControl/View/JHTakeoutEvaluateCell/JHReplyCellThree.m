//
//  JHReplyCellThree.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/13.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHReplyCellThree.h"
#import "UIButton+BackgroundColor.h"
@implementation JHReplyCellThree
{
    UILabel * label;
}
- (void)awakeFromNib {
    // Initialization code
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (_btn_replay == nil) {
        self.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.btn_replay = [[UIButton alloc]init];
        self.btn_replay.frame = FRAME(15, 25, WIDTH - 30, 45);
        [self.btn_replay setTitle:NSLocalizedString(@"确认回复", nil) forState:UIControlStateNormal];
        self.btn_replay.layer.cornerRadius = 3;
        self.btn_replay.clipsToBounds = YES;
        [self.btn_replay setBackgroundColor:[UIColor colorWithRed:248/255.0 green:168/255.0 blue:37/255.0 alpha:1]forState:UIControlStateNormal];
        [self.btn_replay setBackgroundColor:[UIColor colorWithRed:248/255.0 green:168/255.0 blue:37/255.0 alpha:0.5]forState:UIControlStateHighlighted];
        [self.btn_replay setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:self.btn_replay];
        label = [[UILabel alloc]init];
        label.frame = FRAME(0, 80, WIDTH, 20);
        label.textColor = [UIColor redColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:13];
        label.text = NSLocalizedString(@"温馨提示:您只有一次回复机会", nil);
        [self addSubview:label];
    }
}
@end
