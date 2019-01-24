//
//  JHGroupScanControl.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/25.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHGroupScanControl : UIControl<UITextFieldDelegate>
@property(nonatomic,copy)void(^resultBlock)(NSDictionary * dictionary);
@property(nonatomic,copy)void(^sweepBlock)(NSDictionary * dictionary);
+(void)showJHGroupScanControlWithNav:(UINavigationController *)nav withBlock:(void(^)(NSDictionary * dic))myBlock withSweepBlock:(void(^)(NSDictionary * dic))sweepBlock;
-(void)creatJHGroupScanControlWith:(JHGroupScanControl *)control;
@end
