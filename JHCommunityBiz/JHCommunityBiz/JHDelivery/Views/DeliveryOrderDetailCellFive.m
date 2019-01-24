//
//  DeliveryOrderDetailCellFive.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/7/9.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "DeliveryOrderDetailCellFive.h"

@implementation DeliveryOrderDetailCellFive

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = 0;
        //makeUI
        [self makeUI];
    }
    return self;
}

- (void)makeUI
{
    self.titleL = [[UILabel alloc] initWithFrame:FRAME(10, 0, 50, 44)];
    self.titleL.textColor = HEX(@"333333", 1.0);
    self.titleL.font = FONT(14);
    [self addSubview:_titleL];
    
    self.price = [[UILabel alloc] initWithFrame:FRAME(WIDTH - 70, 0, 60, 44)];
    self.price.textColor = HEX(@"faaf19", 1.0);
    self.price.font = FONT(14);
    self.price.textAlignment = NSTextAlignmentRight;
    self.price.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_price];
    
    self.first_youhuiL = [[UILabel alloc] init];
    self.first_youhuiL.backgroundColor = THEME_COLOR;
    self.first_youhuiL.font = FONT(11);
    self.first_youhuiL.frame = FRAME(60, 11, 65, 20);
    self.first_youhuiL.adjustsFontSizeToFitWidth = YES;
    _first_youhuiL.textColor = [UIColor whiteColor];
    _first_youhuiL.layer.cornerRadius = 2;
    _first_youhuiL.layer.masksToBounds = YES;
    _first_youhuiL.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_first_youhuiL];
    
    self.hongbao_youhuiL = [[UILabel alloc] init];
    self.hongbao_youhuiL.backgroundColor = HEX(@"fd432b", 1.0);
    self.hongbao_youhuiL.font = FONT(11);
    self.hongbao_youhuiL.frame = FRAME(60, 11, 65, 20);
    self.hongbao_youhuiL.adjustsFontSizeToFitWidth = YES;
    _hongbao_youhuiL.textColor = [UIColor whiteColor];
    _hongbao_youhuiL.layer.cornerRadius = 2;
    _hongbao_youhuiL.layer.masksToBounds = YES;
    _hongbao_youhuiL.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_hongbao_youhuiL];
    
    self.manjian_youhuiL = [[UILabel alloc] init];
    self.manjian_youhuiL.backgroundColor = HEX(@"faaf19", 1.0);
    self.manjian_youhuiL.font = FONT(11);
    self.manjian_youhuiL.frame = FRAME(60, 11, 65, 20);
    self.manjian_youhuiL.adjustsFontSizeToFitWidth = YES;
    _manjian_youhuiL.textColor = [UIColor whiteColor];
    _manjian_youhuiL.layer.cornerRadius = 2;
    _manjian_youhuiL.layer.masksToBounds = YES;
    _manjian_youhuiL.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_manjian_youhuiL];
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    _titleL.text = dataDic[@"title"];
    _price.text = [NSString stringWithFormat:@"%@%g",MS,[dataDic[@"price"] floatValue]];
    _first_youhuiL.hidden = YES;
    _manjian_youhuiL.hidden = YES;
    _hongbao_youhuiL.hidden = YES;
    NSArray *keys = [dataDic allKeys];
    if ([keys containsObject:@"first_youhui"]) {
        NSMutableArray<UILabel *> *labelArr = @[].mutableCopy;
        //添加优惠展示
        CGFloat first_youhui = [dataDic[@"first_youhui"] floatValue];
        CGFloat hongbao_amount = [dataDic[@"hongbao_amount"] floatValue];
        CGFloat manjian = [dataDic[@"manjian"] floatValue];
        if (first_youhui > 0) {
            [labelArr addObject:_first_youhuiL];
            _first_youhuiL.text = [NSString stringWithFormat:@"%@%g%@",NSLocalizedString(@"首单立减", nil),first_youhui,MT];
        }
        if (hongbao_amount > 0) {
            [labelArr addObject:_hongbao_youhuiL];
            _hongbao_youhuiL.text = [NSString stringWithFormat:@"%g%@%@",hongbao_amount,MT,NSLocalizedString(@"红包抵扣", nil)];
        }
        if (manjian > 0) {
            [labelArr addObject:_manjian_youhuiL];
            _manjian_youhuiL.text = [NSString stringWithFormat:@"%@%g%@",NSLocalizedString(@"满减优惠", nil),manjian,MT];
        }
        [labelArr enumerateObjectsUsingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.hidden = NO;
            obj.frame = FRAME(WIDTH - (labelArr.count+1 - idx)*67, 11, 65, 20);
            
        }];
    }
    
    
}

@end
