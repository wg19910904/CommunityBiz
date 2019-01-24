//
//  DeliveryQiPeiAmountCell.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/23.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "DeliveryQiPeiAmountCell.h"

@implementation DeliveryQiPeiAmountCell
{
    DeliveryQiPeiAmountCellField * _juliField,* _client_pay,* _third_pay;
    UIButton *_deleteBtn;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = FRAME(0, 0, WIDTH, 44);
        self.layoutMargins = UIEdgeInsetsZero;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textFeildChanged:)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:nil];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //添加子控件
        [self makeUI];
    }
    return self;
}

- (void)makeUI
{
    _juliField = [[DeliveryQiPeiAmountCellField alloc] initWithFrame:FRAME(0, 0, (WIDTH - 50)/3, 44)];
    
    _client_pay = [[DeliveryQiPeiAmountCellField alloc] initWithFrame:FRAME((WIDTH - 50)/3, 0,(WIDTH - 50)/3, 44)];
    
    _third_pay = [[DeliveryQiPeiAmountCellField alloc] initWithFrame:FRAME((WIDTH - 50)/3*2, 0,(WIDTH - 50)/3, 44)];
    _deleteBtn = [[UIButton alloc] initWithFrame:FRAME(WIDTH - 50, 0, 50, 44)];
    [_deleteBtn setImage:IMAGE(@"Delivery_X") forState:UIControlStateNormal];
    _deleteBtn.imageEdgeInsets = UIEdgeInsetsMake(12, 15, 12, 15);
    [self addSubview:_juliField];
    [self addSubview:_client_pay];
    [self addSubview:_third_pay];
    [self addSubview:_deleteBtn];
}
#pragma mark - 显示数据
- (void)setDataModel:(DeliveryQiPeiDetailModel *)dataModel
{
    _dataModel = dataModel;
    _juliField.text = dataModel.fkm;
    _client_pay.text = dataModel.fm;
    _third_pay.text = dataModel.sm;
    
    if (self.isThird) {
        _juliField.userInteractionEnabled = NO;
        _client_pay.userInteractionEnabled = NO;
        _third_pay.userInteractionEnabled = NO;
        _deleteBtn.userInteractionEnabled = NO;
    }
    
}
- (void)setRow:(NSInteger)row
{
    _row = row;
    _juliField.tag = _row * 10000+10;
    _client_pay.tag = _row*10000+20;
    _third_pay.tag = _row*10000+30;
}
- (void)textFeildChanged:(NSNotification *)noti
{
    UITextField *textF = (UITextField *)noti.object;
    if (textF.tag == _row * 10000 + 10) {
        _dataModel.fkm = textF.text;
    }else if(textF.tag == _row * 10000 + 20){
        _dataModel.fm = textF.text;
    }else if(textF.tag == _row * 10000 + 30){
        _dataModel.sm = textF.text;
    }
}
@end

//DeliveryQiPeiAmountCellField
@implementation DeliveryQiPeiAmountCellField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        self = [super initWithFrame:frame];
    }
    self.backgroundColor = [UIColor whiteColor];
    self.textAlignment = NSTextAlignmentCenter;
    self.textColor = THEME_COLOR;
    self.font = FONT(15);
    self.layer.borderColor = LINE_COLOR.CGColor;
    self.layer.borderWidth = 0.5;
    self.keyboardType = UIKeyboardTypeNumberPad;
    
    //添加灰色层
    CALayer *grayLayer = [CALayer layer];
    grayLayer.frame = FRAME(10, 5, CGRectGetWidth(frame) - 20, CGRectGetHeight(frame) - 10);
    grayLayer.backgroundColor = DEFAULT_BACKGROUNDCOLOR.CGColor;
    [self.layer addSublayer:grayLayer];
    
    return self;
}

@end
