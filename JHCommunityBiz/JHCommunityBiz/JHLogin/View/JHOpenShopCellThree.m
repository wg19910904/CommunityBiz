//
//  JHOpenShopCellThree.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/17.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHOpenShopCellThree.h"

@implementation JHOpenShopCellThree
{
    UIView * bjView;//白色的背景view
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    if(bjView == nil){
        bjView = [[UIView alloc]init];
        bjView.frame = FRAME(10, 10, WIDTH- 20, 100);
        [bjView setBackgroundColor:[UIColor whiteColor]];
        bjView.layer.borderWidth = 0.5;
        bjView.layer.borderColor = [UIColor colorWithWhite:0.92 alpha:1].CGColor;
        bjView.layer.cornerRadius = 3;
        bjView.layer.masksToBounds = YES;
        [self addSubview:bjView];
        self.textView = [[UITextView alloc]init];
        self.textView.frame = FRAME(10, 5, WIDTH - 40, 70);
        self.textView.text =  NSLocalizedString(@"店铺简介", NSStringFromClass([self class]));
        self.textView.textColor = [UIColor colorWithWhite:0.6 alpha:1];
        self.textView.font = [UIFont systemFontOfSize:14];
        [bjView addSubview:self.textView];
        self.label = [[UILabel alloc]init];
        self.label.frame = FRAME(WIDTH - 130, 70, 100, 20);
        self.label.textColor = [UIColor colorWithWhite:0.7 alpha:1];
        self.label.textAlignment = NSTextAlignmentRight;
        self.label.text =  NSLocalizedString(@"200字以内", NSStringFromClass([self class]));
        self.label.font = [UIFont systemFontOfSize:14];
        //[bjView addSubview:self.label];
    }
}

@end
