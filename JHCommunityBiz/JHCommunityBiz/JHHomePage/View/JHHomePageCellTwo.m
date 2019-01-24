//
//  JHHomePageCellTwo.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/18.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHHomePageCellTwo.h"
#import "JHMyButton.h"
@implementation JHHomePageCellTwo
{
    NSArray * array;
    NSArray * imageArray;
    NSString * tuanImage;
    NSString * maidan;
    NSString * maidanType;
    NSString * tuanType;
}

-(void)setHave_waimai:(NSString *)have_waimai{
    _have_waimai = have_waimai;
    self.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    imageArray = @[@"home_Preferential",@"home_deal",@"",
//                   @"home_evaluate",@"home_Statistics",@"home_customer",
//                   @"home_manage",@"home_shop",@"icon-din"];
    imageArray = @[@"btn_home_nav01",@"btn_home_nav02",@"btn_home_nav03",
                   @"btn_home_nav04",@"btn_home_nav05",@"btn_home_nav06",
                   @"btn_home_nav07",@"btn_home_nav08"];
    if (array == nil) {
//        array = @[NSLocalizedString(@"买单设置", nil),NSLocalizedString(@"外送订单", nil),NSLocalizedString(@"外送设置", nil),
//                  NSLocalizedString(@"商户评价", nil),NSLocalizedString(@"营业统计", nil),NSLocalizedString(@"客户管理", nil),
//                  NSLocalizedString(@"团购管理", nil),NSLocalizedString(@"店铺设置", nil),NSLocalizedString(@"排队订座", nil)];
        array = @[  NSLocalizedString(@"外送设置", NSStringFromClass([self class])),
                    NSLocalizedString(@"团购管理", NSStringFromClass([self class])),
                    NSLocalizedString(@"买单设置", NSStringFromClass([self class])),
                    NSLocalizedString(@"排队订座", NSStringFromClass([self class])),
                    NSLocalizedString(@"店铺管理", NSStringFromClass([self class])),
                    NSLocalizedString(@"评价管理", NSStringFromClass([self class])),
                    NSLocalizedString(@"营业统计", NSStringFromClass([self class])),
                    NSLocalizedString(@"客户管理", NSStringFromClass([self class]))];
        self.btnArray = [NSMutableArray array];
        for (int i = 0; i < array.count; i ++) {
            JHMyButton * btn = [[JHMyButton alloc]init];
            btn.frame = FRAME(i%4*(WIDTH/4), 10+109*(i/4), WIDTH/4, 109);
            btn.backgroundColor = [UIColor whiteColor];
            [self addSubview:btn];
            [self.btnArray addObject:btn];
        }
    }
    for (int i = 0; i < self.btnArray.count; i ++) {
        JHMyButton * btn = self.btnArray[i];
        if (i == 0 && [have_waimai isEqualToString:@"0"]) {
            btn.rightImageView.image = [UIImage imageNamed:@"set_no"];
        }else if (i == 0  && [self.audit isEqualToString:@"0"]){
            btn.rightImageView.image = [UIImage imageNamed:@"set_shz"];
        }else if(i == 0 && [have_waimai isEqualToString:@"1"] && [self.audit isEqualToString:@"1"]){
            btn.rightImageView.image = [UIImage imageNamed:@""];
        }
        btn.centerImageView.image = [UIImage imageNamed:imageArray[i]];
        btn.buttomLababel.text = array[i];
    }
}
@end
