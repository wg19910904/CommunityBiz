//
//  JHPhotoCollectionCell.m
//  JHCommunityClient
//
//  Created by xixixi on 16/3/8.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHPhotoCollectionCellAdd.h"
#import <UIImageView+WebCache.h>
@implementation JHPhotoCollectionCellAdd
{
    //cell的宽 高
    CGFloat width;
    CGFloat height;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self =  [super initWithFrame:frame];
    if (self) {
        width = CGRectGetWidth(frame);
        height = CGRectGetHeight(frame);
        self.backgroundColor = [UIColor whiteColor];
        //添加子视图
        [self addSubviews];
    }
    return self;
}
#pragma mark - 添加子视图
- (void)addSubviews
{
    self.addBtn = [[UIButton alloc] initWithFrame:self.bounds];
    [self.addBtn setBackgroundImage:IMAGE(@"add290D") forState:(UIControlStateNormal)];
    [self.addBtn setBackgroundImage:IMAGE(@"add290C") forState:(UIControlStateSelected)];
    [self.addBtn setBackgroundImage:IMAGE(@"add290C") forState:(UIControlStateHighlighted)];
    [self addSubview:self.addBtn];
}

@end
