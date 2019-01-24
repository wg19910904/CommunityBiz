//
//  JHBrokenLineCell.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/12.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHBrokenLineCell.h"
#import "JHIncomeModel.h"
#import "JHOrderModel.h"
@implementation JHBrokenLineCell
{
    NSIndexPath * path;
    NSMutableArray * array;
    UUChart * chartView;
    int Num;
    UILabel * label_title;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configUI:(NSIndexPath *)indexPath withInfoArray:(NSMutableArray *)infoArray withNum:(int)num{
    if (label_title == nil) {
        label_title = [[UILabel alloc]init];
        label_title.frame = FRAME(10, 5, WIDTH, 20);
        label_title.font = [UIFont systemFontOfSize:15];
        label_title.textColor = [UIColor colorWithWhite:0.4 alpha:1];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        if (num == 1) {
            label_title.text = NSLocalizedString(@"近7天收入折线", nil);
        }else{
            label_title.text = NSLocalizedString(@"近7天订单量折线", nil);
        }
        [self addSubview:label_title];
    }
    if (infoArray.count != 0) {
        if (chartView) {
            [chartView removeFromSuperview];
            chartView = nil;
        }
        path = indexPath;
        array = infoArray;
        Num = num;
        chartView = [[UUChart alloc]initwithUUChartDataFrame:FRAME(10, 30, WIDTH-20, 160) withSource:self withStyle:UUChartStyleLine];
        [chartView showInView:self.contentView];
    }
}
- (NSArray *)getXTitles:(int)num
{
    NSMutableArray *xTitles = [NSMutableArray array];
    if (Num == 1) {
        int a = -1;
            for (NSInteger i = array.count - 1; i >= array.count - num; i--) {
                a ++;
                JHIncomeModel * model = array[array.count - num + a];
                NSString * strr = [model.date substringWithRange:NSMakeRange(5, 5)];
                NSString * str = [NSString stringWithFormat:@"%@",strr];
                [xTitles addObject:str];
            }
            
        }else{
            int b = -1;
            for (NSInteger i = array.count - 1; i >= array.count - num; i--) {
                b++;
                JHOrderModel * model = array[array.count - num + b];
                NSString * strr = [model.date substringWithRange:NSMakeRange(5, 5)];
                NSString * str = [NSString stringWithFormat:@"%@",strr];
                [xTitles addObject:str];
            }
        }
        return xTitles;
}
#pragma mark - @required
//横坐标标题数组
- (NSArray *)chartConfigAxisXLabel:(UUChart *)chart
{
    return [self getXTitles:7];
}
//数值多重数组
- (NSArray *)chartConfigAxisYValue:(UUChart *)chart
{
    NSArray *ary = nil;
    NSString * str1= nil;
    NSString * str2= nil;
    NSString * str3= nil;
    NSString * str4= nil;
    NSString * str5= nil;
    NSString * str6= nil;
    NSString * str7= nil;
    for (NSInteger i = array.count - 1; i >= array.count - 7; i--) {
        if (Num == 1) {
            JHIncomeModel * model = array[i];
            if (i == array.count - 7) {
                str1 = model.money;
            }else if (i == array.count - 6){
                str2 = model.money;
            }else if (i == array.count - 5){
                str3 = model.money;
            }else if (i == array.count - 4){
                str4 = model.money;
            }else if (i == array.count - 3){
                str5 = model.money;
            }else if (i == array.count - 2){
                str6 = model.money;
            }else{
                str7 = model.money;
            }
            
        }else{
            JHOrderModel * model = array[i];
            if (i == array.count - 7) {
                str1 = model.count;
            }else if (i == array.count - 6){
                str2 = model.count;
            }else if (i == array.count - 5){
                str3 = model.count;
            }else if (i == array.count - 4){
                str4 = model.count;
            }else if (i == array.count - 3){
                str5 = model.count;
            }else if (i == array.count - 2){
                str6 = model.count;
            }else{
                str7 = model.count;
            }
        }
    }
    ary = @[str1,str2,str3,str4,str5,str6,str7];
    return @[ary];
}
#pragma mark - @optional
//颜色数组
- (NSArray *)chartConfigColors:(UUChart *)chart
{
    return @[[UUColor skyle],[UUColor red],[UUColor brown]];
}
//显示数值范围
- (CGRange)chartRange:(UUChart *)chart
{   int total = 0 ;
    NSInteger length = 0;
    if (Num == 1) {
        for (int i = 0; i < array.count; i++) {
            JHIncomeModel * model = array[i];
            if (i == 0) {
                total = [model.money intValue];
            }else{
                total = total > [model.money intValue]?total:[model.money intValue];
            }
        }
        
    }else{
        for (int i = 0; i < array.count; i++) {
            JHOrderModel * model = array[i];
            if (i == 0) {
                total = [model.count intValue];
            }else{
                total = total > [model.count intValue]?total:[model.count intValue];
            }
        }
    }
    if (total == 0) {
        total = 2000;
    }else{
        length = [NSString stringWithFormat:@"%d",total].length;
        if (length != 1) {
            total = total/pow( 10,length - 1);
            total = total+1;
            total = total*pow( 10,length - 1);
        }
        NSLog(@"=======%d%ld%f======",total,length,pow( 10,length - 1));
    }
    return CGRangeMake(total, 0);
}
//判断显示横线条
- (BOOL)chart:(UUChart *)chart showHorizonLineAtIndex:(NSInteger)index
{
    return YES;
}

@end
