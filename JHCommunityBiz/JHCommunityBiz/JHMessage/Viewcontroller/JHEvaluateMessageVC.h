//
//  JHEvaluateMessageVC.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/10.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHBaseVC.h"
typedef void(^evaluateBlock)(void);
@interface JHEvaluateMessageVC : JHBaseVC
@property(nonatomic,copy)evaluateBlock  myBlock;
@property(nonatomic,retain)NSMutableArray * infoArray;
@end
