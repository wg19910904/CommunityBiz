//
//  JHSetMaincCellZero.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/30.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHSetMaincCellZero.h"
#import <UIImageView+WebCache.h>
@implementation JHSetMaincCellZero
{
    UIImageView *_logoIV;
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
    [super makeUI];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.layoutMargins = UIEdgeInsetsZero;
    self.logoIV = [[UIImageView alloc] initWithFrame:FRAME(10, 10, 40, 40)];
    _logoIV.layer.cornerRadius = 3;
    _logoIV.layer.masksToBounds = YES;
    [_logoIV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEADDRESS,[JHShareModel shareModel].infoDictionary[@"logo"]]] placeholderImage:[UIImage imageNamed:@"evaluateDefault"]];
    [self addSubview:_logoIV];
    
    self.titleLabel.frame = FRAME(60, 0, 150, 60);
    self.statusLabel.frame = FRAME(210, 0, WIDTH - 245, 60);
}
@end
