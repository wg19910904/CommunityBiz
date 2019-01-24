//
//  ReconderSearchTypeCell.m
//  JHCommunityBiz
//
//  Created by ijianghu on 2017/11/11.
//  Copyright © 2017年 com.jianghu. All rights reserved.
//

#import "ReconderSearchTypeCell.h"
#import "YFTypeBtn.h"
@interface ReconderSearchTypeCell()
{
    NSMutableArray *btnArr;
}
@end
@implementation ReconderSearchTypeCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        btnArr = @[].mutableCopy;
        [self creatSubUI];
    }
    return self;
}
-(void)creatSubUI{
    UILabel *label = [UILabel new];
    label.text = NSLocalizedString(@"收款类型", NSStringFromClass([self class]));
    label.textColor = HEX(@"333333", 1);
    label.font = FONT(14);
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 12;
        make.top.offset = 15;
        make.height.offset = 16;
    }];
    CGFloat scale = WIDTH/375;
    NSArray *titleArr = @[ NSLocalizedString(@"微信", NSStringFromClass([self class])), NSLocalizedString(@"支付宝", NSStringFromClass([self class])), NSLocalizedString(@"台卡", NSStringFromClass([self class]))];
    NSArray *imgArr = @[@"icon_wexin02",@"icon_zhifubao02",@"icon_taika02"];
    CGFloat width = (WIDTH - 44)/3;
    for (int i = 0; i < 3; i++) {
        YFTypeBtn *btn = [[YFTypeBtn alloc]init];
        btn.btnType = LeftImage;
        btn.layer.cornerRadius = 4;
        btn.layer.masksToBounds = YES;
        btn.layer.borderColor =  HEX(@"e6e6e6", 1).CGColor;
        btn.layer.borderWidth = 1;
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:HEX(@"666666", 1) forState:UIControlStateNormal];
        [btn setImage:IMAGE(imgArr[i]) forState:UIControlStateNormal];
        btn.titleLabel.font =FONT(14);
        btn.imageMargin = 25*scale;
        btn.titleMargin = 10*scale;
        [self addSubview:btn];
        btn.tag = i;
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(label.mas_bottom).offset = 12;
            make.left.offset = 12+(width + 10)*i;
            make.width.offset = width;
            make.height.offset = 40;
            make.bottom.offset = -15;
        }];
        [btnArr addObject:btn];
    }
}
-(void)clickBtn:(UIButton *)sender{
    NSLog(@"%ld",sender.tag);
    sender.selected = !sender.selected;
    NSString *str;
    if (sender.selected) {
        sender.layer.borderColor =  HEX(@"ff9900", 1).CGColor;
        sender.backgroundColor = HEX(@"fff7ec", 1);
        str = @"1";
    }else{
        sender.layer.borderColor =  HEX(@"e6e6e6", 1).CGColor;
        sender.backgroundColor = HEX(@"ffffff", 1);
        str = @"0";
    }
    if (self.choseBlock) {
        self.choseBlock(sender.tag,str);
    }
}
-(void)removeSelectorIndex{
    for (YFTypeBtn *btn in btnArr) {
        btn.selected = NO;
        btn.layer.borderColor =  HEX(@"e6e6e6", 1).CGColor;
        btn.backgroundColor = HEX(@"ffffff", 1);
    }
}
@end
