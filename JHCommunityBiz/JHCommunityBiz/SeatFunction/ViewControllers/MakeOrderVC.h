//
//  MakeOrderVC.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/9/30.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHBaseVC.h"

@interface MakeOrderVC : JHBaseVC
@property(nonatomic,assign)BOOL isPaidui;//是否是排队
@property(nonatomic,copy)NSString *paidui_id;//排队号
@property(nonatomic,copy)void(^(myBlcok))(void);
@end
