//
//  JHSetStatusVC.h
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/17.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHBaseVC.h"
typedef void(^JHPeiTimeVC_TimeBlock) (NSArray *timeArr);
@interface JHSetStatusVC : JHBaseVC
@property(nonatomic,retain)NSMutableArray *timeArr;
@property(nonatomic,copy)JHPeiTimeVC_TimeBlock timeBlock;
@end
