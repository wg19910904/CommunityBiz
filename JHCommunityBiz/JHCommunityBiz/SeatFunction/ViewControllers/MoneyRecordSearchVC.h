//
//  MoneyRecordSearchVC.h
//  JHCommunityBiz
//
//  Created by ijianghu on 2017/11/11.
//  Copyright © 2017年 com.jianghu. All rights reserved.
//

#import "JHBaseVC.h"

@interface MoneyRecordSearchVC : JHBaseVC
@property(nonatomic,copy)void(^clickBlock)(NSMutableDictionary *dic);
@end
