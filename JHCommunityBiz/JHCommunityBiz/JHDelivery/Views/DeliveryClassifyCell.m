//
//  DeliveryClassifyCell.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/23.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "DeliveryClassifyCell.h"

@implementation DeliveryClassifyCell
{
    UILabel *_titleLabel;
    UIButton *_editBtn;
    UILabel *subTitleLabel;
    UIButton *arrowBtn;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    }
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.backgroundColor = [UIColor whiteColor];
    //添加控件
    [self makeUI];
    return self;
}
#pragma mark - 添加子控件
- (void)makeUI
{
    _titleLabel = [[UILabel alloc] initWithFrame:FRAME(10, 0,112, 44)];
    _titleLabel.font = FONT(14);
    _titleLabel.textColor = HEX(@"333333", 1.0f);
    _editBtn = [[UIButton alloc] initWithFrame:FRAME(122, 0, 44, 44)];
    [_editBtn setImage:IMAGE(@"Delivery_bi") forState:(UIControlStateNormal)];
    _editBtn.imageEdgeInsets = UIEdgeInsetsMake(11, 11, 11, 11);
    subTitleLabel = [[UILabel alloc] initWithFrame:FRAME(170, 0, WIDTH - 210, 44)];
    subTitleLabel.font = FONT(14);
    subTitleLabel.textColor = THEME_COLOR;
    subTitleLabel.textAlignment = NSTextAlignmentRight;
    subTitleLabel.userInteractionEnabled = YES;
    subTitleLabel.backgroundColor = [UIColor clearColor];

    [self addSubview:_titleLabel];
    [self addSubview:subTitleLabel];
    [self addSubview:_editBtn];
    [self addSubview:arrowBtn];
}
- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    _titleLabel.text = [dataDic valueForKey:@"title"];
    subTitleLabel.text = [NSString stringWithFormat:@"%ld%@",[[dataDic valueForKey:@"childrens"] count],NSLocalizedString(@"个子类", nil)];
}
@end
