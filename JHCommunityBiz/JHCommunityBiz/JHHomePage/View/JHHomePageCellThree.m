//
//  JHHomePageCellThree.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/18.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHHomePageCellThree.h"

@implementation JHHomePageCellThree
{
    UIImageView * imageView;//背景图
    UILabel * label;//显示文本的label
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle =  UITableViewCellSelectionStyleNone;
    if (imageView == nil) {
        imageView = [[UIImageView alloc]init];
        imageView.frame = FRAME(0, 0, WIDTH, 90);
        //imageView.backgroundColor = [UIColor colorWithRed:115/255.0 green:107/255.0 blue:104/255.0 alpha:1];
        imageView.image = [UIImage imageNamed:@"attentation"];
        [self addSubview:imageView];
        label = [[UILabel alloc]init];
        label.frame = FRAME(0, 10, WIDTH, 20);
        label.text =  NSLocalizedString(@"完成实名认证,保障店铺权益", NSStringFromClass([self class]));
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor colorWithRed:225/255.0 green:158/255.0 blue:29/255.0 alpha:1];
        [self addSubview:label];
        self.btn_attestation = [[UIButton alloc]init];
        self.btn_attestation.frame = FRAME((WIDTH - 160)/2, 45, 160, 35);
        [self.btn_attestation setTitle: NSLocalizedString(@"立即认证", NSStringFromClass([self class])) forState:UIControlStateNormal];
        self.btn_attestation.layer.cornerRadius = 3;
        self.btn_attestation.layer.masksToBounds = YES;
        [self.btn_attestation setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.btn_attestation.titleLabel.font = [UIFont systemFontOfSize:15];
        self.btn_attestation.backgroundColor = [UIColor colorWithRed:250/255.0 green:175/255.0 blue:25/255.0 alpha:1];
         [self addSubview:self.btn_attestation];
    }
}
- (void)setType:(NSString *)type{
     [self.btn_attestation setTitle:type forState:UIControlStateNormal];
}
@end
