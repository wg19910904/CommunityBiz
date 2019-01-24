//
//  DeliveryProductModifyCellTwo.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/30.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "DeliveryProductModifyCellTwo.h"

@implementation DeliveryProductModifyCellTwo
{
    UILabel *_guigeL;//规格title
    UITextField *_guigeNameF;//规格名
    UILabel *_priceL;//价格title
    UITextField *_priceF;//价格
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    }
    self.layoutMargins = UIEdgeInsetsZero;
    //添加控件
    [self makeUI];
    return self;
}
#pragma mark - 添加控件
- (void)makeUI
{

    _guigeL = [[UILabel alloc] initWithFrame:FRAME(10, 0, 70,44)];
    _guigeL.font = FONT(15);
    _guigeL.textColor = HEX(@"333333", 1.0f);
    _guigeNameF = [[UITextField alloc] initWithFrame:FRAME(80,0, WIDTH - 90, 44)];
    _guigeNameF.textColor = THEME_COLOR;
    _guigeNameF.font = FONT(15);
    _guigeNameF.keyboardType = UIKeyboardTypeNumberPad;
    [self addSubview:_guigeL];
    [self addSubview:_guigeNameF];
    
    //添加line
    CALayer *line = [CALayer layer];
    line.frame = FRAME(15, 44, WIDTH - 15, 0.5);
    line.backgroundColor = LINE_COLOR.CGColor;
    [self.layer addSublayer:line];
    
    _priceL = [[UILabel alloc] initWithFrame:FRAME(10, 44, 70,44)];
    _priceL.text = NSLocalizedString(@"价格", nil);
    _priceL.font = FONT(15);
    _priceL.textColor = HEX(@"333333", 1.0f);
    _priceF = [[UITextField alloc] initWithFrame:FRAME(80,44, WIDTH - 90, 44)];
    _priceF.textColor = THEME_COLOR;
    _priceF.font = FONT(15);
    _priceF.textAlignment = NSTextAlignmentRight;
    _priceF.keyboardType = UIKeyboardTypeNumberPad;
    //添加右侧文字
    UILabel *remidLabel = [[UILabel alloc] initWithFrame:FRAME(0, 0, 30, 34)];
    remidLabel.text = NSLocalizedString(@"¥", nil);
    remidLabel.font = FONT(12);
    remidLabel.textColor = THEME_COLOR;
    remidLabel.backgroundColor = [UIColor whiteColor];
    remidLabel.textAlignment = NSTextAlignmentCenter;
    _priceF.rightViewMode = UITextFieldViewModeAlways;
    _priceF.rightView = remidLabel;

    [self addSubview:_priceL];
    [self addSubview:_priceF];

}

-(void)setDataDic:(NSDictionary *)dataDic
{
    _guigeL.text = NSLocalizedString(@"规格一", nil);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
