//
//  JHComplainMessageVC.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/10.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHBaseVC.h"
typedef void(^refreshkBlock)(void);
@interface JHComplainMessageVC : JHBaseVC
@property(nonatomic,copy)refreshkBlock myBlock;
@property(nonatomic,retain)NSMutableArray * infoArray;
@end
