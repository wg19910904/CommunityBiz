//
//  JHOriginImage.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/24.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHOriginImage.h"

@implementation JHOriginImage
-(void)showWithImage:(UIImage *)image withBlock:(void(^)(void))myBlock{
    UIWindow * window = [UIApplication sharedApplication].delegate.window;
    self.frame = FRAME(0, 0, WIDTH, HEIGHT);
    self.backgroundColor = [UIColor colorWithWhite:0.3 alpha:1];
    [self addTarget:self action:@selector(clickCancel) forControlEvents:UIControlEventTouchUpInside];
    [window addSubview:self];
    UIImageView * imageView = [[UIImageView alloc]init];
    imageView.frame = FRAME(0, HEIGHT/3, WIDTH, HEIGHT/3);
    imageView.image = image;
    imageView.userInteractionEnabled= YES;
    [self addSubview:imageView];
    //加点击手势
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickCancel)];
    [imageView addGestureRecognizer:tap];
    //缩放手势
    UIPinchGestureRecognizer * pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handlePinch:)];
    [imageView addGestureRecognizer:pinch];
    [self setBlock:^(void){
        myBlock();
    }];
}
-(void)handlePinch:(UIPinchGestureRecognizer *)pinch{
    pinch.view.transform = CGAffineTransformScale(pinch.view.transform, pinch.scale, pinch.scale);
    pinch.scale = 1;
}
-(void)clickCancel{
    self.block();
}
@end
