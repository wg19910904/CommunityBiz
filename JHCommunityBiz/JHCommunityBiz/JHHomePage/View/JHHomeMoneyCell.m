//
//  JHHomeMoneyCell.m
//  JHCommunityBiz
//
//  Created by ijianghu on 2017/11/15.
//  Copyright © 2017年 com.jianghu. All rights reserved.
//

#import "JHHomeMoneyCell.h"
#import "YFTypeBtn.h"
@interface JHHomeMoneyCell(){
    NSMutableArray *fourBtnArr;
}
@property(nonatomic,strong)UILabel *labelT;//标题
@property(nonatomic,strong)YFTypeBtn *seeBtn;//查看的按钮
@property(nonatomic,strong)UILabel *moneyL;//显示金额的
@property(nonatomic,strong)UILabel *totalL;//总共多少笔
@end
@implementation JHHomeMoneyCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        fourBtnArr = @[].mutableCopy;
        [self labelT];
        [self seeBtn];
        [self moneyL];
        [self totalL];
        UIView *line = [UIView new];
        line.backgroundColor = LINE_COLOR;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset = 0;
            make.height.offset = 0.5;
            make.top.mas_equalTo(_moneyL.mas_bottom).offset = 20;
        }];
        
    }
    return self;
}
-(UILabel *)labelT{
    if (!_labelT) {
        _labelT = [[UILabel alloc]init];
        _labelT.text =  NSLocalizedString(@"今日全部收入", NSStringFromClass([self class]));
        _labelT.textColor = HEX(@"999999", 1);
        _labelT.font = FONT(14);
        [self addSubview:_labelT];
        [_labelT mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 21;
            make.top.offset  = 20;
            make.height.offset = 16;
        }];
    }
    return _labelT;
}
-(YFTypeBtn *)seeBtn{
    if (!_seeBtn) {
        _seeBtn = [[YFTypeBtn alloc]init];
        _seeBtn.btnType = RightImage;
        [_seeBtn setTitle: NSLocalizedString(@"查看对账单", NSStringFromClass([self class])) forState:UIControlStateNormal];
        [_seeBtn setTitleColor:HEX(@"ff9900", 1) forState:UIControlStateNormal];
        [_seeBtn setImage:IMAGE(@"btn_arrow_r") forState:UIControlStateNormal];
        _seeBtn.titleLabel.font = FONT(14);
        _seeBtn.imageMargin = 5;
        _seeBtn.titleMargin = 12;
        [self addSubview:_seeBtn];
        [_seeBtn addTarget:self action:@selector(clickSeeBtn) forControlEvents:UIControlEventTouchUpInside];
        [_seeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset = -22*SCALE;
            make.height.offset = 18;
            make.width.offset = 100;
            make.top.offset = 15;
        }];
        
    }
    return _seeBtn;
}
-(void)clickSeeBtn{
    if (self.clickBlock) {
        self.clickBlock();
    }
}
-(UILabel *)moneyL{
    if (!_moneyL) {
        _moneyL = [[UILabel alloc]init];
       
        _moneyL.textColor = HEX(@"ff9900", 1);
        _moneyL.font = FONT(32);
        [self addSubview:_moneyL];
        [_moneyL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 21;
            make.height.offset = 35;
            make.top.mas_equalTo(_labelT.mas_bottom).offset = 10;
        }];
        
    }
    return _moneyL;
}
-(UILabel *)totalL{
    if (!_totalL) {
        _totalL = [[UILabel alloc]init];
        
        _totalL.textColor = HEX(@"999999", 1);
        _totalL.font = FONT(14);
        [self addSubview:_totalL];
        [_totalL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset = -21;
            make.centerY.mas_equalTo(_moneyL.mas_centerY);
            make.height.offset = 16;
        }];
       
    }
    return _totalL;
}
-(void)creatFourBtn{
    for (UIButton *btn in fourBtnArr) {
        [btn removeFromSuperview];
    }
    [fourBtnArr removeAllObjects];
    NSArray *titleArr = @[
                          [NSString stringWithFormat: NSLocalizedString(@"外送\n%@", NSStringFromClass([self class])),_dic[@"waimai"][@"amount"]],
                          [NSString stringWithFormat: NSLocalizedString(@"团购\n%@", NSStringFromClass([self class])),_dic[@"tuan"][@"amount"]],
                          [NSString stringWithFormat: NSLocalizedString(@"买单\n%@", NSStringFromClass([self class])),_dic[@"maidan"][@"amount"]],
                          [NSString stringWithFormat: NSLocalizedString(@"收款\n%@", NSStringFromClass([self class])),_dic[@"cashier"][@"amount"]]];
    CGFloat w = WIDTH/4;
    for (int i = 0; i < 4; i ++) {
        UIButton *btn = [[UIButton alloc]init];
        [btn setTitleColor:HEX(@"666666", 1) forState:UIControlStateNormal];
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        btn.titleLabel.font = FONT(14);
        btn.titleLabel.numberOfLines = 0;
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = w*i;
            make.bottom.offset = 0;
            make.height.offset = 70;
            make.width.offset = w;
        }];
        if (i != 0) {
            UIView *line = [UIView new];
            line.backgroundColor = LINE_COLOR;
            [self addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.offset = 0;
                make.height.offset = 0.5;
                make.top.mas_equalTo(_moneyL.mas_bottom).offset = 20;
            }];
            
        }
        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc]initWithString:btn.titleLabel.text];
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc]init];
        [paragraph setLineSpacing:10];
        [attribute addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, btn.titleLabel.text.length)];
        btn.titleLabel.attributedText = attribute;
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [fourBtnArr addObject:btn];
    }
}
-(void)setDic:(NSDictionary *)dic{
    _dic = dic;
    _moneyL.text = [NSString stringWithFormat: NSLocalizedString(@"¥%@", NSStringFromClass([self class])),dic[@"all"][@"amount"]];
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc]initWithString:_moneyL.text];
    [attribute addAttributes:@{NSFontAttributeName:FONT(20)} range:NSMakeRange(0, 1)];
    _moneyL.attributedText = attribute;
    _totalL.text = [NSString stringWithFormat: NSLocalizedString(@"共计%@笔", NSStringFromClass([self class])),dic[@"all"][@"num"]];
    NSMutableAttributedString *attribute1 = [[NSMutableAttributedString alloc]initWithString:_totalL.text];
    [attribute1 addAttributes:@{NSForegroundColorAttributeName:HEX(@"333333", 1)} range:NSMakeRange(2, [dic[@"all"][@"num"] length])];
    _totalL.attributedText = attribute1;
    [self creatFourBtn];
}
@end
