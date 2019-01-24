//
//  JHModifyNameView.h
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/18.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^GetNameBlock)(NSString *);
@interface JHModifyNameView : UIControl<UITextFieldDelegate>
@property(nonatomic,copy)GetNameBlock getNameBlock;
@property(nonatomic,weak)UINavigationController *navVC;
@end
