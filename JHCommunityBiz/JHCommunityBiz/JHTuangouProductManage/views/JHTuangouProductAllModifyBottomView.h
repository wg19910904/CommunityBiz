//
//  JHTuangouProductAllModifyBottomView.h
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/31.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, ETuangouProductAllModifyType)
{
    ETuanStatusShelf = 0, //已上架
    ETuanStatusNotShelf,  //未上架
    ETuanStatusOverdue    //已过期
};
@interface JHTuangouProductAllModifyBottomView : UIView
@property(nonatomic,assign)ETuangouProductAllModifyType bottomViewType;
@property(nonatomic,retain)UIButton *selectAllBtn;//全选
@property(nonatomic,retain)UIButton *shelfBtn;//上架
@property(nonatomic,retain)UIButton *outShelfBtn;//下架
@property(nonatomic,retain)UIButton *delayBtn;//延期
@end
