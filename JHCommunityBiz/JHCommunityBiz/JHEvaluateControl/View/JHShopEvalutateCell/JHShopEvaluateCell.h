//
//  JHShopEvaluateCell.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/25.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHShopEvaluateModel.h"
@interface JHShopEvaluateCell : UITableViewCell
@property(nonatomic,retain)JHShopEvaluateModel * model;
@property(nonatomic,retain)NSIndexPath * indexPath;
@property(nonatomic,assign)float height_evaluate;
@property(nonatomic,assign)float height_reply;
@property(nonatomic,retain)UIButton * btn_reply;
@end
