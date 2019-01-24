//
//  DeliveryProductGuigeCell.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/7/7.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "DeliveryProductGuigeCell.h"

@implementation DeliveryProductGuigeCell
{
    UIImageView *_logoIV;//logo
    UILabel *_titleLabel;//标题
    UILabel *_priceLabel;//价格
    UILabel *_stockLabel;//库存及销量
    
    UIButton *_modifyBtn;//修改按钮
    UIButton *_deleteBtn;//删除按钮
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //添加控件
        self.layoutMargins = UIEdgeInsetsZero;
        [self makeUI];
    }
    return self;
}

- (void)makeUI
{
    _logoIV = [UIImageView new];
    _logoIV.frame = FRAME(10, 10, 60, 60);
    _logoIV.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:_logoIV];
    
    _titleLabel = [UILabel new];
    _titleLabel.frame = FRAME(80, 0, WIDTH - 90, 30);
    _titleLabel.textColor = HEX(@"333333", 1.0f);
    _titleLabel.font = FONT(16);
    [self addSubview:_titleLabel];
    
    _priceLabel = [UILabel new];
    _priceLabel.font = FONT(14);
    _priceLabel.textColor = HEX(@"faaf19", 1.0);
    _priceLabel.frame = FRAME(80, 30, WIDTH - 90, 20);
    [self addSubview:_priceLabel];
    
    _stockLabel = [UILabel new];
    _stockLabel.frame = FRAME(80, 50, WIDTH - 90, 30);
    _stockLabel.font = FONT(14);
    _stockLabel.textColor = HEX(@"666666", 1.0);
    [self addSubview:_stockLabel];
    
    self.modifyBtn = [UIButton new]; //修改
    _modifyBtn.frame = FRAME(WIDTH - 220, 87.5, 80, 30);
    _modifyBtn.layer.borderWidth = 0.7;
    _modifyBtn.layer.borderColor = THEME_COLOR.CGColor;
    _modifyBtn.layer.cornerRadius = 3;
    _modifyBtn.layer.masksToBounds = YES;
    [_modifyBtn setTitle:NSLocalizedString(@"修改", nil) forState:(UIControlStateNormal)];
    [_modifyBtn setTitleColor:THEME_COLOR forState:(UIControlStateNormal)];
    _modifyBtn.titleLabel.font = FONT(14);
    [self addSubview:_modifyBtn];
    
    self.deleteBtn = [UIButton new]; //删除
    _deleteBtn.frame = FRAME(WIDTH - 110, 87.5, 80, 30);
    _deleteBtn.layer.borderWidth = 0.7;
    _deleteBtn.layer.borderColor = HEX(@"f70000", 1.0).CGColor;
    _deleteBtn.layer.cornerRadius = 3;
    _deleteBtn.layer.masksToBounds = YES;
    [_deleteBtn setTitle:NSLocalizedString(@"删除", nil) forState:(UIControlStateNormal)];
    [_deleteBtn setTitleColor:HEX(@"f70000", 1.0) forState:(UIControlStateNormal)];
    _deleteBtn.titleLabel.font = FONT(14);
    [self addSubview:_deleteBtn];
    //添加分割线
    CALayer *line1 = [CALayer layer];
    line1.frame = FRAME(0, 80, WIDTH, 0.5);
    line1.backgroundColor = LINE_COLOR.CGColor;
    [self.layer addSublayer:line1];
}
- (void)setDataModel:(DeliveryProductGuigeCellModel *)dataModel
{
    _dataModel = dataModel;
    [_logoIV sd_setImageWithURL:[NSURL URLWithString:[IMAGEADDRESS stringByAppendingString:dataModel.spec_photo]] placeholderImage:IMAGE(@"120*120")];
    _titleLabel.text = dataModel.spec_name;
    _priceLabel.text = [NSString stringWithFormat:@"%@%g",MS,[dataModel.price floatValue]];
    _stockLabel.text = [NSString stringWithFormat:@"%@%@   %@%@",NSLocalizedString(@"库存:", nil),dataModel.sale_sku,NSLocalizedString(@"销量:", nil),dataModel.sale_count];
}
@end
