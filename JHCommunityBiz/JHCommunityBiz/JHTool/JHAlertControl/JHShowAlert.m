//
//  JHShowAlert.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/6/22.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHShowAlert.h"

@implementation JHShowAlert
+(void)showAlertWithTitle:(NSString *)title
               withMessage:(NSString *)msg
            withBtn_cancel:(NSString *)cancel
              withBtn_sure:(NSString *)sure
           withCancelBlock:(void(^)(void))cancelBlock
             withSureBlock:(void(^)(void))sureBlock {
    UIAlertController * alertControl = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    if (cancel) {
        [alertControl addAction:[UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            if (cancelBlock) {
                cancelBlock();
            }
        }]];
    }
    if (sure) {
        [alertControl addAction:[UIAlertAction actionWithTitle:sure style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (sureBlock) {
                sureBlock();
            }

        }]];
    }
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alertControl animated:YES completion:nil];
}
+(void)showAlertWithMsg:(NSString *)msg
{
   
    UIAlertController * alertControl = [UIAlertController alertControllerWithTitle: NSLocalizedString(@"温馨提示", NSStringFromClass([self class]))
                                                                           message:msg
                                                                    preferredStyle:UIAlertControllerStyleAlert];
    [alertControl addAction:[UIAlertAction actionWithTitle: NSLocalizedString(@"知道了", NSStringFromClass([self class]))
                                                     style:UIAlertActionStyleCancel
                                                   handler:nil]];

    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alertControl animated:YES completion:nil]; 
}
+(void)showAlertWithMsg:(NSString *)msg withBtnTitle:(NSString *)title withBtnBlock:(void(^)())btnBlock
{
    UIAlertController * alertControl = [UIAlertController alertControllerWithTitle: NSLocalizedString(@"温馨提示", NSStringFromClass([self class]))
                                                                           message:msg
                                                                    preferredStyle:UIAlertControllerStyleAlert];
    [alertControl addAction:[UIAlertAction actionWithTitle:title
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction * _Nonnull action) {
                                                       if (btnBlock) {
                                                           btnBlock();
                                                       }
                                                   }]];
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alertControl animated:YES completion:nil];
}
//电话
+ (void)showCallWithMsg:(NSString *)phone
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@""
                                                                   message:phone
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle: NSLocalizedString(@"取消", NSStringFromClass([self class]))
                                                      style:UIAlertActionStyleCancel
                                                    handler:nil];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle: NSLocalizedString(@"确定", NSStringFromClass([self class])) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phone]]];
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alert animated:YES completion:nil];

}

@end
