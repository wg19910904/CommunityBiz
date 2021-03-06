//
//  XHQRCodeVC.m
//  JHCommunityBiz
//
//  Created by xixixi on 2017/5/16.
//  Copyright © 2017年 com.jianghu. All rights reserved.
//

//屏幕宽高
#define THE_WIDTH  (WIDTH)
#define THE_HEIGHT (HEIGHT-64)

#import "XHQRCodeVC.h"
#import <AVFoundation/AVFoundation.h>


#import "PayWithQRCodeVC.h"

@interface XHQRCodeVC ()<AVCaptureMetadataOutputObjectsDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property(nonatomic,strong)UIView *vcBackView;
// 有结果
@property(nonatomic,assign)BOOL is_haveResult;
// 输入输出的管理者
@property (strong,nonatomic)AVCaptureSession *session;
// 播放扫描成功后的声音
@property(nonatomic,strong)AVAudioPlayer *player;

// 预览图层
@property(nonatomic,weak)AVCaptureVideoPreviewLayer *previewLayer;
// 用于存放框出扫描的二维码的layer框
@property(nonatomic,weak)CALayer *contentLayer;

#pragma mark ======需要设初始化的一些信息=======
// 扫描区域四个角的图片
@property(nonatomic,copy)NSString *codeRangeImgName;
// 扫描动画线的图片
@property(nonatomic,copy)NSString *codeLineImgName;
// 扫描的有效范围,再次范围外的扫描无效
@property(nonatomic,assign)CGRect scanFrame;
// 是否显示选中二维码的框
@property(nonatomic,assign)BOOL is_showSelectedLayer;

@end

@implementation XHQRCodeVC


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title =  NSLocalizedString(@"扫一扫", NSStringFromClass([self class]));
    [self configSetting];
    [self setUpView];
    
    //添加其他功能
    [self addOtherFun];
    
}

-(void)setUpView{
    
    //    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(takeQRCodeFromPic)];
    //
    // 判断有无摄像头
    [self isOnorOffCamera];
    
}

- (void)addOtherFun{
    NSUInteger selectTag = [self.type isEqualToString:@"alipay"]?100:101;
    //添加支付宝和微信按钮
    UIView *payView = [[UIView alloc] initWithFrame:CGRectMake(0, THE_HEIGHT-80, THE_WIDTH, 80)];
    payView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    NSArray *imgArr = @[IMAGE(@"pay01_small"),IMAGE(@"pay02_small")];
    NSArray *selectImgArr = @[IMAGE(@"pay01_small_pre"),IMAGE(@"pay02_small_pre")];
    NSArray *titleArr = @[ NSLocalizedString(@"支付宝支付", NSStringFromClass([self class])), NSLocalizedString(@"微信支付", NSStringFromClass([self class]))];
    for (int i = 0; i < 2; i++) {
        UIButton *btn = [[UIButton alloc ] initWithFrame:CGRectMake(THE_WIDTH/2*i,0, THE_WIDTH/2, 80)];
        [btn setBackgroundColor:[UIColor clearColor] forState:(UIControlStateNormal)];
        [btn setBackgroundColor:[UIColor clearColor] forState:(UIControlStateHighlighted)];
        [btn setImage:imgArr[i] forState:(UIControlStateNormal)];
        [btn setTitle:titleArr[i] forState:(UIControlStateNormal)];
        [btn setImage:selectImgArr[i] forState:(UIControlStateSelected)];
        [btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        btn.titleLabel.font = FONT(14);
        // 按钮图片和标题总高度
        CGFloat totalHeight = (btn.imageView.frame.size.height + btn.titleLabel.frame.size.height) + 10;
        // 设置按钮图片偏移
        [btn setImageEdgeInsets:UIEdgeInsetsMake(-(totalHeight - btn.imageView.frame.size.height), 0.0, 0.0, -btn.titleLabel.frame.size.width)];
        // 设置按钮标题偏移
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -btn.imageView.frame.size.width, -(totalHeight - btn.titleLabel.frame.size.height),0.0)];
        [payView addSubview:btn];
        
        btn.tag = 100+i;
        [btn addTarget:self action:@selector(clickPayTypeBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        if (btn.tag == selectTag) btn.selected = YES;
    }
    [self.view addSubview:payView];
    
    //添加扫扫我呗
    UIButton *scanMeBtn = [[UIButton alloc] initWithFrame:CGRectMake(THE_WIDTH/2-215/2, THE_HEIGHT-80-80, 215, 40)];
    [scanMeBtn setBackgroundColor:HEX(@"ff9900", 1.0) forState:(UIControlStateNormal)];
    [scanMeBtn setImage:IMAGE(@"icon_saowo") forState:(UIControlStateNormal)];
    [scanMeBtn setTitle: NSLocalizedString(@"  扫扫我呗", NSStringFromClass([self class])) forState:(UIControlStateNormal)];
    [scanMeBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    scanMeBtn.titleLabel.font = FONT(14);
    scanMeBtn.layer.cornerRadius = 6;
    scanMeBtn.clipsToBounds = YES;
    [scanMeBtn addTarget:self action:@selector(clickScanMeBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:scanMeBtn];
}

- (void)clickPayTypeBtn:(UIButton *)sender{
    UIButton *btn = (UIButton *)[self.view viewWithTag:100];
    btn.selected = NO;
    UIButton *btn1= (UIButton *)[self.view viewWithTag:101];
    btn1.selected = NO;
    sender.selected = YES;
    self.type = (sender.tag == 100) ? @"alipay":@"wxpay";
}
- (void)clickScanMeBtn:(UIButton *)sender{
    NSLog(@"点击扫扫我呗按钮");
    PayWithQRCodeVC *vc = [[PayWithQRCodeVC alloc]init];
    vc.alipay_str = self.alipay_str;
    vc.weiChat_str = self.weiChat_str;
    vc.trade_no = self.trade_no;
    vc.amout = self.amout;
    vc.type = self.type;
    [self.navigationController pushViewController:vc animated:YES];
}
//一些需要修改的设置
-(void)configSetting{
    UIView *backView = [UIView new];
    [self.view addSubview:backView];
    backView.frame = CGRectMake(0, 0, THE_WIDTH, THE_HEIGHT-64);
    self.vcBackView = backView;
    self.vcBackView.backgroundColor = [UIColor blackColor];
    self.codeRangeImgName = @"commodity_sao";
    self.codeLineImgName = @"QRCodeScanLine";
    self.scanFrame = CGRectMake(THE_WIDTH/2-0.6*THE_WIDTH/2,THE_HEIGHT/2-0.6*THE_WIDTH/1.3, 0.6*THE_WIDTH, 0.6*THE_WIDTH);
    self.is_showSelectedLayer = NO;
}

#pragma mark 判断 有无摄像头
- (void)isOnorOffCamera{
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (error) {
        //        input = nil;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle: NSLocalizedString(@"提示", NSStringFromClass([self class])) message: NSLocalizedString(@"请在设置-隐私-中打开相机权限", NSStringFromClass([self class])) preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *confirm = [UIAlertAction actionWithTitle: NSLocalizedString(@"确定", NSStringFromClass([self class])) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
        
        [alert addAction:confirm];
        [self presentViewController:alert animated:YES completion:nil];
        
    }else{
        // 设置扫描功能
        [self configCodeFunction];
    }
}

#pragma mark 设置扫描功能
- (void)configCodeFunction {
#pragma mark ======获取设备=======
    // 1 实例化摄像头设备
    AVCaptureDevice *device = nil;
    for (AVCaptureDevice *current_device in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
        if (current_device.position == AVCaptureDevicePositionBack) {
            device = current_device;
        }
    }
    if (!device) {
        NSLog(@"不存在摄像头或者无权限");
        return;
    }
    
    // 2 设置输入
    NSError *error=nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (!input) {
        NSLog(@"输入设备获取失败");
        return;
    }
    
#pragma mark ======✨✨✨✨✨✨✨✨设置扫描范围 =======
    // 3 设置输出
    AVCaptureMetadataOutput *outPut = [[AVCaptureMetadataOutput alloc] init];
    if (!outPut) {
        NSLog(@"输出获取失败");
        return;
    }
    outPut.rectOfInterest =CGRectMake(0.25,0.25,0.5,0.5);
    // 4 设置输出的代理,扫描到结果后的回调
    [outPut setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // 5 拍摄会话
    AVCaptureSession *session = [[AVCaptureSession alloc]init];
    session.sessionPreset = AVCaptureSessionPreset1280x720;
    // 添加session的输入和输出
    [session addInput:input];
    [session addOutput:outPut];
    self.session = session;
    //启动会话
    [session startRunning];
    
    // 6 设置输出的格式，扫描的格式
    /*
     二维码 AVMetadataObjectTypeQRCode
     
     条形码 AVMetadataObjectTypeEAN13Code,
     AVMetadataObjectTypeEAN8Code,
     AVMetadataObjectTypeCode128Code
     */
    if (self.is_barcode) {
        [outPut setMetadataObjectTypes:@[AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode128Code]];
    }else{
        [outPut setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    }
    
#pragma mark ======标记显示扫描的范围 和 扫描的动画=======
    //标记显示扫描的范围
    UIImageView *scanView = [[UIImageView alloc] initWithFrame:self.scanFrame];
    scanView.image = [UIImage imageNamed:self.codeRangeImgName];
    [self.vcBackView addSubview:scanView];
    
    //添加蒙层
    [self addAlphaViewWithFrame:self.scanFrame];
    
    //扫描的动画
    UIImageView *lineImgView = [[UIImageView alloc] initWithFrame:CGRectMake(-25, 0,self.scanFrame.size.width+50, 6)];
    lineImgView.image = [UIImage imageNamed:self.codeLineImgName];
    [scanView addSubview:lineImgView];
    

    
    
    //使用基础动画的原因: 使用UIView动画会在present的时候导致动画失效,但是基础动画不会
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.y"];
    animation.fromValue=@(0);
    animation.toValue=@(self.scanFrame.size.height);
    animation.duration = 2.0;
    animation.repeatCount = MAXFLOAT;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    [lineImgView.layer addAnimation:animation forKey:nil];
    
#pragma mark ======设置预览图层=======
    // 7 设置预览图层(用来让用户能够看到扫描情况)
    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    // 7.1 设置preview图层的属性
    [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    // 7.2设置preview图层的大小
    [previewLayer setFrame:FRAME(0, 0, THE_WIDTH, THE_HEIGHT)];
    //7.3将图层添加到视图的图层
    [self.vcBackView.layer insertSublayer:previewLayer atIndex:0];
    self.previewLayer = previewLayer;
    
    if ([_previewLayer.connection isVideoOrientationSupported]) {
        _previewLayer.connection.videoOrientation = [[self class] videoOrientationFromInterfaceOrientation:self.preferredInterfaceOrientationForPresentation];
    }
    
#pragma mark ======存放框出扫描的二维码的框的layer======
    if (self.is_showSelectedLayer) {
        CALayer *layer = [[CALayer alloc] init];
        layer.frame = self.vcBackView.bounds;
        [self.vcBackView.layer addSublayer:layer];
        self.contentLayer = layer;
    }
    
    // 返回按钮
    UIButton *btn = nil;
    btn =[[UIButton alloc] initWithFrame:FRAME(10, 10, 50, 50)];
    [self.view addSubview:btn];
    [btn setImage:IMAGE(@"member_det") forState:UIControlStateNormal];
    [btn sizeToFit];
//    [btn addTarget:self action:@selector(clickBackBtn) forControlEvents:UIControlEventTouchUpInside];
    
#pragma mark ======添加额外的控件=======
  }

#pragma mark ======获取设备方向=======
+ (AVCaptureVideoOrientation)videoOrientationFromInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    switch (interfaceOrientation) {
        case UIInterfaceOrientationLandscapeLeft:
            return AVCaptureVideoOrientationLandscapeLeft;
        case UIInterfaceOrientationLandscapeRight:
            return AVCaptureVideoOrientationLandscapeRight;
        case UIInterfaceOrientationPortrait:
            return AVCaptureVideoOrientationPortrait;
        default:
            return AVCaptureVideoOrientationPortraitUpsideDown;
    }
}

#pragma mark ======AVCaptureMetadataOutputObjectsDelegate=======
// 扫描成功后的代理回调
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
  
    
    if (self.is_haveResult) {//扫描有结果后过2秒后再扫描新的
        return;
    }
    
    if ([[metadataObjects.lastObject class] isSubclassOfClass:[AVMetadataMachineReadableCodeObject class]]) {
        
        self.is_haveResult = YES;
        
        if (self.is_showSelectedLayer) {
            [self createLayerWith:metadataObjects.lastObject];
        }
        
        [self playSound];
        
        AVMetadataMachineReadableCodeObject * ty  = (AVMetadataMachineReadableCodeObject *)metadataObjects.lastObject;
        //ty.stringValue  扫描的结果
        NSLog(@"%@  string  %@",ty.type, ty.stringValue);
        //扫描成功后的回调
        if (self.completionBlock) {
            self.completionBlock(ty.stringValue,self.type);
        }
        //避免连续扫描
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.is_haveResult = NO;
        });
    }
}

#pragma mark ======添加模糊效果=======
-(void)addAlphaViewWithFrame:(CGRect)frame{
    
    UIView *view = [[UIView alloc] initWithFrame:FRAME(0, 0, THE_WIDTH, THE_HEIGHT)];
    view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    [self.view addSubview:view];
    //创建贝塞尔曲线 rect 曲线作用的范围
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:FRAME(0, 0, THE_WIDTH, THE_HEIGHT)];
    
    // 曲线路劲，需要抠出的范围大小
    [path appendPath:[[UIBezierPath bezierPathWithRect:frame] bezierPathByReversingPath]];
    // 裁剪
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    [view.layer setMask:shapeLayer];
    
}

#pragma mark ======框出被扫描的二维码=======
-(void)createLayerWith:(AVMetadataMachineReadableCodeObject *)object{
    
    AVMetadataObject *metadata = [self.previewLayer transformedMetadataObjectForMetadataObject:object];
    object = (AVMetadataMachineReadableCodeObject *)metadata;
    
    UIBezierPath *path = nil;
    NSLog(@"===== %@",NSStringFromCGRect(metadata.bounds));
    
    if (metadata.type == AVMetadataObjectTypeQRCode) {
        path = [[UIBezierPath alloc] init];
        int index =0;
        CGPoint point = CGPointZero;
        CGPointMakeWithDictionaryRepresentation((CFDictionaryRef)object.corners[index++], &point);
        
        [path moveToPoint:point];
        while (index < object.corners.count ) {
            CGPointMakeWithDictionaryRepresentation((CFDictionaryRef)object.corners[index++], &point);
            [path addLineToPoint:point];
        }
        [path closePath];
    }else {
        path = [UIBezierPath bezierPathWithRect:metadata.bounds];
    }
    
    
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.lineWidth = 2.0;
    layer.strokeColor = [UIColor greenColor].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.frame = self.vcBackView.bounds;
    layer.path = path.CGPath;
    [self.contentLayer addSublayer:layer];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self clearLayer];
    });
}

//清除框layer
-(void)clearLayer{
    if ( self.contentLayer.sublayers.count > 0) {
        for (CALayer *layer in self.contentLayer.sublayers) {
            [layer removeFromSuperlayer];
        }
    }
}

#pragma mark ======播放语音=======
-(void)playSound{
    if (self.player.isPlaying)  return;
    [self.player play];
}

- (AVAudioPlayer *)player
{
    if (_player == nil) {
        NSString *str = [[NSBundle mainBundle] pathForResource:@"di.wav" ofType:nil];
        NSURL *url = [[NSURL alloc] initFileURLWithPath:str];
        NSData *data=[NSData dataWithContentsOfURL:url];
        NSError *err = nil;
        _player = [[AVAudioPlayer alloc] initWithData:data error:&err];
        [_player prepareToPlay];
        _player.volume = 1.0;
    }
    return _player;
}

#pragma mark - 相册中读取二维码
/* navi按钮实现 */
-(void)takeQRCodeFromPic{
    
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] < 8) {
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"提示", NSStringFromClass([self class])) message: NSLocalizedString(@"请更新系统至8.0以上!", NSStringFromClass([self class])) delegate:nil cancelButtonTitle: NSLocalizedString(@"确定", NSStringFromClass([self class])) otherButtonTitles:nil, nil];
        [alert show];
        
    }else{
        
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
            
            UIImagePickerController *pickerC = [[UIImagePickerController alloc] init];
            pickerC.delegate = self;
            
            pickerC.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;  //来自相册
            
            [self presentViewController:pickerC animated:YES completion:NULL];
            
        }else{
            
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"提示", NSStringFromClass([self class])) message: NSLocalizedString(@"设备不支持访问相册，请在设置->隐私->照片中进行设置！", NSStringFromClass([self class])) delegate:nil cancelButtonTitle: NSLocalizedString(@"确定", NSStringFromClass([self class])) otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //1.获取选择的图片
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    if (!image) {
        image = info[UIImagePickerControllerOriginalImage];
    }
    //2.初始化一个监测器
    CIDetector*detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
        //监测到的结果数组  放置识别完之后的数据
        NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
        //判断是否有数据（即是否是二维码）
        if (features.count >=1) {
            /**结果对象 */
            CIQRCodeFeature *feature = [features objectAtIndex:0];
            NSString *scannedResult = feature.messageString;
            
            [self playSound];
            NSLog(@"相册中的二维码  %@",scannedResult);
            if (self.completionBlock) {
                self.completionBlock(scannedResult,self.type);
            }
            
        }
        else{
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle: NSLocalizedString(@"提示", NSStringFromClass([self class])) message: NSLocalizedString(@"该图片没有包含二维码！", NSStringFromClass([self class])) delegate:nil cancelButtonTitle: NSLocalizedString(@"确定", NSStringFromClass([self class])) otherButtonTitles:nil, nil];
            [alertView show];
        }
    }];
}



- (void)setCompletionWithBlock:(void (^) (NSString *resultAsString,NSString *type))completionBlock
{
    self.completionBlock = completionBlock;
    
}
@end
