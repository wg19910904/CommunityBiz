//
//  DeliveryYouhuiCell.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/24.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "DeliveryYouhuiCell.h"
@implementation DeliveryYouhuiCell
{
    DeliveryYouhuiCellField *_man_field,*_jian_field;
    UIButton *_deleteBtn;
    
}

- (instancetype)init
{
    self = [super init];
    if (!self) {
        self = [super init];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFeildChanged:)
                                                 name:UITextFieldTextDidChangeNotification
                                               object:nil];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self makeUI];
    return self;
}

#pragma mark - 添加控件
- (void)makeUI
{
    _man_field = [[DeliveryYouhuiCellField alloc] initWithFrame:FRAME(0, 7, (WIDTH - 50)/2, 30)];
    _jian_field = [[DeliveryYouhuiCellField alloc] initWithFrame:FRAME((WIDTH - 50)/2, 7, (WIDTH - 50)/2, 30)];
    UILabel *leftL = (UILabel *)[_jian_field leftView];
    leftL.text = NSLocalizedString(@"减", nil);
    _deleteBtn = [[UIButton alloc] initWithFrame:FRAME(WIDTH - 50, 0, 50, 44)];
    [_deleteBtn setImage:IMAGE(@"Delivery_X") forState:UIControlStateNormal];
    _deleteBtn.imageEdgeInsets = UIEdgeInsetsMake(12, 15, 12, 15);
    [self addSubview:_man_field];
    [self addSubview:_jian_field];
    [self addSubview:_deleteBtn];
}
- (void)setDataModel:(DeliveryYouhuiDetailModel *)dataModel
{
    _dataModel = dataModel;
    _man_field.text = [NSString stringWithFormat:@"%g",[dataModel.order_amount floatValue]];
    _jian_field.text = [NSString stringWithFormat:@"%g",[dataModel.youhui_amount floatValue]];
}
- (void)setRow:(NSInteger)row
{
    _row = row;
    _man_field.tag = row * 100 + 10;
    _jian_field.tag = row * 100 + 20;
}
- (void)textFeildChanged:(NSNotification *)noti
{
    UITextField *textF = (UITextField *)noti.object;
    if (textF.tag == _row * 100 + 10) {
        _dataModel.order_amount = textF.text;
    }else if(textF.tag == _row * 100 + 20){
        _dataModel.youhui_amount = textF.text;
    }
}
@end

@implementation DeliveryYouhuiCellField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        self = [super initWithFrame:frame];

    }
    self.keyboardType = UIKeyboardTypeNumberPad;
    //添加左右文字
    [self addWords];
    return self;
}
#pragma mark - 添加左右文字
- (void)addWords
{
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:FRAME(0, 0, 30, 30)];
    leftLabel.text = NSLocalizedString(@"满", nil);
    leftLabel.textColor = HEX(@"333333", 1.0f);
    leftLabel.font = FONT(15);
    leftLabel.textAlignment = NSTextAlignmentCenter;
    leftLabel.backgroundColor = [UIColor whiteColor];
    
    UILabel *rightLabel = [[UILabel alloc] initWithFrame:FRAME(0, 0, 30, 30)];
    rightLabel.text = NSLocalizedString(@"元", nil);
    rightLabel.textColor = HEX(@"666666", 1.0f);
    rightLabel.font = FONT(15);
    rightLabel.textAlignment = NSTextAlignmentCenter;
    rightLabel.backgroundColor = [UIColor whiteColor];
    
    self.leftViewMode = UITextFieldViewModeAlways;
    self.rightViewMode  = UITextFieldViewModeAlways;
    
    self.leftView = leftLabel;
    self.rightView = rightLabel;
    
    self.font = FONT(14);
    self.textColor = THEME_COLOR;
    self.textAlignment = NSTextAlignmentCenter;
    
    //添加灰色层
    CALayer *grayLayer = [CALayer layer];
    grayLayer.frame = FRAME(30, 0, CGRectGetWidth(self.frame) - 60, CGRectGetHeight(self.frame));
    grayLayer.backgroundColor = DEFAULT_BACKGROUNDCOLOR.CGColor;
    [self.layer addSublayer:grayLayer];
}
@end
