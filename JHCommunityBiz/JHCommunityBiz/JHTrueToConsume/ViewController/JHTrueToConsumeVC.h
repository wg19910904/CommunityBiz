//
//  JHTrueToConsumeVC.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/25.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHBaseVC.h"

@interface JHTrueToConsumeVC : JHBaseVC<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,retain)NSDictionary * dictionary;
@property(nonatomic,assign)BOOL isFromTuanOrderDetai;
@end
