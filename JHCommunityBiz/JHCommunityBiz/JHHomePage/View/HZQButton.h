//
//  HZQButton.h
//  JHLive
//
//  Created by ijianghu on 16/8/18.
//  Copyright © 2016年 ijianghu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HZQButton : UIButton
/**
 *
 *
 *  @param size  size
 *  @param num   闯过来的数字
 *  @param image 需要的图片
 *  @param title 文本
 *
 *  @return 
 */
-(id)initWithSize:(CGSize)size
          withNum:(NSInteger)num
        withImage:(UIImage *)image
        withTitle:(NSString *)title;
@end
