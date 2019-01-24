//
//  JHTuanProductDescVC.h
//  JHCommunityBiz
//
//  Created by jianghu2 on 16/11/28.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHBaseVC.h"

@interface JHTuanProductDescVC : JHBaseVC
@property (nonatomic,copy)NSString *htmlStr;
@property (nonatomic,copy)void(^activityInfoBlock)(NSString *htmlStr);
@end
