//
//  JHReplyCell.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/13.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHEvaluteModel.h"
#import <Masonry.h>
#import "StarView.h"
#import "DisplayImageInView.h"
#import "MyTapGestureRecognizer.h"
@interface JHReplyCell : UITableViewCell
@property(nonatomic,assign)float height;
@property(nonatomic,copy)NSString * face;//用户头像
@property(nonatomic,copy)NSString * nickname;//用户昵称
@property(nonatomic,copy)NSString * score;//评价的星星数
@property(nonatomic,copy)NSString * score_fuwu;//评价的星星数
@property(nonatomic,copy)NSString * score_kouwei;//评价的星星数
@property(nonatomic,copy)NSString * time_pei;//送达时间
@property(nonatomic,copy)NSString * content;//评价的内容
@property(nonatomic,copy)NSString * dateline;
@property(nonatomic,copy)NSString * pei_time_label;
@property(nonatomic,retain)NSMutableArray * photoArray;//存放图片的数组

@end
