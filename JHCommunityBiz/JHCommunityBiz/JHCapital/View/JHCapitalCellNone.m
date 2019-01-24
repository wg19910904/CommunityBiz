//
//  JHCapitalCellNone.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/19.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHCapitalCellNone.h"

@implementation JHCapitalCellNone
{
    UIImageView * imageV;//图片
    UILabel * label;//提示字符串
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if(imageV == nil){
        self.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        imageV = [[UIImageView alloc]init];
        imageV.frame = FRAME((WIDTH - 90)/2, 50, 90, 90);
        imageV.image = [UIImage  imageNamed:@"capital_no"];
        [self addSubview:imageV];
//        //提示字符串
//        label = [[UILabel alloc]init];
//        label.frame = FRAME(0, 130, WIDTH, 20);
//        label.textAlignment = NSTextAlignmentCenter;
//        label.text = NSLocalizedString(@"暂无资金明细", nil);
//        label.font = [UIFont systemFontOfSize:15];
//        label.textColor = [UIColor colorWithWhite:0.6 alpha:1];
//        [self addSubview:label];
    }

}

@end
