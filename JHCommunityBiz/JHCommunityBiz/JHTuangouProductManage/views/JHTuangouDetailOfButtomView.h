//
//  JHTuangouDetailOfButtomView.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/7/16.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,ETuangouProductAllModifyType){
    ETuanStatusShelf = 0, //已上架
    ETuanStatusNotShelf,  //未上架
    ETuanStatusOverdue    //已过期

};
@interface JHTuangouDetailOfButtomView : UIView
@property(nonatomic,assign)ETuangouProductAllModifyType buttomViewType;
@property(nonatomic,retain)UIButton *shelfBtn;//上架或者下架的按钮
@property(nonatomic,retain)UIButton *deleteBtn;//删除
@end
