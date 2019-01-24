//
//  JHBankDetailModel.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/7/22.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHBankDetailModel : NSObject
+(JHBankDetailModel * )creatJHBankDetailModelWithDic:(NSDictionary *)dic;
-(id)initWithDictionary:(NSDictionary *)dic;
@property(nonatomic,copy)NSString * account_name;//账户姓名
@property(nonatomic,copy)NSString * account_number;//账号
@property(nonatomic,copy)NSString * account_type;//账户类型
@property(nonatomic,copy)NSString * account_branch;//开户支行
@property(nonatomic,copy)NSString * shop_id;//商户id
@end
