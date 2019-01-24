//
//  JhTuanGouProductRuleVC.h
//  JHCommunityBiz
//
//  Created by xixixi on 16/6/1.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHBaseVC.h"
typedef void(^completionBlock)(NSString * result);
@interface JhTuanGouProductRuleVC : JHBaseVC
@property(nonatomic,copy)completionBlock block;
@property(nonatomic,copy)NSString * notice;
@end
