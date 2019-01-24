//
//  JHPeiTimeVC.h
//  JHCommunityBiz
//
//  Created by jianghu1 on 17/2/6.
//  Copyright © 2017年 com.jianghu. All rights reserved.
//

#import "JHBaseVC.h"
typedef void(^JHPeiTimeVC_TimeBlock) (NSArray *timeArr);
@interface JHPeiTimeVC : JHBaseVC
@property(nonatomic,retain)NSMutableArray *timeArr;
@property(nonatomic,copy)JHPeiTimeVC_TimeBlock timeBlock;
@end
