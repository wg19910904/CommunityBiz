//
//  JHMarketStatiscalCell.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/7/1.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHMarketStatiscalCell.h"

@implementation JHMarketStatiscalCell
{
    UILabel * label_title;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(JHMarketModel *)model{
    _model  = model;
    if (_indexpath.row == 1) {
        self.infoArray = model.weekDataArray;
    }else{
        self.infoArray = model.monthDataArray;
    }
    
    self.nameArray = @[].mutableCopy;
    self.array = @[].mutableCopy;
    self.slices = @[].mutableCopy;
    float total = 0;
    for (NSDictionary * dic in self.infoArray) {
        [self.nameArray addObject:dic[@"name"]];
        total = [dic[@"num"] floatValue] + total;
    }
    NSInteger a = 0;
    if (self.infoArray.count == 1) {
        [self.slices addObject:@"100"];
    }else{
        for (int i = 0; i < self.infoArray.count; i ++) {
            NSDictionary * dic = self.infoArray[i];
            if (i < self.infoArray.count - 1) {
                //a = [dic[@"num"]floatValue] / total + a;
                a = [[[[NSString stringWithFormat:@"%.2f",[dic[@"num"]floatValue] / total] componentsSeparatedByString:@"."]lastObject] integerValue] + a;
                if ([[[[NSString stringWithFormat:@"%.2f",[dic[@"num"]floatValue] / total] componentsSeparatedByString:@"."]lastObject] integerValue] < 10) {
                    [self.slices addObject:@([[[[NSString stringWithFormat:@"%.2f",[dic[@"num"]floatValue] / total] componentsSeparatedByString:@"."]lastObject] integerValue]).stringValue];
                }else{
                   [self.slices addObject:[[[NSString stringWithFormat:@"%.2f",[dic[@"num"]floatValue] / total] componentsSeparatedByString:@"."]lastObject]];
                }
                
            }else{
                [self.slices addObject:@(100 - a).stringValue];
            }
            
        }
 
    }
    if (!label_title) {
        label_title = [[UILabel alloc]init];
        label_title.frame = FRAME(5, 5, WIDTH - 10, 20);
        label_title.textColor = [UIColor colorWithWhite:0.4 alpha:1];
        label_title.font = [UIFont systemFontOfSize:15];
        [self addSubview:label_title];
    }
    if (_indexpath.row == 1) {
        label_title.text = NSLocalizedString(@"近7天商品销量饼状图", nil);
    }else if (_indexpath.row == 3){
        label_title.text = NSLocalizedString(@"近30天商品销量饼状图", nil);
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
                           [UIColor colorWithRed:255/255.0 green:206/255.0 blue:67/255.0 alpha:1],
                           THEME_COLOR,
                           nil];
        [self addSubview:self.view_bj];
        for (int i = 0; i < self.infoArray.count; i ++) {
                UILabel * label = [[UILabel alloc]init];
                label.frame = FRAME(WIDTH - 70, 85+(14+5)*i, 14, 14);
                label.layer.cornerRadius = 7;
                label.layer.masksToBounds = YES;
                label.backgroundColor = self.sliceColors[i];
                [self addSubview:label];
                UILabel * label1 = [[UILabel alloc]init];
                label1.frame = FRAME(WIDTH - 50, 85+(15+5)*i, 50, 14);
                label1.textColor = [UIColor colorWithWhite:0.4 alpha:1];
                label1.font = [UIFont systemFontOfSize:11];
                label1.adjustsFontSizeToFitWidth = YES;
                label1.text = self.nameArray[i];
                [self addSubview:label1];
            }
        if (self.infoArray.count == 0) {
            UIImageView * imageView = [[UIImageView alloc]init];
            imageView.frame = FRAME((WIDTH - 160)/2, 30, 160, 160);
            imageView.image  = [UIImage imageNamed:@"picMOdif"];
            [self addSubview:imageView];
        }
    }
    for (int i = 0 ; i < self.infoArray.count; i++) {
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
