//
//  JHMyButton.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/7/27.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHMyButton.h"
#import <Masonry.h>
@implementation JHMyButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)init{
    self = [super init];
    if (self) {
        //显示在中间的图片
        self.centerImageView = [[UIImageView alloc]init];
        self.centerImageView.frame = FRAME((WIDTH/4 - 50)/2, 15, 50, 50);
        [self addSubview:self.centerImageView];
        //显示在右上角的图片
        self.rightImageView = [[UIImageView alloc]init];
        self.rightImageView.frame = FRAME(WIDTH/4 - 50, 0, 50, 50);
        [self addSubview:self.rightImageView];
        //显示在下方的label
        self.buttomLababel = [[UILabel alloc]init];
        self.buttomLababel.frame = FRAME(0, 80, WIDTH/4, 20);
        self.buttomLababel.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        self.buttomLababel.font = [UIFont systemFontOfSize:15];
        self.buttomLababel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.buttomLababel];
//        UIView * view_one = [UIView new];
//        [self addSubview:view_one];
//        [view_one mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.offset(-0);
//            make.top.offset(0);
//            make.bottom.offset(0);
//            make.width.offset(0.5);
//        }];
//        view_one.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
//        UIView * view_two = [UIView new];
//        [self addSubview:view_two];
//        [view_two mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.offset(-0);
//            make.left.offset(0);
//            make.bottom.offset(0);
//            make.height.offset(0.5);
//        }];
//        view_two.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    }
    return self;
}
@end
