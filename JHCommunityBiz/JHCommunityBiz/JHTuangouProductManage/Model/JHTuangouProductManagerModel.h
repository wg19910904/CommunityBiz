//
//  JHTuangouProductManagerModel.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/7/12.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHTuangouProductManagerModel : NSObject
+(JHTuangouProductManagerModel *)creatJHTuangouProductManagerModelWithDic:(NSDictionary *)dic;
-(id)initWithDictionary:(NSDictionary *)dic;
@property(nonatomic,copy)NSString * dateline;//创建时间
@property(nonatomic,copy)NSString * is_onsale;//是否上架
@property(nonatomic,copy)NSString * ltime;//活动截止时间
@property(nonatomic,copy)NSString * stime;//活动开始时间时间
@property(nonatomic,copy)NSString * market_price;//市场价
@property(nonatomic,copy)NSString * price;//团购价
@property(nonatomic,copy)NSString * title;//标题
@property(nonatomic,copy)NSString * photo;//图标
@property(nonatomic,copy)NSString * stock_num;//库存
@property(nonatomic,copy)NSString * sales;//库存
@property(nonatomic,copy)NSString * stock_type;//判断是否有库存
@property(nonatomic,copy)NSString * type;//判断状态的
@property(nonatomic,copy)NSString * tuan_id;//判断状态的
@end
