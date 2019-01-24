//
//  HZQTypeImageView.m
//  JHLive
//
//  Created by ijianghu on 16/8/18.
//  Copyright © 2016年 ijianghu. All rights reserved.
//

#import "HZQTypeImageView.h"
//屏幕宽高
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
@implementation HZQTypeImageView
{
    NSArray * _imageArray;
    NSArray * _titleArray;
    NSArray * _numArray;
    CGSize btn_size;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initwithSize:(CGSize)size withImageArray:(NSArray *)imageArray
   withTitleArray:(NSArray *)titleArray
     withNumArray:(NSArray *)numArray
{
    if (self == [super init]) {
        _imageArray = imageArray;
        _titleArray = titleArray;
        _numArray = numArray;
        btn_size = size;
        [self creatSubView];
    }
    return self;
}
#pragma mark - 这是创建子视图的方法
-(void)creatSubView{
    for (int i =0; i < _imageArray.count; i ++) {
        HZQButton * btn = [[HZQButton alloc]initWithSize:btn_size withNum:[_numArray[i] integerValue] withImage:_imageArray[i] withTitle:_titleArray[i]];
        btn.frame = CGRectMake((SCREEN_WIDTH/_imageArray.count)*i+SCREEN_WIDTH*1/24, 0, btn_size.width, btn_size.height);
        btn.tag = i;
        [btn addTarget:self action:@selector(btnToClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
}
#pragma mark - 点击按钮的方法
-(void)btnToClick:(HZQButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickToButton:)]) {
        [self.delegate clickToButton:sender];
    }
}

@end
