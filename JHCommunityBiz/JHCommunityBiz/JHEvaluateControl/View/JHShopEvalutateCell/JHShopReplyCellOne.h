//
//  JHShopReplyCellOne.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/25.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHShopEvaluateModel.h"
#import <Masonry.h>
#import "StarView.h"
#import "DisplayImageInView.h"
#import "MyTapGestureRecognizer.h"
#import <UIImageView+WebCache.h>
#import "HZQChangeDateLine.h"
@interface JHShopReplyCellOne : UITableViewCell
@property(nonatomic,assign)float height;
@property(nonatomic,assign)BOOL isPhoto;
@property(nonatomic,retain)NSMutableArray * photoArray;
@property(nonatomic,copy)NSString * headUrl;
@property(nonatomic,copy)NSString * name;
@property(nonatomic,copy)NSString * score;
@property(nonatomic,copy)NSString * evaluate;
@property(nonatomic,copy)NSString * evaluate_time;
@end
