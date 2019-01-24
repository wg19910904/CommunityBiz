//
//  JHShopInDoorCellOne.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/6/22.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHShopInDoorCellOne.h"

@implementation JHShopInDoorCellOne

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    if (self.myTextField == nil) {
        self.myTextField = [[UITextField alloc]initWithFrame:FRAME(10, 10, WIDTH - 20, 40)];
        self.myTextField.placeholder = NSLocalizedString(@"  请填写许可证编号", NSStringFromClass([self class]));
        self.myTextField.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 3;
        self.clipsToBounds = YES;
        [self addSubview:self.myTextField];
    }
}

@end
