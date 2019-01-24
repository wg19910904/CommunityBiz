//
//  JHAddAndEditPeiTimeVC.h
//  JHCommunityBiz
//
//  Created by jianghu1 on 17/2/6.
//  Copyright © 2017年 com.jianghu. All rights reserved.
//

#import "JHBaseVC.h"
typedef void (^TimeBlock)(NSString *stime,NSString *ltime);
@interface JHAddAndEditPeiTimeVC : JHBaseVC
@property(nonatomic,copy)NSString *STime;
@property(nonatomic,copy)NSString *ETime;
@property(nonatomic,copy)TimeBlock timeBlock;
@end
