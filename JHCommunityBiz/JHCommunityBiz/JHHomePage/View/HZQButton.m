//
//  HZQButton.m
//  JHLive
//
//  Created by ijianghu on 16/8/18.
//  Copyright © 2016年 ijianghu. All rights reserved.
//

#import "HZQButton.h"

@implementation HZQButton
{
    CGSize btn_size;
    NSInteger lab_num;
    UIImage * btn_image;
    NSString * btn_title;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithSize:(CGSize)size withNum:(NSInteger)num withImage:(UIImage *)image withTitle:(NSString *)title{
    self = [super init];
    if (self) {
        lab_num = num;
        btn_size = size;
        btn_image = image;
        btn_title = title;
        [self creatSubView];
    }
    return self;
}
#pragma mark - 这是创建子控件的方法
-(void)creatSubView{
    //创建图片
    UIImageView * imageV = [[UIImageView alloc]init];
    imageV.frame = CGRectMake(btn_size.width/3+1.5 , 15, btn_size.width/3-3, btn_size.width/3-3);
    imageV.image = btn_image;
    [self addSubview:imageV];
    //创建title
    UILabel * label = [[UILabel alloc]init];
    label.frame = CGRectMake(0, btn_size.height - 25, btn_size.width, 20);
    label.text = btn_title;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:12];
    [self addSubview:label];
    //创建显示个数label
    UILabel * lab = [[UILabel alloc]init];
    lab.frame = CGRectMake(btn_size.width/3*2-8, 8, 16, 16);
    lab.text = @(lab_num).stringValue;
    lab.layer.cornerRadius = 8;
    lab.layer.masksToBounds = YES;
    lab.textColor = [UIColor whiteColor];
    lab.font = [UIFont systemFontOfSize:8];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.backgroundColor = THEME_COLOR;
    if (lab_num <= 0) {
        lab.hidden = YES;
    }else{
        lab.hidden = NO;
    }
    [self addSubview:lab];
}

@end
