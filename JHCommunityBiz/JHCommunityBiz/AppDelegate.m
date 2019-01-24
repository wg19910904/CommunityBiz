//
//  AppDelegate.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/9.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "AppDelegate.h"
#import "JHLoginVC.h"
#import <AFNetworkActivityIndicatorManager.h>
#import <AFNetworkReachabilityManager.h>
#import "JHShareModel.h"
#import <IQKeyboardManager.h>
#import "JHBaseNavVC.h"
#import "YYFPSLabel.h"
#import "JHShopTypeModel.h"
#import "JPUSHService.h"
#import "OpenUDID.h"
#import <AVFoundation/AVFoundation.h>
#import <Bugly/Bugly.h>
#import <UMCommon/UMCommon.h>
@interface AppDelegate ()
@end

@implementation AppDelegate
{
    AVAudioPlayer * newPotui_audioPlay;
    AVAudioPlayer * newPay_audioPlay;
    AVAudioPlayer * newTuanOrder_audioPlay;
    AVAudioPlayer * newWaimaiOrder_audioPlay;
    AVAudioPlayer * newYudingOrder_audioPlay;
    
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //bugly
    [Bugly startWithAppId:@"728259a638"];
    //友盟统计
    [UMConfigure initWithAppkey:@"5bfdf740f1f556e73b0000c5" channel:@"App Store"];
    //显示网络指示器
    [self showIndicator];
    //添加网络监听
    [self addReachability];
    newPotui_audioPlay = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"newPaiduiOrder" ofType:@"mp3"]] error:nil];
    newPay_audioPlay = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"newPayOrder" ofType:@"mp3"]] error:nil];
    newTuanOrder_audioPlay = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"newTuanOrder" ofType:@"mp3"]] error:nil];
    newWaimaiOrder_audioPlay = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"newWaimaiOrder" ofType:@"mp3"]] error:nil];
    newYudingOrder_audioPlay = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"newYudingOrder" ofType:@"mp3"]] error:nil];
    //地图相关
    if ([GAO_DE_KEY length] > 0) {
        [XHMapKitManager shareManager].gaodeKey = GAO_DE_KEY;
    }else if ([GMS_MapKey length] > 0){
        [XHMapKitManager shareManager].gmsMapKey = GMS_MapKey;
        [XHMapKitManager shareManager].theme_color = THEME_COLOR;
    }
    [[XHPlaceTool sharePlaceTool] getCurrentPlaceWithSuccess:^(XHLocationInfo *model) {
        [[XHPlaceTool sharePlaceTool] aroundSearchWithSuccess:^(NSArray<XHLocationInfo *> *pois) {
            if (pois.count) {
                XHLocationInfo *model = pois[0];
                [XHMapKitManager shareManager].currentCity = model.city;
            }

        } failure:^(NSString *error) {}];
    } failure:^(NSString *error) {}];

    //创建极光推送
    [self creatJPushWithOptions:launchOptions];
    //将icon的通知数量清零
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    //定位
    [self getLocation];
    //IQKeyboard
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    //    YYFPSLabel *fps = [[YYFPSLabel alloc] initWithFrame:FRAME(50, 30, 60, 30)];
    //    [self.window addSubview:fps];
    //请求商户分类的方法
    [self postShopTypeHttp];
    [self postForCloudPrict];

    [[UITabBar appearance] setTranslucent:NO];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    JHLoginVC * loginVC = [[JHLoginVC alloc]init];
    JHBaseNavVC * nav = [[JHBaseNavVC alloc]initWithRootViewController:loginVC];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    [[JHShareModel shareModel].blueTooth applicationActiveAutoConnectPeripheral];
    [self setUserAgent];
    return YES;
}
#pragma mark - 设置webView加载时的user_agent
-(void)setUserAgent{
    UIWebView* tempWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString* userAgent = [tempWebView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSString *ua = [NSString stringWithFormat:@"%@/%@",userAgent, @"com.jhcms.ios.sq"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{@"UserAgent" : ua, @"User-Agent" : ua}];
}

#pragma mark - 这是创建极光推送的方法
-(void)creatJPushWithOptions:(NSDictionary *)launchOptions{
    [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound) categories:nil];
    [JPUSHService setupWithOption:launchOptions appKey:JPUSH_KEY channel:@"Publish channel" apsForProduction:NO advertisingIdentifier:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kJPFNetworkDidLoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getRegistrationID) name:kJPFNetworkDidLoginNotification object:nil];
}
#pragma mark - 这是获取极光推送的RegistrationID的方法
-(void)getRegistrationID{
     NSString * registrationID = [JPUSHService registrationID];
    [[NSUserDefaults standardUserDefaults] setObject:registrationID forKey:@"registrationID"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    //获取openUDID
    //[self getOpenUDID];
}
#pragma mark - 获取极光推送需要的openUDID
-(void)getOpenUDID{
//    NSString * openUDID = [OpenUDID value];
//    [[NSUserDefaults standardUserDefaults] setObject:openUDID forKey:@"OpenUDID"];
//    [[NSUserDefaults standardUserDefaults]synchronize];
}
#pragma mark - 这是获取到deviceToken的方法
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSLog(@"%@",deviceToken);
    [JPUSHService registerDeviceToken:deviceToken];
}
#pragma mark - 远程推送注册失败
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"注册远程推送失败%@", error);
}
#pragma mark - 这是获取远程推送信息的方法
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    NSLog(@"%@",userInfo);
    [JPUSHService handleRemoteNotification:userInfo];
    
    completionHandler(UIBackgroundFetchResultNewData);
    NSString * str = userInfo[@"aps"][@"sound"];
    NSString *type = userInfo[@"aps"][@"type"];
    if ([str containsString:@"newPaiduiOrder"]) {
         newPotui_audioPlay.volume = 1;
         [newPotui_audioPlay play];
    }else if ([str containsString:@"newPayOrder"]){
         newPay_audioPlay.volume = 1;
         [newPay_audioPlay play];
        if ([type isEqualToString:@"newPayOrder"]) {
            [JHShowAlert showAlertWithMsg:[NSString stringWithFormat: NSLocalizedString(@"您成功收款%@元", NSStringFromClass([self class])),userInfo[@"aps"][@"money"]] withBtnTitle: NSLocalizedString(@"知道了", NSStringFromClass([self class])) withBtnBlock:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"paySuccess" object:nil];
        }
        
    }else if([str containsString:@"newTuanOrder"]){
        newTuanOrder_audioPlay.volume = 1;
        [newTuanOrder_audioPlay play];
    }else if ([str containsString:@"newWaimaiOrder"]){
        newWaimaiOrder_audioPlay.volume = 1;
        [newWaimaiOrder_audioPlay play];
    }else if ([str containsString:@"newYudingOrder"]){
        newYudingOrder_audioPlay.volume = 1;
        [newYudingOrder_audioPlay play];
    }
}
#pragma mark - 请求商户分类的方法
-(void)postShopTypeHttp{
    NSMutableArray * fatherArray = @[].mutableCopy;
    NSMutableArray * children = @[].mutableCopy;
    NSMutableArray * fatherArray_cateID = @[].mutableCopy;
    NSMutableArray * children_cateID = @[].mutableCopy;
    [HttpTool postWithAPI:@"biz/account/cate" withParams:@{} success:^(id json) {
        NSLog(@"%@",json);
        NSArray * tempArray = json[@"data"][@"cate"];
        for (NSDictionary * dic  in tempArray) {
            [fatherArray addObject:dic[@"title"]];
            [fatherArray_cateID addObject:dic[@"cate_id"]];
            NSArray * temp = dic[@"childrens"];
            NSLog(@"%@",temp);
            NSMutableArray * childrenArray = @[].mutableCopy;
            NSMutableArray * childrenArray_cateID = @[].mutableCopy;
            if (temp) {
                for (NSDictionary * dictionary in temp) {
                    [childrenArray addObject:dictionary[@"title"]];
                    [childrenArray_cateID addObject:dictionary[@"cate_id"]];
                }
                 [children addObject:childrenArray];
                 [children_cateID addObject:childrenArray_cateID];
            }else{
                 [children addObject:childrenArray];
                 [children_cateID addObject:childrenArray_cateID];
            }
        }
        JHShopTypeModel * model = [JHShopTypeModel shareShopTypeModel];
        model.fatherArray = fatherArray;
        model.children = children;
        model.fatherArray_cateID = fatherArray_cateID;
        model.children_cateID = children_cateID;
    } failure:^(NSError *error) {
        NSLog(@"%@",error.localizedDescription);
    }];
}
#pragma mark - 这是请求云打印数据的接口
-(void)postForCloudPrict{
    [HttpTool postWithAPI:@"biz/printer/items" withParams:@{} success:^(id json) {
        NSLog(@"json>>>>%@",json);
        if ([json[@"error"] isEqualToString:@"0"]) {
            NSArray * tempArray = json[@"data"][@"items"];
            for (NSDictionary * dic  in tempArray) {
                if ([dic[@"status"] isEqualToString:@"1"]) {
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"yunPrintState"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [JHShareModel shareModel].printType = @"yunPrint";
                }else{
                    
                }
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 显示网络指示器
- (void)showIndicator
{
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}
#pragma mark - 添加网络监听
- (void)addReachability
{
    [[JHShareModel shareModel] addReachability];
}
#pragma mark - 定位
- (void)getLocation
{
    [[JHShareModel shareModel] getCurrentLocation];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //程序即将进入前台的一些操作
    // [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"yunPrintState"];
    //[[NSUserDefaults standardUserDefaults] setObject:@"" forKey:[NSString stringWithFormat:@"%@%@",@"yunPrintPlat_id",model.plat_id]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [application setApplicationIconBadgeNumber:0];
    [JPUSHService resetBadge];
}
- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
@end
