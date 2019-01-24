//
//  JHPhotoCollectionCell.m
//  JHCommunityClient
//
//  Created by xixixi on 16/3/8.
//  Copyright © 2016年 JiangHu. All rights reserved.
//

#import "JHPhotoCollectionCell.h"
#import <UIImageView+WebCache.h>
@implementation JHPhotoCollectionCell
{
    //cell的宽 高
    CGFloat width;
    CGFloat height;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self =  [super initWithFrame:frame];
    if (self) {
        width = CGRectGetWidth(frame);
        height = CGRectGetHeight(frame);
        //添加子视图
        [self addSubviews];
    }
    return self;
}
#pragma mark - 添加子视图
- (void)addSubviews
{
    self.iv = [UIImageView new];
    self.iv.frame = FRAME(0, 0, width, height);
    [self addSubview:_iv];
  
    self.indicateIV = [[UIImageView alloc] initWithFrame:FRAME(width - 40, 5, 35, 35)];
    [self.indicateIV setHighlightedImage:IMAGE(@"Delivery_selected")];
    [self.indicateIV setImage:IMAGE(@"select_no")];
    self.indicateIV.userInteractionEnabled = YES;
    [self addSubview:_indicateIV];
    
}
- (void)setDataModel:(JHPhotoCollectionCellModel *)dataModel
{
    _dataModel = dataModel;
    NSString *url = dataModel.url;
    NSInteger status = dataModel.status;
    if (status == 0) {
        self.indicateIV.hidden = YES;
    }else if (status == 1){
        self.indicateIV.hidden = NO;
        [self.indicateIV setHighlighted:NO];
    }else{
        self.indicateIV.hidden = NO;
        [self.indicateIV setHighlighted:YES];
    }
     NSURL *url2 = [NSURL URLWithString:[IMAGEADDRESS stringByAppendingString:url]];
    [self.iv sd_setImageWithURL:url2 placeholderImage:nil];
    _iv.contentMode = 2;
    _iv.clipsToBounds =YES;
}

- (void)setHighlighted:(BOOL)highlighted
{
    BOOL highted_indicate = self.indicateIV.highlighted;
    [super setHighlighted:highlighted];
    self.indicateIV.highlighted = highted_indicate;
}
- (void)setSelected:(BOOL)selected
{
    BOOL highted_indicate = self.indicateIV.highlighted;
    [super setSelected:selected];
    self.indicateIV.highlighted = highted_indicate;
}
@end
