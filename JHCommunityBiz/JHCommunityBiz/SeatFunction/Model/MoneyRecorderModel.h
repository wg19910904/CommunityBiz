//
//  MoneyRecorderModel.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/10/11.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MoneyRecorderModel : NSObject
+(MoneyRecorderModel *)creatMoneyRecorderModelWithDic:(NSDictionary *)dic;
-(id)initWithDic:(NSDictionary *)dic;
@property(nonatomic,copy)NSString *amount;//金额
@property(nonatomic,copy)NSString *type;//支付方式
@property(nonatomic,copy)NSString *time;//支付时间
@property(nonatomic,copy)NSString *date;//支付日期
@property(nonatomic,copy)NSString *order_type;//支付类型
@property(nonatomic,strong)UIImage *image;//图片
@property(nonatomic,copy)NSString *po_id;
@property(nonatomic,copy)NSString *type_code;

@end
