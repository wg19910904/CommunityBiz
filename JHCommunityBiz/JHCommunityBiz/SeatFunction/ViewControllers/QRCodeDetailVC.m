//
//  QRCodeDetailVC.m
//  JHCommunityBiz
//
//  Created by ijianghu on 2017/11/14.
//  Copyright © 2017年 com.jianghu. All rights reserved.
//

#import "QRCodeDetailVC.h"
#import "UIImage+Bitmap.h"
@interface QRCodeDetailVC ()
{
    NSString *payStr;
}
@property(nonatomic,strong)UIButton *bottomBtn;
@property(nonatomic,strong)UIImageView *imgV;
@end

@implementation QRCodeDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title =  NSLocalizedString(@"台卡详情", NSStringFromClass([self class]));
    self.view.backgroundColor = THEME_COLOR;
    [self getData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(paySuccess) name:@"paySuccess" object:nil];
    
}
-(void)paySuccess{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)getData{
    SHOW_HUD
    [HttpTool postWithAPI:@"biz/decca/get_pay_url" withParams:@{@"decca_id":self.spec_id} success:^(id json) {
        HIDE_HUD
        if ([json[@"error"] isEqualToString:@"0"]) {
            payStr = json[@"data"][@"url"];
            _money = json[@"data"][@"money"];
            [JHShareModel shareModel].shop_name = json[@"data"][@"shop_name"];;
            [self bottomBtn];
            [self imgV];
        }else{
            [self showToastAlertMessageWithTitle:json[@"message"]];
        }
    } failure:^(NSError *error) {
        HIDE_HUD
        NSLog(@"请求出错%@",error);
    }];
}
-(UIButton *)bottomBtn{
    if (!_bottomBtn) {
        _bottomBtn = [[UIButton alloc]init];
        [_bottomBtn setTitle: NSLocalizedString(@"保存台卡到相册", NSStringFromClass([self class])) forState:UIControlStateNormal];
        [_bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _bottomBtn.backgroundColor = HEX(@"ff9900", 1);
        _bottomBtn.layer.cornerRadius = 4;
        _bottomBtn.layer.masksToBounds = YES;
        [self.view addSubview:_bottomBtn];
        [_bottomBtn addTarget:self action:@selector(clickBottomBtn) forControlEvents:UIControlEventTouchUpInside];
        [_bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 15;
            make.right.offset = -15;
            make.height.offset = 44;
            make.bottom.offset = -20;
        }];
    }
    return _bottomBtn;
}
-(void)clickBottomBtn{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(WIDTH-40*SCALE, 440*SCALE), NO, 0);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:FRAME(0, 0, WIDTH-40*SCALE,  440*SCALE)];
    //设置超出的内容不显示
    [path addClip];
    //获取绘图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //将图片渲染的上下文中
    [_imgV.layer renderInContext:context];
    //获取上下文中的图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //关闭位图上下文
    //写入相册
    SHOW_HUD
   UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo

{
    HIDE_HUD
    NSString *msg = nil ;
    if(error != NULL){
        msg = NSLocalizedString( NSLocalizedString(@"保存图片失败!", nil), NSStringFromClass([self class]));
    }else{
        msg =  NSLocalizedString(@"图片已经成功保存到相册!", NSStringFromClass([self class]));
    }
    [JHShowAlert showAlertWithMsg:msg];
}
-(UIImageView *)imgV{
    if (!_imgV) {
        _imgV = [[UIImageView alloc]init];
        _imgV.backgroundColor = HEX(@"41b035", 1);
        _imgV.layer.cornerRadius = 4;
        _imgV.layer.masksToBounds = YES;
        [self.view addSubview:_imgV];
        [_imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 20*SCALE;
            make.right.offset = -20*SCALE;
            make.top.offset = 40*SCALE;
            make.height.offset = 440*SCALE;
        }];
        
        UILabel *shopN = [UILabel new];
        shopN.text = [JHShareModel shareModel].shop_name;
        shopN.textColor = [UIColor whiteColor];
        shopN.textAlignment = NSTextAlignmentCenter;
        shopN.font = FONT(18*SCALE);
        shopN.backgroundColor = HEX(@"25a018", 1);
        [_imgV addSubview:shopN];
        [shopN mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset = 0;
            make.height.offset = 50*SCALE;
            make.top.offset = 0;
        }];
        
        UILabel *numL = [UILabel new];
        numL.textColor = [UIColor whiteColor];
        numL.font = FONT(12*SCALE);
        numL.textAlignment = NSTextAlignmentCenter;
        numL.text = [NSString stringWithFormat:@"NO:%@",self.spec_id];
        [_imgV addSubview:numL];
        [numL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset = 0;
            make.height.offset = 20*SCALE;
            make.top.mas_equalTo(shopN.mas_bottom).offset = 20*SCALE;
        }];
        
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor whiteColor];
        [_imgV addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset = 200*SCALE;
            make.centerX.mas_equalTo(_imgV.mas_centerX);
            make.top.mas_equalTo(numL.mas_bottom).offset = 12*SCALE;
        }];
        
        UIImageView *qrImgV = [[UIImageView alloc]init];
        qrImgV.backgroundColor = [UIColor whiteColor];
        [view addSubview:qrImgV];
        qrImgV.image = [UIImage qrCodeImageWithInfo:payStr centerImage:nil width:200*SCALE];
        [qrImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset = 180*SCALE;
            make.centerX.mas_equalTo(view.mas_centerX);
            make.centerY.mas_equalTo(view.mas_centerY);
        }];
        
        UILabel *label = [UILabel new];
        label.textColor = [UIColor whiteColor];
        label.font = FONT(20*SCALE);
        label.textAlignment = NSTextAlignmentCenter;
        label.text =  NSLocalizedString(@"欢迎扫我付款", NSStringFromClass([self class]));
        [_imgV addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.offset = 0;
            make.height.offset = 25*SCALE;
            make.top.mas_equalTo(view.mas_bottom).offset = 20*SCALE;
        }];
        NSArray *titleArr = @[ NSLocalizedString(@"微信支付", NSStringFromClass([self class])), NSLocalizedString(@"支付宝支付", NSStringFromClass([self class]))];
        NSArray *imgArr = @[@"icon_wexin",@"icon_zhifubao"];
        for (int i = 0; i < 2; i++) {
            UIButton *btn = [[UIButton alloc]init];
            btn.backgroundColor = [UIColor whiteColor];
            [btn setTitle:titleArr[i] forState:UIControlStateNormal];
            [btn setTitleColor:HEX(@"333333", 1) forState:UIControlStateNormal];
            btn.titleLabel.font = FONT(15*SCALE);
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, -10*SCALE, 0, 0);
            btn.imageEdgeInsets = UIEdgeInsetsMake(0, -35*SCALE, 0, 0);
            [btn setImage:IMAGE(imgArr[i]) forState:UIControlStateNormal];
            [_imgV addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.offset = (WIDTH-20)/2*i;
                make.bottom.offset = 0;
                make.height.offset = 70*SCALE;
                make.width.offset = (WIDTH-20)/2;
            }];
        }
        if (_money.integerValue > 0) {
            UILabel *moneyL = [[UILabel alloc]init];
            moneyL.text = [NSString stringWithFormat: NSLocalizedString(@"¥%g", NSStringFromClass([self class])),_money.floatValue];
            moneyL.textColor = HEX(@"ff9900", 1);
            moneyL.layer.cornerRadius = 4;
            moneyL.layer.masksToBounds = YES;
            moneyL.font = FONT(16*SCALE);
            moneyL.layer.borderColor =HEX(@"eeeeee", 1).CGColor;
            moneyL.layer.borderWidth = 2;
            moneyL.backgroundColor = [UIColor whiteColor];
            moneyL.textAlignment = NSTextAlignmentCenter;
            [qrImgV addSubview:moneyL];
            [moneyL mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(qrImgV.mas_centerX);
                make.centerY.mas_equalTo(qrImgV.mas_centerY);
                make.width.height.offset = 50*SCALE;
            }];
        }
       
        
    }
    return _imgV;
}

@end
