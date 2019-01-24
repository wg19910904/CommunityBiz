//
//  JHSetMainCell.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/30.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHSetMainCell.h"

@implementation JHSetMainCell
{
    UILabel *_titleLabel;
    UILabel *_statusLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
       self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    }
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //添加子控件
    [self makeUI];
    return self;
}
#pragma mark - 添加控件
- (void)makeUI
{
    self.titleLabel = [[UILabel alloc] initWithFrame:FRAME(10, 0, 150, 44)];
    _titleLabel.font = FONT(14);
    _titleLabel.textColor = [UIColor colorWithHex:@"333333" alpha:1.0];
    
    self.statusLabel = [[UILabel alloc] initWithFrame:FRAME(160, 0, WIDTH - 195, 44)];
    _statusLabel.textAlignment = NSTextAlignmentRight;
    _statusLabel.font = FONT(14);
    _statusLabel.textColor = THEME_COLOR;
    _statusLabel.tag = 100;
    
    [self addSubview:_titleLabel];
    //[self addSubview:_statusLabel];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
