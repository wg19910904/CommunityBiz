//
//  MoneyRecordCell.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/9/29.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "MoneyRecordCell.h"
@interface MoneyRecordCell()
@property(nonatomic,strong)UIImageView *header_imageV;
@property(nonatomic,strong)UILabel *label_money;//金钱
@property(nonatomic,strong)UILabel *label_order;//单号
@property(nonatomic,strong)UILabel *label_way;//支付方式
@property(nonatomic,strong)UILabel *label_date;//日期
@end
@implementation MoneyRecordCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.header_imageV];
        [self addSubview:self.label_money];
        [self addSubview:self.label_date];
        [self addSubview:self.label_order];
        [self addSubview:self.label_way];
    }
    return self;
}
#pragma mark - 创建的是头像
-(UIImageView *)header_imageV{
    if (!_header_imageV) {
        _header_imageV = [[UIImageView alloc]init];
        _header_imageV.frame = FRAME(15, 10, 44, 44);
        _header_imageV.layer.cornerRadius = 22;
        _header_imageV.layer.masksToBounds = YES;
        
    }
    return _header_imageV;
}
#pragma mark - 创建显示金额的label
-(UILabel *)label_money{
    if (!_label_money) {
        _label_money = [[UILabel alloc]init];
        _label_money.frame = FRAME(70, 15, WIDTH - 70/2, 20);
        _label_money.textColor = HEX(@"333333", 1.0);
        _label_money.font = FONT(16);
    }
    return _label_money;
}
#pragma mark - 创建显示时间
-(UILabel *)label_order{
    if (!_label_order) {
        _label_order = [[UILabel alloc]init];
        _label_order.frame = FRAME(WIDTH - (WIDTH - 70)/2 - 10, 5, (WIDTH - 70)/2, 20);
        _label_order.textAlignment = NSTextAlignmentRight;
        _label_order.textColor = HEX(@"666666", 1.0);
        _label_order.font = FONT(12);
    }
    return _label_order;
}
#pragma mark - 创建显示支付方法
-(UILabel *)label_way{
    if (!_label_way) {
        _label_way = [[UILabel alloc]init];
        _label_way.frame = FRAME(70, 35, WIDTH - 70/2, 20);
        _label_way.textColor = HEX(@"666666", 1.0);
        _label_way.font = FONT(12);
    }
    return _label_way;
}
#pragma mark - 创建显示日期
-(UILabel *)label_date{
    if (!_label_date) {
        _label_date = [[UILabel alloc]init];
        _label_date.frame = FRAME(WIDTH - (WIDTH - 70)/2 - 10,35, (WIDTH - 70)/2, 20);
        _label_date.textColor = HEX(@"666666", 1.0);
        _label_date.textAlignment = NSTextAlignmentRight;
        _label_date.font = FONT(12);
    }
    return _label_date;
}
-(void)setModel:(MoneyRecorderModel *)model{
    _model = model;
    _label_money.text = [NSString stringWithFormat:@"+%@",model.amount];
    _label_way.text = model.type;
    _label_date.text = [NSString stringWithFormat:@"%@  %@",model.date,model.time];
    _label_order.text = [ NSLocalizedString(@"单号:", NSStringFromClass([self class])) stringByAppendingString:model.po_id];
    _header_imageV.image = model.image;
}
@end
