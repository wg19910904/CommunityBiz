//
//  XHTextView.m
//  XHToolkit_OC
//
//  Created by jianghu1 on 17/1/7.
//  Copyright © 2017年 xixixi. All rights reserved.
//

#import "XHTextView.h"
#define XHTextViewContainerInset UIEdgeInsetsMake(10, 10, 10, 10)
@interface XHTextView()

//占位label,用于显示占位文字
@property(nonatomic,strong)UITextView *placeholderView;


@end

@implementation XHTextView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //设置内容边距
        self.textContainerInset = XHTextViewContainerInset;
        //添加通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(beginFisrtResponder:)
                                                     name:UITextViewTextDidBeginEditingNotification
                                                   object:nil];
        //添加通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(endFisrtResponder:)
                                                     name:UITextViewTextDidEndEditingNotification
                                                   object:nil];
    }
    return self;
}
- (void)setPlaceholder:(NSString *)placeholder{
    self.placeholderLabel.text = placeholder;
    
}
- (void)setPlaceholderFont:(CGFloat)placeholderFont{
    _placeholderFont = placeholderFont;
    self.placeholderLabel.font = [UIFont systemFontOfSize:self.placeholderFont];
}
- (void)setPlaceholderColor:(UIColor *)placeholderColor{
    _placeholderColor = placeholderColor;
    self.placeholderLabel.textColor = _placeholderColor;
}

- (void)beginFisrtResponder:(NSNotification *)noti{
    self.placeholderLabel.hidden = YES;
}
- (void)endFisrtResponder:(NSNotification *)noti{

    self.placeholderLabel.hidden = self.text.length > 0;
}

- (void)setText:(NSString *)text{
    [super setText:text];
    if (text.length > 0) self.placeholderLabel.hidden = YES;
}

- (UITextView *)placeholderLabel{
    if (!_placeholderView) {
        _placeholderView = [[UITextView alloc] initWithFrame:self.bounds];
        _placeholderView.font = self.font;
        _placeholderView.textColor = self.textColor;
        _placeholderView.backgroundColor = [UIColor clearColor];
        _placeholderView.userInteractionEnabled = NO;
        _placeholderView.textContainerInset = XHTextViewContainerInset;
        [self addSubview:_placeholderView];
    }
    return _placeholderView;
    
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextViewTextDidBeginEditingNotification
                                                  object:NULL];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextViewTextDidEndEditingNotification
                                                  object:NULL];
}

@end
