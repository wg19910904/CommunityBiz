//
//  JHTakeTheirCellOne.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/26.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHTakeTheirCellOne.h"

@implementation JHTakeTheirCellOne{
    UIImageView * imageView;//显示密码正确的图标的
    UILabel * label_text;//显示密码正确的内容
}
-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:YES];
    self.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if (imageView == nil) {
        imageView = [[UIImageView alloc]init];
        imageView.frame = FRAME((WIDTH - 170)/2 - 50, 25, 40, 40);
        imageView.image = [UIImage imageNamed:@"Logon_success"];
        [self addSubview:imageView];
        label_text = [[UILabel alloc]init];
        label_text.frame = FRAME((WIDTH - 170)/2, 35, 170, 20);
        label_text.textColor = [UIColor colorWithRed:102/255.0 green:204/255.0 blue:33/255.0 alpha:1];
        label_text.font = [UIFont systemFontOfSize:15];
        label_text.text =  NSLocalizedString(@"密码正确,是否核销此单?", NSStringFromClass([self class]));
        [self addSubview:label_text];
        
    }
}
@end
