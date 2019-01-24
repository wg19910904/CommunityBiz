//
//  JHTakeTheirCellFour.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/26.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHTakeTheirCellFour.h"

@implementation JHTakeTheirCellFour{
    UIView * bj_view;//创建白色的背景
    NSMutableArray * array;
    NSMutableArray * array1;
}
-(void)setModel:(JHTakeTheirModel *)model{
    _model = model;
    self.backgroundColor =[UIColor colorWithWhite:0.98 alpha:1];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if (bj_view == nil) {
        array = @[].mutableCopy;
        array1 = @[].mutableCopy;
        bj_view = [[UIView alloc]init];
        bj_view.frame = FRAME(10, 0, WIDTH - 20, self.frame.size.height - 10);
        bj_view.backgroundColor = [UIColor whiteColor];
        bj_view.layer.cornerRadius = 3;
        bj_view.layer.masksToBounds = YES;
        bj_view.layer.borderColor = [UIColor colorWithWhite:0.95 alpha:1].CGColor;
        bj_view.layer.borderWidth = 1;
        [self addSubview:bj_view];
        for (JHDishModel * dishModel in model.infoArray) {
            [array addObject:dishModel.product_name];
            NSString * str = [NSString stringWithFormat:@"X%@   %@%@",dishModel.product_number, NSLocalizedString(@"¥", NSStringFromClass([self class])),dishModel.product_price];
            [array1 addObject:str];
    }
   
        for (int i = 0; i < array.count; i ++) {
            UILabel * label = [[UILabel alloc]init];
            label.frame = FRAME(10, 10+(20+5)*i, (WIDTH - 20)/2-10, 20);
            label.text = array[i];
            label.adjustsFontSizeToFitWidth = YES;
            label.textColor = [UIColor colorWithWhite:0.3 alpha:1];
            label.font = [UIFont systemFontOfSize:14];
            [bj_view addSubview:label];
            UILabel * label1 = [[UILabel alloc]init];
            label1.frame = FRAME((WIDTH - 20)/2+10, 10+(20+5)*i, (WIDTH - 20)/2-25, 20);
            label1.text = array1[i];
            label1.textAlignment = NSTextAlignmentRight;
            label1.adjustsFontSizeToFitWidth = YES;
            label1.textColor = [UIColor colorWithWhite:0.3 alpha:1];
            label1.font = [UIFont systemFontOfSize:14];
            [bj_view addSubview:label1];
        }
        UILabel *package_price_title = [UILabel new];
        UILabel *package_price = [UILabel new];
        [bj_view addSubview:package_price_title];
        [bj_view addSubview:package_price];
        [package_price_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 10;
            make.bottom.offset = -5;
            make.height.offset = 20;
        }];
        package_price_title.text = NSLocalizedString(@"打包费", nil);
        package_price_title.font = [UIFont systemFontOfSize:14];
        package_price_title.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        [package_price mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset = -15;
            make.bottom.offset = -5;
            make.height.offset = 20;
        }];
        package_price.text = [NSString stringWithFormat: NSLocalizedString(@"¥%@", NSStringFromClass([self class])),model.package_price];
        package_price.font = [UIFont systemFontOfSize:14];
        package_price.textColor = [UIColor colorWithWhite:0.3 alpha:1];
    }
}
@end
