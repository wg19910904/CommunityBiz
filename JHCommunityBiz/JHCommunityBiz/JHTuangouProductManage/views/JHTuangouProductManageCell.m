//
//  DeliveryProductCell.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/25.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHTuangouProductManageCell.h"
#import "DeliveryProductModifyVC.h"
#import <UIImageView+WebCache.h>
#import "JHTuanGouProductAddVC.h"
@implementation JHTuangouProductManageCell
{
    UIImageView *_logoIV;//logo
    UILabel *_titleLabel;//标题
    UILabel *_priceLabel;//价格
    UILabel *_salesPriceLabel;//门市价
    UILabel *_stockLabel;//库存及销量
    UILabel *_statusLabel;//状态
    UILabel *_timeLabel;//创建时间
    UILabel *_effectTimeLabel;//有效期
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    }
#warning 不在编辑状态时,选中cell无法消除
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
    self.selectedBackgroundView = nil;
    self.layoutMargins = UIEdgeInsetsZero;
    //添加ui
    [self makeUI];
    return self;
}
#pragma mark - 添加UI
- (void)makeUI
{
    self.back_view = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH,200)];
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
    
    _priceLabel = [UILabel new];
    _priceLabel.font = FONT(14);
    _priceLabel.textColor = HEX(@"faaf19", 1.0);
    [_back_view addSubview:_priceLabel];
    
    _salesPriceLabel = [UILabel new];
    _salesPriceLabel.font = FONT(13);
    _salesPriceLabel.textColor = HEX(@"666666", 1.0);
    [_back_view addSubview:_salesPriceLabel];
    
    _stockLabel = [UILabel new];
    _stockLabel.frame = FRAME(80, 50, WIDTH - 90, 30);
    _stockLabel.font = FONT(14);
    _stockLabel.textColor = HEX(@"666666", 1.0);
    [_back_view addSubview:_stockLabel];
    
    _statusLabel = [UILabel new];
    _statusLabel.font = FONT(14);
    _statusLabel.textColor = THEME_COLOR;
    _statusLabel.textAlignment = NSTextAlignmentCenter;
    _statusLabel.frame = FRAME(0, 80, 80, 80);
    [_back_view addSubview:_statusLabel];
    
    _timeLabel = [UILabel new];
    _timeLabel.font = FONT(14);
    _timeLabel.textColor = HEX(@"666666", 1.0f);
    _timeLabel.frame = FRAME(90, 80, WIDTH - 95, 40);
    _timeLabel.adjustsFontSizeToFitWidth = YES;
    [_back_view addSubview:_timeLabel];
    
    _effectTimeLabel = [UILabel new];
    _effectTimeLabel.font = FONT(14);
    _effectTimeLabel.textColor = HEX(@"666666", 1.0f);
    _effectTimeLabel.frame = FRAME(90, 120, WIDTH - 95, 30);
    _effectTimeLabel.adjustsFontSizeToFitWidth = YES;
    [_back_view addSubview:_effectTimeLabel];
    
    self.modifyBtn = [UIButton new]; //修改
    _modifyBtn.frame = FRAME(WIDTH - 220, 165, 80, 30);
    _modifyBtn.layer.borderWidth = 0.7;
    _modifyBtn.layer.borderColor = THEME_COLOR.CGColor;
    _modifyBtn.layer.cornerRadius = 3;
    _modifyBtn.layer.masksToBounds = YES;
    [_modifyBtn setTitle:NSLocalizedString(@"修改", nil) forState:(UIControlStateNormal)];
    [_modifyBtn setTitleColor:THEME_COLOR forState:(UIControlStateNormal)];
    _modifyBtn.titleLabel.font = FONT(14);
    [_modifyBtn addTarget:self action:@selector(clickModifyBtn) forControlEvents:(UIControlEventTouchUpInside)];
    [_back_view addSubview:_modifyBtn];
    
    self.shelfBtn = [UIButton new]; //上架
    _shelfBtn.frame = FRAME(WIDTH - 110, 165, 80, 30);
    _shelfBtn.layer.borderWidth = 0.7;
    _shelfBtn.layer.borderColor = THEME_COLOR.CGColor;
    _shelfBtn.layer.cornerRadius = 3;
    _shelfBtn.layer.masksToBounds = YES;
    [_shelfBtn setTitle:NSLocalizedString(@"上架", nil) forState:(UIControlStateNormal)];
    [_shelfBtn setTitleColor:THEME_COLOR forState:(UIControlStateNormal)];
    _shelfBtn.titleLabel.font = FONT(14);
    [_back_view addSubview:_shelfBtn];
    
    
    self.OffBtn = [UIButton new]; //下架
    _OffBtn.frame = FRAME(WIDTH - 220, 165, 80, 30);
    _OffBtn.layer.borderWidth = 0.7;
    _OffBtn.layer.borderColor = HEX(@"f70000", 1.0).CGColor;
    _OffBtn.layer.cornerRadius = 3;
    _OffBtn.layer.masksToBounds = YES;
    [_OffBtn setTitle:NSLocalizedString(@"下架", nil) forState:(UIControlStateNormal)];
    [_OffBtn setTitleColor:HEX(@"f70000", 1.0) forState:(UIControlStateNormal)];
    _OffBtn.titleLabel.font = FONT(14);
    [_back_view addSubview:_OffBtn];
    
    self.delayBtn = [UIButton new];  //延期
    _delayBtn.frame = FRAME(WIDTH - 220, 165, 80, 30);
    _delayBtn.layer.borderWidth = 0.7;
    _delayBtn.layer.borderColor = HEX(@"faaf19", 1.0f).CGColor;
    _delayBtn.layer.cornerRadius = 3;
    _delayBtn.layer.masksToBounds = YES;
    [_delayBtn setTitle:NSLocalizedString(@"延期", nil) forState:(UIControlStateNormal)];
    [_delayBtn setTitleColor:HEX(@"faaf19", 1.0f) forState:(UIControlStateNormal)];
    _delayBtn.titleLabel.font = FONT(14);
    [_back_view addSubview:_delayBtn];
    //添加分割线
    CALayer *line1 = [CALayer layer];
    line1.frame = FRAME(0, 80, WIDTH, 0.5);
    line1.backgroundColor = LINE_COLOR.CGColor;
    [_back_view.layer addSublayer:line1];
    CALayer *line2 = [CALayer layer];
    line2.frame = FRAME(80, 90, 0.5, 60);
    line2.backgroundColor = LINE_COLOR.CGColor;
    [_back_view.layer addSublayer:line2];
    CALayer *line3 = [CALayer layer];
    line3.frame = FRAME(0, 160, WIDTH, 0.5);
    line3.backgroundColor = LINE_COLOR.CGColor;
    [_back_view.layer addSublayer:line3];
}
- (void)setCellType:(ETuangouProductCellType)cellType
{
    switch (cellType) {
        case ETuangouProductCellTypeShelied: //已上架
        {
            self.shelfBtn.hidden = YES;
            self.OffBtn.hidden = NO;
            self.modifyBtn.hidden = NO;
            self.delayBtn.hidden = NO;
            
            self.delayBtn.frame = FRAME(WIDTH - 90, 165, 80, 30);
            self.OffBtn.frame = FRAME(WIDTH - 180, 165, 80, 30);
            self.modifyBtn.frame = FRAME(WIDTH - 270, 165, 80, 30);
            
        }
            break;
            
        case ETuangouProductCellTypeNotShelied: //未上架
        {
            self.shelfBtn.hidden = NO;
            self.OffBtn.hidden = YES;
            self.modifyBtn.hidden = NO;
            self.delayBtn.hidden = YES;
            self.shelfBtn.frame = FRAME(WIDTH - 90, 165, 80, 30);
            self.modifyBtn.frame = FRAME(WIDTH - 180, 165, 80, 30);
        }
            break;
        default: //已过期
        {
            self.shelfBtn.hidden = YES;
            self.modifyBtn.hidden = NO;
            self.delayBtn.hidden = NO;
            self.OffBtn.hidden = YES;
            self.delayBtn.frame = FRAME(WIDTH - 90, 165, 80, 30);
            self.modifyBtn.frame = FRAME(WIDTH - 180, 165, 80, 30);
        }
            break;
    }
}
-(void)setModel:(JHTuangouProductManagerModel *)model{
    _model = model;
    _titleLabel.text = model.title;
    
    _priceLabel.text = [NSString stringWithFormat:@"%@%@",@"¥",model.price];
    CGSize _priceLabel_size = [_priceLabel getLabelFitHeight:_priceLabel withFont:FONT(14)];
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_logoIV.mas_right).with.offset(10);
        make.top.equalTo(_titleLabel.mas_bottom);
        make.width.mas_equalTo(_priceLabel_size.width);
        make.height.mas_equalTo(20);
    }];
    
    _salesPriceLabel.text = [NSString stringWithFormat:@"%@%@",@"¥",model.market_price];
    [_salesPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_priceLabel.mas_right).with.offset(10);
        make.top.equalTo(_titleLabel.mas_bottom);
        make.height.mas_equalTo(20);
        make.right.equalTo(self).with.offset(-10);
    }];
    if ([model.stock_type isEqualToString:@"1"]) {
       _stockLabel.text = [NSString stringWithFormat:@"%@%@ %@%@",NSLocalizedString(@"库存:", nil),model.stock_num,NSLocalizedString(@"销量:", nil),model.sales];
    }else{
       _stockLabel.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"销量:", nil),model.sales];
    }
    
    NSString * str_type = nil;
    if ([model.type integerValue] == 1) {
        str_type = NSLocalizedString(@"未上架", nil);
    }else if ([model.type integerValue] == 2){
        str_type = NSLocalizedString(@"上架中", nil);
    }else {
        str_type = NSLocalizedString(@"已过期", nil);
    }
    _statusLabel.text = str_type;
    _timeLabel.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(@"创建时间:", nil),model.dateline];
    _effectTimeLabel.text = [NSString stringWithFormat:@"%@%@%@%@",NSLocalizedString(@"有效期:", nil),model.stime,NSLocalizedString(@"至", nil) ,model.ltime];
    [_logoIV sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:@"evaluateDefault"]];
}
#pragma mark - 点击了修改按钮
- (void)clickModifyBtn
{
    JHTuanGouProductAddVC * addVC = [[JHTuanGouProductAddVC alloc] init];
    addVC.tuan_id = _model.tuan_id;
    addVC.isRevise = YES;
    if ([_model.type integerValue] == 1) {
        addVC.type = 1;
    }else if ([_model.type integerValue] == 2){
        addVC.type = 0;
    }else {
        addVC.type = 2;
    }
    [self.navVC pushViewController:addVC animated:YES];
}
@end
