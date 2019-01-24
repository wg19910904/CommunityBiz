//
//  DeliveryOrderCell.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/24.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//
#import "DeliveryOrderPeiCell.h"
#import "NSDateToString.h"
@implementation DeliveryOrderPeiCell
{
    UIImageView *_orderIV;
    UILabel *_orderTitleLabel;
    UILabel *_orderNumLabel;
    UILabel *_orderStatusLabel;
    UIImageView *_arrowIV;
    CALayer *_line1;
    
    UIImageView *_timeIV;
    UILabel *_timeTitleLabel;
    UILabel *_timeLabel;
    UIImageView *_payTypeIV;
    UILabel *_payTLabel;
    CALayer *_line2;
    
    UILabel *_clientTitleLabel;
    UILabel *_clientLabel;
    UILabel *_remindLabel;
    
    UILabel *_phoneLabel;
    UILabel *_phoneNumLabel;
    UIButton *_phoneBtn;
    
    UILabel *_addressTitleLabel;
    UILabel *_addressLabel;
    UIButton *_distanceBtn;
    
    UILabel *_noteLabel;
    CALayer *_line3;
    
    UIButton *_replyBtn;
    UIButton *_deliveryBtn;
    
    CALayer *_line4;
    
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    //addView
    [self addViews];
    return self;
}
#pragma mark - addView
- (void)addViews
{
    //初始化
    _orderIV = [UIImageView new];
    _orderIV.frame = FRAME(10, 13, 12, 14);
    _orderIV.image = IMAGE(@"Delivery_order");
    [self addSubview:_orderIV];
    _orderTitleLabel = [UILabel new];
    _orderTitleLabel.font = FONT(14);
    _orderTitleLabel.textColor = HEX(@"333333",1.0f);
    [self addSubview:_orderTitleLabel];
    
    _orderNumLabel = [UILabel new];
    _orderNumLabel.font = FONT(14);
    _orderNumLabel.textColor = HEX(@"666666",1.0f);
    [self addSubview:_orderNumLabel];
    
    _orderStatusLabel = [UILabel new];
    _orderStatusLabel.font = FONT(14);
    _orderStatusLabel.textColor = HEX(@"666666",1.0f);
    _orderStatusLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_orderStatusLabel];
    
    _arrowIV = [UIImageView new];
    _arrowIV.frame = FRAME(WIDTH - 20, 10, 10, 20);
    _arrowIV.image = IMAGE(@"Delivery_arrow");
    [self addSubview:_arrowIV];
    _line1 = [CALayer new];
    _line1.frame = FRAME(0, 40, WIDTH, 0.5);
    _line1.backgroundColor = LINE_COLOR.CGColor;
    [self.layer addSublayer:_line1];
    
    _timeIV = [UIImageView new];
    _timeIV.frame = FRAME(8, 53, 14, 14);
    _timeIV.image = IMAGE(@"Delivery_time");
    [self addSubview:_timeIV];
    
    _timeTitleLabel = [UILabel new];
    _timeTitleLabel.font = FONT(14);
    _timeTitleLabel.textColor = HEX(@"333333", 1.0f);
    [self addSubview:_timeTitleLabel];
    
    _timeLabel = [UILabel new];
    _timeLabel.font = FONT(14);
    _timeLabel.textColor = HEX(@"666666",1.0f);
    [self addSubview:_timeLabel];
    
    _payTypeIV = [UIImageView new];
    [self addSubview:_payTypeIV];
    
    _payTLabel = [UILabel new];
    _payTLabel.font = FONT(12);
    _payTLabel.textColor = [UIColor whiteColor];
    _payTLabel.textAlignment = NSTextAlignmentCenter;
    [_payTypeIV addSubview:_payTLabel];
    
    _line2 = [CALayer new];
    _line2.frame = FRAME(15, 80, WIDTH - 15, 0.5);
    _line2.backgroundColor = LINE_COLOR.CGColor;
    [self.layer addSublayer:_line2];
    
    _clientTitleLabel = [UILabel new];
    _clientTitleLabel.font = FONT(14);
    _clientTitleLabel.textColor = HEX(@"333333", 1.0);
    [self addSubview:_clientTitleLabel];
    
    _clientLabel = [UILabel new];
    _clientLabel.font = FONT(14);
    _clientLabel.textColor = THEME_COLOR;
    [self addSubview:_clientLabel];
    
    _remindLabel = [UILabel new];
    _remindLabel.backgroundColor = HEX(@"fa4535", 1.0);
    _remindLabel.textColor = [UIColor whiteColor];
    _remindLabel.layer.cornerRadius = 12.5;
    _remindLabel.layer.masksToBounds = YES;;
    _remindLabel.font = FONT(14);
    [self addSubview:_remindLabel];
    
    _phoneLabel = [UILabel new];
    _phoneLabel.font = FONT(14);
    _phoneLabel.textColor = HEX(@"333333", 1.0);
    [self addSubview:_phoneLabel];
    
    _phoneNumLabel = [UILabel new];
    _phoneNumLabel.font = FONT(14);
    _phoneNumLabel.textColor = THEME_COLOR;
    [self addSubview:_phoneNumLabel];
    
    _phoneBtn = [UIButton new];
    [self addSubview:_phoneBtn];
    [_phoneBtn addTarget:self action:@selector(call) forControlEvents:(UIControlEventTouchUpInside)];
    
    _addressTitleLabel = [UILabel new];
    _addressTitleLabel.font = FONT(14);
    _addressTitleLabel.textColor = HEX(@"333333", 1.0f);
    [self addSubview:_addressTitleLabel];
    
    _addressLabel = [UILabel new];
    _addressLabel.font = FONT(14);
    _addressLabel.textColor = HEX(@"333333", 1.0f);
    [self addSubview:_addressLabel];
    
    _distanceBtn = [UIButton new];
    [self addSubview:_distanceBtn];
    
    _noteLabel = [UILabel new];
    _noteLabel.font = FONT(14);
    _noteLabel.textColor = HEX(@"333333", 1.0f);
    [self addSubview:_noteLabel];
    
    _line3 = [CALayer new];
    _line3.frame = FRAME(0, 200, WIDTH, 0.5);
    _line3.backgroundColor = LINE_COLOR.CGColor;
    [self.layer addSublayer:_line3];
    
    _replyBtn = [UIButton new];
    [self addSubview:_replyBtn];
    
    _deliveryBtn = [UIButton new];
    [self addSubview:_deliveryBtn];
    
}
- (void)setDataModel:(DeliveryOrderCellModel *)dataModel
{
    _dataModel = dataModel;
    //布局
    _orderTitleLabel.text = NSLocalizedString(@"订单号:", nil);
    CGSize _ordertitleLabel_size =  getSize(NSLocalizedString(@"订单号:", nil), 40,14);
     _orderTitleLabel.frame = FRAME(27, 0, _ordertitleLabel_size.width, 40);
    _orderNumLabel.text = dataModel.order_id;
     CGSize _orderNumLabel_size = getSize(dataModel.order_id, 40,14);
     _orderNumLabel.frame = FRAME(27+_ordertitleLabel_size.width, 0, _orderNumLabel_size.width, 40);
    _orderStatusLabel.text = dataModel.order_status_label;
    [_orderStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_orderNumLabel.mas_right).with.offset(5);
        make.top.equalTo(self);
        make.bottom.equalTo(self.mas_top).with.offset(40);
        make.right.equalTo(self).with.offset(-25);
    }];
    
    _timeTitleLabel.text = NSLocalizedString(@"下单时间:", nil);
    CGSize _timeTitleLabel_size = getSize(NSLocalizedString(@"下单时间:", nil), 40,14);
    _timeTitleLabel.frame = FRAME(27, 40, _timeTitleLabel_size.width, 40);
    _timeLabel.text = [NSDateToString stringFromUnixTime:dataModel.dateline];
    CGSize _timeLabel_size = getSize(_timeLabel.text, 40,14);
     _timeLabel.frame = FRAME(27 + _timeTitleLabel_size.width, 40, _timeLabel_size.width, 40);
    _payTypeIV.frame = FRAME(WIDTH - 70, 50, 60, 20);
    _payTypeIV.image = [dataModel.online_pay isEqualToString:@"1"]?IMAGE(@"Delivery_line"):IMAGE(@"Delivery_daofu");
    _payTLabel.frame = _payTypeIV.bounds;
    _payTLabel.text = [dataModel.online_pay isEqualToString:@"1"]?NSLocalizedString(@"在线支付", nil):NSLocalizedString(@"货到付款", nil);
    
    _clientTitleLabel.text = NSLocalizedString(@"客户姓名:", nil);
    CGSize _clientTitleLabel_size = getSize(NSLocalizedString(@"客户姓名:", nil),30,14);
     _clientTitleLabel.frame = FRAME(10, 80, _clientTitleLabel_size.width, 30);
    _clientLabel.text = dataModel.contact;
     CGSize _clientLabel_size = getSize(dataModel.contact,30,14);
    _clientLabel.frame = FRAME(10 + _clientTitleLabel_size.width, 80, _clientLabel_size.width, 30);
    NSString *remindText;
    if ([dataModel.pei_type integerValue] == 3) {  //自提单
        remindText = [NSString stringWithFormat:@"  %@",NSLocalizedString(@"自提单", nil)];
    }
    if ([dataModel.cui_count integerValue]>0) {
        remindText = [NSString stringWithFormat:NSLocalizedString(@"  %@条催单消息", nil),dataModel.cui_count];
    }
    
    if (!remindText || remindText.length == 0) {
        _remindLabel.hidden = YES;
    }else{
        _remindLabel.hidden = NO;
        _remindLabel.text = remindText;
        _remindLabel.frame = FRAME(WIDTH -getSize(remindText, 25, 14).width-5,85,getSize(remindText, 25, 14).width+12.5+5, 25);
    }
    _phoneLabel.text = NSLocalizedString(@"手机号:", nil);
    CGSize _phoneLabel_size = getSize(NSLocalizedString(@"手机号:", nil),30,14);
     _phoneLabel.frame = FRAME(10, 110, _phoneLabel_size.width, 30);
    _phoneNumLabel.text = dataModel.mobile;
    CGSize _phoneNumLabel_size = getSize(dataModel.mobile,30,14);
     _phoneNumLabel.frame = FRAME(10 + _phoneLabel_size.width, 110, _phoneNumLabel_size.width, 30);
    _phoneBtn.frame = FRAME(10 + _phoneLabel_size.width + _phoneNumLabel_size.width, 115, 17, 17);
    [_phoneBtn setImage:IMAGE(@"Delivery_phone") forState:(UIControlStateNormal)];
    
    _addressTitleLabel.text = NSLocalizedString(@"客户地址:", nil) ;
    CGSize _addressTitleLabel_size = getSize(NSLocalizedString(@"客户地址:", nil),30,14);
    _addressTitleLabel.frame = FRAME(10, 140, _addressTitleLabel_size.width, 30);
    if ([dataModel.pei_type integerValue] == 3) {  //自提单
        _addressLabel.text = NSLocalizedString(@"自提", nil);

    }else{
        _addressLabel.text = [dataModel.addr stringByAppendingString:dataModel.house ?dataModel.house:@"" ];
    }
    _addressLabel.numberOfLines = 0;
   CGFloat height_addr = getStrHeight(_addressLabel.text, WIDTH - 150, 14)+15;
    _addressLabel.frame = FRAME(10 + _addressTitleLabel_size.width, 140, WIDTH - 150, height_addr);
    _noteLabel.text = [NSLocalizedString(@"备注:", nil) stringByAppendingString:dataModel.intro];
    _noteLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _noteLabel.numberOfLines = 0;
    _noteLabel.frame = FRAME(10, 140 + height_addr, WIDTH - 30, getStrHeight(_noteLabel.text, WIDTH - 30, 14)+15);
    _line3.frame = FRAME(0, 140+height_addr + getStrHeight(_noteLabel.text, WIDTH - 30, 14)+15, WIDTH, 0.5);
    _replyBtn.frame = FRAME(WIDTH - 160, 150+height_addr + getStrHeight(_noteLabel.text, WIDTH - 30, 14)+15, 80, 30);
   if (dataModel.cui_count.integerValue == 0) {
        _replyBtn.hidden = YES;
    }else{
        _replyBtn.hidden = NO;
        [_replyBtn setTitle:NSLocalizedString(@"回复催单", nil) forState:(UIControlStateNormal)];
        [_replyBtn setTitleColor:THEME_COLOR forState:(UIControlStateNormal)];
    }
    _deliveryBtn.frame = FRAME(WIDTH - 80, 150+height_addr + getStrHeight(_noteLabel.text, WIDTH - 30, 14)+15, 80, 30);

    [_deliveryBtn setTitle:NSLocalizedString(@"配送", nil) forState:(UIControlStateNormal)];
    if (dataModel.pei_type.integerValue == 3) {
       [_deliveryBtn setTitle:NSLocalizedString(@"验证核销", nil) forState:(UIControlStateNormal)];
    }
    [_deliveryBtn setTitleColor:HEX(@"faaf19",1.0) forState:(UIControlStateNormal)];
}

- (void)call
{
    if (!_dataModel) return;
    [JHShowAlert showCallWithMsg:_dataModel.mobile];
}
@end
