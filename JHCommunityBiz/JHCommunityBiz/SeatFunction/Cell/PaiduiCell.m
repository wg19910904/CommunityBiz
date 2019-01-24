//
//  PaiduiCell.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/9/30.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "PaiduiCell.h"

@implementation PaiduiCell
{
    CALayer * layer1;
    UIButton *_phoneBtn;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self creatSubView];
    }
    return self;
}
-(void)creatSubView{
    //添加状态的label
    [self addSubview:self.status_label];
    //添加单号的label
    [self addSubview:self.order_label];
    //画线
    CALayer * layer = [[CALayer alloc]init];
    layer.frame = FRAME(0, 39.5, WIDTH, 0.5);
    layer.backgroundColor = LINE_COLOR.CGColor;
    [self.layer addSublayer:layer];
    //添加显示姓名和电话的
    [self addSubview:self.name_phone_label];
    [self addSubview:self.phoneBtn];
    //添加就餐人数的
    [self addSubview:self.people_num];
    //画线
    layer1 = [[CALayer alloc]init];
    layer1.frame = FRAME(0, 105, WIDTH, 0.5);
    layer1.backgroundColor = LINE_COLOR.CGColor;
    [self.layer addSublayer:layer1];
    //显示桌号
    [self addSubview:self.label_zhuo];
}
//添加状态的label
-(UILabel *)status_label{
    if (!_status_label) {
        _status_label = [[UILabel alloc]init];
        _status_label.frame = FRAME(10, 10, WIDTH/2, 20);
        _status_label.textColor = HEX(@"333333", 1.0);
        _status_label.font = FONT(14);
        
    }
    return _status_label;
}
//添加单号的label
-(UILabel *)order_label{
    if (!_order_label) {
        _order_label = [[UILabel alloc]init];
        _order_label.frame = FRAME(WIDTH/2, 10, WIDTH/2-10, 20);
        _order_label.textColor = HEX(@"333333", 1.0);
        _order_label.textAlignment = NSTextAlignmentRight;
        _order_label.font = FONT(14);
        
    }
    return _order_label;
 
}
//添加显示姓名和电话的
-(UILabel *)name_phone_label{
    if (!_name_phone_label) {
        _name_phone_label = [[UILabel alloc]init];
        _name_phone_label.frame = FRAME(10, 53, WIDTH-10, 20);
        _name_phone_label.textColor = HEX(@"666666", 1.0);
        _name_phone_label.textAlignment = NSTextAlignmentLeft;
        _name_phone_label.font = FONT(12);
    }
    return _name_phone_label;
}
- (UIButton *)phoneBtn{
    if (_phoneBtn == nil) {
        _phoneBtn = [[UIButton alloc] initWithFrame:FRAME(WIDTH-150, 41, 40, 40)];
        [_phoneBtn setImage:IMAGE(@"Delivery_phone") forState:(UIControlStateNormal)];
        _phoneBtn.imageEdgeInsets = UIEdgeInsetsMake(11.5, 11.5, 11.5, 11.5);
        [_phoneBtn addTarget:self action:@selector(clickPhoneBtn) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _phoneBtn;
}
//显示就餐人数的
-(UILabel *)people_num{
    if (!_people_num) {
        _people_num = [[UILabel alloc]init];
        _people_num.frame = FRAME(10, 73, WIDTH-10, 20);
        _people_num.textColor = HEX(@"666666", 1.0);
        _people_num.textAlignment = NSTextAlignmentLeft;
        _people_num.font = FONT(12);
    }
    return _people_num;
}
//显示桌号
-(UILabel *)label_zhuo{
    if (!_label_zhuo) {
        _label_zhuo = [[UILabel alloc]init];
        _label_zhuo.frame = FRAME(WIDTH - 150, 55, 140, 35);
        _label_zhuo.textColor = HEX(@"faaf19", 1.0);
        _label_zhuo.textAlignment = NSTextAlignmentRight;
        _label_zhuo.font = FONT(20);
    }
    return _label_zhuo;
}
//确认就餐的按钮
-(UIButton *)btn{
    if (!_btn) {
        _btn = [[UIButton alloc]init];
        _btn.frame = FRAME(0, 105.5, WIDTH, 39.5);
        [_btn setTitle: NSLocalizedString(@"确认就餐", NSStringFromClass([self class])) forState:UIControlStateNormal];
        [_btn addTarget:self action:@selector(clickToBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_btn setTitleColor:THEME_COLOR forState:UIControlStateNormal];
        _btn.titleLabel.font = FONT(14);
        _btn.tag = self.indexPath.section;
    }
    return _btn;
}
//接单的按钮
-(UIButton *)btn_jie{
    if (!_btn_jie) {
        _btn_jie = [[UIButton alloc]init];
        _btn_jie.frame = FRAME(WIDTH/2, 105.5, WIDTH/2, 39.5);
        [_btn_jie setTitle: NSLocalizedString(@"确认接单", NSStringFromClass([self class])) forState:UIControlStateNormal];
        [_btn_jie addTarget:self action:@selector(clickToBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_btn_jie setTitleColor:THEME_COLOR forState:UIControlStateNormal];
        _btn_jie.titleLabel.font = FONT(14);
         _btn_jie.tag = self.indexPath.section;
        UIView * label_line = [[UIView alloc]init];
        label_line.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];
        label_line.frame = FRAME(0, 5, 0.5, 30);
        [_btn_jie addSubview:label_line];
    }
    return _btn_jie;
}
//取消接单的按钮
-(UIButton *)btn_cancle{
    if (!_btn_cancle) {
        _btn_cancle = [[UIButton alloc]init];
        _btn_cancle.frame = FRAME(0, 105.5, WIDTH/2, 39.5);
        [_btn_cancle setTitle: NSLocalizedString(@"拒绝接单", NSStringFromClass([self class])) forState:UIControlStateNormal];
        [_btn_cancle addTarget:self action:@selector(clickToBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_btn_cancle setTitleColor:THEME_COLOR forState:UIControlStateNormal];
        _btn_cancle.titleLabel.font = FONT(14);
        _btn_cancle.tag = self.indexPath.section;
    }
    return _btn_cancle;
}
//显示取消理由
-(UILabel *)label_cancel{
    if (!_label_cancel) {
        _label_cancel = [[UILabel alloc]init];
        _label_cancel.frame = FRAME(10, 93, WIDTH - 10, 20);
        _label_cancel.textColor = HEX(@"666666", 1.0);
        _label_cancel.textAlignment = NSTextAlignmentLeft;
        _label_cancel.font = FONT(12);
    }
    return _label_cancel;
}
-(void)setModel:(PaiduiModel *)model{
    _model= model;
    _status_label.text = model.order_state_label;
    _order_label.text = [NSString stringWithFormat:@"%@:%@", NSLocalizedString(@"号单", NSStringFromClass([self class])),model.paidui_id];
    _name_phone_label.text = [NSString stringWithFormat: NSLocalizedString(@"排队人:%@   %@", NSStringFromClass([self class])),model.contact,model.mobile];
    _people_num.text = [NSString stringWithFormat: NSLocalizedString(@"就餐人数:%@人", NSStringFromClass([self class])),model.paidui_number];
    [_btn removeFromSuperview];
    _btn = nil;
    [_btn_jie removeFromSuperview];
    _btn_jie = nil;
    [_btn_cancle removeFromSuperview];
    _btn_cancle = nil;
    [_label_cancel removeFromSuperview];
    _label_cancel = nil;
    if (model.status == 0) {
        [self addSubview:self.btn_jie];
        [self addSubview:self.btn_cancle];
        layer1.backgroundColor = LINE_COLOR.CGColor;
        _label_zhuo.text = @"--";
    }else if (model.status == 1){
        [self addSubview:self.btn];
        layer1.backgroundColor = LINE_COLOR.CGColor;
        _label_zhuo.text = model.title;
    }else if (model.status == 2){
        _label_zhuo.text = model.title;
        layer1.backgroundColor = [UIColor clearColor].CGColor;
    }else{
        _label_zhuo.text = @"--";
        layer1.backgroundColor = [UIColor clearColor].CGColor;
        //显示取消理由的
        [self addSubview:self.label_cancel];
        _label_cancel.text = [NSString stringWithFormat: NSLocalizedString(@"取消理由:%@", NSStringFromClass([self class])),model.reason];
    }
    
}
#pragma mark - 这是点击接单或者确认就餐的按钮
-(void)clickToBtn:(UIButton *)sender{
    NSLog(@"点击的是:%ld",sender.tag);
    if (self.myBlock) {
        self.myBlock(sender);
    }
}
- (void)clickPhoneBtn{
    [JHShowAlert showCallWithMsg:_model.mobile];
}
@end
