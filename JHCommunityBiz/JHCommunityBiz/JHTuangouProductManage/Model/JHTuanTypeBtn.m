//
//  JHTuanTypeBtn.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/7/29.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHTuanTypeBtn.h"

@implementation JHTuanTypeBtn

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
        [self setImage: [UIImage imageNamed:@"Delivery_selected"] forState:UIControlStateSelected];
        [self setImage: [UIImage imageNamed:@"Delivery_Not-selected"] forState:UIControlStateNormal];
        self.frame = FRAME(0, 0, WIDTH/2, 44);
        self.imageEdgeInsets = UIEdgeInsetsMake(12, WIDTH/2 - 50, 12,30);
        self.textLabel = [[UILabel alloc]init];
        self.textLabel.font = [UIFont systemFontOfSize:15];
        self.textLabel.textColor = [UIColor colorWithWhite:0.1 alpha:1];
        self.textLabel.frame = FRAME(10, 12, 100, 20);
        [self addSubview:self.textLabel];
    }
    return self;
}
@end
