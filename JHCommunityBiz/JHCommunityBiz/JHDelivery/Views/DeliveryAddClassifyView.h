//
//  DeliveryAddClassifyView.h
//  JHCommunityBiz
//
//  Created by xixixi on 16/6/29.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^CancelB)();
typedef void(^SureB)();
@interface DeliveryAddClassifyView : UIView
@property(nonatomic,copy)CancelB cancelB;
@property(nonatomic,copy)SureB sureB;
@property(nonatomic,copy)NSString *parent_id;
@property(nonatomic,weak)UILabel *remindLabel;
@property(nonatomic,copy)NSString *numPlaceHolder;//第二个的placeholderstr
@property(nonatomic,assign)BOOL is_sub;//是不是子类
@property(nonatomic,copy)NSString *urlLink;//接口

- (instancetype)initWithTitle:(NSString *)title
                 withSubTitle:(NSString *)subTitle
              withRemindTitle:(NSString *)reminTitle
              withCancelBlock:(void(^)())cancelBlock
                withSureBlock:(void(^)())sureBlock;
@end
