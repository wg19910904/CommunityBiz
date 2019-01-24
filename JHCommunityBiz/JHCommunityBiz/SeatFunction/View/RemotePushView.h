//
//  RemotePushView.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/11/4.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RemotePushView : UIView
+(RemotePushView *)showView;
@property(nonatomic,strong)UIImageView *imageV;//显示商家图标的
@property(nonatomic,strong)UILabel *nameL;//显示app名字
@property(nonatomic,strong)UILabel *label;//显示现在
@property(nonatomic,strong)UILabel *completionL;//提示支付完成的显示
@end
