//
//  DeliveryOrderDetailCellSix.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/7/14.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "DeliveryOrderDetailCellSix.h"
#import "JHPathMapVC.h"
#import "GaoDe_Convert_BaiDu.h"
@implementation DeliveryOrderDetailCellSix
{
    UILabel *titleL1;
    UILabel *titleL2;
    UILabel *pei_typeL;
    UILabel *staff_contact;
    UIButton *addrBtn;
    UIButton *phoneBtn;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //makeUI
        [self makeUI];
    }
    return self;
}
- (void)makeUI
{
    titleL1 = [[UILabel alloc] initWithFrame:FRAME(10, 0, WIDTH-20, 44)];
    titleL1.textColor = HEX(@"333333", 1.0);
    titleL1.font = FONT(14);
    titleL1.text = NSLocalizedString(@"配送方式", nil);
    [self addSubview:titleL1];
    
    titleL2 = [[UILabel alloc] initWithFrame:FRAME(10, 44, 70, 44)];
    titleL2.textColor = HEX(@"333333", 1.0);
    titleL2.font = FONT(14);
    titleL2.text = NSLocalizedString(@"配送员", nil);
    [self addSubview:titleL2];
    
    pei_typeL = [[UILabel alloc] initWithFrame:FRAME(90,44, WIDTH - 100, 44)];
    pei_typeL.font = FONT(14);
    pei_typeL.textColor = HEX(@"333333", 1.0);
    [self addSubview:pei_typeL];
    
    CALayer *line1 = [CALayer layer];
    line1.backgroundColor = LINE_COLOR.CGColor;
    line1.frame = FRAME(0, 44, WIDTH, 0.5);
    [self.layer addSublayer:line1];
    
    addrBtn = [[UIButton alloc] initWithFrame:FRAME(WIDTH -80, 44, 40, 44)];
    [addrBtn setImage:IMAGE(@"Delivery_location") forState:(UIControlStateNormal)];
    addrBtn.imageEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15);
    [self addSubview:addrBtn];
    [addrBtn addTarget:self action:@selector(showAddr) forControlEvents:(UIControlEventTouchUpInside)];
    
    phoneBtn = [[UIButton alloc] initWithFrame:FRAME(WIDTH -40, 44, 40, 44)];
    [phoneBtn setImage:IMAGE(@"Delivery_phone") forState:(UIControlStateNormal)];
    phoneBtn.imageEdgeInsets = UIEdgeInsetsMake(13.5, 11.5, 13.5, 11.5);
    [self addSubview:phoneBtn];
    [phoneBtn addTarget:self action:@selector(call) forControlEvents:(UIControlEventTouchUpInside)];
    
    CALayer *line2 = [CALayer layer];
    line1.backgroundColor = LINE_COLOR.CGColor;
    line1.frame = FRAME(WIDTH - 80, 44, 0.5, 44);
    [self.layer addSublayer:line2];
    
    CALayer *line3 = [CALayer layer];
    line1.backgroundColor = LINE_COLOR.CGColor;
    line1.frame = FRAME(WIDTH -40, 44, 0.5, 44);
    [self.layer addSublayer:line3];
}
- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    titleL1.text = [[NSLocalizedString(@"配送方式", nil) stringByAppendingString:@"      "]
                    stringByAppendingString:NSLocalizedString(@"第三方配送", nil)];
    pei_typeL.text = _dataDic[@"name"];
    
    
}
- (void)call
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"联系商家", nil) message:_dataDic[@"mobile"] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil)
                                                      style:UIAlertActionStyleCancel
                                                    handler:nil];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_dataDic[@"mobile"]]]];
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alert animated:YES completion:nil];
}
- (void)showAddr
{
    if (!_dataDic) return;
    JHPathMapVC *vc = [JHPathMapVC new];
    double lat;
    double lng;
    double bd_lat = [_dataDic[@"lat"] floatValue];
    double bd_lng = [_dataDic[@"lng"] floatValue];
    [GaoDe_Convert_BaiDu transform_baidu_to_gaodeWithBD_lat:bd_lat
                                                 WithBD_lon:bd_lng
                                                 WithGD_lat:&lat
                                                 WithGD_lon:&lng];
    vc.lat = @(lat).stringValue;
    vc.lng = @(lng).stringValue;
    [_navVC pushViewController:vc animated:YES];
}

@end
