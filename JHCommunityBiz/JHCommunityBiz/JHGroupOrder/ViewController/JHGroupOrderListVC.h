//
//  JHGroupOrderListVC.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/28.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHBaseVC.h"
@interface JHGroupOrderListVC : JHBaseVC<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,assign)BOOL isShaiXuan;
- (void)reloadTableViewCondition:(NSMutableDictionary *)condition;
@end
