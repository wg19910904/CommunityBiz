//
//  JHNewCapitalHeaderCell.m
//  JHCommunityBiz
//
//  Created by ijianghu on 2017/11/29.
//  Copyright © 2017年 com.jianghu. All rights reserved.
//

#import "JHNewCapitalHeaderCell.h"
@interface JHNewCapitalHeaderCell()
@property(nonatomic,strong)UILabel *moneyL;//金额
@property(nonatomic,strong)UIButton *tixianBtn;//提现的按钮
@end
@implementation JHNewCapitalHeaderCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self creatSubView];
    }
    return self;
}
-(void)creatSubView{
    UIImageView *imgV = [UIImageView new];
    imgV.image = IMAGE(@"bg_zhang");
    [self addSubview:imgV];
    [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset = 0;
        make.height.offset = 180;
    }];
    
    UILabel *lab = [[UILabel alloc]init];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = FONT(14);
    lab.text =  NSLocalizedString(@"当前账户余额", NSStringFromClass([self class]));
    lab.textColor = HEX(@"ffffff", 1);
    [self addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset = 32;
        make.height.offset = 16;
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    [self moneyL];
    [self tixianBtn];
}
-(UILabel *)moneyL{
    if (!_moneyL) {
        _moneyL = [[UILabel alloc]init];
        _moneyL.textColor = HEX(@"ffffff", 1);
        _moneyL.font = FONT(30);
        [self addSubview:_moneyL];
        [_moneyL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.height.offset = 35;
            make.top.offset = 70;
            
        }];
        
        
    }
    return _moneyL;
}
-(void)setMoney:(NSString *)money{
    _money = money;
    _moneyL.text = [NSLocalizedString(@"¥", NSStringFromClass([self class])) stringByAppendingString:money];
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc]initWithString:_moneyL.text];
    [attribute addAttributes:@{NSFontAttributeName:FONT(20)} range:[_moneyL.text rangeOfString: NSLocalizedString(@"¥", NSStringFromClass([self class]))]];
    _moneyL.attributedText = attribute;
}
-(UIButton *)tixianBtn{
    if (!_tixianBtn) {
        _tixianBtn = [[UIButton alloc]init];
        [_tixianBtn setBackgroundImage:IMAGE(@"btn_tixian") forState:UIControlStateNormal];
        [_tixianBtn addTarget:self action:@selector(clickTixianBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_tixianBtn];
        [_tixianBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.width.height.offset = 80;
            make.top.mas_equalTo(_moneyL.mas_bottom).offset = 16;
        }];
    }
    return _tixianBtn;
}
-(void)clickTixianBtn{
    if (self.clickBlock) {
        self.clickBlock();
    }
}
@end
