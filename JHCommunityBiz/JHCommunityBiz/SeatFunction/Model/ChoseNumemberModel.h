//
//  ChoseNumemberModel.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/10/8.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChoseNumemberModel : NSObject
+(ChoseNumemberModel *)shareChoseNumemberModelWithDic:(NSDictionary *)dic;
-(id)initWithDic:(NSDictionary *)dic;
@property(nonatomic,assign)BOOL isSelecter;//是否选中
@property(nonatomic,copy)NSString *cate_id;//主类的id
@property(nonatomic,copy)NSString *shop_id;//城市id
@property(nonatomic,copy)NSString *title;//主类的名字
@property(nonatomic,retain)NSMutableArray * childrenModelArray;//存放model类
@end
@interface childrenModel : NSObject
+(childrenModel *)creatChildrenWithDic:(NSDictionary *)dic;
-(id)initWithDic:(NSDictionary *)dic;
@property(nonatomic,copy)NSString *cate_id;
@property(nonatomic,copy)NSString *number;
@property(nonatomic,copy)NSString *zhuohao_id;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,assign)BOOL isSelecter;//是否选中
@end