//
//  JHPreferentialSetCellSix.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/27.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHPreferentialSetCellSix.h"

@implementation JHPreferentialSetCellSix
-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:YES];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.btn_add == nil) {
        self.btn_add = [[UIButton alloc]init];
        self.btn_add.frame = FRAME((WIDTH - 90)/2, 5, 90, 30);
        [self.btn_add setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.btn_add setTitle: NSLocalizedString(@"添加", NSStringFromClass([self class])) forState:UIControlStateNormal];
        self.btn_add.titleLabel.font = [UIFont systemFontOfSize:15];
        [self.btn_add setBackgroundColor:[UIColor colorWithRed:250/255.0 green:175/255.0 blue:25/255.0 alpha:1]forState:UIControlStateNormal];
        self.btn_add.layer.cornerRadius = 16;
        self.btn_add.layer.masksToBounds = YES;
        [self addSubview:self.btn_add];
        UIView * label_line = [[UIView alloc]init];
        label_line.frame = FRAME(0, 39.5, WIDTH, 0.5);
        label_line.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        [self addSubview:label_line];
    }
}
@end
