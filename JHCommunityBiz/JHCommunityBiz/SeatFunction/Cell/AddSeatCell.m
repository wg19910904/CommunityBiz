//
//  AddSeatCell.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/9/30.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "AddSeatCell.h"
#import "HZQChangeDateLine.h"
@implementation AddSeatCell
{
    CALayer * layer1;
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
    //    //显示桌号
//    [self addSubview:self.label_zhuo];
    //添加备注两字的label
    [self addSubview:self.label_beizhu];
    //显示备注信息的
    [self addSubview:self.label_notice];
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
//添加电话拨打按钮
- (UIButton *)phoneBtn{
    if (_phoneBtn == nil) {
        _phoneBtn = [[UIButton alloc] initWithFrame:FRAME(150, 41, 40, 40)];
        [_phoneBtn setImage:IMAGE(@"Delivery_phone") forState:(UIControlStateNormal)];
        _phoneBtn.imageEdgeInsets = UIEdgeInsetsMake(11.5, 11.5, 11.5, 11.5);
        [_phoneBtn addTarget:self action:@selector(clickPhoneBtn) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _phoneBtn;
}
- (void)clickPhoneBtn{
    [JHShowAlert showCallWithMsg:_model.mobile];
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
////显示桌号
//-(UILabel *)label_zhuo{
//    if (!_label_zhuo) {
//        _label_zhuo = [[UILabel alloc]init];
//        _label_zhuo.frame = FRAME(WIDTH - 150, 55, 140, 35);
//        _label_zhuo.textColor = HEX(@"faaf19", 1.0);
//        _label_zhuo.textAlignment = NSTextAlignmentRight;
//        _label_zhuo.font = FONT(20);
//    }
//    return _label_zhuo;
//}
//确认就餐的按钮
-(UIButton *)btn{
    if (!_btn) {
        _btn = [[UIButton alloc]init];
        [_btn setTitle: NSLocalizedString(@"确认到店", NSStringFromClass([self class])) forState:UIControlStateNormal];
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
        [_btn_jie setTitle: NSLocalizedString(@"确认接单", NSStringFromClass([self class])) forState:UIControlStateNormal];
        [_btn_jie addTarget:self action:@selector(clickToBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_btn_jie setTitleColor:THEME_COLOR forState:UIControlStateNormal];
        _btn_jie.titleLabel.font = FONT(14);
        _btn_jie.tag = self.indexPath.section;
        UIView *label_line = [[UIView alloc]init];
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
        _label_cancel.textColor = HEX(@"666666", 1.0);
        _label_cancel.textAlignment = NSTextAlignmentLeft;
        _label_cancel.font = FONT(12);
    }
    return _label_cancel;
}
//显示备注两字的
-(UILabel *)label_beizhu{
    if (!_label_beizhu) {
        _label_beizhu = [[UILabel alloc]init];
        _label_beizhu.text =  NSLocalizedString(@"备注:", NSStringFromClass([self class]));
        _label_beizhu.textColor = HEX(@"666666", 1.0);
        _label_beizhu.frame = FRAME(10, 93, 30, 20);
        _label_beizhu.font = FONT(12);
    }
    return _label_beizhu;
}
//显示备注信息的
-(UILabel *)label_notice{
    if (!_label_notice) {
        _label_notice = [[UILabel alloc]init];
        _label_notice.textColor = HEX(@"666666", 1.0);
        _label_notice.font = FONT(12);
        _label_notice.numberOfLines = 0;
    }
    return _label_notice;
}
//显示桌号的
-(void)setModel:(AddSeatModel *)model{
    _model= model;
    if (layer1) {
        [layer1 removeFromSuperlayer];
        layer1 = nil;
    }
    //画线
    if (layer1 == nil) {
        layer1 = [[CALayer alloc]init];
        layer1.frame = FRAME(0, 105+model.height + 10, WIDTH, 0.5);
        layer1.backgroundColor = LINE_COLOR.CGColor;
        [self.layer addSublayer:layer1];
    }
    //暂时的处理
    _status_label.text = model.order_state_label;
    _order_label.text = [NSString stringWithFormat: NSLocalizedString(@"%@到店 (桌号: %@)", NSStringFromClass([self class])),[HZQChangeDateLine ExchangeWithDateLine:model.yuyue_time],model.dingzuo_id];
    _name_phone_label.text = [NSString stringWithFormat:@"%@:   %@",model.contact ,model.mobile];
    _people_num.text = [NSString stringWithFormat: NSLocalizedString(@"就餐人数:%@人 ", NSStringFromClass([self class])),model.yuyue_number];
    [_btn removeFromSuperview];
    _btn = nil;
    [_btn_jie removeFromSuperview];
    _btn_jie = nil;
    [_btn_cancle removeFromSuperview];
    _btn_cancle = nil;
    [_label_cancel removeFromSuperview];
    _label_cancel = nil;
    _label_notice.text = model.notice?model.notice: NSLocalizedString(@"无", NSStringFromClass([self class]));
    _label_notice.frame = FRAME(40, 96, WIDTH - 50, model.height == 0? 20:model.height);
    if (model.status == 0) {
        [self addSubview:self.btn_jie];
        [self addSubview:self.btn_cancle];
         _btn_cancle.frame = FRAME(0, 105.5+model.height+10, WIDTH/2, 39.5);
        _btn_jie.frame = FRAME(WIDTH/2, 105.5+model.height+10, WIDTH/2, 39.5);
        layer1.backgroundColor = LINE_COLOR.CGColor;
       
    }else if (model.status == 1){
        [self addSubview:self.btn];
        _btn.frame = FRAME(0, 105.5+model.height+10, WIDTH, 39.5);
        layer1.backgroundColor = LINE_COLOR.CGColor;
    }else if (model.status == 2){
        layer1.backgroundColor = [UIColor clearColor].CGColor;
    }else{
       layer1.backgroundColor = [UIColor clearColor].CGColor;
        //显示取消理由的
        [self addSubview:self.label_cancel];
        _label_cancel.frame = FRAME(10, 100 + (model.height == 0? 20:model.height), WIDTH - 10, 20);
        _label_cancel.text = [NSString stringWithFormat: NSLocalizedString(@"取消理由:%@", NSStringFromClass([self class])),model.reason];
    }
}
#pragma mark - 这是点击接单或者确认就餐的按钮
-(void)clickToBtn:(UIButton *)sender{
    NSLog(@"点击的是:%@",sender.titleLabel.text);
    if (self.myBlock) {
        self.myBlock(sender);
    }
}
@end
