//
//  XHTextView.h
//  XHToolkit_OC
//
//  Created by jianghu1 on 17/1/7.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XHTextView : UITextView

//设置占位文字
@property(nonatomic,strong)NSString *placeholder;
//设置占位文字颜色
@property(nonatomic,strong)UIColor *placeholderColor;
//设置占位文字大小
@property(nonatomic,assign)CGFloat placeholderFont;

@end
