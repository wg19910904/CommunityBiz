//
//  JHTuangouManageNav.h
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/31.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^JHTuangouManageNav_RefreshBlock)(NSInteger num);
@interface JHTuangouManageNav : UIView
@property(nonatomic,strong)NSArray<UIButton *>*btnArray;
@property(nonatomic,strong)UIButton *btn0;
@property(nonatomic,strong)UIButton *btn1;
@property(nonatomic,strong)UIButton *btn2;
@property(nonatomic,strong)UIButton *btn3;
@property(nonatomic,copy)JHTuangouManageNav_RefreshBlock refreshBlock;
@end
