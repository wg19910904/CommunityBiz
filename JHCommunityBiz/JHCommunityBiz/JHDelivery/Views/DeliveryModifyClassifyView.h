//
//  DeliveryModifyClassifyView.h
//  JHCommunityBiz
//
//  Created by xixixi on 16/6/30.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^CancelB)();
typedef void(^SureB)();
@interface DeliveryModifyClassifyView : UIView
@property(nonatomic,copy)CancelB cancelB;
@property(nonatomic,copy)SureB sureB;
@property(nonatomic,copy)NSString *parent_id;
@property(nonatomic,weak)UILabel *remindLabel;
@property(nonatomic,copy)NSString *urlLink;//接口
@property(nonatomic,assign)BOOL is_sub;//桌号修改
@property(nonatomic,copy)NSString *zhuohao_id;
@property(nonatomic,copy)NSString *numPlaceHolder;

- (instancetype)initWithTitle:(NSString *)title
                 withSubTitle:(NSString *)subTitle
              withRemindTitle:(NSString *)reminTitle
              withCancelBlock:(void(^)())cancelBlock
                withSureBlock:(void(^)())sureBlock
                withCateTitle:(NSString *)cateTitle
                  withOrderBy:(NSString *)orderBy
                         withCate_id:(NSString *)cate_id;
@end
