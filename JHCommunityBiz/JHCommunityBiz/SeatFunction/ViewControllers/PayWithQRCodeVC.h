//
//  PayWithQRCodeVC.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/9/29.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHBaseVC.h"

@interface PayWithQRCodeVC : JHBaseVC
@property(nonatomic,copy)NSString * alipay_str;//支付宝二维码需要的字符串
@property(nonatomic,copy)NSString * weiChat_str;//微信二维码需要的字符串
@property(nonatomic,copy)NSString *trade_no;
@property(nonatomic,copy)NSString *amout;
@property(nonatomic,copy)NSString *type;
@end
