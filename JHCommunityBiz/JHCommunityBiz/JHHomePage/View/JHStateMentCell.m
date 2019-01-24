//
//  JHStateMentCell.m
//  JHCommunityBiz
//
//  Created by ijianghu on 2017/11/17.
//  Copyright © 2017年 com.jianghu. All rights reserved.
//

#import "JHStateMentCell.h"
@interface JHStateMentCell()
@property(nonatomic,strong)UIImageView *imgV;
@property(nonatomic,strong)UILabel *titleL;
@property(nonatomic,strong)UILabel *numL;
@property(nonatomic,strong)UILabel *moneyL;
@end
@implementation JHStateMentCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configUI];
       
    }
    return self;
}
-(void)configUI{
    [self imgV];
    [self titleL];
    [self numL];
    [self moneyL];
    [self creatRightImgV];
    [self addBottomLine];
}
-(UIImageView *)imgV{
    if (!_imgV) {
        _imgV = [[UIImageView alloc]init];
        [self addSubview:_imgV];
        [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 15;
            make.centerY.mas_equalTo(self.mas_centerY);
            make.height.width.offset = 44;
        }];
    }
    return _imgV;
}
-(UILabel *)titleL{
    if (!_titleL) {
        _titleL = [[UILabel alloc]init];
        _titleL.textColor = HEX(@"333333", 1);
        _titleL.font = FONT(16);
        [self addSubview:_titleL];
        [_titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_imgV.mas_right).offset = 12;
            make.top.offset = 23;
            make.height.offset = 16;
        }];
    }
    return _titleL;
}
-(UILabel *)numL{
    if (!_numL) {
        _numL = [[UILabel alloc]init];
        _numL.textColor = HEX(@"999999", 1);
        _numL.font = FONT(12);
        [self addSubview:_numL];
        [_numL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_imgV.mas_right).offset = 12;
            make.top.mas_equalTo(_titleL.mas_bottom).offset = 10;
            make.height.offset = 16;
        }];
    }
    return _numL;
}
-(UILabel *)moneyL{
    if (!_moneyL) {
        _moneyL = [[UILabel alloc]init];
        _moneyL.textColor = HEX(@"999999", 1);
        _moneyL.font = FONT(12);
        [self addSubview:_moneyL];
        [_moneyL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_numL.mas_right).offset = 20;
            make.top.mas_equalTo(_titleL.mas_bottom).offset = 10;
            make.height.offset = 16;
        }];
    }
    return _moneyL;
}
-(void)creatRightImgV{
    UIImageView *rightImgV = [[UIImageView alloc]init];
    rightImgV.image = IMAGE(@"btn_arrow_r");
    [self addSubview:rightImgV];
    [rightImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.offset = 16;
        make.height.offset = 23;
        make.right.offset = -21;
    }];
}
-(void)addBottomLine{
    UIView *view = [UIView new];
    view.backgroundColor = LINE_COLOR;
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset = 0 ;
        make.height.offset = 0.5;
    }];
}
-(void)setModel:(JHStateMentModel *)model{
    _model = model;
    _imgV.image = IMAGE(model.imgStr);
    _titleL.text = model.titleStr;
    _numL.text = [NSString stringWithFormat: NSLocalizedString(@"共计%@笔", NSStringFromClass([self class])),model.numStr];
    _moneyL.text = [NSString stringWithFormat: NSLocalizedString(@"收入¥%@", NSStringFromClass([self class])),model.moneyStr];
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc]initWithString:_numL.text];
    [attribute addAttributes:@{NSForegroundColorAttributeName:HEX(@"333333", 1)} range:NSMakeRange(2, 2)];
    _numL.attributedText = attribute;
    NSMutableAttributedString *attribute1 = [[NSMutableAttributedString alloc]initWithString:_moneyL.text];
    [attribute1 addAttributes:@{NSForegroundColorAttributeName:HEX(@"ff9900", 1)} range:NSMakeRange(2, model.moneyStr.length+1)];
    _moneyL.attributedText = attribute1;
}
@end
