//
//  JHGroupOrderDetailCellOne.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/30.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHGroupOrderDetailCellOne.h"

@implementation JHGroupOrderDetailCellOne{
    UILabel * label;
    UIView * label_line;
    UILabel * label_type;
    UIButton * btn_call;
}
-(void)setModel:(JHGroupDetailModel *)model{
    _model = model;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if (label_line == nil) {
        label_line = [[UIView alloc]init];
        label_line.frame = FRAME(0, 39.5, WIDTH, 0.5);
        label_line.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        [self addSubview:label_line];
    }
    if (label == nil) {
        label = [[UILabel alloc]init];
        label.frame = FRAME(10, 10, WIDTH-110, 20);
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        [self addSubview:label];
    }
    if (label_type) {
        [label_type removeFromSuperview];
        label_type = nil;
    }
    if (btn_call) {
        [btn_call removeFromSuperview];
        btn_call = nil;
    }
    if (self.indexPath.section == 0) {
        NSString * str = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"订单号:", NSStringFromClass([self class])),model.order_id];
        NSRange range = [str rangeOfString:model.order_id];
        NSMutableAttributedString * attribute = [[NSMutableAttributedString alloc]initWithString:str];
        [attribute addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithWhite:0.6 alpha:1]} range:range];
        label.attributedText =  attribute;
        //创建显示状态的
        if(label_type == nil){
            label_type = [[UILabel alloc]init];
            label_type.frame = FRAME(WIDTH - 100, 10, 90, 20);
            label_type.font = [UIFont systemFontOfSize:15];
            label_type.textAlignment = NSTextAlignmentRight;
            label_type.textColor = [UIColor colorWithRed:246/255.0 green:57/255.0 blue:33/255.0 alpha:1];
            [self addSubview:label_type];
        }
        label_type.text = model.order_state_label;
    }else{
        switch (self.indexPath.row) {
            case 0:
            {
                NSString * str = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"客户姓名:", NSStringFromClass([self class])),model.contact];
                NSRange range = [str rangeOfString:model.contact];
                NSMutableAttributedString * attribute = [[NSMutableAttributedString alloc]initWithString:str];
                [attribute addAttributes:@{NSForegroundColorAttributeName:THEME_COLOR} range:range];
                label.attributedText =  attribute;
 
            }
                break;
             case 1:
            {
                NSString * str = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"手机号码:", NSStringFromClass([self class])),model.mobile];
                NSRange range = [str rangeOfString:model.mobile];
                NSMutableAttributedString * attribute = [[NSMutableAttributedString alloc]initWithString:str];
                [attribute addAttributes:@{NSForegroundColorAttributeName:THEME_COLOR} range:range];
                label.attributedText =  attribute;
                 //创建打电话的按钮
                btn_call = [[UIButton alloc]init];
                btn_call.frame = FRAME(WIDTH - 40, 5, 30, 30);
                [btn_call setImage:[UIImage imageNamed:@"Delivery_phone"] forState:UIControlStateNormal];
                [self addSubview:btn_call];
                [btn_call addTarget:self action:@selector(clickToCall) forControlEvents:UIControlEventTouchUpInside];
            }
                break;
            default:
                break;
        }
    }
}
#pragma mark - 这是点击打电话的方法
-(void)clickToCall{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:_model.mobile preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle: NSLocalizedString(@"取消", NSStringFromClass([self class])) style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle: NSLocalizedString(@"确定", NSStringFromClass([self class])) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_model.mobile]]];
    }]];
    UIWindow * window = [UIApplication sharedApplication].delegate.window;
    [window.rootViewController presentViewController:alert animated:YES completion:nil];
}
@end
