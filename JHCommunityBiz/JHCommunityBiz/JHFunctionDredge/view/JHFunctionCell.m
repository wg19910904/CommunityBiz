//
//  JHFunctionCell.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/7/29.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHFunctionCell.h"

@implementation JHFunctionCell
{
    NSArray * imageArray;
    NSArray * titleArray;
}

-(void)setModel:(JHFunctionModel *)model{
    _model = model;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if (imageArray == nil) {
        imageArray = @[@"home_Preferential",@"home_manage",@"quan"];
        titleArray = @[ NSLocalizedString(@"优惠买单", NSStringFromClass([self class])),
                         NSLocalizedString(@"团购", NSStringFromClass([self class])),
                         NSLocalizedString(@"代金券", NSStringFromClass([self class]))];

    }
    if (self.imageV == nil) {
        UIView * label_line = [[UIView alloc]initWithFrame:FRAME(0, 0, WIDTH, 0.5)];
        label_line.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
        [self addSubview:label_line];
        UIView * label_l = [[UIView alloc]initWithFrame:FRAME(0, 43.5, WIDTH, 0.5)];
        label_l.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
        [self addSubview:label_l];
        self.imageV = [[UIImageView alloc]initWithFrame:FRAME(10, 12, 20, 20)];
        self.imageV.image = [UIImage imageNamed:imageArray[self.indexPath.section]];
        [self addSubview:self.imageV];
    }
    if (self.title_label == nil) {
        self.title_label = [[UILabel alloc]init];
        self.title_label.frame = FRAME(40, 12, 100, 20);
        self.title_label.text = titleArray[self.indexPath.section];
        self.title_label.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.title_label];
    }
    if (self.mySwitch == nil) {
        self.mySwitch = [[UISwitch alloc]init];
        self.mySwitch.transform = CGAffineTransformMakeScale(0.8, 0.8);
        self.mySwitch.frame = FRAME(WIDTH - 50, 12, 40, 20);
        self.mySwitch.onTintColor = THEME_COLOR;
        [self addSubview:self.mySwitch];
        self.mySwitch.tag = self.indexPath.section;
    }
    if (self.indexPath.section == 0) {
        if ([[JHShareModel shareModel].infoDictionary[@"have_waimai"] isEqualToString:@"1"]) {
            self.mySwitch.on = YES;
        }else{
            self.mySwitch.on = NO;
        }
    }else if (self.indexPath.section == 1){
        if ([[JHShareModel shareModel].infoDictionary[@"have_maidan"] isEqualToString:@"1"]) {
            self.mySwitch.on = YES;
        }else{
            self.mySwitch.on = NO;
        }

    }else if (self.indexPath.section == 2){
        if ([[JHShareModel shareModel].infoDictionary[@"have_tuan"] isEqualToString:@"1"]) {
            self.mySwitch.on = YES;
        }else{
            self.mySwitch.on = NO;
        }

    }else{
        if ([[JHShareModel shareModel].infoDictionary[@"have_quan"] isEqualToString:@"1"]) {
            self.mySwitch.on = YES;
        }else{
            self.mySwitch.on = NO;
        }

    }
}
@end
