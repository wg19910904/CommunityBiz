//
//  JHShopReplyVC.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/25.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHBaseVC.h"
typedef void(^successBlock)(void);
@interface JHShopReplyVC : JHBaseVC
@property(nonatomic,assign)BOOL isPhoto;//是否有照片;
@property(nonatomic,copy)NSString * comment_id;
@property(nonatomic,copy)NSString * headUrl;
@property(nonatomic,copy)NSString * name;
@property(nonatomic,copy)NSString * score;
@property(nonatomic,copy)NSString * dateline;
@property(nonatomic,copy)NSString * evaluate;
@property(nonatomic,retain)NSMutableArray  * photoArray;
@property(nonatomic,copy)successBlock myBlock;
@property(nonatomic,assign)BOOL isFromOrderDetail;
@end
