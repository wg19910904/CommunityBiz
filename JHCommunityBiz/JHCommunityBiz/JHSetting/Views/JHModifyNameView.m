//
//  JHModifyNameView.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/18.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHModifyNameView.h"
@implementation JHModifyNameView
{
    UIView *centerView;
    UITextField *namefield;
}

- (instancetype)init
{
    self = [super init];
    if (!self) {
        self = [super init];
    }
    self.frame = FRAME(0, 0, WIDTH, HEIGHT);
    self.backgroundColor = HEX(@"000000", 0.4);
    [self addTarget:self action:@selector(touchBack) forControlEvents:(UIControlEventTouchUpInside)];
    //添加子控件
    [self addSubviews];
    return self;
}
#pragma mark - 添加子控件
- (void)addSubviews
{
    centerView = [UIView new];
    centerView.center = self.center;
    centerView.layer.cornerRadius = 3;
    centerView.layer.masksToBounds = YES;
    centerView.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
    //添加titleLabel,nameLabel,cancelBtn,sureBtn
    UILabel *titleLabel = [UILabel new];
    namefield = [UITextField new];
    UIButton *cancelBtn = [UIButton new];
    UIButton *sureBtn = [UIButton new];
    [self addSubview:centerView];
    [centerView addSubview:titleLabel];
    [centerView addSubview:namefield];
    [centerView addSubview:cancelBtn];
    [centerView addSubview:sureBtn];
    //布局
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_equalTo(WIDTH - 40);
        make.height.mas_equalTo(150);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(centerView);
        make.left.equalTo(centerView);
        make.right.equalTo(centerView);
        make.bottom.equalTo(centerView).with.offset(-120);
    }];
    titleLabel.text = NSLocalizedString(@"设置用户名", nil);
    titleLabel.font = FONT(15);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = THEME_COLOR;
    
    [namefield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).with.offset(15);
        make.left.equalTo(centerView).with.offset(10);
        make.right.equalTo(centerView).with.offset(-10);
        make.bottom.equalTo(centerView).with.offset(-60);
    }];
    namefield.placeholder = NSLocalizedString(@"请输入用户名", nil);
    namefield.font = FONT(14);
    namefield.backgroundColor = HEX(@"ebebeb", 1.0);
    namefield.textColor = THEME_COLOR;
    namefield.delegate = self;
    UIView *leftView = [[UIView alloc] initWithFrame:FRAME(0, 0, 10, 35)];
    namefield.leftViewMode = UITextFieldViewModeAlways;
    namefield.leftView = leftView;
    
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(centerView).with.offset(15);
        make.top.equalTo(centerView).with.offset(100);
        make.bottom.equalTo(centerView).with.offset(-10);
        make.right.equalTo(centerView.mas_left).with.offset(((WIDTH - 40) - 35)/ 2 + 15);
    }];
    cancelBtn.layer.cornerRadius = 3;
    cancelBtn.layer.masksToBounds = YES;
    cancelBtn.layer.borderColor = HEX(@"faaf19", 1.0).CGColor;
    cancelBtn.layer.borderWidth = 0.7;
    [cancelBtn setTitle:NSLocalizedString(@"取消", nil) forState:(UIControlStateNormal)];
    [cancelBtn setTitleColor:HEX(@"faaf19", 1.0) forState:(UIControlStateNormal)];
    cancelBtn.titleLabel.font = FONT(15);
    [cancelBtn addTarget:self action:@selector(touchBack) forControlEvents:(UIControlEventTouchUpInside)];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(cancelBtn);
        make.width.height.equalTo(cancelBtn);
        make.left.equalTo(cancelBtn.mas_right).with.offset(10);
    }];
    [sureBtn setBackgroundColor:THEME_COLOR forState:(UIControlStateNormal)];
    sureBtn.layer.cornerRadius = 3;
    sureBtn.layer.masksToBounds = YES;
    [sureBtn setTitle:NSLocalizedString(@"确定", nil) forState:(UIControlStateNormal)];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    sureBtn.titleLabel.font = FONT(15);
    [sureBtn addTarget:self action:@selector(clickSureBtn) forControlEvents:(UIControlEventTouchUpInside)];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [namefield resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3 animations:^{
        centerView.center = CGPointMake(WIDTH/2, HEIGHT/2- 100 );
    }];
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3 animations:^{
        centerView.center = CGPointMake(WIDTH/2, HEIGHT/2);
    }];
    return YES;
}
- (void)touchBack
{
    [self removeFromSuperview];
}
#pragma mark - 点击确定按钮
- (void)clickSureBtn
{
    NSString *contact = namefield.text;
    if (contact.length == 0 || !contact) {
        [JHShowAlert showAlertWithTitle:NSLocalizedString(@"提示", nil)
                            withMessage:NSLocalizedString(@"请输入修改后的用户名", nil)
                         withBtn_cancel:NSLocalizedString(@"知道了", nil)
                           withBtn_sure:nil
                        withCancelBlock:nil
                          withSureBlock:nil];
        return;
    }
    SHOW_HUD_IN_SELF
    [HttpTool postWithAPI:@"biz/shop/shop/updatecontact"
               withParams:@{@"contact":namefield.text}
                  success:^(id json) {
                      HIDE_HUD_IN_SELF
                      if ([json[@"error"] isEqualToString:@"0"]) {
                          [[NSNotificationCenter defaultCenter] postNotificationName:@"KGetNewBizInfoNoti"
                                                                              object:nil];
                          if (_getNameBlock) {
                              _getNameBlock(namefield.text);
                          }
                          [JHShareModel shareModel].contact = namefield.text;
                          [JHShowAlert showAlertWithTitle:NSLocalizedString(@"提示", nil)
                                              withMessage:NSLocalizedString(@"修改成功", nil)
                                           withBtn_cancel:NSLocalizedString(@"知道了", nil)
                                             withBtn_sure:nil
                                          withCancelBlock:^{
                                              [_navVC popViewControllerAnimated:YES];
                                          }
                                            withSureBlock:nil];
                      }else{
                      
                          [JHShowAlert showAlertWithMsg:json[@"meassage"]];
                      }
                      
                  } failure:^(NSError *error) {
                      HIDE_HUD_IN_SELF
                      [JHShowAlert showAlertWithMsg:NSLocalizedString(@"服务器或网络异常", nil)];
                      
                  }];
    [self touchBack];
    _getNameBlock(namefield.text);
}
@end
