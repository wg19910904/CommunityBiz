//
//  JHShareModel.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/10.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHShareModel.h"
#import <MAMapKit/MAMapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AMapLocationKit/AMapLocationKit.h>
@implementation JHShareModel
{
    AMapLocationManager *locationManager;
}
+ (JHShareModel *)shareModel
{
    static JHShareModel *model = nil;
    if (!model) {
        model = [[JHShareModel alloc] init];
        model.blueTooth = [[XHBlueToothModel alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:model
                                                 selector:@selector(refreshBizInfo)
                                                     name:@"KGetNewBizInfoNoti"
                                                   object:nil];
        if (SHOW_COUNTRY_CODE) {
            [model get_def_code];
        }
        
        
    }
    return model;
}

//获取默认的区号
- (void)get_def_code{
    [HttpTool postWithAPI:@"magic/get_default_code"
               withParams:@{}
                  success:^(id json) {
                      NSLog(@"magic/get_default_code------------%@",json);
                      if ([json[@"error"] isEqualToString:@"0"]) {
                          self.def_code = json[@"data"][@"code_code"];
                      }
                  } failure:^(NSError *error) {
                      
                  }];
}

//初始化蓝牙model类
-(void)initblueTooth{
    static dispatch_once_t onceToken2;
    dispatch_once(&onceToken2, ^{
        self.blueTooth = [[XHBlueToothModel alloc] init];
    });
    
}
-(NSString *)version{
    NSDictionary *dic = [[NSBundle mainBundle]infoDictionary];
    NSString *vers = dic[@"CFBundleShortVersionString"];
    return  vers;
}
#pragma mark===========网络监听=================
- (void)addReachability
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    _hostReach = [Reachability reachabilityForInternetConnection];
    [_hostReach startNotifier];
    
}
#pragma mark=======网络监听响应方法============
- (void)reachabilityChanged:(NSNotification *)noti
{
    Reachability *curReach = [noti object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    [self getNetStatusWithReachability:curReach];
    
}
#pragma mark=======获取当前网络的相关状态=======
- (void)getNetStatusWithReachability:(Reachability *)reachability
{
    NetworkStatus status = [reachability currentReachabilityStatus];
    
    if(status == NotReachable){
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"NetWorkStatus"];
        UIAlertController * controller = [UIAlertController alertControllerWithTitle: NSLocalizedString(@"温馨提示", NSStringFromClass([self class])) message: NSLocalizedString(@"网络连接失败,请重新链接", NSStringFromClass([self class])) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *canaelAction = [UIAlertAction actionWithTitle: NSLocalizedString(@"知道了", NSStringFromClass([self class])) style:UIAlertActionStyleCancel handler:nil];
        [controller addAction:canaelAction];
        [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:controller animated:YES completion:nil];
        
    }else if(status ==  ReachableViaWWAN){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"NetWorkStatus"];
        UIAlertController *controller = [UIAlertController alertControllerWithTitle: NSLocalizedString(@"温馨提示", NSStringFromClass([self class])) message: NSLocalizedString(@"正在使用蜂窝网络", NSStringFromClass([self class])) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *canaelAction = [UIAlertAction actionWithTitle: NSLocalizedString(@"知道了", NSStringFromClass([self class])) style:UIAlertActionStyleCancel handler:nil];
        [controller addAction:canaelAction];
        [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:controller animated:YES completion:nil];
        
    }else if(status == ReachableViaWiFi){
        UIAlertController *controller = [UIAlertController alertControllerWithTitle: NSLocalizedString(@"温馨提示", NSStringFromClass([self class])) message: NSLocalizedString(@"wifi已链接", NSStringFromClass([self class])) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *canaelAction = [UIAlertAction actionWithTitle: NSLocalizedString(@"知道了", NSStringFromClass([self class])) style:UIAlertActionStyleCancel handler:nil];
        [controller addAction:canaelAction];
        [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:controller animated:YES completion:nil];
    }
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"NetWorkStatus"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
#pragma mark - 获取电话号码
- (NSString *)mobile
{
    return [UserDefaults objectForKey:@"mobile"];
}
#pragma mark - 后台获取地理位置
- (void)getCurrentLocation
{
    //******高德定位sdk,一次性定位******//
    [AMapLocationServices sharedServices].apiKey = GAO_DE_KEY;
    locationManager = [[AMapLocationManager alloc] init];
    [locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    [locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error){
            NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
            if (error.code == AMapLocationErrorLocateFailed){
                return;
            }
        }
        NSLog(@"location:%@", location);
        if (regeocode)
        {
            NSLog(@"reGeocode:%@", regeocode);
            self.cityName = regeocode.city;
        }
    }];
}
#pragma mark - 刷新店铺基本信息
- (void)refreshBizInfo
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [HttpTool postWithAPI:@"biz/shop/shop/info" withParams:@{} success:^(id json) {
            NSLog(@"%@",json);
            
            if ([json[@"error"] isEqualToString:@"0"]) {
                
                self.infoDictionary = json[@"data"];
            }
            
        } failure:^(NSError *error) {
            
            NSLog(@"%@",error.localizedDescription);
        }];
        
        
    });
}

- (NSString *)def_code{
    if (_def_code.length) {
        return _def_code;
    }
    return @"";
}

/****************************以下为店铺设置相关存取方法********************/
- (void)setNoDisturb:(BOOL)noDisturb
{
    [UserDefaults setBool:noDisturb forKey:@"noDisturb"];
}
- (BOOL)noDisturb
{
    return [UserDefaults boolForKey:@"noDisturb"];
}
- (void)setMaidan_autoPrint:(BOOL)maidan_autoPrint
{
    [UserDefaults setBool:maidan_autoPrint forKey:@"maidan_autoPrint"];
}
- (BOOL)maidan_autoPrint
{
    return [UserDefaults boolForKey:@"maidan_autoPrint"];
}
- (void)setWaisong_autoPrint:(BOOL)waisong_autoPrint
{
    [UserDefaults setBool:waisong_autoPrint forKey:@"waisong_autoPrint"];
}
- (BOOL)waisong_autoPrint
{
    return [UserDefaults boolForKey:@"waisong_autoPrint"];
}
@end
