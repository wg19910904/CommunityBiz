//
//  JHGroupOrderListOtherCell.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/30.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHGroupOrderListOtherCell.h"
#import <UIImageView+WebCache.h>
@implementation JHGroupOrderListOtherCell{
     UIView * bj_view;
    UIView * label_line;
    UIView * label_l;
    UIImageView * imageV_book;
    UILabel * label_order;//显示订单号的
    UIImageView * imageV_arrow;
    UILabel * label_no;//显示状态的
    NSArray * array;//模拟假数据
    UIImageView * imageV_pie;//显示图片的
    UILabel * label_title;//显示团购内容的
    UILabel * label_num;//显示有多少份的
    UILabel * label_money;//显示金额的
}
-(void)setModel:(JHGroupOrderListOtherModel *)model{
    _model = model;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if (bj_view == nil) {
        bj_view = [UIView new];
        if ([model.order_status_label isEqualToString: NSLocalizedString(@"待回复", NSStringFromClass([self class]))] || [model.order_status_label isEqualToString: NSLocalizedString(@"已消费", NSStringFromClass([self class]))]) {
            bj_view.frame = FRAME(0, 0, WIDTH, 150);
        }else{
            bj_view.frame = FRAME(0, 0, WIDTH, 110);
        }
        bj_view.backgroundColor = [UIColor whiteColor];
        bj_view.layer.borderColor = [UIColor colorWithWhite:0.95 alpha:1].CGColor;
        bj_view.layer.borderWidth = 1;
        [self addSubview:bj_view];
        //array = @[NSLocalizedString(@"待回复", nil),NSLocalizedString(@"已消费", nil),NSLocalizedString(@"已回复", nil),NSLocalizedString(@"已退款", nil),NSLocalizedString(@"已过期", nil),NSLocalizedString(@"已取消", nil)];
    }
    if ([model.order_status_label isEqualToString: NSLocalizedString(@"待回复", NSStringFromClass([self class]))] || [model.order_status_label isEqualToString: NSLocalizedString(@"已消费", NSStringFromClass([self class]))]) {
        bj_view.frame = FRAME(0, 0, WIDTH, 150);
    }else{
        bj_view.frame = FRAME(0, 0, WIDTH, 110);
    }
//    if (label_line) {
//        [label_line removeFromSuperview];
//        label_line = nil;
//    }
    if (label_line == nil) {
        label_line = [[UIView alloc]init];
        label_line.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        label_line.frame = FRAME(0, 39.5, WIDTH, 0.5);
        [bj_view addSubview:label_line];
    }
//    if (label_l) {
//        [label_l removeFromSuperview];
//        label_l = nil;
//    }
    if (label_l == nil) {
        label_l = [[UIView alloc]init];
        label_l.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        label_l.frame = FRAME(0, 109.5, WIDTH, 0.5);
        [bj_view addSubview:label_l];
    }
//    if (imageV_book) {
//        [imageV_book removeFromSuperview];
//        imageV_book = nil;
//    }
    if (imageV_book == nil) {
        imageV_book = [[UIImageView alloc]init];
        imageV_book.frame = FRAME(10, 10, 15, 20);
        imageV_book.image = [UIImage imageNamed:@"Delivery_book"];
        [bj_view addSubview:imageV_book];
    }
//    if(label_order){
//        [label_order removeFromSuperview];
//        label_order = nil;
//    }
    if (label_order == nil) {
        label_order = [[UILabel alloc]init];
        label_order.frame = FRAME(40, 10, 150, 20);
        label_order.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        label_order.font = [UIFont systemFontOfSize:15];
        [bj_view addSubview:label_order];
    }
    NSString * str = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"订单号:", NSStringFromClass([self class])),model.order_id];
    NSRange range = [str rangeOfString:model.order_id];
    NSMutableAttributedString * attributed = [[NSMutableAttributedString alloc]initWithString:str];
    [attributed addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.6 alpha:1],NSFontAttributeName:[UIFont systemFontOfSize:13]} range:range];
    label_order.attributedText = attributed;
//    if (imageV_arrow) {
//        [imageV_arrow removeFromSuperview];
//        imageV_arrow = nil;
//    }
    if (imageV_arrow == nil) {
        imageV_arrow = [[UIImageView alloc]init];
        imageV_arrow.image = [UIImage imageNamed:@"home_go"];
        imageV_arrow.frame = FRAME(WIDTH - 20, 10, 10, 20);
        [bj_view addSubview:imageV_arrow];
    }
//    if (label_no) {
//        [label_no removeFromSuperview];
//        label_no = nil;
//    }
    if (label_no == nil) {
        label_no = [[UILabel alloc]init];
        label_no.frame = FRAME(WIDTH - 130, 10, 100, 20);
        label_no.textColor = [UIColor colorWithWhite:0.6 alpha:1];
        label_no.font =  [UIFont systemFontOfSize:15];
        label_no.textAlignment = NSTextAlignmentRight;
        [bj_view addSubview:label_no];
    }
    label_no.text = model.order_status_label;
//    if (imageV_pie) {
//        [imageV_pie removeFromSuperview];
//        imageV_pie = nil;
//    }
    if (imageV_pie == nil) {
        imageV_pie = [[UIImageView alloc]init];
        imageV_pie.frame = FRAME(10, 50, 50, 50);
        [bj_view addSubview:imageV_pie];
    }
    [imageV_pie sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEADDRESS,model.shop_logo]] placeholderImage:[UIImage imageNamed:@"evaluateDefault"]];
    
//    if (label_title) {
//        [label_title removeFromSuperview];
//        label_title = nil;
//    }
    if (label_title == nil) {
        label_title = [[UILabel alloc]init];
        label_title.frame  = FRAME(70, 55, WIDTH - 80, 20);
        label_title.font = [UIFont systemFontOfSize:15];
        label_title.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        //label_title.text = NSLocalizedString(@"码格力塔比萨单人餐", nil);
        [bj_view addSubview:label_title];
    }
    label_title.text = model.tuan_title;
//    if (label_num) {
//        [label_num removeFromSuperview];
//        label_num = nil;
//    }
    if (label_num == nil) {
        label_num = [[UILabel alloc]init];
        label_num.frame = FRAME(70, 80, (WIDTH - 90)/2, 20);
        label_num.textColor = [UIColor colorWithRed:250/255.0 green:175/255.0 blue:25/255.0 alpha:1];
        label_num.font = [UIFont systemFontOfSize:15];
        //label_num.text = @"X2/份";
        [bj_view addSubview:label_num];
    }
    label_num.text = [NSString stringWithFormat:@"%@%@/%@",@"X",model.tuan_number, NSLocalizedString(@"份", NSStringFromClass([self class]))];
//    if (label_money) {
//        [label_money removeFromSuperview];
//        label_money = nil;
//    }
    if (label_money == nil) {
        label_money = [[UILabel alloc]init];
        label_money.frame = FRAME((WIDTH - 90)/2+80, 80, (WIDTH - 90)/2, 20);
        label_money.textColor = [UIColor colorWithRed:250/255.0 green:175/255.0 blue:25/255.0 alpha:1];
        label_money.font = [UIFont systemFontOfSize:15];
        label_money.textAlignment = NSTextAlignmentRight;
        //label_money.text = @"¥ 12.8";
        [bj_view addSubview:label_money];
    }
    label_money.text = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"¥", NSStringFromClass([self class])),model.total_price];
    if (self.btn) {
        [self.btn removeFromSuperview];
        self.btn = nil;
    }
    if (([model.order_status_label isEqualToString: NSLocalizedString(@"待回复", NSStringFromClass([self class]))] || [model.order_status_label isEqualToString: NSLocalizedString(@"已消费", NSStringFromClass([self class]))]) && self.btn == nil) {
        self.btn = [[UIButton alloc]init];
        self.btn.frame = FRAME(WIDTH - 90, 115, 80, 30);
        if ([model.order_status_label isEqualToString: NSLocalizedString(@"待回复", NSStringFromClass([self class]))]) {
            [self.btn setTitle: NSLocalizedString(@"回复", NSStringFromClass([self class])) forState:UIControlStateNormal];
            [self.btn setTitleColor:[UIColor colorWithRed:250/255.0 green:175/255.0 blue:25/255.0 alpha:1] forState:UIControlStateNormal];
            self.btn.layer.borderColor = [UIColor colorWithRed:250/255.0 green:175/255.0 blue:25/255.0 alpha:1].CGColor;
        }else{
            [self.btn setTitle: NSLocalizedString(@"等待评价", NSStringFromClass([self class])) forState:UIControlStateNormal];
            [self.btn setTitleColor:[UIColor colorWithWhite:0.6 alpha:1] forState:UIControlStateNormal];
            self.btn.layer.borderColor = [UIColor colorWithWhite:0.6 alpha:1].CGColor;
        }
        self.btn.titleLabel.font = [UIFont systemFontOfSize:15];
        self.btn.layer.borderWidth = 1;
        self.btn.layer.cornerRadius = 3;
        self.btn.layer.masksToBounds = YES;
        self.btn.enabled = NO;
        [bj_view addSubview:self.btn];
    }
}
@end
