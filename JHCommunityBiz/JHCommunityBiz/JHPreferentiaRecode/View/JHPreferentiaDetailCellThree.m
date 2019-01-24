//
//  JHPreferentiaDetailCellThree.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/27.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHPreferentiaDetailCellThree.h"

@implementation JHPreferentiaDetailCellThree
{
    UIView * bj_view;//背景
    NSArray * array;//存放4个标题的
    NSMutableArray * array_money;//存放3个金额的
}
-(void)setModel:(JHPreferentiaDetailModel *)model{
    _model = model;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    array_money = [NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"%g%@",[model.total_price floatValue], NSLocalizedString(@"元", NSStringFromClass([self class]))],
                   [NSString stringWithFormat:@"%g%@",[model.youhui_price floatValue], NSLocalizedString(@"元", NSStringFromClass([self class]))],
                   [NSString stringWithFormat:@"%g%@",[model.amount floatValue], NSLocalizedString(@"元", NSStringFromClass([self class]))],nil];
    if(bj_view){
        [bj_view removeFromSuperview];
        bj_view = nil;
    }
    if (bj_view == nil) {
        array = @[ NSLocalizedString(@"订单详情", NSStringFromClass([self class])),
                    NSLocalizedString(@"消费金额", NSStringFromClass([self class])),
                    NSLocalizedString(@"优惠金额", NSStringFromClass([self class])),
                    NSLocalizedString(@"实付金额", NSStringFromClass([self class]))];
        bj_view = [[UIView alloc]init];
        bj_view.backgroundColor = [UIColor whiteColor];
        bj_view.frame = FRAME(0, 0, WIDTH, 140);
        bj_view.layer.borderColor = [UIColor colorWithWhite:0.95 alpha:1].CGColor;
        bj_view.layer.borderWidth = 1;
        [self addSubview:bj_view];
        //创建四根线
        for(int i = 0;i < 3;i ++){
            UILabel * label = [[UILabel alloc]init];
            label.frame = FRAME(10, 10+(20 + 12)*(i+1)+10, WIDTH - 20, 1);
            label.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
            [bj_view addSubview:label];
        }
        //创建前面的4个标题
        for (int i = 0; i < array.count; i++) {
            UILabel * label = [[UILabel alloc]init];
            label = [[UILabel alloc]init];
            label.frame = FRAME(10, 10+(20 + 12)*i, 70, 20);
            label.text = array[i];
            label.backgroundColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:15];
            if (i == 0) {
                label.textColor = [UIColor colorWithWhite:0.3 alpha:1];
            }else{
                label.textColor = [UIColor colorWithWhite:0.6 alpha:1];
            }
            [bj_view addSubview:label];
        }
        //后面的金额
        for (int i = 0; i < array_money.count; i++) {
            UILabel * label = [[UILabel alloc]init];
            label = [[UILabel alloc]init];
            label.frame = FRAME(WIDTH - 70, 10+(20 + 12)*(i+1), 60, 20);
            label.text = array_money[i];
            label.adjustsFontSizeToFitWidth = YES;
            label.backgroundColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentRight;
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = [UIColor colorWithRed:250/255.0 green:175/255.0 blue:25/255.0 alpha:1];
            [bj_view addSubview:label];
        }
    }
  }
@end
