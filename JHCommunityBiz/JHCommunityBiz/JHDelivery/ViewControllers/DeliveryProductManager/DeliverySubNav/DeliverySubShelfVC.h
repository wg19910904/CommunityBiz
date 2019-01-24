//
//  DeliverySubShelfVC.h
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/26.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHBaseVC.h"
typedef void(^Refresh)(NSDictionary *);
//回调所选title
typedef void(^RefreshBtnTitleBlock)(NSString *btnTitle);
@interface DeliverySubShelfVC : JHBaseVC
@property(nonatomic,copy)RefreshBtnTitleBlock refreshBtnTitleBlock;
@property(nonatomic, strong)UITableView *mainTableView;
@property(nonatomic, copy)Refresh refreshBlock;
@end
