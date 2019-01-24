//
//  JHPreferentialSetCellFive.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/27.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHPreferentialSetCellFive.h"

@implementation JHPreferentialSetCellFive{
    UIView * label_line;
}
-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:YES];
    
}
-(void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if (label_line == nil) {
        label_line = [[UIView alloc]init];
        label_line.frame = FRAME(0, 39.5, WIDTH, 0.5);
        label_line.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        [self addSubview:label_line];
    }
    if (self.btn_remove == nil) {
        self.btn_remove = [[UIButton alloc]init];
        self.btn_remove.frame = FRAME(WIDTH - 40, 0, 40, 40);
        self.btn_remove.layer.borderColor = [UIColor colorWithWhite:0.95 alpha:1].CGColor;
        self.btn_remove.layer.borderWidth = 1;
        [self.btn_remove setImage:[UIImage imageNamed:@"Delivery_X"] forState:UIControlStateNormal];
        [self addSubview:self.btn_remove];
    }
    if (self.textField_one) {
        [self.textField_one removeFromSuperview];
        self.textField_one = nil;
    }
    if (self.textField_one == nil) {
        self.textField_one = [[UITextField alloc]init];
        self.textField_one.frame = FRAME(0, 5, (WIDTH - 40)/2 - 18, 30);
        self.textField_one.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        self.textField_one.keyboardType = UIKeyboardTypeNumberPad;
        self.textField_one.leftViewMode = UITextFieldViewModeAlways;
        self.textField_one.textColor = [UIColor orangeColor];
        self.textField_one.tag = indexPath.row + 100;
        self.textField_one.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.textField_one];
        UILabel * label = [[UILabel alloc]init];
        label.frame = FRAME(0, 0, 40, 30);
        label.font = [UIFont systemFontOfSize:15];
        label.backgroundColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        label.text =  NSLocalizedString(@"每满", NSStringFromClass([self class]));
        self.textField_one.leftView = label;
    }
    if (self.textField_two) {
        [self.textField_two removeFromSuperview];
        self.textField_two = nil;
    }
    if (self.textField_two == nil) {
        self.textField_two = [[UITextField alloc]init];
        self.textField_two.frame = FRAME((WIDTH - 40)/2 - 18, 5, (WIDTH - 40)/2 + 18, 30);
        self.textField_two.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        self.textField_two.keyboardType = UIKeyboardTypeNumberPad;
        self.textField_two.leftViewMode = UITextFieldViewModeAlways;
        self.textField_two.rightViewMode = UITextFieldViewModeAlways;
        self.textField_two.textColor = [UIColor orangeColor];
        self.textField_two.textAlignment = NSTextAlignmentCenter;
        self.textField_two.tag = indexPath.row + 500;
        [self addSubview:self.textField_two];
        UILabel * label = [[UILabel alloc]init];
        label.frame = FRAME(0, 0, 40, 30);
        label.font = [UIFont systemFontOfSize:15];
        label.backgroundColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        label.text =  NSLocalizedString(@"减", NSStringFromClass([self class]));
        self.textField_two.leftView = label;
        UILabel * labe = [[UILabel alloc]init];
        labe.frame = FRAME(0, 0, 40, 30);
        labe.font = [UIFont systemFontOfSize:15];
        labe.backgroundColor = [UIColor whiteColor];
        labe.textAlignment = NSTextAlignmentCenter;
        labe.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        labe.text =  NSLocalizedString(@"元", NSStringFromClass([self class]));
        self.textField_two.rightView = labe;
    }

}
@end
