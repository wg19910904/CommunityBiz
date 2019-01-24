//
//  CollectionHeaderView.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/10/8.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "CollectionHeaderView.h"

@implementation CollectionHeaderView
-(void)setModel:(ChoseNumemberModel *)model{
    _model = model;
    [_label removeFromSuperview];
    _label = nil;
    [_btn removeFromSuperview];
    _btn = nil;
    [_imageV removeFromSuperview];
    _imageV = nil;
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.label];
    [self addSubview:self.btn];
    [self addSubview:self.imageV];
     self.label.text = model.title;
    if (model.isSelecter) {
        self.imageV.image = [UIImage imageNamed:@"jiantou"];
    }else{
        self.imageV.image = [UIImage imageNamed:@"home_go"];
    }
}
#pragma mark - 创建显示文本的label
-(UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc]init];
        _label.frame = FRAME(10, 10, WIDTH/2, 20);
        _label.textColor = THEME_COLOR;
        _label.textAlignment = NSTextAlignmentLeft;
        _label.font = FONT(16);
    }
    return _label;
}
-(UIButton *)btn{
    if (!_btn) {
        _btn = [[UIButton alloc]init];
        _btn.frame = FRAME(0, 0, WIDTH, 40);
        _btn.backgroundColor = [UIColor clearColor];
    }
    return _btn;
}
-(UIImageView *)imageV{
    if (!_imageV) {
        _imageV = [[UIImageView alloc]init];
        _imageV.frame = FRAME(WIDTH - 25, 12.5, 15, 15);
    }
    return _imageV;
}
@end