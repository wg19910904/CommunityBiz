//
//  JHOrderMessage.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/10.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBaseVC.h"
@protocol JHOrderMessageDelegate<NSObject>
@optional
-(void)refresh;
@end
@interface JHOrderMessage :JHBaseVC
@property(nonatomic,retain)NSMutableArray * infoArray;
@property(nonatomic,assign)id<JHOrderMessageDelegate>delegate;
@end
