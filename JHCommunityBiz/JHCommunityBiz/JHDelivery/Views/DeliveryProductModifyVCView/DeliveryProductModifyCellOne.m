//
//  DeliveryProductModifyCellOne.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/28.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "DeliveryProductModifyCellOne.h"
CGFloat DeliveryProductModifyCellOne_height;
@implementation DeliveryProductModifyCellOne
{
    NSInteger count;
    CGFloat imgWidth;
    UIView *imgBackView;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
      self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    }
    self.layoutMargins = UIEdgeInsetsZero;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = HEX(@"f5f5f5", 1.0);
    //添加子控件
    [self makeUI];
    
    return self;
}
#pragma mark - 添加子控件
- (void)makeUI
{
    imgWidth = WIDTH/4;
    UILabel *remindLabel = [[UILabel alloc] initWithFrame:FRAME(10, 0, WIDTH - 20, 30)];
    remindLabel.text = NSLocalizedString(@"商品图片(第一张会默认为封面)", nil);
    remindLabel.textColor = HEX(@"666666", 1.0);
    remindLabel.font = FONT(14);
    [self addSubview:remindLabel];
    imgBackView = [[UIView alloc] init];
    imgBackView.backgroundColor = HEX(@"f5f5f5", 1.0f);
    [self addSubview:imgBackView];
    
    
}

- (void)setDataModel:(DeliveryProductCellOneAddModel *)dataModel
{
    _dataModel = dataModel;
    imgBackView.frame = FRAME(0, 30, WIDTH, DeliveryProductModifyCellOne_height - 30);
    for (UIView *view in imgBackView.subviews) {
        [view removeFromSuperview];
    }
    NSInteger img_count = dataModel.imgArray.count;
    for (int i = 0; i<img_count; i++) {
        PhotoIV *tem_iv = [[PhotoIV alloc] init];
        NSInteger a = i/4;
        NSInteger b = i%4;
        tem_iv.frame = FRAME(imgWidth * b,imgWidth * a, imgWidth, imgWidth);
        tem_iv.tag = 100+i;
        [imgBackView addSubview:tem_iv];
    }
    //添加最后的按钮
    self.addBtn = [[UIButton alloc] initWithFrame:FRAME(imgWidth*(img_count%4),imgWidth*(img_count/4),imgWidth, imgWidth)];
    [self.addBtn setImage:IMAGE(@"Delivery_pic_add") forState:(UIControlStateNormal)];
    [imgBackView addSubview:self.addBtn];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}

+ (CGFloat)getHeight:(NSInteger)count
{
    NSInteger a = (count + 2) / 4;
    if ((count + 1) %4 == 0) {
        DeliveryProductModifyCellOne_height = WIDTH/4 * a + 30;
    }else{
        DeliveryProductModifyCellOne_height = WIDTH/4 * (a+1) + 30;
    }
    return DeliveryProductModifyCellOne_height;
}
@end



@implementation PhotoIV

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
    
    self.cancelBtn = [UIButton new];
    [self addSubview:_cancelBtn];
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_right).with.offset(-20);
        make.right.equalTo(self);
        make.top.equalTo(self);
        make.bottom.equalTo(self.mas_top).with.offset(20);
    }];
    [_cancelBtn setImage:IMAGE(@"Delivery_pic_delete") forState:(UIControlStateNormal)];
    [_cancelBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 5, 5, 0)];
}

@end
