//
//  JHOpenShopCellTwo.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/17.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHOpenShopCellTwo.h"

@implementation JHOpenShopCellTwo
{
    NSMutableArray * titleArray;//四个标题

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
        [super setSelected:selected animated:animated];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
        if (titleArray == nil) {
            titleArray = [NSMutableArray arrayWithObjects:
                           NSLocalizedString(@"店铺名称", NSStringFromClass([self class])),
                           NSLocalizedString(@"服务电话", NSStringFromClass([self class])),
                           NSLocalizedString(@"店铺类型", NSStringFromClass([self class])),
                           NSLocalizedString(@"店铺地址", NSStringFromClass([self class])),
                           NSLocalizedString(@"请输入店铺名称", NSStringFromClass([self class])),
                           NSLocalizedString(@"请输入电话号码", NSStringFromClass([self class])),@"",@"", nil];
            self.textFieldArray = [NSMutableArray array];
            for (int i = 0; i < 4; i ++) {
                UIView * view = [[UIView alloc]init];
                view.frame = FRAME(10, 10+40*i, WIDTH - 20, 40);
                view.backgroundColor = [UIColor whiteColor];
                view.layer.borderColor = [UIColor colorWithWhite:0.95 alpha:1].CGColor;
                view.layer.borderWidth = 0.5;
                [self addSubview:view];
                UILabel * label = [[UILabel alloc]init];
                label.frame = FRAME(10, 10, 70, 20);
                label.text = titleArray[i];
                label.textColor = [UIColor colorWithWhite:0.4 alpha:1];
                label.font = [UIFont systemFontOfSize:15];
                [view addSubview:label];
                UILabel * label_line = [[UILabel alloc]init];
                label_line.frame = FRAME(81, 2, 1, 36);
                label_line.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
                [view addSubview:label_line];
                UITextField * textField = [[UITextField alloc]init];
                if (i == 2 ) {
                    textField.frame = FRAME(85, 5, WIDTH - 105 - 85, 30);
                    textField.enabled = NO;
                    self.btn_type = [[UIButton alloc]init];
                    self.btn_type.frame = FRAME(WIDTH - 20 - 30, 5, 25, 30);
                    [self.btn_type setBackgroundImage:[UIImage imageNamed:@"login_select"] forState:UIControlStateNormal];
                    [view addSubview:self.btn_type];
                }else if (i == 3){
                    textField.frame = FRAME(85, 5, WIDTH - 105 - 85, 30);
                    textField.enabled = NO;
                    self.btn_address = [[UIButton alloc]init];
                    self.btn_address.frame = FRAME(WIDTH - 20 - 35, 5, 30, 30);
                    [self.btn_address setBackgroundImage:[UIImage imageNamed:@"login_position"] forState:UIControlStateNormal];
                    [view addSubview:self.btn_address];
                }
                else{
                    textField.frame = FRAME(85, 5, WIDTH - 105, 30);
                    textField.enabled = YES;
                }
                if (i == 1) {
                    textField.keyboardType = UIKeyboardTypeNumberPad;
                }
                textField.font = [UIFont systemFontOfSize:15];
                textField.placeholder = titleArray[i+4];
                textField.textColor = [UIColor colorWithWhite:0.4 alpha:1];
                [view addSubview:textField];
                [self.textFieldArray addObject:textField];
            }
        }
    }
@end
