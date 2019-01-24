//
//  QiPeiHeadView.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/21.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "QiPeiHeadView.h"

@implementation QiPeiHeadView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        self = [super initWithFrame:frame];
    }
    //添加控件
    [self makeViews];
    
    return self;
}
#pragma mark - 添加控件
- (void)makeViews
{
    self.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(10, 0, WIDTH - 20, 30)];
    titleLabel.text = [NSString stringWithFormat:@"%@%@%@%@",NSLocalizedString(@"配送费", nil),@"(",MT,@")"];
    titleLabel.font = FONT(14);
    titleLabel.textColor = HEX(@"333333", 1.0f);
    [self addSubview:titleLabel];
    
    NSArray *titleArray = @[NSLocalizedString(@"公里数", nil),NSLocalizedString(@"用户支付", nil),NSLocalizedString(@"第三方配送", nil),NSLocalizedString(@"操作", nil)];
    NSArray *widthArray = @[@((WIDTH - 50)/3),@((WIDTH - 50)/3),@((WIDTH - 50)/3),@(50)];
    NSArray *ponit_x = @[@(0),@((WIDTH - 50)/3*1),@((WIDTH - 50)/3 *2),@(WIDTH - 50)];
    for (int i = 0; i <= 3; i++) {
        UILabel *temLabel = [[UILabel alloc] initWithFrame:FRAME([ponit_x[i] floatValue], 30, [widthArray[i] floatValue], 30)];
        temLabel.font = FONT(14);
        temLabel.backgroundColor = [UIColor whiteColor];
        temLabel.text = titleArray[i];
        temLabel.textColor = HEX(@"666666", 1.0f);
        temLabel.textAlignment = NSTextAlignmentCenter;
        temLabel.layer.borderColor = LINE_COLOR.CGColor;
        temLabel.layer.borderWidth = 0.5;
        [self addSubview:temLabel];
    }
}
@end
