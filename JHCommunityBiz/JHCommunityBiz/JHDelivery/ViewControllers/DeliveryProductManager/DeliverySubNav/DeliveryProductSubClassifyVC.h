//
//  DeliverySubClassifyVC.h
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/26.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHBaseVC.h"
typedef void(^DeliveryProductSubClassifyVC_RefreshBlock)(NSDictionary *paramDic);
//回调所选title
typedef void(^RefreshBtnTitleBlock)(NSString *btnTitle);
@interface DeliveryProductSubClassifyVC : JHBaseVC
@property(nonatomic,copy)RefreshBtnTitleBlock refreshBtnTitleBlock;
@property(nonatomic, strong)UITableView *leftTable;
@property(nonatomic, strong)UITableView *rightTable;
@property(nonatomic, copy)DeliveryProductSubClassifyVC_RefreshBlock refreshBlock;
@end
