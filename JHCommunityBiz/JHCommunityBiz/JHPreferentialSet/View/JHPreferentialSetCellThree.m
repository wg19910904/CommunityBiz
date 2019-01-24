//
//  JHPreferentialSetCellThree.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/27.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHPreferentialSetCellThree.h"

@implementation JHPreferentialSetCellThree
-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:YES];
    self.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    if (self.btn_array == nil) {
        self.btn_array = [NSMutableArray array];
        for (int i = 0; i < 2; i ++) {
            UIButton * btn = [[UIButton alloc]init];
            btn.frame = FRAME(WIDTH/2*i, 0, WIDTH/2, 50);
            btn.tag = i;
            [self addSubview:btn];
            UIImageView * imageView = [[UIImageView alloc]init];
            imageView.frame = FRAME(WIDTH/4-30, 14, 22, 22);
            //imageView.tag = 100+i;
            [btn addSubview:imageView];
            UILabel * label = [[UILabel alloc]init];
            label.frame = FRAME(WIDTH/4+5, 15, 35, 20);
            label.textColor = [UIColor colorWithWhite:0.3 alpha:1];
            label.font = [UIFont systemFontOfSize:15];
            [btn addSubview:label];
            if (i == 0) {
                imageView.image = [UIImage imageNamed:@"Delivery_selected"];
                self.imageVOne = imageView;
                label.text =  NSLocalizedString(@"折扣", NSStringFromClass([self class]));
                UIView * label_line = [[UIView alloc]init];
                label_line.frame = FRAME(WIDTH/2-0.5, 5, 0.5, 40);
                label_line.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
                [btn addSubview:label_line];
            }else{
                imageView.image = [UIImage imageNamed:@"Delivery_Not-selected"];
                self.imageVTwo = imageView;
                label.text =  NSLocalizedString(@"满减", NSStringFromClass([self class]));
            }
            [self.btn_array addObject:btn];
        }
    }
}
@end
