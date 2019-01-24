//
//  QRCodeListModel.h
//  JHCommunityBiz
//
//  Created by ijianghu on 2017/11/18.
//  Copyright © 2017年 com.jianghu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QRCodeListModel : NSObject
@property(nonatomic,strong)NSString *amount;
@property(nonatomic,strong)NSString *clientip;
@property(nonatomic,strong)NSString *closed;
@property(nonatomic,strong)NSString *dateline;
@property(nonatomic,strong)NSString *decca_id;
@property(nonatomic,strong)NSString *money;
@property(nonatomic,strong)NSString *shop_id;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *type;
+(QRCodeListModel *)getDataWithDic:(NSDictionary *)dic;
-(instancetype)initWithDic:(NSDictionary *)dic;
@end
