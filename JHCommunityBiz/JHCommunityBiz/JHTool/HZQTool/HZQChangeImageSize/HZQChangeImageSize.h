//
//  HZQChangeImageSize.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/7/18.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HZQChangeImageSize : NSObject
+(UIImage * )scaleFromImage:(UIImage*)img scaledToSize:(CGSize)newSize;
@end
