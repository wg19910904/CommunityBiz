//
//  JHIdentityCellTwo.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/24.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHIdentityCellTwo.h"

@implementation JHIdentityCellTwo
{
    UILabel * label;
    NSArray * array;
    NSArray * detailArray;
    NSArray * imageArray;
}
-(void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    if (label == nil) {
        array = @[ NSLocalizedString(@"拍摄店主身份证正面照", NSStringFromClass([self class])),
                    NSLocalizedString(@"拍摄店面(含店主)照", NSStringFromClass([self class])),
                    NSLocalizedString(@"补充更多资源", NSStringFromClass([self class]))];
        detailArray = @[ NSLocalizedString(@"(请保证所拍照中文清晰)", NSStringFromClass([self class])),
                          NSLocalizedString(@"(请保证所拍照中文清晰)", NSStringFromClass([self class])),
                          NSLocalizedString(@"(选填)", NSStringFromClass([self class]))];
        imageArray = @[@"image_example4",@"image_example5",@"image_example6"];
        label = [[UILabel alloc]init];
        label.frame = FRAME(10, 10, WIDTH- 20, 20);
        [self addSubview:label];
        NSString * str =[NSString stringWithFormat:@"%@%@",array[indexPath.row - 2],detailArray[indexPath.row -2]];
        NSRange range = [str rangeOfString:detailArray[indexPath.row -2]];
        NSMutableAttributedString * attributed = [[NSMutableAttributedString alloc]initWithString:str];
        [attributed addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:250/255.0 green:167/255.0 blue:0/255.0 alpha:1],NSFontAttributeName:[UIFont systemFontOfSize:14]} range:range];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        label.attributedText = attributed;
        //创建中间的白色区域
        UIView * view = [[UIView alloc]init];
        view.frame = FRAME(0, 40, WIDTH, 150);
        view.backgroundColor = [UIColor whiteColor];
        view.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:1].CGColor;
        view.layer.borderWidth = 1;
        [self addSubview:view];
        //创建显示参考照片/你的照片
        for (int i = 0; i < 2; i ++) {
            UILabel * label_ = [[UILabel alloc]init];
            label_.frame = FRAME(WIDTH/2*i, 5, WIDTH/2, 20);
            label_.textColor = [UIColor colorWithWhite:0.7 alpha:1];
            label_.font = [UIFont systemFontOfSize:15];
            label_.textAlignment = NSTextAlignmentCenter;
            [view addSubview:label_];
            if (i == 0) {
                label_.text =  NSLocalizedString(@"参考照片", NSStringFromClass([self class]));
            }else{
                label_.text =  NSLocalizedString(@"你的照片", NSStringFromClass([self class]));
            }
        }
        //创建显示参考照片的
        self.imageV_example = [[UIImageView alloc]init];
        self.imageV_example.frame = FRAME(10, 30, WIDTH/2-15, 110);
        self.imageV_example.image = [UIImage imageNamed:imageArray[indexPath.row - 2]];
        [view addSubview:self.imageV_example];
        //显示选择的照片的
        self.imageV_add = [[UIImageView alloc]init];
        self.imageV_add.frame = FRAME(WIDTH/2 + 5, 30, WIDTH/2-15, 110);
        self.imageV_add.image = [UIImage imageNamed:@"certified_add-to"];
        [view addSubview:self.imageV_add];
    }

}
@end
