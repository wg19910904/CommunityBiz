//
//  PayResultVC.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/10/12.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBaseVC.h"
@interface PayResultVC : UIViewController
@property(nonatomic,copy)NSString * auth_code;
@property(nonatomic,copy)NSString * amount;
@property(nonatomic,copy)NSString * type;
@property(nonatomic,copy)NSString * trade_no;
@end
