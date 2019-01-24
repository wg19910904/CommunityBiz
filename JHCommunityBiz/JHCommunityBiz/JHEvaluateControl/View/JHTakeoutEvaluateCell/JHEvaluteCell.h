//
//  JHEvaluteCell.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/13.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHEvaluteModel.h"
@interface JHEvaluteCell : UITableViewCell
@property(nonatomic,retain)JHEvaluteModel * model;
@property(nonatomic,retain)NSIndexPath * indexPath;
@property(nonatomic,assign)float height_evaluate;
@property(nonatomic,assign)float height_reply;
@property(nonatomic,retain)UIButton * btn_reply;
+(CGFloat)getHeightWithModel:(JHEvaluteModel *)model;
@end
