//
//  JHHomePageCellOne.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/18.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHHomePageCellOne.h"
#import "HZQButton.h"
@implementation JHHomePageCellOne
{
    UIView * view;//蓝色的背景
    UILabel * label_lineOne;//竖着的分割线
    UILabel * label_lineTwo;//分割线
    NSArray * image_array;//存放的第一行的图片
    NSArray * title_array;//存放的第一行的标题
    HZQTypeImageView * view_two;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
}
-(void)setModel:(JHHomePageModel *)model{
    title_array = @[ NSLocalizedString(@"扫一扫", NSStringFromClass([self class])),
                     NSLocalizedString(@"收款", NSStringFromClass([self class])),
//                    NSLocalizedString(@"功能开启", nil),
                     NSLocalizedString(@"设置", NSStringFromClass([self class])),
                    ];
    image_array = @[[UIImage imageNamed:@"btn_home_fast01"],
                    [UIImage imageNamed:@"btn_home_fast02"],
//                    [UIImage imageNamed:@"btn_home_fast03"],
                    [UIImage imageNamed:@"btn_home_fast04"]];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    _model = model;
    if (view == nil) {
        view = [[UIView alloc]init];
        view.backgroundColor = THEME_COLOR;
        view.frame = FRAME(0, 0, WIDTH, 60);
        [self addSubview:view];
    }
    if (self.textFiled == nil) {
        UIView * view_bj = [[UIView alloc]init];
        view_bj.frame = FRAME(10, 10, WIDTH-20, 40);
        view_bj.backgroundColor = [UIColor colorWithRed:101/255.0 green:108/255.0 blue:157/255.0 alpha:1];
        view_bj.layer.cornerRadius = 3;
        view_bj.clipsToBounds = YES;
        [view addSubview:view_bj];
        self.textFiled = [[UITextField alloc]init];
        self.textFiled.backgroundColor = [UIColor colorWithRed:101/ 255.0 green:108/255.0 blue:157/255.0 alpha:1];
        self.textFiled.text =  NSLocalizedString(@"请输入核销码", NSStringFromClass([self class]));
        self.textFiled.textColor = [UIColor whiteColor];
        self.textFiled.textAlignment = NSTextAlignmentCenter;
        self.textFiled.frame = FRAME(0, 0, WIDTH - 80, 40);
        self.textFiled.keyboardType = UIKeyboardTypeNumberPad;
        self.textFiled.tintColor = [UIColor whiteColor];
        [view_bj addSubview:self.textFiled];
        self.btn = [[UIButton alloc]init];
        self.btn.frame = FRAME(WIDTH - 80 , 0, 80, 40);
        self.btn.backgroundColor = [UIColor colorWithRed:82/255.0 green:91/255.0 blue:154/255.0 alpha:1];
        //[self.btn setImage:[UIImage imageNamed:@"home_arrow"] forState:UIControlStateNormal];
        [view_bj addSubview:self.btn];
        UIImageView * image = [[UIImageView alloc]init];
        image.frame = FRAME(20, 10,20, 20);
        image.image = [UIImage imageNamed:@"btn_home_go"];
        [self.btn addSubview:image];
    }
    if (view_two) {
        [view_two removeFromSuperview];
        view_two = nil;
    }
    if (!view_two) {
        view_two = [[HZQTypeImageView alloc]initwithSize:CGSizeMake(WIDTH/4, 75) withImageArray:image_array withTitleArray:title_array withNumArray:@[@"0",@"0",@"0",@"0"]];
        view_two.frame = FRAME(0, 50, WIDTH, 75);
        view_two.delegate = self;
        view_two.backgroundColor = THEME_COLOR;
        [self addSubview:view_two];
    }

}
-(void)clickToButton:(HZQButton *)sender{
    if (self.myBlock) {
        self.myBlock(sender.tag);
    }
}
@end
