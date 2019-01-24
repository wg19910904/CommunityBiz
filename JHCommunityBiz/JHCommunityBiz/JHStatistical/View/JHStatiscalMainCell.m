//
//  JHStatiscalMainCell.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/12.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHStatiscalMainCell.h"

@implementation JHStatiscalMainCell
{
    UIView * line;//中间的竖线
}
- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(JHstatiscalModel *)model{
    _model = model;
    if (line == nil) {
        self.labelArray = [NSMutableArray array];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //创建显示在中间的竖线
        line = [[UIView alloc]init];
        line.frame = FRAME(WIDTH/2-0.5, 10, 1, 100);
        line.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        [self addSubview:line];
        //创建四个标题的label
        for (int i = 0; i < 4; i++) {
            UILabel * label_title = [[UILabel alloc]init];
            label_title.frame = FRAME((i%2)*(WIDTH/2)+0.5, 15+(i/2)*55, WIDTH/2-1, 15);
            label_title.text = self.titleArray[i];
            label_title.textAlignment = NSTextAlignmentCenter;
            label_title.textColor = [UIColor colorWithWhite:0.4 alpha:1];
            label_title.font = [UIFont systemFontOfSize:15];
            [self addSubview:label_title];
        }
        //创建四个数值的label
        for (int i = 0; i < 4; i++) {
            UILabel * label_data = [[UILabel alloc]init];
            label_data.frame = FRAME((i%2)*(WIDTH/2)+0.5, 40+(i/2)*55, WIDTH/2-1, 15);
            label_data.textAlignment = NSTextAlignmentCenter;
            label_data.textColor = [UIColor colorWithRed:248/255.0 green:168/255.0 blue:37/255.0 alpha:1];
            label_data.font = [UIFont systemFontOfSize:18];
            [self addSubview:label_data];
            [self.labelArray addObject:label_data];
        }
    }
    for (int i = 0; i < self.labelArray.count ;i++) {
        UILabel * label = self.labelArray[i];
        label.text = self.dataArray[i];
    }
}
@end
