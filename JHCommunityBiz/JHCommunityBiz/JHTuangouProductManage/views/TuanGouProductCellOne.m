//
//  DeliveryProductModifyCellOne.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/28.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "TuanGouProductCellOne.h"
@implementation TuanGouProductCellOne
{
    NSInteger count;
    CGFloat imgWidth;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    }
    self.layoutMargins = UIEdgeInsetsZero;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
    //添加子控件
    [self makeUI];
    
    return self;
}
#pragma mark - 添加子控件
- (void)makeUI
{
    imgWidth = WIDTH/4;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(10, 0, WIDTH - 20, 30)];
    titleLabel.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
    titleLabel.text = NSLocalizedString(@"商品图片(第一张会默认为封面)", nil);
    titleLabel.font = FONT(13);
    titleLabel.textColor = HEX(@"333333", 1.0f);
    [self addSubview:titleLabel];
    
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
        self.tem_iv = [[PhotoIV1 alloc] init];
        self.tem_iv.frame = FRAME(0, 30, imgWidth, imgWidth);
        self.tem_iv.tag = 100;
        [self addSubview:self.tem_iv];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}

+ (CGFloat)getHeight:(NSInteger)count
{
    NSInteger a = (count + 1) / 4;
    if ((count + 1) %4 == 0) {
        return WIDTH/4 * a + 30;
    }else{
        return WIDTH/4 * (a+1) + 30;
    }
}
@end



@implementation PhotoIV1

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = FRAME(0, 0, WIDTH/4,WIDTH / 4);
        //添加控件
        [self makeUI];
    }
    return self;
}

- (void)makeUI
{
    self.img = [[UIImageView alloc] init];
    [self addSubview:_img];
    UIEdgeInsets insert = UIEdgeInsetsMake(5, 5, 5, 5);
    [_img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(insert);
    }];
    
//    self.cancelBtn = [UIButton new];
//    [self addSubview:_cancelBtn];
//    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mas_right).with.offset(-20);
//        make.right.equalTo(self);
//        make.top.equalTo(self);
//        make.bottom.equalTo(self.mas_top).with.offset(20);
//    }];
    //[_cancelBtn setImage:IMAGE(@"Delivery_pic_delete") forState:(UIControlStateNormal)];
    //[_cancelBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 5, 5, 0)];
}

@end
