//
//  JHPreferentiaDetailVC.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/26.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHBaseVC.h"

@interface JHPreferentiaDetailVC : JHBaseVC<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,assign)BOOL isPhoto;
@property(nonatomic,copy)NSString * type;
@property(nonatomic,copy)NSString * order_id;//上个界面需要传的唯一订单号
@end
