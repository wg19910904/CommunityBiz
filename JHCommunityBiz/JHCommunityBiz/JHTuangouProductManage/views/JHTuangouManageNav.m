//
//  JHTuangouManageNav.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/31.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHTuangouManageNav.h"

@implementation JHTuangouManageNav
{
    UIButton *_btn0;
    UIButton *_btn1;
    UIButton *_btn2;
    UIButton *_btn3;
    
    //添加滑块
    UIView *indicateV;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //添加子控件
        [self makeUI];
    }
    
    return self;
}
- (void)makeUI
{
    _btn0 = [UIButton new];
    _btn1 = [UIButton new];
    _btn2 = [UIButton new];
    _btn3 = [UIButton new];
    
    [self addSubview:_btn0];
    [self addSubview:_btn1];
    [self addSubview:_btn2];
    [self addSubview:_btn3];
    CGFloat width = WIDTH / 4;
    self.btnArray = @[_btn0,_btn1,_btn2,_btn3];
    NSArray *titleArray = @[NSLocalizedString(@"未上架", nil),NSLocalizedString(@"已上架", nil),NSLocalizedString(@"已过期", nil),NSLocalizedString(@"销量", nil)];
    for (int i = 0; i < 4;i++) {
        UIButton *temB = _btnArray[i];
        temB.frame = FRAME(width * i , 0, width, 40);
        [temB setTitle:titleArray[i] forState:(UIControlStateNormal)];
        [temB setTitleColor:HEX(@"333333", 1.0f) forState:(UIControlStateNormal)];
        temB.titleLabel.font = FONT(14);
        if (i == 3) {
            [temB setImage:[UIImage imageNamed:@"Deliveryarrow_down_up"] forState:UIControlStateNormal];
            [temB setImage:[UIImage imageNamed:@"Deliveryarrow_up_down"] forState:UIControlStateSelected];
        }
        temB.tag = 100 + i;
        [temB addTarget:self action:@selector(clickBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:temB];
    }
    
    _btn0.selected = YES;
    indicateV = [[UIView alloc] initWithFrame:FRAME(0, self.bounds.size.height - 1, width, 2)];
    indicateV.backgroundColor = THEME_COLOR;
    [self addSubview:indicateV];
    
}
#pragma mark - 点击上方按钮
- (void)clickBtn:(UIButton *)sender
{
    if (sender.tag != 103) {
        indicateV.center = CGPointMake(WIDTH/8 + WIDTH/4 * (sender.tag-100), indicateV.center.y);
    }
    switch (sender.tag) {
        case 100:
        {
            //点击未上架按钮
            _btn0.selected = YES;
            _btn1.selected = NO;
            _btn2.selected = NO;
            self.refreshBlock(1);
        }
            break;
        case 101:
        {
            //点击已上架按钮
            _btn0.selected = NO;
            _btn1.selected = YES;
            _btn2.selected = NO;
            self.refreshBlock(2);
        }
            break;
        case 102:
        {
            //点击已过期按钮
            _btn0.selected = NO;
            _btn1.selected = NO;
            _btn2.selected = YES;
            self.refreshBlock(3);
        }
            break;
        default:
        {
            //点击销量按钮
            sender.selected = !sender.selected;
            if (sender.selected) {
             self.refreshBlock(4);
            }else{
              self.refreshBlock(5);
                
            }
            
        }
            break;
    }
}
@end
