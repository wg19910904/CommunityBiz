//
//  PayWithQRCodeVC.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/9/29.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "PayWithQRCodeVC.h"
#import "UIImage+MDQRCode.h"
#import "QRCodeReaderViewController.h"
#import "PayResultVC.h"
#import "RemotePushView.h"
#import "MoneyRecordVC.h"
@interface PayWithQRCodeVC ()
{
    NSString * qr_string;
    NSDictionary * dic;
}
@property(nonatomic,strong)UISegmentedControl *segMentControl;
@property(nonatomic,strong)UIView *qrCodeView;
@property(nonatomic,strong)UIImageView *imageVeiw;
@property(nonatomic,strong)UIButton *scan_btn;
@property(nonatomic,strong)RemotePushView *pushView;
@end

@implementation PayWithQRCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化一些数据的方法
    [self initData];
    //添加segMentControl
    [self.navigationController.view addSubview:self.segMentControl];
    //添加中间生成二维码
    [self.view addSubview:self.qrCodeView];
    [self creatUIImageView];
    //添加扫一扫的按钮
    [self.view addSubview:self.scan_btn];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(payCompletion:) name:@"REMOTERPUSH" object:nil];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //添加segMentControl
    [self.navigationController.view addSubview:self.segMentControl];
    [self.segMentControl setSelectedSegmentIndex:[self.type isEqualToString:@"alipay"] ? 0 : 1];
    [self clickSelegmentControl:self.segMentControl];
}

-(void)payCompletion:(NSNotification *)noti{
    //添加推送的view
    dic = noti.userInfo;
    NSLog(@"%@",noti.userInfo);
//    MoneyRecordVC * vc = [[MoneyRecordVC alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
//    UIWindow * window = [UIApplication sharedApplication].delegate.window;
//    [window addSubview:self.pushView];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [UIView animateWithDuration:0.4 animations:^{
//            _pushView.frame = FRAME(10, -75, WIDTH - 20, 75);
//        } completion:^(BOOL finished) {
//            [_pushView removeFromSuperview];
//            _pushView = nil;
//        }];
//    });
    [JHShowAlert showAlertWithMsg:[NSString stringWithFormat: NSLocalizedString(@"客户%@成功支付%@元,请及时核对账单", NSStringFromClass([self class])),dic[@"name"],dic[@"money"]] withBtnTitle: NSLocalizedString(@"知道了", NSStringFromClass([self class])) withBtnBlock:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
 
}
////pushView
//-(RemotePushView *)pushView{
//    if (!_pushView) {
//        _pushView = [RemotePushView showView];
//        _pushView.completionL.text = [NSString stringWithFormat:@"   客户%@成功支付%@元,请及时核对账单",dic[@"name"],dic[@"money"]];
//    }
//    return _pushView;
//}
-(void)viewWillDisappear:(BOOL)animated{
    [_segMentControl removeFromSuperview];
    _segMentControl = nil;
}

#pragma mark - 这是初始化一些数据的方法
-(void)initData{
    self.view.backgroundColor = THEME_COLOR;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}
#pragma mark - 这是创建选择支付宝还是微信
-(UISegmentedControl *)segMentControl{
    if (!_segMentControl) {
        _segMentControl = [[UISegmentedControl alloc]initWithItems:@[ NSLocalizedString(@"支付宝", NSStringFromClass([self class])), NSLocalizedString(@"微信", NSStringFromClass([self class]))]];
        _segMentControl.layer.borderColor = [UIColor whiteColor].CGColor;
        _segMentControl.layer.borderWidth = 1;
        _segMentControl.layer.cornerRadius = 5;
         _segMentControl.layer.masksToBounds = YES;
        _segMentControl.selectedSegmentIndex = [JHShareModel shareModel].index;
        qr_string = [JHShareModel shareModel].index == 0? self.alipay_str:self.weiChat_str;
        _segMentControl.backgroundColor = THEME_COLOR;
        _segMentControl.tintColor = [UIColor whiteColor];
        _segMentControl.frame = FRAME(60, 26, WIDTH - 120, 30);
        [_segMentControl addTarget:self action:@selector(clickSelegmentControl:) forControlEvents:UIControlEventValueChanged];
    }
    return _segMentControl;
}
#pragma mark - 这是点击_segMentControl的方法
-(void)clickSelegmentControl:(UISegmentedControl *)seg{
    if (seg.selectedSegmentIndex == 0) {
        //支付宝
        NSLog(@"支付宝");
        qr_string = self.alipay_str;
        [self creatUIImageView];
         [_scan_btn setTitle: NSLocalizedString(@"支付宝扫一扫", NSStringFromClass([self class])) forState:UIControlStateNormal];
        _scan_btn.tag = 0;
        [JHShareModel shareModel].index = 0;
    }else{
        //微信
          NSLog(@"微信");
        qr_string = self.weiChat_str;
        [self creatUIImageView];
         [_scan_btn setTitle: NSLocalizedString(@"微信扫一扫", NSStringFromClass([self class])) forState:UIControlStateNormal];
        _scan_btn.tag = 1;
        [JHShareModel shareModel].index = 1;
    }
}
#pragma mark - 这是创建承载二维码的底图
-(UIView *)qrCodeView
{
    if (!_qrCodeView) {
        _qrCodeView = [[UIView alloc]init];
        _qrCodeView.backgroundColor = [UIColor whiteColor];
        _qrCodeView.frame = FRAME(20, 40 , WIDTH - 40, WIDTH - 40);
        _qrCodeView.layer.cornerRadius = 3;
        _qrCodeView.layer.masksToBounds = YES;
        
    }
    return _qrCodeView;
}
#pragma mark - 这是创建UIImageView的方法
-(void)creatUIImageView{
    if (!_imageVeiw) {
        _imageVeiw = [[UIImageView alloc]init];
        _imageVeiw.frame = FRAME(40, 40, WIDTH - 120, WIDTH - 120);
        _imageVeiw.layer.borderColor = [UIColor colorWithWhite:0.7 alpha:1].CGColor;
        _imageVeiw.layer.borderWidth = 1;
        [_qrCodeView addSubview:_imageVeiw];
    }
    _imageVeiw.image = [UIImage mdQRCodeForString:qr_string size:_imageVeiw.bounds.size.width fillColor:[UIColor darkGrayColor]];
}
#pragma mark - 创建点击扫一扫的按钮
-(UIButton *)scan_btn{
    if (!_scan_btn) {
        _scan_btn = [[UIButton alloc]init];
        _scan_btn.frame = FRAME(20, WIDTH + 20, WIDTH - 40, 40);
        _scan_btn.backgroundColor = HEX(@"faaf19", 1.0);
        _scan_btn.layer.cornerRadius = 3;
        _scan_btn.layer.masksToBounds = YES;
        [_scan_btn setTitle: NSLocalizedString(@"支付宝扫一扫", NSStringFromClass([self class])) forState:UIControlStateNormal];
        [_scan_btn setTitleColor:HEX(@"000000", 1.0) forState:UIControlStateNormal];
        _scan_btn.tag = 0;
        _scan_btn.titleLabel.font = FONT(16);
        [_scan_btn setImage:[UIImage imageNamed:@"icon-erweima"] forState:UIControlStateNormal];
        _scan_btn.imageEdgeInsets = UIEdgeInsetsMake(0, -50, 0, 0);
        [_scan_btn addTarget:self action:@selector(clickToScan:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _scan_btn;
}
#pragma mark - 这是点击扫一扫的方法
-(void)clickToScan:(UIButton *)sender{
//    if (sender.tag == 0) {
//        //支付宝扫一扫
//    }else{    
//        //微信扫一扫
//    }
//    QRCodeReaderViewController * code = [QRCodeReaderViewController new];
//    code.modalPresentationStyle = UIModalPresentationFormSheet;
//    code.navigationItem.title = NSLocalizedString(@"扫一扫", nil);
//    [code setCompletionWithBlock:^(NSString *resultAsString) {
//        [self.navigationController popViewControllerAnimated:YES];
//        NSLog(@"%@",resultAsString);
//        PayResultVC *vc = [[PayResultVC alloc]init];
//        vc.amount = self.amout;
//        vc.auth_code = resultAsString;
//        vc.trade_no = self.trade_no;
//        vc.type = [JHShareModel shareModel].index == 0? @"alipay":@"wxpay";
//        [self.navigationController pushViewController:vc animated:YES];
//    }];
//    [self.navigationController pushViewController:code animated:YES];
}
@end
