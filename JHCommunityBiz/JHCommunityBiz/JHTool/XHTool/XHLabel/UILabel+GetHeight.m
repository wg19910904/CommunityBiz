//
//  UILabel+GetHeight.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/24.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "UILabel+GetHeight.h"

@implementation UILabel (GetHeight)
/*
 *return size
 *
 */
- (CGSize)getLabelFitHeight:(UILabel *)label  withFont:(UIFont *)font
{
    CGFloat width = label.frame.size.width;     //width : UILable的宽度
    CGSize size = CGSizeMake(width, MAXFLOAT);
    label.lineBreakMode = NSLineBreakByWordWrapping;
    
    //自动换行
    label.numberOfLines = 0;
    CGSize textRealSize;
    textRealSize = [label.text boundingRectWithSize:size
                                            options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                         attributes:@{NSFontAttributeName:font}
                                            context:nil].size;
    textRealSize = CGSizeMake(textRealSize.width + 6, textRealSize.height);
    //返回适应后的高
    return textRealSize;
}
@end
