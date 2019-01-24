//
//  JHGroupOrderDetailCellThree.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/30.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHGroupOrderDetailCellThree.h"
#import <UIImageView+WebCache.h>
@implementation JHGroupOrderDetailCellThree{
    UIImageView * imageV;
    UILabel * label_title;
    UILabel * label_num;
    UILabel * label_money;
}
-(void)setModel:(JHGroupDetailModel *)model{
    _model = model;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if (imageV == nil) {
        imageV = [[UIImageView alloc]init];
        imageV.frame = FRAME(10, 10, 50, 50);
        [self addSubview:imageV];
    }
    [imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEADDRESS,model.shop_logo]] placeholderImage:[UIImage imageNamed:@"evaluateDefault"]];
    if (label_title == nil) {
        label_title = [[UILabel alloc]init];
        label_title.frame = FRAME(70, 15, WIDTH - 70, 20);
        label_title.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        label_title.font = [UIFont systemFontOfSize:15];
        [self addSubview:label_title];
    }
    label_title.text = model.shop_title;
    if (label_num == nil) {
        label_num = [[UILabel alloc]init];
        label_num.frame = FRAME(70, 40, 100, 20);
        label_num.textColor = [UIColor colorWithRed:250/255.0 green:175/255.0 blue:25/255.0 alpha:1];
        label_num.font = [UIFont systemFontOfSize:15];
        [self addSubview:label_num];
    }
     label_num.text = [NSString stringWithFormat:@"%@%@/%@",@"X",model.tuan_number, NSLocalizedString(@"份", NSStringFromClass([self class]))];
    if (label_money == nil) {
        label_money = [[UILabel alloc]init];
        label_money.frame = FRAME(WIDTH - 110, 40, 100, 20);
        label_money.textColor = [UIColor colorWithRed:250/255.0 green:175/255.0 blue:25/255.0 alpha:1];
        label_money.font = [UIFont systemFontOfSize:15];
        label_money.textAlignment = NSTextAlignmentRight;
        [self addSubview:label_money];
    }
        label_money.text = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"¥", NSStringFromClass([self class])),model.total_price];

}
@end
