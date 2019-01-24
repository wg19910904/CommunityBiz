//
//  DeliveryClassifyHeaderView.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/23.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "DeliveryClassifyHeaderView.h"

@implementation DeliveryClassifyHeaderView
{
    
    UILabel *titleLabel;
    UIButton *editBtn;
    UILabel *subTitleLabel;
    UIButton *arrowBtn;
    
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        self = [super initWithFrame:frame];
    }
    self.backgroundColor = [UIColor whiteColor];
    //添加控件
    [self makeUI];
    
    return self;
}
#pragma mark - 添加子控件
- (void)makeUI
{
    titleLabel = [[UILabel alloc] initWithFrame:FRAME(10, 0,112, 44)];
    titleLabel.font = FONT(14);
    titleLabel.textColor = HEX(@"333333", 1.0f);
    editBtn = [[UIButton alloc] initWithFrame:FRAME(122, 0, 44, 44)];
    subTitleLabel = [[UILabel alloc] initWithFrame:FRAME(170, 0, WIDTH - 200, 44)];
    subTitleLabel.font = FONT(14);
    subTitleLabel.textColor = THEME_COLOR;
    subTitleLabel.textAlignment = NSTextAlignmentRight;
    arrowBtn = [[UIButton alloc] initWithFrame:FRAME(WIDTH - 30, 0, 30, 44)];
    [self addSubview:titleLabel];
    [self addSubview:editBtn];
    [self addSubview:subTitleLabel];
    [self addSubview:arrowBtn];
}
- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    titleLabel.text = NSLocalizedString(@"一级分类", nil);
    subTitleLabel.text = NSLocalizedString(@"5个子类", nil);
}
@end
