//
//  DeliveryOrderDetailCellThree.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/7/9.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "DeliveryOrderDetailCellThree.h"
#import "GaoDe_Convert_BaiDu.h"
#import "JHPathMapVC.h"
@implementation DeliveryOrderDetailCellThree
{
    UILabel *_clientTitleL;
    UILabel *_clientL;
    UILabel *_phoneTitleL;
    UILabel *_phoneL;
    UIButton *_phoneBtn;
    UILabel *_addrTitleL;
    UILabel *_addrL;
    UIButton *_addrBtn;
    UILabel *_noteTitleL;
    UILabel *_noteL;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = 0;
        //make UI
        [self makeUI];
    }
    return self;
}

- (void)makeUI
{
    _clientTitleL = [[UILabel alloc] initWithFrame:FRAME(10,2.5, 60, 30)];
    _clientTitleL.textColor = HEX(@"333333", 1.0);
    _clientTitleL.font = FONT(14);
    _clientTitleL.text = NSLocalizedString(@"客户名", nil);
    _clientL = [[UILabel alloc] initWithFrame:FRAME(60, 2.5, WIDTH - 70, 30)];
    _clientL.textColor = THEME_COLOR;
    _clientL.font = FONT(14);
    _phoneTitleL = [[UILabel alloc] initWithFrame:FRAME(10, 32.5, 60, 30)];
    _phoneTitleL.textColor = HEX(@"333333", 1.0);
    _phoneTitleL.font = FONT(14);
    _phoneTitleL.text = NSLocalizedString(@"手机号", nil);
    _phoneL = [[UILabel alloc] initWithFrame:FRAME(60, 32.5, WIDTH - 100, 30)];
    _phoneL.textColor = THEME_COLOR;
    _phoneL.font = FONT(14);
    _phoneBtn = [[UIButton alloc] initWithFrame:FRAME(WIDTH - 40, 22.5, 40, 40)];
    [_phoneBtn setImage:IMAGE(@"Delivery_phone") forState:(UIControlStateNormal)];
    [_phoneBtn addTarget:self action:@selector(call) forControlEvents:(UIControlEventTouchUpInside)];
    _phoneBtn.imageEdgeInsets = UIEdgeInsetsMake(11.5, 11.5, 11.5, 11.5);
    _addrTitleL = [[UILabel alloc] initWithFrame:FRAME(10, 62.5, 50, 30)];
    _addrTitleL.textColor = HEX(@"333333", 1.0);
    _addrTitleL.font = FONT(14);
    _addrTitleL.text = NSLocalizedString(@"目的地", nil);
    _addrL = [[UILabel alloc] initWithFrame:FRAME(60, 62.5, WIDTH - 100, 30)];
    _addrL.textColor = THEME_COLOR;
    _addrL.font = FONT(14);
    _addrBtn = [[UIButton alloc] initWithFrame:FRAME(WIDTH - 40, 62.5, 40, 40)];
    [_addrBtn setImage:IMAGE(@"Delivery_location") forState:(UIControlStateNormal)];
    [_addrBtn addTarget:self action:@selector(showAddr) forControlEvents:(UIControlEventTouchUpInside)];
    _addrBtn.imageEdgeInsets = UIEdgeInsetsMake(13, 15, 13, 15);
    _noteTitleL = [[UILabel alloc] initWithFrame:FRAME(10, 92.5, 50, 30)];
    _noteTitleL.textColor = HEX(@"333333", 1.0);
    _noteTitleL.font = FONT(14);
    _noteTitleL.text = NSLocalizedString(@"备注", nil);
    _noteL = [[UILabel alloc] initWithFrame:FRAME(60, 92.5, WIDTH - 70, 40)];
    _noteL.textColor = THEME_COLOR;
    _noteL.font = FONT(14);
    _noteL.numberOfLines = 0;
    
    [self addSubview:_clientTitleL];
    [self addSubview:_clientL];
    [self addSubview:_phoneTitleL];
    [self addSubview:_phoneL];
    [self addSubview:_phoneBtn];
    [self addSubview:_addrTitleL];
    [self addSubview:_addrL];
    [self addSubview:_addrBtn];
    [self addSubview:_noteTitleL];
    [self addSubview:_noteL];
}
- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    _clientL.text = dataDic[@"contact"];
    _phoneL.text = dataDic[@"mobile"];
    _addrL.text = [dataDic[@"addr"] stringByAppendingString:dataDic[@"house"]?dataDic[@"house"]:@""];
    _addrL.frame = FRAME(60, 62.5, WIDTH - 100, MAX(30, 5+getStrHeight(_addrL.text, WIDTH-100, 14)));
    _addrL.numberOfLines = 0;
    _addrTitleL.center = CGPointMake(_addrTitleL.center.x, _addrL.center.y);
    _addrBtn.center = CGPointMake(_addrBtn.center.x, _addrL.center.y);
    _noteL.text = dataDic[@"note"];
    _noteL.frame = FRAME(60, _addrTitleL.frame.size.height+62.5, WIDTH-100,MAX(15+getStrHeight(_noteL.text, WIDTH-100, 14),30));
    _noteTitleL.center = CGPointMake(_noteTitleL.center.x, _noteL.center.y);
    if ([_addrL.text isEqualToString:NSLocalizedString(@"自提", nil)]||[_addrL.text isEqualToString:NSLocalizedString(@"堂食", nil)]) {
        _addrBtn.hidden = YES;
    }
}
+ (CGFloat)getHeight:(NSDictionary *)dic
{
    NSString *addrText = dic[@"addr"];
    NSString *noteText = dic[@"note"];
    
    return 62.5+MAX(30, getStrHeight(addrText,WIDTH-100,14)+5)+MAX(30,15+getStrHeight(noteText,WIDTH - 100, 14));
}
- (void)call
{
    if (!_dataDic) return;
    [JHShowAlert showCallWithMsg:_dataDic[@"mobile"]];
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
