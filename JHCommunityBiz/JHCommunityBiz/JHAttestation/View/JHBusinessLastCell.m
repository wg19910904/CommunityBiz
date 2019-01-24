//
//  JHBusinessLastCell.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/23.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHBusinessLastCell.h"

@implementation JHBusinessLastCell
-(void)setArea:(NSString *)area{
    _area = area;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    if (self.label_area == nil) {
        UIView * view = [UIView new];
        view.frame = FRAME(0, 0, WIDTH, 120);
        view.backgroundColor = [UIColor whiteColor];
        [self addSubview:view];
        UILabel * label_one = [[UILabel alloc]init];
        label_one.frame = FRAME(10, 10, 70, 20);
        label_one.text =  NSLocalizedString(@"所在地区", NSStringFromClass([self class]));
        label_one.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        label_one.font = [UIFont systemFontOfSize:15];
        [view addSubview:label_one];
        //创建分割线
        UIView * view_line = [[UIView alloc]init];
        view_line.frame = FRAME(10, 39.5, WIDTH - 10, 0.5);
        view_line.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        [view addSubview:view_line];
        //显示地址的
        self.label_area = [[UILabel alloc]init];
        self.label_area.frame = FRAME(90, 10, WIDTH - 100, 20);
        self.label_area.textColor = THEME_COLOR;
        self.label_area.text = area;
        self.label_area.textAlignment = NSTextAlignmentRight;
        self.label_area.font = [UIFont systemFontOfSize:13];
        [view  addSubview:self.label_area];
        //创建显示详细地址的label
        UILabel * label_two = [[UILabel alloc]init];
        label_two.frame = FRAME(10, 50, 70, 20);
        label_two.text = NSLocalizedString(@"详细地址", NSStringFromClass([self class]));
        label_two.font = [UIFont systemFontOfSize:15];
        label_two.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        [view addSubview:label_two];
        //创建textView
        self.myTextView = [[UITextView alloc]init];
        self.myTextView.frame = FRAME(90, 45, WIDTH - 100, 60);
        self.myTextView.text = NSLocalizedString(@"请填写具体的楼层门牌号", NSStringFromClass([self class]));
        self.myTextView.font = [UIFont systemFontOfSize:14];
        self.myTextView.textColor = [UIColor colorWithWhite:0.7 alpha:1];
        [view addSubview:self.myTextView];
        //创建点击确定的按钮
        self.btn =  [[UIButton alloc]init];
        self.btn.frame = FRAME(10, 150, WIDTH - 20, 45);
        [self.btn setTitle: NSLocalizedString(@"确定", NSStringFromClass([self class])) forState:UIControlStateNormal];
        self.btn.layer.cornerRadius = 3;
        self.btn.layer.masksToBounds = YES;
        [self.btn setBackgroundColor:[UIColor colorWithRed:250/255.0 green:175/255.0 blue:25/255.0 alpha:1] forState:UIControlStateNormal];
        [self.btn setBackgroundColor:[UIColor colorWithRed:250/255.0 green:175/255.0 blue:25/255.0 alpha:0.5] forState:UIControlStateHighlighted];
        [self addSubview:self.btn];

    }
}
@end
