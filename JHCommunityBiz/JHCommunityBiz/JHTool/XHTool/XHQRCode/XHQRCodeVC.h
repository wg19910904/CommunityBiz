//
//  XHQRCodeVC.h
//  JHCommunityBiz
//
//  Created by xixixi on 2017/5/16.
//  Copyright © 2017年 com.jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface XHQRCodeVC : UIViewController
/**
 *  是不是扫描条形码(默认扫描二维码)
 */
@property(nonatomic,assign)BOOL is_barcode;

@property(nonatomic,copy)NSString *type;


@property(nonatomic,copy)NSString * alipay_str;//支付宝二维码需要的字符串
@property(nonatomic,copy)NSString * weiChat_str;//微信二维码需要的字符串
@property(nonatomic,copy)NSString *trade_no;
@property(nonatomic,copy)NSString *amout;

@property (copy, nonatomic) void (^completionBlock) (NSString *result,NSString *type);

- (void)setCompletionWithBlock:(void (^) (NSString *resultAsString , NSString *type))completionBlock;

@end
