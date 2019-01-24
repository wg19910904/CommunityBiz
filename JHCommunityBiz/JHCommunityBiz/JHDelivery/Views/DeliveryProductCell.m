//
//  DeliveryProductCell.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/25.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "DeliveryProductCell.h"
#import "DeliveryProductGuigeVC.h"
#import "NSDateToString.h"
@implementation DeliveryProductCell
{
    UIImageView *_logoIV;//logo
    UILabel *_titleLabel;//标题
    UILabel *_classifyLabel;//分类
    UILabel *_priceLabel;//价格
    UILabel *_stockLabel;//库存及销量
    UILabel *_statusLabel;//状态
    UILabel *_timeLabel;//创建时间
    
    UIButton *_modifyBtn;//修改按钮
    UIButton *_shelfBtn;//上架按钮
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    }
#warning 不在编辑状态时,选中cell无法消除
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
    
//    UIView *bg_view = [[UIView alloc] initWithFrame:self.bounds];
//    bg_view.backgroundColor = [UIColor clearColor];
    self.selectedBackgroundView = nil;
    self.layoutMargins = UIEdgeInsetsZero;
    //添加ui
    [self makeUI];
    return self;
}
#pragma mark - 添加UI
- (void)makeUI
{
    self.back_view = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 160)];
    [self addSubview:_back_view];
    _logoIV = [UIImageView new];
    _logoIV.frame = FRAME(10, 10, 60, 60);
    _logoIV.backgroundColor = [UIColor lightGrayColor];
    [_back_view addSubview:_logoIV];
    
    _titleLabel = [UILabel new];
    _titleLabel.frame = FRAME(80, 0, WIDTH - 90, 30);
    _titleLabel.textColor = HEX(@"333333", 1.0f);
    _titleLabel.font = FONT(15);
    [_back_view addSubview:_titleLabel];
    
    _classifyLabel = [UILabel new];
    _classifyLabel.font = FONT(12);
    _classifyLabel.textAlignment = NSTextAlignmentCenter;
    _classifyLabel.backgroundColor = HEX(@"faaf19", 1.0);
    _classifyLabel.textColor = [UIColor whiteColor];
    _classifyLabel.layer.cornerRadius = 3;
    _classifyLabel.layer.masksToBounds = YES;
    [_back_view addSubview:_classifyLabel];
    
    _priceLabel = [UILabel new];
    _priceLabel.font = FONT(14);
    _priceLabel.textColor = HEX(@"faaf19", 1.0);
    [_back_view addSubview:_priceLabel];
    
    _stockLabel = [UILabel new];
    _stockLabel.frame = FRAME(80, 50, WIDTH - 90, 30);
    _stockLabel.font = FONT(14);
    _stockLabel.textColor = HEX(@"666666", 1.0);
    [_back_view addSubview:_stockLabel];
    
    _statusLabel = [UILabel new];
    _statusLabel.font = FONT(14);
    _statusLabel.textColor = THEME_COLOR;
    _statusLabel.textAlignment = NSTextAlignmentCenter;
    _statusLabel.frame = FRAME(0, 80, 80, 40);
    [_back_view addSubview:_statusLabel];
    
    _timeLabel = [UILabel new];
    _timeLabel.font = FONT(14);
    _timeLabel.textColor = HEX(@"666666", 1.0f);
    _timeLabel.frame = FRAME(90, 80, WIDTH - 90, 40);
    [_back_view addSubview:_timeLabel];
    
    self.specBtn = [UIButton new]; //规格
    self.specBtn.frame = FRAME(WIDTH - 220, 125, 80, 30);
    self.specBtn.layer.borderWidth = 0.7;
    self.specBtn.layer.borderColor = THEME_COLOR.CGColor;
    self.specBtn.layer.cornerRadius = 3;
    self.specBtn.layer.masksToBounds = YES;
    [self.specBtn setTitle:NSLocalizedString(@"规格", nil) forState:(UIControlStateNormal)];
    [self.specBtn setTitleColor:THEME_COLOR forState:(UIControlStateNormal)];
    self.specBtn.titleLabel.font = FONT(14);
    [self.specBtn addTarget:self
                     action:@selector(clickSpecBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [_back_view addSubview:self.specBtn];
    
    self.modifyBtn = [UIButton new]; //修改
    _modifyBtn.frame = FRAME(WIDTH - 110, 125, 80, 30);
    _modifyBtn.layer.borderWidth = 0.7;
    _modifyBtn.layer.borderColor = THEME_COLOR.CGColor;
    _modifyBtn.layer.cornerRadius = 3;
    _modifyBtn.layer.masksToBounds = YES;
    [_modifyBtn setTitle:NSLocalizedString(@"修改", nil) forState:(UIControlStateNormal)];
    [_modifyBtn setTitleColor:THEME_COLOR forState:(UIControlStateNormal)];
    _modifyBtn.titleLabel.font = FONT(14);
    [_back_view addSubview:_modifyBtn];
    
    self.shelfBtn = [UIButton new]; //上架
    _shelfBtn.frame = FRAME(WIDTH - 110, 125, 80, 30);
    _shelfBtn.layer.borderWidth = 0.7;
    _shelfBtn.layer.borderColor = THEME_COLOR.CGColor;
    _shelfBtn.layer.cornerRadius = 3;
    _shelfBtn.layer.masksToBounds = YES;
    [_shelfBtn setTitle:NSLocalizedString(@"上架", nil) forState:(UIControlStateNormal)];
    [_shelfBtn setTitleColor:THEME_COLOR forState:(UIControlStateNormal)];
    _shelfBtn.titleLabel.font = FONT(14);
    [_back_view addSubview:_shelfBtn];
    
    
    self.OffBtn = [UIButton new]; //下架
    _OffBtn.frame = FRAME(WIDTH - 220, 125, 80, 30);
    _OffBtn.layer.borderWidth = 0.7;
    _OffBtn.layer.borderColor = HEX(@"f70000", 1.0).CGColor;
    _OffBtn.layer.cornerRadius = 3;
    _OffBtn.layer.masksToBounds = YES;
    [_OffBtn setTitle:NSLocalizedString(@"下架", nil) forState:(UIControlStateNormal)];
    [_OffBtn setTitleColor:HEX(@"f70000", 1.0) forState:(UIControlStateNormal)];
    _OffBtn.titleLabel.font = FONT(14);
    [_back_view addSubview:_OffBtn];
    
//    self.delayBtn = [UIButton new];  //延期
//    self.delayBtn.hidden = YES;
//    _delayBtn.frame = FRAME(WIDTH - 220, 125, 80, 30);
//    _delayBtn.layer.borderWidth = 0.7;
//    _delayBtn.layer.borderColor = HEX(@"faaf19", 1.0f).CGColor;
//    _delayBtn.layer.cornerRadius = 3;
//    _delayBtn.layer.masksToBounds = YES;
//    [_delayBtn setTitle:NSLocalizedString(@"延期", nil) forState:(UIControlStateNormal)];
//    [_delayBtn setTitleColor:HEX(@"faaf19", 1.0f) forState:(UIControlStateNormal)];
//    _delayBtn.titleLabel.font = FONT(14);
//    [_back_view addSubview:_delayBtn];
    
    //添加分割线
    CALayer *line1 = [CALayer layer];
    line1.frame = FRAME(0, 80, WIDTH, 0.5);
    line1.backgroundColor = LINE_COLOR.CGColor;
    [_back_view.layer addSublayer:line1];
    CALayer *line2 = [CALayer layer];
    line2.frame = FRAME(80, 90, 0.5, 20);
    line2.backgroundColor = LINE_COLOR.CGColor;
    [_back_view.layer addSublayer:line2];
    
    CALayer *line3 = [CALayer layer];
    line3.frame = FRAME(0, 120, WIDTH, 0.5);
    line3.backgroundColor = LINE_COLOR.CGColor;
    [_back_view.layer addSublayer:line3];
    
}
- (void)setCellType:(EDeliveryProductCellType)cellType
{
    switch (cellType) {
        case EDeliveryProductCellTypeShelied: //已上架
        {
            self.shelfBtn.hidden = YES;
            self.OffBtn.hidden = NO;
            self.modifyBtn.hidden = NO;
            self.delayBtn.hidden = NO;
            
            self.OffBtn.frame = FRAME(WIDTH - 90, 125, 80, 30);
            self.modifyBtn.frame = FRAME(WIDTH - 180, 125, 80, 30);
            self.specBtn.frame = FRAME(WIDTH - 270, 125, 80, 30);
        }
            break;
            
        case EDeliveryProductCellTypeNotShelied: //未上架
        {
            self.shelfBtn.hidden = NO;
            self.OffBtn.hidden = YES;
            self.modifyBtn.hidden = NO;
            self.delayBtn.hidden = YES;
            self.shelfBtn.frame = FRAME(WIDTH - 90, 125, 80, 30);
            self.modifyBtn.frame = FRAME(WIDTH - 180, 125, 80, 30);
            self.specBtn.frame = FRAME(WIDTH - 270, 125, 80, 30);
        }
            break;
        default: //已过期
        {
            self.shelfBtn.hidden = YES;
            self.modifyBtn.hidden = NO;
            self.delayBtn.hidden = NO;
            self.OffBtn.hidden = YES;
            self.delayBtn.frame = FRAME(WIDTH - 90, 125, 80, 30);
            self.modifyBtn.frame = FRAME(WIDTH - 180, 125, 80, 30);
        }
            break;
    }
}
- (void)setDataModel:(DeliveryProductCellModel *)dataModel
{
    _dataModel = dataModel;
    _titleLabel.text = dataModel.title;
    _classifyLabel.text = dataModel.cate_name;
    NSURL *url = [NSURL URLWithString:[IMAGEADDRESS stringByAppendingString:dataModel.photo]];
    [_logoIV sd_setImageWithURL:url placeholderImage:IMAGE(@"120*120")];
    CGFloat _classifyLabel_size_width = dataModel.cate_name.length * 12 + 6;
//    [_classifyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_logoIV.mas_right).with.offset(10);
//        make.top.equalTo(_titleLabel.mas_bottom);
//        make.width.equalTo(@(_classifyLabel_size_width));
//        make.height.equalTo(@20);
//    }];
    _classifyLabel.frame = FRAME(80, 30, _classifyLabel_size_width, 20);
    
    _priceLabel.text = [NSString stringWithFormat:@"%@%g",MS,[dataModel.price floatValue]];
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_classifyLabel.mas_right).with.offset(10);
        make.top.equalTo(_titleLabel.mas_bottom);
        make.height.mas_equalTo(20);
        make.right.equalTo(self).with.offset(-10);
    }];
    if (dataModel.sale_sku.integerValue > 0) {
        _stockLabel.text = [NSString stringWithFormat:@"%@%@ %@%@",NSLocalizedString(@"库存:", nil),dataModel.sale_sku,NSLocalizedString(@"销量:", nil),dataModel.sales];
    }else{
       _stockLabel.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"销量:", nil),dataModel.sales];
    }
    
    _statusLabel.text = [dataModel.is_onsale integerValue] == 0?NSLocalizedString(@"未上架", nil):NSLocalizedString(@"已上架", nil);
    _timeLabel.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"创建时间:", nil),[NSDateToString stringFromUnixTime:dataModel.dateline]];
}
#pragma mark - 点击规格按钮
- (void)clickSpecBtn:(UIButton *)sender
{
    DeliveryProductGuigeVC *vc = [[DeliveryProductGuigeVC alloc] init];
    vc.product_id = _dataModel.product_id;
    [self.navVC pushViewController:vc animated:YES];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    _classifyLabel.backgroundColor = HEX(@"faaf19", 1.0);
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    _classifyLabel.backgroundColor = HEX(@"faaf19", 1.0);
}
@end
