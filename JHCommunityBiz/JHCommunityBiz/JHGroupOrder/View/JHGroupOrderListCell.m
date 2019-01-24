//
//  JHGroupOrderListCell.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/28.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHGroupOrderListCell.h"
#import <UIImageView+WebCache.h>
@implementation JHGroupOrderListCell{
    UIView * bj_view;
    UIView * label_line;
    UIView * label_l;
    UIImageView * imageV_book;
    UILabel * label_order;//显示订单号的
    UIImageView * imageV_arrow;
    UILabel * label_no;//显示未消费的
    UIImageView * imageV_pie;//显示图片的
    UILabel * label_title;//显示团购内容的
    UILabel * label_num;//显示有多少份的
    UILabel * label_money;//显示金额的
}
-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:YES];
}
-(void)setModel:(JHGroupListModel *)model{
    _model = model;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if (bj_view == nil) {
        bj_view = [UIView new];
        bj_view.backgroundColor = [UIColor whiteColor];
        bj_view.layer.borderColor = [UIColor colorWithWhite:0.95 alpha:1].CGColor;
        bj_view.layer.borderWidth = 1;
        bj_view.userInteractionEnabled = YES;
        [self addSubview:bj_view];
    }
    if ([model.order_status_label isEqualToString: NSLocalizedString(@"待回复", NSStringFromClass([self class]))] ||
        [model.order_status_label isEqualToString: NSLocalizedString(@"已消费", NSStringFromClass([self class]))]||
        [model.order_status_label isEqualToString: NSLocalizedString(@"待消费", NSStringFromClass([self class]))]) {
        bj_view.frame = FRAME(0, 0, WIDTH, 150);
    }else{
        bj_view.frame = FRAME(0, 0, WIDTH, 110);
    }
    if (label_line == nil) {
        label_line = [[UIView alloc]init];
        label_line.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        label_line.frame = FRAME(0, 39.5, WIDTH, 0.5);
        [bj_view addSubview:label_line];
    }

    if (label_l == nil) {
        label_l = [[UIView alloc]init];
        label_l.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        label_l.frame = FRAME(0, 109.5, WIDTH, 0.5);
        [bj_view addSubview:label_l];
    }
    if (imageV_book == nil) {
        imageV_book = [[UIImageView alloc]init];
        imageV_book.frame = FRAME(10, 10, 15, 20);
        imageV_book.image = [UIImage imageNamed:@"Delivery_book"];
        [bj_view addSubview:imageV_book];
    }

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
    if (imageV_arrow == nil) {
        imageV_arrow = [[UIImageView alloc]init];
        imageV_arrow.image = [UIImage imageNamed:@"home_go"];
        imageV_arrow.frame = FRAME(WIDTH - 20, 10, 10, 20);
        [bj_view addSubview:imageV_arrow];
    }

    if (label_no == nil) {
        label_no = [[UILabel alloc]init];
        label_no.frame = FRAME(WIDTH - 130, 10, 100, 20);
        label_no.textColor = [UIColor colorWithWhite:0.6 alpha:1];
        label_no.font =  [UIFont systemFontOfSize:15];
        label_no.textAlignment = NSTextAlignmentRight;
        [bj_view addSubview:label_no];
    }
     label_no.text = model.order_status_label;
    if([label_no.text isEqualToString: NSLocalizedString(@"待消费", NSStringFromClass([self class]))]){
         label_no.textColor = [UIColor colorWithRed:250/255.0 green:44/255.0 blue:2/255.0 alpha:1];
    }
    if (imageV_pie == nil) {
        imageV_pie = [[UIImageView alloc]init];
        imageV_pie.frame = FRAME(10, 50, 50, 50);
        [bj_view addSubview:imageV_pie];
    }
    [imageV_pie sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEADDRESS,model.shop_logo]] placeholderImage:[UIImage imageNamed:@"evaluateDefault"]];

    if (label_title == nil) {
        label_title = [[UILabel alloc]init];
        label_title.frame  = FRAME(70, 55, WIDTH - 80, 20);
        label_title.font = [UIFont systemFontOfSize:15];
        label_title.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        [bj_view addSubview:label_title];
    }
    label_title.text = model.tuan_title;

    if (label_num == nil) {
        label_num = [[UILabel alloc]init];
        label_num.frame = FRAME(70, 80, (WIDTH - 90)/2, 20);
        label_num.textColor = [UIColor colorWithRed:250/255.0 green:175/255.0 blue:25/255.0 alpha:1];
        label_num.font = [UIFont systemFontOfSize:15];
        [bj_view addSubview:label_num];
    }
    label_num.text = [NSString stringWithFormat:@"%@%@/%@",@"X",model.tuan_number, NSLocalizedString(@"份", NSStringFromClass([self class]))];

    if (label_money == nil) {
        label_money = [[UILabel alloc]init];
        label_money.frame = FRAME((WIDTH - 90)/2+80, 80, (WIDTH - 90)/2, 20);
        label_money.textColor = [UIColor colorWithRed:250/255.0 green:175/255.0 blue:25/255.0 alpha:1];
        label_money.font = [UIFont systemFontOfSize:15];
        label_money.textAlignment = NSTextAlignmentRight;
        [bj_view addSubview:label_money];
    }
    label_money.text = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"¥", NSStringFromClass([self class])),model.total_price];
    if (self.btn_Verification) {
        [self.btn_Verification removeFromSuperview];
        self.btn_Verification = nil;
    }
    if (self.btn_Verification == nil&&(
                                       [model.order_status_label isEqualToString: NSLocalizedString(@"待回复", NSStringFromClass([self class]))] ||
                                       [model.order_status_label isEqualToString: NSLocalizedString(@"已消费", NSStringFromClass([self class]))]||
                                       [model.order_status_label isEqualToString: NSLocalizedString(@"待消费", NSStringFromClass([self class]))])) {
        self.btn_Verification = [[UIButton alloc]init];
        self.btn_Verification.frame = FRAME(WIDTH - 90, 115, 80, 30);
        [self.btn_Verification setTitle: NSLocalizedString(@"验证", NSStringFromClass([self class])) forState:UIControlStateNormal];
        [self.btn_Verification setTitleColor: [UIColor colorWithRed:250/255.0 green:175/255.0 blue:25/255.0 alpha:1] forState:UIControlStateNormal];
        self.btn_Verification.layer.cornerRadius = 3;
        self.btn_Verification.layer.masksToBounds = YES;
        self.btn_Verification.titleLabel.font = [UIFont systemFontOfSize:15];
        self.btn_Verification.layer.borderColor = [UIColor colorWithRed:250/255.0 green:175/255.0 blue:25/255.0 alpha:1].CGColor;
        self.btn_Verification.layer.borderWidth = 1;
        [bj_view addSubview:self.btn_Verification];
        if ([model.order_status_label isEqualToString: NSLocalizedString(@"待回复", NSStringFromClass([self class]))]) {
            [self.btn_Verification setTitle: NSLocalizedString(@"回复", NSStringFromClass([self class])) forState:UIControlStateNormal];
            [self.btn_Verification setTitleColor:[UIColor colorWithRed:250/255.0 green:175/255.0 blue:25/255.0 alpha:1] forState:UIControlStateNormal];
            self.btn_Verification.layer.borderColor = [UIColor colorWithRed:250/255.0 green:175/255.0 blue:25/255.0 alpha:1].CGColor;
        }else if ([model.order_status_label isEqualToString: NSLocalizedString(@"已消费", NSStringFromClass([self class]))]){
            [self.btn_Verification setTitle: NSLocalizedString(@"等待评价", NSStringFromClass([self class])) forState:UIControlStateNormal];
            [self.btn_Verification setTitleColor:[UIColor colorWithWhite:0.6 alpha:1] forState:UIControlStateNormal];
            self.btn_Verification.layer.borderColor = [UIColor colorWithWhite:0.6 alpha:1].CGColor;
        }
    }

}
@end
