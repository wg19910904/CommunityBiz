//
//  JHOriginImage.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/24.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHOriginImage : UIControl
@property(nonatomic,copy)void(^block)(void);
-(void)showWithImage:(UIImage *)image withBlock:(void(^)(void))myBlock;
@end
