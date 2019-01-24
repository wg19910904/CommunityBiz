//
//  JHGroupListCompletionVC.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/28.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHBaseVC.h"

@interface JHGroupListCompletionVC : JHBaseVC<UITableViewDataSource,UITableViewDelegate>
- (void)reloadTableViewCondition:(NSMutableDictionary *)condition;
@end
