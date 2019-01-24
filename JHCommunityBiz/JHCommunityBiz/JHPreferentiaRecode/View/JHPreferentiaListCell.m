//
//  JHPreferentiaListCell.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/26.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHPreferentiaListCell.h"
#import "HZQChangeDateLine.h"
@implementation JHPreferentiaListCell{
    UIView * bj_view;//白色的背景
    UIView * label_one;//创建显示第一根分割线
    UIView * label_five;//创建第五根分割线
    UILabel * label_state;//显示状态的
    UILabel * label_order;//显示订单号的
    UILabel * label_time;//显示下单时间的
    UIButton * btn_phone;//创建点击电话打电话的方法
    UILabel * label_name;//显示客户姓名的
    UILabel * label_phone;//显示手机号的
    UILabel * label_money;//显示消费金额的
    UIButton * btn_reply;//创建回复的按钮
    //模拟用的
    NSArray * array;
}
-(void)setModel:(JHPreferentiaListModel *)model{
    _model = model;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    if (bj_view ) {
        [bj_view removeFromSuperview];
        bj_view = nil;
    }
    if (bj_view == nil) {
        bj_view = [[UIView alloc]init];
        if ([model.reply isEqualToString:@"0"]&&[model.comment isEqualToString:@"1"]) {
          bj_view.frame = FRAME(0, 0, WIDTH, 200);
        }else{
          bj_view.frame = FRAME(0, 0, WIDTH, 160);
        }
        bj_view.backgroundColor = [UIColor whiteColor];
        [self addSubview:bj_view];
    }
    if (self.btn) {
        [self.btn removeFromSuperview];
        self.btn = nil;
    }
    if (self.btn == nil) {
        self.btn = [[UIButton alloc]init];
        self.btn.frame = FRAME(0, 0, WIDTH, 40);
        self.btn.enabled = NO;
        [bj_view addSubview:self.btn];
        //[self.btn addTarget:self action:@selector(clickToDetail:) forControlEvents:UIControlEventTouchUpInside];
        //创建第一个图标
        UIImageView * imageView = [[UIImageView alloc]init];
        imageView.frame = FRAME(10, 10, 15, 20);
        imageView.image = [UIImage imageNamed:@"Delivery_book"];
        [self.btn addSubview:imageView];
        //创建进入的图标
        UIImageView * image_arrorw = [[UIImageView alloc]init];
        image_arrorw.frame = FRAME(WIDTH - 20, 10, 10, 20);
        image_arrorw.image = [UIImage imageNamed:@"Delivery_arrow"];
        [self.btn addSubview:image_arrorw];
        //创建显示状态的
        label_state = [[UILabel alloc]init];
        label_state.frame = FRAME(WIDTH - 125, 10, 95, 20);
        label_state.textColor = [UIColor colorWithWhite:0.6 alpha:1];
        label_state.font = [UIFont systemFontOfSize:14];
        label_state.textAlignment = NSTextAlignmentRight;
        [self.btn addSubview:label_state];
        //创建显示订单号的
        label_order = [[UILabel alloc]init];
        label_order.frame = FRAME(40, 10, WIDTH - 170, 20);
        label_order.font = [UIFont systemFontOfSize:14];
        label_order.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        [self.btn addSubview:label_order];

    }
    NSString * str = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"订单号:", NSStringFromClass([self class])),model.order_id];
    NSRange range = [str rangeOfString:model.order_id];
    NSMutableAttributedString * attribute =  [[NSMutableAttributedString alloc]initWithString:str];
    [attribute addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.6 alpha:1]} range:range];
    label_order.attributedText = attribute;
    if ([model.reply isEqualToString:@"0"]&&[model.comment isEqualToString:@"1"]) {
        label_state.text =  NSLocalizedString(@"待回复", NSStringFromClass([self class]));
    }else if ([model.comment isEqualToString:@"0"]){
        label_state.text =  NSLocalizedString(@"等待客户评价", NSStringFromClass([self class]));
    }else if([model.reply isEqualToString:@"1"]){
        label_state.text =  NSLocalizedString(@"已回复", NSStringFromClass([self class]));
    }
    self.btn.tag = self.indexPath.row;
    if (label_one) {
        [label_one removeFromSuperview];
        label_one = nil;
    }
    if(label_one == nil){
        //创建第一根分割线
        label_one = [[UIView alloc]init];
        label_one.frame = FRAME(0, 0, WIDTH, 0.5);
        label_one.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        [self.btn addSubview:label_one];
        //创建第二根分割线
        UIView * label_two = [[UIView alloc]init];
        label_two.frame = FRAME(0, 39.5, WIDTH, 0.5);
        label_two.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        [self.btn addSubview:label_two];
        //创建第三根分割线
        UIView * label_three = [[UIView alloc]init];
        label_three.frame = FRAME(0, 79.5, WIDTH, 0.5);
        label_three.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        [bj_view addSubview:label_three];
        //创建第四根分割线
        UIView * label_four = [[UIView alloc]init];
        label_four.frame = FRAME(0, 159.5, WIDTH, 0.5);
        label_four.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        [bj_view addSubview:label_four];
        //创建显示时间的图片
        UIImageView * imageV = [[UIImageView alloc]init];
        imageV.frame = FRAME(10, 50, 20, 20);
        imageV.image = [UIImage imageNamed:@"Delivery_time"];
        [bj_view addSubview:imageV];
        //创建显示下单时间的label
        label_time  = [[UILabel alloc]init];
        label_time.frame = FRAME(40, 50, WIDTH - 40, 20);
        label_time.font = [UIFont systemFontOfSize:14];
        label_time.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        [bj_view addSubview:label_time];
    }
    if (btn_phone) {
        [btn_phone removeFromSuperview];
        btn_phone = nil;
    }
    if (btn_phone == nil) {
        //创建显示电话的
        btn_phone = [[UIButton alloc]init];
        btn_phone.frame = FRAME(WIDTH - 60, 95, 50, 50);
        [btn_phone setImage:[UIImage imageNamed:@"Delivery_phone"] forState:UIControlStateNormal];
        btn_phone.tag = self.indexPath.row;
        [bj_view addSubview:btn_phone];
        [btn_phone addTarget:self action:@selector(clickToCall:) forControlEvents:UIControlEventTouchUpInside];
    }
    NSString * str1 = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"下单时间:", NSStringFromClass([self class])),[HZQChangeDateLine dateLineExchangeWithTime:model.dateline]];
    NSRange range1 = [str1 rangeOfString:[HZQChangeDateLine dateLineExchangeWithTime:model.dateline]];
    NSMutableAttributedString * attributed = [[NSMutableAttributedString alloc]initWithString:str1];
    [attributed addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.6 alpha:1]} range:range1];
    label_time.attributedText = attributed;
    //创建显示客户姓名的
    if (label_name ) {
        [label_name removeFromSuperview];
        label_name = nil;
    }
    if (label_name == nil) {
        label_name = [[UILabel alloc]init];
        label_name.frame = FRAME(10, 87, WIDTH - 80, 20);
        label_name.font = [UIFont systemFontOfSize:14];
        label_name.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        [bj_view addSubview:label_name];
    }
    NSString * str2 = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"客户姓名:", NSStringFromClass([self class])),model.contact];
    NSRange range2 = [str2 rangeOfString:model.contact];
    NSMutableAttributedString * attribute1 = [[NSMutableAttributedString alloc]initWithString:str2];
    [attribute1 addAttributes:@{NSForegroundColorAttributeName:THEME_COLOR} range:range2];
    label_name.attributedText = attribute1;
    //显示用户手机号的
    if (label_phone ) {
        [label_phone removeFromSuperview];
        label_phone = nil;
    }
    if(label_phone == nil){
        label_phone = [[UILabel alloc]init];
        label_phone.frame = FRAME(10, 110, WIDTH - 80, 20);
        label_phone.font = [UIFont systemFontOfSize:14];
        label_phone.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        [bj_view addSubview:label_phone];
    }
    NSString * str3 = [NSString stringWithFormat:@"%@%@", NSLocalizedString(@"手机号:", NSStringFromClass([self class])),model.mobile];
    NSRange range3 = [str3 rangeOfString:model.mobile];
    NSMutableAttributedString * attribute2 = [[NSMutableAttributedString alloc]initWithString:str3];
    [attribute2 addAttributes:@{NSForegroundColorAttributeName:THEME_COLOR} range:range3];
    label_phone.attributedText =  attribute2;
    //创建显示消费金额的
    if (label_money ) {
        [label_money removeFromSuperview];
        label_money = nil;
    }
    if (label_money == nil) {
        label_money = [[UILabel alloc]init];
        label_money.frame = FRAME(10, 133, WIDTH - 20, 20);
        label_money.font = [UIFont systemFontOfSize:14];
        label_money.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        [bj_view addSubview:label_money];
    }
    NSString * str4 = [NSString stringWithFormat:@"%@ %@ %g  %@ %@ %g", NSLocalizedString(@"消费金额:", NSStringFromClass([self class])), NSLocalizedString(@"¥", NSStringFromClass([self class])),[model.total_price floatValue], NSLocalizedString(@"实付金额:", NSStringFromClass([self class])), NSLocalizedString(@"¥", NSStringFromClass([self class])),[model.amount floatValue]];
    NSRange range4 = [str4 rangeOfString:[NSString stringWithFormat:@"%@ %g", NSLocalizedString(@"¥", NSStringFromClass([self class])),[model.total_price floatValue]]];
    NSRange range5 = [str4 rangeOfString:[NSString stringWithFormat:@"%@ %g", NSLocalizedString(@"¥", NSStringFromClass([self class])),[model.amount floatValue]] options:NSBackwardsSearch];
    NSMutableAttributedString * attribute3 = [[NSMutableAttributedString alloc]initWithString:str4];
    [attribute3 addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:250/255.0 green:175/255.0 blue:25/255.0 alpha:1],NSFontAttributeName:[UIFont systemFontOfSize:16]} range:range4];
    [attribute3 addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:250/255.0 green:175/255.0 blue:25/255.0 alpha:1],NSFontAttributeName:[UIFont systemFontOfSize:16]} range:range5];
    label_money.attributedText = attribute3;
    
    if (label_five) {
        [label_five  removeFromSuperview];
        label_five = nil;
    }
    //创建第五根分割线
    if (label_five == nil && (self.indexPath == 0||self.indexPath.row ==1)) {
        label_five = [[UIView alloc]init];
        label_five.frame = FRAME(0, 199.5, WIDTH, 0.5);
        label_five.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
        [bj_view addSubview:label_five];
    }
    //创建回复的按钮
    if (btn_reply) {
        [btn_reply removeFromSuperview];
        btn_reply =  nil;
    }
    if (btn_reply == nil && [model.reply isEqualToString:@"0"] && [model.comment isEqualToString:@"1"]) {
        btn_reply = [[UIButton alloc]init];
        btn_reply.frame = FRAME(WIDTH - 90, 165, 80, 30);
        [btn_reply setTitleColor:[UIColor colorWithRed:250/255.0 green:175/255.0 blue:25/255.0 alpha:1] forState:UIControlStateNormal];
        [btn_reply setTitle: NSLocalizedString(@"回复", NSStringFromClass([self class])) forState:UIControlStateNormal];
        btn_reply.layer.cornerRadius = 3;
        btn_reply.layer.masksToBounds = YES;
        btn_reply.layer.borderColor = [UIColor colorWithRed:250/255.0 green:175/255.0 blue:25/255.0 alpha:1].CGColor;
        btn_reply.layer.borderWidth = 1;
        btn_reply.enabled = NO;
        //[btn_reply addTarget:self action:@selector(clicktoReply:) forControlEvents:UIControlEventTouchUpInside];
        [bj_view addSubview:btn_reply];
    }
    btn_reply.tag = self.indexPath.row;
}
#pragma mark - 这是点击电话打电话的方法
-(void)clickToCall:(UIButton *)sender{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:_model.mobile preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle: NSLocalizedString(@"取消", NSStringFromClass([self class])) style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle: NSLocalizedString(@"确定", NSStringFromClass([self class])) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_model.mobile]]];
    }]];
    [self.vc presentViewController:alert animated:YES completion:nil];
}
#pragma mark - 这是点击回复按钮调用的方法
//-(void)clicktoReply:(UIButton *)sender{
//    NSLog(@"点击回复");
//    //模拟用的
//    array = @[NSLocalizedString(@"待回复", nil),NSLocalizedString(@"待回复", nil),NSLocalizedString(@"等待客户评价", nil),NSLocalizedString(@"已回复", nil),NSLocalizedString(@"已回复", nil)];
//    JHPreferentiaDetailVC * vc = [[JHPreferentiaDetailVC alloc]init];
//    if (self.indexPath.row == 0 || self.indexPath.row == 3) {
//        vc.isPhoto = YES;
//    }else{
//        vc.isPhoto = NO;
//    }
//    vc.type = array[self.indexPath.row];
//    [self.vc.navigationController pushViewController:vc animated:YES];
//}
//#pragma mark - 这是点击跳转到详情界面的
//-(void)clickToDetail:(UIButton *)sender{
//    JHPreferentiaDetailVC * vc = [[JHPreferentiaDetailVC alloc]init];
//    [self.vc.navigationController pushViewController:vc animated:YES];
//}
@end
