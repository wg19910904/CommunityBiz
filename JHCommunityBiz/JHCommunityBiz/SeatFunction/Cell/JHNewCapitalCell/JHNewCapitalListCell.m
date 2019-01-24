//
//  JHNewCapitalListCell.m
//  JHCommunityBiz
//
//  Created by ijianghu on 2017/11/29.
//  Copyright © 2017年 com.jianghu. All rights reserved.
//

#import "JHNewCapitalListCell.h"
@interface JHNewCapitalListCell()
@property(nonatomic,strong)UILabel *timeL;
@property(nonatomic,strong)UILabel *typeL;//收入/支付
@property(nonatomic,strong)UILabel *moneyL;//金额
@property(nonatomic,strong)UILabel *textL;//提示的文本
@property(nonatomic,strong)UILabel *statusL;//审核的状态(支出)
@end
@implementation JHNewCapitalListCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configUI];
    }
    return self;
}
-(void)configUI{
    UIView *line = [UIView new];
    line.backgroundColor = HEX(@"e6e6e6", 1);
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset = 0;
        make.height.offset = 0.5;
    }];
    [self timeL];
    [self typeL];
    [self moneyL];
    [self textL];
    [self statusL];
    
}
-(UILabel *)timeL{
    if (!_timeL) {
        _timeL = [[UILabel alloc]init];
        _timeL.textColor = HEX(@"666666", 1);
        _timeL.font = FONT(12);
        _timeL.numberOfLines = 2;
        [self addSubview:_timeL];
        [_timeL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 12;
            make.centerY.mas_equalTo(self.mas_centerY);
            make.height.offset = 40;
            make.width.offset = 105;
        }];
    }
    return _timeL;
}
-(UILabel *)typeL{
    if (!_typeL) {
        _typeL = [[UILabel alloc]init];
        _typeL.font = FONT(14);
        _typeL.textColor = [UIColor whiteColor];
        _typeL.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_typeL];
        _typeL.layer.masksToBounds = YES;
        _typeL.layer.cornerRadius = 20;
        [_typeL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_timeL.mas_right).offset = 24;
            make.centerY.mas_equalTo(self.mas_centerY);
            make.width.height.offset = 40;
        }];
    }
    return _typeL;
}
-(UILabel *)moneyL{
    if (!_moneyL) {
        _moneyL = [[UILabel alloc]init];
        _moneyL.textColor = HEX(@"333333", 1);
        _moneyL.font = FONT(18);
        [self addSubview:_moneyL];
        [_moneyL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_typeL.mas_right).offset = 24;
            make.top.offset = 10;
            make.height.offset = 20;
        }];
    }
    return _moneyL;
}
-(UILabel *)textL{
    if (!_textL) {
        _textL = [[UILabel alloc]init];
        _textL.font = FONT(12);
        _textL.textColor = HEX(@"666666", 1);
        _textL.numberOfLines = 0;
        [self addSubview:_textL];
        [_textL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_moneyL.mas_left);
            make.right.offset = -5;
            make.top.mas_equalTo(_moneyL.mas_bottom).offset = -5;
            make.height.offset = 40;
        }];
        
    }
    return _textL;
}
//-(UILabel *)statusL{
//    if (!_statusL) {
//        _statusL = [[UILabel alloc]init];
//        _statusL.text = NSLocalizedString(@"待转账", nil);
//        _statusL.font = FONT(12);
//        _statusL.textColor = HEX(@"ff9900", 1);
//        [self addSubview:_statusL];
//        [_statusL mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.offset = -12;
//            make.top.offset = 12;
//            make.height.offset = 20;
//        }];
//    }
//    return _statusL;
//}
-(void)setModel:(JHCapitalModel *)model{
    _model = model;
    _timeL.text = model.dateline;
    _moneyL.text = model.money;
    _textL.text = model.intro;
    if ([model.money hasPrefix:@"-"]) {
        _typeL.backgroundColor = HEX(@"fe564f", 1);
         _typeL.text = NSLocalizedString(@"支出", NSStringFromClass([self class]));
    }else{
        _typeL.backgroundColor = HEX(@"6887f5", 1);
        _typeL.text = NSLocalizedString(@"收入", NSStringFromClass([self class]));
    }
}
@end
