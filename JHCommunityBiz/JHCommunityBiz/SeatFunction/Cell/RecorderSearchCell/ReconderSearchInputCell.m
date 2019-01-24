//
//  ReconderSearchInputCell.m
//  JHCommunityBiz
//
//  Created by ijianghu on 2017/11/11.
//  Copyright © 2017年 com.jianghu. All rights reserved.
//

#import "ReconderSearchInputCell.h"
@interface ReconderSearchInputCell()
@end
@implementation ReconderSearchInputCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
        [self inputText];
    }
    return self;
}
-(UITextField *)inputText{
    if (!_inputText) {
        _inputText = [[UITextField alloc]init];
        _inputText.placeholder =  NSLocalizedString(@"请输入单号", NSStringFromClass([self class]));
        _inputText.layer.cornerRadius = 4;
        _inputText.layer.masksToBounds = YES;
        _inputText.backgroundColor = [UIColor whiteColor];
        _inputText.keyboardType = UIKeyboardTypeNumberPad;
        _inputText.font = FONT(14);
        _inputText.textColor= HEX(@"666666", 1);
        _inputText.leftViewMode = UITextFieldViewModeAlways;
        _inputText.rightViewMode = UITextFieldViewModeAlways;
        UIView *leftView = [[UIView alloc]initWithFrame:FRAME(0, 0, 20, 40)];
        leftView.backgroundColor = [UIColor whiteColor];
        _inputText.leftView = leftView;
        UIButton *rightBtn = [[UIButton alloc]initWithFrame:FRAME(0, 0, 80, 40)];
        [rightBtn setImage:IMAGE(@"btn_search") forState:UIControlStateNormal];
        rightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -25);
        _inputText.rightView = rightBtn;
        [rightBtn addTarget:self action:@selector(clickSearch) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_inputText];
        [_inputText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 10;
            make.right.offset = -10;
            make.top.bottom.offset = 0;
            make.height.offset = 40;
        }];
    }
    return _inputText;
}
-(void)clickSearch{
    if (self.searchBlock) {
        self.searchBlock();
    }
}
@end
