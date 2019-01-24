//
//  DeliveryOrderDetailCellFour.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/7/9.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "DeliveryOrderDetailCellFour.h"

@implementation DeliveryOrderDetailCellFour

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = 0;
        //makeUI
        [self makeUI];
    }
    return self;
}
- (void)makeUI
{
    self.productL = [[UILabel alloc] initWithFrame:FRAME(10, 0, WIDTH - 100, 44)];
    self.productL.textColor = HEX(@"333333", 1.0);
    self.productL.font = FONT(14);
    
    self.priceL = [[UILabel alloc] initWithFrame:FRAME(WIDTH - 100, 0, 90, 44)];
    self.priceL.textColor = HEX(@"333333", 1.0);
    self.priceL.font = FONT(14);
    self.priceL.textAlignment = NSTextAlignmentRight;
    
    [self addSubview:self.productL];
    [self addSubview:self.priceL];
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    _productL.text = dataDic[@"product_name"];
    _priceL.text = [NSString stringWithFormat:@"x%@   %@%g",
                    dataDic[@"product_number"]?dataDic[@"product_number"]:@"",
                    MS,
                    [dataDic[@"product_price"] floatValue]];
}
@end
