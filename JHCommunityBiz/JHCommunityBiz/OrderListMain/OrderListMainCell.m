//
//  OrderListMainCell.m
//  JHCommunityBiz
//
//  Created by ijianghu on 2017/11/16.
//  Copyright © 2017年 com.jianghu. All rights reserved.
//

#import "OrderListMainCell.h"
@interface OrderListMainCell()

@end
@implementation OrderListMainCell

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
    [self creatRightImgV];
}
-(UIImageView *)imgV{
    if (!_imgV) {
        _imgV = [[UIImageView alloc]init];
        _imgV.layer.cornerRadius = 28;
        _imgV.layer.masksToBounds = YES;
        [self addSubview:_imgV];
        [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.width.height.offset = 56;
            make.left.offset = 21;
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
            make.centerY.mas_equalTo(self.mas_centerY);
            make.height.offset = 18;
            make.left.mas_equalTo(_imgV.mas_right).offset = 21;
        }];
    }
    return _titleL;
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
@end
