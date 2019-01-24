//
//  JHIdentityCellOne.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/24.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHIdentityCellOne.h"

@implementation JHIdentityCellOne{
    
    UILabel * label;
}
-(void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if (label == nil) {
        //创建显示单元格标题的
        label = [[UILabel alloc]init];
        label.frame = FRAME(10, 10, 80, 20);
        label.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        label.font = [UIFont systemFontOfSize:15];
        label.text = self.array[indexPath.row];
        [self addSubview:label];
        //创建单元格的输入框的
        self.mytextField = [[UITextField alloc]init];
        self.mytextField.frame = FRAME(100, 0, WIDTH - 90, 40);
        self.mytextField.placeholder = self.placeArray[indexPath.row];
        self.mytextField.font = [UIFont systemFontOfSize:13];
        [self addSubview:self.mytextField];
        //创建分割线
        UIView * label_line = [[UIView alloc]init];
        label_line.frame = FRAME(0, 39.5, WIDTH, 0.5);
        label_line.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        [self addSubview:label_line];
    }
    
}
@end
