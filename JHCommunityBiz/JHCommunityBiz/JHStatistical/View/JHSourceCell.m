//
//  JHSourceCell.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/12.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHSourceCell.h"

@implementation JHSourceCell
{
    UILabel * label_title;
    NSString * android;
    NSString * ios;
    NSString * weixin;
}
- (void)awakeFromNib {
    // Initialization code
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
-(void)setModel:(JHSourceModel *)model{
    _model  = model;
     self.nameArray = [@[NSLocalizedString(@"安卓", nil),NSLocalizedString(@"微信", nil),@"IOS"] mutableCopy];
    if (_indexpath.row == 1) {
                float total = [model.week_dictioanry[@"weixin_count"] integerValue] + [model.week_dictioanry[@"wap_count"] integerValue] + [model.week_dictioanry[@"ios_count"] integerValue] + [model.week_dictioanry[@"android_count"] integerValue];
                float io = [model.week_dictioanry[@"ios_count"] integerValue];
                float wei = [model.week_dictioanry[@"weixin_count"] integerValue] + [model.week_dictioanry[@"wap_count"] integerValue];
        if (io == total) {
            ios = @"100";
        }else{
             ios = [[[NSString stringWithFormat:@"%.2f",io/total]componentsSeparatedByString:@"."]lastObject];
             ios = [ios isEqualToString:@"00"]? @"0" : ios;
        }
        if (wei == total) {
             weixin = @"100";
        }else{
             weixin = [[[NSString stringWithFormat:@"%.2f",wei/total]componentsSeparatedByString:@"."]lastObject];
             weixin = [weixin isEqualToString:@"00"]? @"0" : weixin;
        }
        if (io == 0 && ios == 0) {
           android = @"100";
        }else{
            android = [NSString stringWithFormat:@"%ld",100 - [ios integerValue] -[weixin integerValue]];
            android = [android isEqualToString:@"00"]? @"0" : android;


        }
        self.slices = [@[android,weixin,ios] mutableCopy];
    }else if (_indexpath.row == 3){
                float total = [model.month_dictioanry[@"weixin_count"] integerValue] + [model.month_dictioanry[@"wap_count"] integerValue] + [model.month_dictioanry[@"ios_count"] integerValue] + [model.month_dictioanry[@"android_count"] integerValue];
                float io = [model.month_dictioanry[@"ios_count"] integerValue];
                float wei = [model.month_dictioanry[@"weixin_count"] integerValue] + [model.month_dictioanry[@"wap_count"] integerValue];
        
        if (io == total) {
            ios = @"100";
        }else{
            ios = [[[NSString stringWithFormat:@"%.2f",io/total]componentsSeparatedByString:@"."]lastObject];
            ios = [ios isEqualToString:@"00"]? @"0" : ios;
        }
        if (wei == total) {
            weixin = @"100";
        }else{
            weixin = [[[NSString stringWithFormat:@"%.2f",wei/total]componentsSeparatedByString:@"."]lastObject];
            weixin = [weixin isEqualToString:@"00"]? @"0" : weixin;
        }
        if (io == 0 && ios == 0) {
            android = @"100";
        }else{
            android = [NSString stringWithFormat:@"%ld",100 - [ios integerValue] -[weixin integerValue]];
            android = [android isEqualToString:@"00"]? @"0" : android;
            
        }

                self.slices = [@[android,weixin,ios] mutableCopy];
        

    }

    self.array = [NSMutableArray array];
    if (!label_title) {
        label_title = [[UILabel alloc]init];
        label_title.frame = FRAME(5, 5, WIDTH - 10, 20);
        label_title.textColor = [UIColor colorWithWhite:0.4 alpha:1];
        label_title.font = [UIFont systemFontOfSize:15];
        [self addSubview:label_title];
    }
    if (_indexpath.row == 1) {
        label_title.text = NSLocalizedString(@"近7天订单来源饼状图", nil);
    }else if (_indexpath.row == 3){
        label_title.text = NSLocalizedString(@"近30天订单来源饼状图", nil);
    }
    if (self.view_bj == nil) {
        self.view_bj = [[XYPieChart alloc]initWithFrame:FRAME(0, 30, WIDTH, 160)];
        self.view_bj.delegate = self;
        self.view_bj.dataSource = self;
        self.view_bj.pieCenter = CGPointMake(self.center.x, 80);
        [self.view_bj setShowPercentage:NO];
        [self.view_bj setLabelColor:[UIColor whiteColor]];
        [self.view_bj setLabelFont:[UIFont systemFontOfSize:10]];
        self.sliceColors =[NSArray arrayWithObjects:
                           [UIColor colorWithRed:0/255.0 green:183/255.0 blue:238/255.0 alpha:1],
                           [UIColor colorWithRed:93/255.0 green:181/255.0 blue:62/255.0 alpha:1],
                           [UIColor colorWithRed:235/255.0 green:97/255.0 blue:0/255.0 alpha:1],
                           nil];
        [self addSubview:self.view_bj];
        
        for (int i = 0; i < 3; i ++) {
            UILabel * label = [[UILabel alloc]init];
            label.frame = FRAME(WIDTH - 50, 85+(14+5)*i, 14, 14);
            label.layer.cornerRadius = 7;
            label.layer.masksToBounds = YES;
            label.backgroundColor = self.sliceColors[i];
            [self addSubview:label];
            UILabel * label1 = [[UILabel alloc]init];
            label1.frame = FRAME(WIDTH - 30, 85+(15+5)*i, 30, 14);
            label1.textColor = [UIColor colorWithWhite:0.4 alpha:1];
            label1.font = [UIFont systemFontOfSize:11];
            label1.text = self.nameArray[i];
            [self addSubview:label1];
        }
        if (_indexpath.row == 1 && [model.week_dictioanry[@"weixin_count"] isEqualToString:@"0"] && [model.week_dictioanry[@"wap_count"] isEqualToString:@"0"]&& [model.week_dictioanry[@"ios_count"] isEqualToString:@"0"]&& [model.week_dictioanry[@"android_count"] isEqualToString:@"0"]) {
            UIImageView * imageView = [[UIImageView alloc]init];
            imageView.frame = FRAME((WIDTH - 160)/2, 30, 160, 160);
            imageView.image  = [UIImage imageNamed:@"picMOdif"];
            [self addSubview:imageView];
        }else if (_indexpath.row == 3 && [model.month_dictioanry[@"weixin_count"] isEqualToString:@"0"] && [model.month_dictioanry[@"wap_count"] isEqualToString:@"0"]&& [model.month_dictioanry[@"ios_count"] isEqualToString:@"0"]&& [model.month_dictioanry[@"android_count"] isEqualToString:@"0"]){
            UIImageView * imageView = [[UIImageView alloc]init];
            imageView.frame = FRAME((WIDTH - 160)/2, 30, 160, 160);
            imageView.image  = [UIImage imageNamed:@"picMOdif"];
            [self addSubview:imageView];
        }

}
    for (int i = 0 ; i < 3; i++) {
        NSString * str = [NSString stringWithFormat:@"%@%@％",@"",self.slices[i]];
        [self.array addObject:str];
}
    [self.view_bj reloadData];
}
#pragma mark - XYPieChart Data Source
- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart
{
    return self.slices.count;
}
- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index
{
    return [[self.slices objectAtIndex:index] intValue];
}
- (NSString *)pieChart:(XYPieChart *)pieChart textForSliceAtIndex:(NSUInteger)index{
    return [self.array objectAtIndex:index];
}
- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
    return [self.sliceColors objectAtIndex:(index % self.sliceColors.count)];
}
@end
