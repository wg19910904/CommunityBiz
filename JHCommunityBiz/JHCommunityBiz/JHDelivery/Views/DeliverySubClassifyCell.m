//
//  DeliveryClassifyCell.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/23.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "DeliverySubClassifyCell.h"

@implementation DeliverySubClassifyCell
{
    UILabel *_titleLabel;
    UIButton *_editBtn;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    }
    self.backgroundColor = [UIColor whiteColor];
    //添加控件
    [self makeUI];
    return self;
}
#pragma mark - 添加子控件
- (void)makeUI
{
    _titleLabel = [[UILabel alloc] initWithFrame:FRAME(10, 0,112, 44)];
    _titleLabel.font = FONT(14);
    _titleLabel.textColor = HEX(@"333333", 1.0f);
    _editBtn = [[UIButton alloc] initWithFrame:FRAME(WIDTH - 64, 0, 64, 44)];
    [_editBtn setImage:IMAGE(@"Delivery_bi") forState:(UIControlStateNormal)];
    _editBtn.imageEdgeInsets = UIEdgeInsetsMake(11, 22, 11, 22);
    [self addSubview:_titleLabel];
    [self addSubview:_editBtn];
}
- (void)setDataModel:(DeliverySubClassifyDetailModel *)dataModel
{
    _dataModel = dataModel;
    _titleLabel.text = dataModel.title;
}
@end
