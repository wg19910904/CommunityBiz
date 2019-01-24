//
//  CollectionViewCell_dingzuo.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/10/8.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "CollectionViewCell_dingzuo.h"

@implementation CollectionViewCell_dingzuo
-(void)setModel:(childrenModel *)model{
    _model = model;
    self.layer.cornerRadius = 4;
    self.layer.masksToBounds = YES;
    [self addSubview:self.label];
    if (model.isSelecter) {
        self.backgroundColor = THEME_COLOR;
        _label.textColor = [UIColor whiteColor];
    }else{
        self.backgroundColor = [UIColor whiteColor];
        _label.textColor = THEME_COLOR;
    }
    _label.text = [NSString stringWithFormat: NSLocalizedString(@"%@(%@人)", NSStringFromClass([self class])),model.title,model.number];
}
#pragma mark - 创建显示文本的label
-(UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc]init];
        _label.frame = FRAME(0, 10, (WIDTH - 60)/3, 20);
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = FONT(14);
    }
    return _label;
}
@end
