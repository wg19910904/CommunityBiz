//
//  JHTuangouProductManageCell.h
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/31.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHTuangouProductManagerModel.h"
typedef NS_ENUM(NSInteger, ETuangouProductCellType)
{
    ETuangouProductCellTypeShelied = 0, //已上架
    ETuangouProductCellTypeNotShelied,  //未上架
    ETuangouProductCellTypeOverdue      //已过期
};
@interface JHTuangouProductManageCell : UITableViewCell
@property(nonatomic,retain) JHTuangouProductManagerModel * model;
@property(nonatomic,assign)ETuangouProductCellType cellType;
@property(nonatomic,strong)UIView *back_view;
@property(nonatomic,strong)UIButton *modifyBtn;
@property(nonatomic,strong)UIButton *shelfBtn;
@property(nonatomic,strong)UIButton *OffBtn;
@property(nonatomic,strong)UIButton *delayBtn;
@property(nonatomic,copy)NSDictionary *dataDic;
/**
 *  外部传入的导航控制器
 */
@property(nonatomic,weak)UINavigationController *navVC;
@end
