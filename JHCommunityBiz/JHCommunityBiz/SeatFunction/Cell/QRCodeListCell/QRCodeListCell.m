//
//  QRCodeListCell.m
//  JHCommunityBiz
//
//  Created by ijianghu on 2017/11/14.
//  Copyright © 2017年 com.jianghu. All rights reserved.
//

#import "QRCodeListCell.h"
@interface QRCodeListCell()
@property(nonatomic,strong)UILabel *nameL;
@property(nonatomic,strong)UILabel *numberL;
@property(nonatomic,strong)UIImageView *imgV;
@end
@implementation QRCodeListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self nameL];
        [self numberL];
        [self imgV];
    }
    return self;
}
-(UILabel *)nameL{
    if (!_nameL) {
        _nameL = [[UILabel alloc]init];
        _nameL.textColor = HEX(@"333333", 1);
        _nameL.font = FONT(14);
        [self addSubview:_nameL];
        [_nameL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 12;
            make.top.offset = 14;
            make.height.offset = 16;
        }];
    }
    return _nameL;
}
-(UILabel *)numberL{
    if (!_numberL) {
        _numberL = [[UILabel alloc]init];
        _numberL.textColor = HEX(@"333333", 1);
        _numberL.font = FONT(12);
        [self addSubview:_numberL];
        [_numberL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 12;
            make.top.mas_equalTo(_nameL.mas_bottom).offset = 10;
            make.height.offset = 15;
        }];
    }
    return _numberL;
}
-(UIImageView *)imgV{
    if (!_imgV) {
        _imgV = [[UIImageView alloc]init];
        _imgV.image = IMAGE(@"icon_ma02");
        [self addSubview:_imgV];
        [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.width.height.offset = 20;
            make.right.offset = -12;
        }];
    }
    return _imgV;
}
-(void)setModel:(QRCodeListModel *)model{
    _model = model;
    _nameL.text = model.title;
    
    _numberL.text = [NSString stringWithFormat:NSLocalizedString(@"NO.%@   今日流水:¥%@", NSStringFromClass([self class])),model.decca_id,model.amount];
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:_numberL.text];
    [attributeStr addAttributes:@{NSForegroundColorAttributeName:HEX(@"999999", 1)} range:[_numberL.text rangeOfString:[NSString stringWithFormat: NSLocalizedString(@"今日流水:¥%@", NSStringFromClass([self class])),model.amount]]];
    _numberL.attributedText = attributeStr;
    
}
@end
