//
//  PayResultVC.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/10/12.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "PayResultVC.h"
#import "JHHomePageVC.h"
#import "MoneyRecordVC.h"
#import "RemotePushView.h"

@interface PayResultVC ()
{
    NSString * _error;
    NSTimer * timer;
    int tim;
    NSDictionary * dicc;
}
@property(nonatomic,strong)UILabel *label;
@property(nonatomic,strong)UILabel *label_dao;
@property(nonatomic,strong)RemotePushView *pushView;
@end

@implementation PayResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = NSLocalizedString(@"支付结果", NSStringFromClass([self class]));
    tim = 5;
    [self.view addSubview:self.label];
    [self.view addSubview:self.label_dao];
    [self postHttp];
     //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(payCompletion:) name:@"REMOTERPUSH" object:nil];
}
-(void)payCompletion:(NSNotification *)noti{
    //添加推送的view
    NSLog(@"%@",noti.userInfo);
    dicc = noti.userInfo;
    UIWindow * window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self.pushView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.4 animations:^{
            _pushView.frame = FRAME(10, -75, WIDTH - 20, 75);
        } completion:^(BOOL finished) {
            [_pushView removeFromSuperview];
            _pushView = nil;
        }];
    });
    
    
}
//pushView
-(RemotePushView *)pushView{
    if (!_pushView) {
        _pushView = [RemotePushView showView];
       _pushView.completionL.text = [NSString stringWithFormat: NSLocalizedString(@"   客户%@成功支付%@元,请及时核对账单", NSStringFromClass([self class])),dicc[@"name"],dicc[@"money"]];
    }
    return _pushView;
}
#pragma mark - 开始定时器
-(void)startTimer{
    if (!timer) {
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    }
    [timer fire];
}
-(void)onTimer{
    tim--;
    if (tim == 0) {
        MoneyRecordVC * vc = [[MoneyRecordVC alloc]init];
        vc.isOther = YES;
        [self.navigationController pushViewController:vc animated:YES];
        [self stopTimer];
        return;
    }
    _label_dao.text = [NSString stringWithFormat: NSLocalizedString(@"%ds后将自动跳转到收账记录", NSStringFromClass([self class])),tim];
}
-(void)stopTimer{
    [timer invalidate];
    timer = nil;
}
-(void)clickBackBtn{
    if ([_error isEqualToString:@"0"]) {
        NSArray * array = self.navigationController.viewControllers;
        for (JHBaseVC * vc  in array) {
            if ([vc isKindOfClass:[JHHomePageVC class]]) {
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
    }else{
        [self.navigationController popViewControllerAnimated:YES];
   }
}
-(UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc]init];
        _label.bounds = FRAME(0, 0, WIDTH, 20);
        _label.center = CGPointMake(self.view.center.x, self.view.center.y -50);
        _label.text =  NSLocalizedString(@"客户正在支付中......", NSStringFromClass([self class]));
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}
-(UILabel *)label_dao{
    if (!_label_dao) {
        _label_dao = [[UILabel alloc]init];
        _label_dao.bounds = FRAME(0, 0, WIDTH, 20);
        _label_dao.center = CGPointMake(self.view.center.x, self.view.center.y);
        _label_dao.textAlignment = NSTextAlignmentCenter;
        _label_dao.textColor = [UIColor redColor];
        _label_dao.font = FONT(14);
    }
    return _label_dao;
}
#pragma mark - 这是付款请求的方法
-(void)postHttp{
    NSDictionary * dic = @{@"auth_code":self.auth_code,
                           @"amount":self.amount,
                           @"trade_no":self.trade_no,
                           @"type":self.type
                           };
    NSLog(@"%@",dic);
    [HttpTool postWithAPI:@"biz/cashier/saoma" withParams:dic
       success:^(id json) {
        NSLog(@"json:%@",json);
        if ([json[@"error"] isEqualToString:@"0"]) {
            _label.text =  NSLocalizedString(@"客户支付成功,请及时查收", NSStringFromClass([self class]));
            _error = @"0";
            [self startTimer];
        }else{
            [JHShowAlert showAlertWithMsg:json[@"message"] withBtnTitle: NSLocalizedString(@"知道了", NSStringFromClass([self class])) withBtnBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
            _error = @"1";
        }
    } failure:^(NSError *error) {
        _error = @"1";
        NSLog(@"error:%@",error.localizedDescription);
    }];
}
@end
