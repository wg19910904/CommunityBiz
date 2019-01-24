//
//  JHTakeTheirMsgVC.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/26.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHBaseVC.h"
typedef void(^success)(void);
@interface JHTakeTheirMsgVC : JHBaseVC<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,retain)NSDictionary * dictionary;
@property(nonatomic,copy)success completionBlock;
@end
