//
//  JHSignageCell.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/23.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHSignageCell.h"

@implementation JHSignageCell
{
    UILabel * label;
}
-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:YES];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    if (label == nil) {
        label = [[UILabel alloc]init];
        label.frame = FRAME(10, 10, WIDTH- 20, 20);
        [self addSubview:label];
        NSString * str = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"拍摄营业执照", NSStringFromClass([self class])), NSLocalizedString(@"(请保证所拍照中文清晰)", NSStringFromClass([self class]))];
        NSRange range = [str rangeOfString: NSLocalizedString(@"(请保证所拍照中文清晰)", NSStringFromClass([self class]))];
        NSMutableAttributedString * attributed = [[NSMutableAttributedString alloc]initWithString:str];
        [attributed addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:249/255.0 green:80/255.0 blue:53/255.0 alpha:1]} range:range];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        label.attributedText = attributed;
        //创建中间的白色区域
        UIView * view = [[UIView alloc]init];
        view.frame = FRAME(0, 50, WIDTH, 150);
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
        self.imageV_example.image = [UIImage imageNamed:@"image_example"];
        [view addSubview:self.imageV_example];
        //显示选择的照片的
        self.imageV_add = [[UIImageView alloc]init];
        self.imageV_add.frame = FRAME(WIDTH/2 + 5, 30, WIDTH/2-15, 110);
        self.imageV_add.image = [UIImage imageNamed:@"certified_add-to"];
        [view addSubview:self.imageV_add];
    }
    if (self.btn_completion == nil) {
        self.btn_completion = [[UIButton alloc]init];
        self.btn_completion.frame = FRAME(10, 230, WIDTH - 20, 45);
        [self.btn_completion setTitle: NSLocalizedString(@"完成", NSStringFromClass([self class])) forState:UIControlStateNormal];
        self.btn_completion.layer.cornerRadius = 3;
        self.btn_completion.layer.masksToBounds = YES;
        [self.btn_completion setBackgroundColor:[UIColor colorWithRed:250/255.0 green:175/255.0 blue:25/255.0 alpha:1] forState:UIControlStateNormal];
        [self.btn_completion setBackgroundColor:[UIColor colorWithRed:250/255.0 green:175/255.0 blue:25/255.0 alpha:0.5] forState:UIControlStateHighlighted];
        [self addSubview:self.btn_completion];
    }
}

@end
