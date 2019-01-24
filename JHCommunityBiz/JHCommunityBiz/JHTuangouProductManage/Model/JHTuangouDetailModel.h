//
//  JHTuangouDetailModel.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/7/18.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHTuangouDetailModel : NSObject
+(JHTuangouDetailModel *)creatJHTuangouDetailModelWithDictionary:(NSDictionary *)dic;
-(id)initWithDictionary:(NSDictionary *)dic;
@property(nonatomic,copy)NSString * photo;//展示的照片的url
@property(nonatomic,copy)NSString * title;//商品名称
@property(nonatomic,copy)NSString * min_buy;//最小购买数
@property(nonatomic,copy)NSString * max_buy;//最大购买数
@property(nonatomic,copy)NSString * stock_type;//是否启用库存限购
@property(nonatomic,copy)NSString * stock_num;//库存
@property(nonatomic,copy)NSString * orderby;//排序
@property(nonatomic,copy)NSString * price;//团购价
@property(nonatomic,copy)NSString * market_price;//门市价
@property(nonatomic,copy)NSString * stime;//券开始使用时间
@property(nonatomic,copy)NSString * ltime;//券结束时间
@property(nonatomic,copy)NSString * notice;//使用规则描述
@property(nonatomic,copy)NSString * detail;//图文详情
@property(nonatomic,copy)NSString * type;//团购类型
@property(nonatomic,copy)NSString * sales;//
@property(nonatomic,copy)NSString * is_onsale;//是否上架
@property(nonatomic,copy)NSString * desc;//副标题
@end
