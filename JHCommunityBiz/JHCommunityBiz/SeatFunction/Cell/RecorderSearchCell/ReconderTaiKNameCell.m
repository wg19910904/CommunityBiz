//
//  ReconderTaiKNameCell.m
//  JHCommunityBiz
//
//  Created by ijianghu on 2017/11/11.
//  Copyright © 2017年 com.jianghu. All rights reserved.
//

#import "ReconderTaiKNameCell.h"
#import "ReconderSearchBottomView.h"
@interface ReconderTaiKNameCell()<UITextFieldDelegate>
@property(nonatomic,strong)UITextField *nameText;
@property(nonatomic,strong)ReconderSearchBottomView *bottomView;
@end
@implementation ReconderTaiKNameCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self creatSubUI];
        [self nameText];
    }
    return self;
}

-(void)creatSubUI{
    UILabel *label = [UILabel new];
    label.text =  NSLocalizedString(@"台卡名称", NSStringFromClass([self class]));
    label.textColor = HEX(@"333333", 1);
    label.font = FONT(14);
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 12;
        make.top.offset = 15;
        make.height.offset = 16;
    }];
}
-(UITextField *)nameText{
    if (!_nameText) {
        _nameText = [[UITextField alloc]init];
        _nameText.placeholder =  NSLocalizedString(@"请选择台卡", NSStringFromClass([self class]));
        _nameText.layer.cornerRadius = 4;
        _nameText.layer.masksToBounds = YES;
        _nameText.backgroundColor = [UIColor whiteColor];
        _nameText.keyboardType = UIKeyboardTypeNumberPad;
        _nameText.font = FONT(14);
        _nameText.textColor= HEX(@"666666", 1);
        _nameText.delegate = self;
        _nameText.layer.cornerRadius = 4;
        _nameText.layer.masksToBounds = YES;
        _nameText.layer.borderColor = HEX(@"e6e6e6", 1).CGColor;
        _nameText.layer.borderWidth = 1;
        _nameText.leftViewMode = UITextFieldViewModeAlways;
        _nameText.rightViewMode = UITextFieldViewModeAlways;
        UIView *leftView = [[UIView alloc]initWithFrame:FRAME(0, 0, 15, 40)];
        leftView.backgroundColor = [UIColor whiteColor];
        _nameText.leftView = leftView;
        UIButton *rightBtn = [[UIButton alloc]initWithFrame:FRAME(0, 0, 130, 40)];
        rightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -85);
        [rightBtn setImage:IMAGE(@"btn_arrow_r") forState:UIControlStateNormal];
        _nameText.rightView = rightBtn;
        [rightBtn addTarget:self action:@selector(clickChose) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_nameText];
        [_nameText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 12;
            make.right.offset = -12;
            make.top.offset = 41;
            make.height.offset = 40;
            make.bottom.offset = -15;
        }];
    }
    return _nameText;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return NO;
}
-(void)clickChose{
    [self.bottomView showView];
    _bottomView.seleterStr = _nameText.text;
    _bottomView.nameArr = _nameArr;
}
-(ReconderSearchBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[ReconderSearchBottomView alloc]init];
        __weak typeof (self)weakSelf = self;
        [_bottomView setSureBlock:^(NSString *name,NSInteger index) {
            weakSelf.nameText.text = name;
            if (weakSelf.clickBlock) {
                weakSelf.clickBlock(index);
            }
        }];
    }
    return _bottomView;
}
@end
