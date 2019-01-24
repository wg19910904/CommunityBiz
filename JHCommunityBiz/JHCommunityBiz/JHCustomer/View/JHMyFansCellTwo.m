//
//  JHMyFansCellTwo.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/17.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHMyFansCellTwo.h"
#import <UIImageView+WebCache.h>
@implementation JHMyFansCellTwo
{
    UIImageView * imageV;//头像
    UIView * label_line;//分割线
    UIImageView * imageView;//箭头
    UILabel * label_name;//姓名
    UILabel * label_phone;//电话
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)setModel:(JHMyFansModel *)model{
    _model = model;
    //self.selectionStyle = UITableViewCellSeparatorStyleNone;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (imageV == nil) {
        imageV = [[UIImageView alloc]init];
        imageV.frame = FRAME(10, 10, 40, 40);
        imageV.layer.cornerRadius = 20;
        imageV.clipsToBounds =  YES;
        [self addSubview:imageV];
        label_line = [[UIView alloc]init];
        label_line.frame = FRAME(0, 59.5, WIDTH, 0.5);
        label_line.backgroundColor = [UIColor colorWithWhite:0.90 alpha:1];
        [self addSubview:label_line];
//        imageView = [[UIImageView alloc]init];
//        imageView.frame = FRAME(WIDTH - 30, 15, 20, 30);
//        imageView.backgroundColor = [UIColor redColor];
//        [self addSubview:imageView];
        label_name = [[UILabel alloc]init];
        label_name.frame = FRAME(60, 10, 100, 20);
        label_name.textColor = THEME_COLOR;
        label_name.font = [UIFont systemFontOfSize:15];
        [self addSubview:label_name];
        label_phone = [[UILabel alloc]init];
        label_phone.frame = FRAME(60, 35, 150, 20);
        label_phone.textColor = THEME_COLOR;
        label_phone.font = [UIFont systemFontOfSize:15];
        [self addSubview:label_phone];
    }
    [imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEADDRESS,model.face]] placeholderImage:[UIImage imageNamed:@"client_Photos"]];
    label_name.text = model.nickname;
    label_phone.text = model.mobile;
    
}

@end
