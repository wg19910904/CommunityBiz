//
//  JHCustomerCellNone.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/17.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHCustomerCellNone.h"

@implementation JHCustomerCellNone
{
    UIImageView * imageV;//图片
    UILabel * label;//提示字符串
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    }
-(void)setStr:(NSString *)str{
    _str = str;
    if(imageV == nil){
        self.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        imageV = [[UIImageView alloc]init];
        imageV.frame = FRAME((WIDTH - 70)/2, 50, 70, 60);
        imageV.image = [UIImage  imageNamed:@"evaluateCry"];
        [self addSubview:imageV];
        //提示字符串
        label = [[UILabel alloc]init];
        label.frame = FRAME(0, 130, WIDTH, 20);
        label.textAlignment = NSTextAlignmentCenter;
        label.text = str;
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor colorWithWhite:0.6 alpha:1];
        [self addSubview:label];
    }
    

}
@end
