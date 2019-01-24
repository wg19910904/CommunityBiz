//
//  JHGroupChitRecordModel.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/25.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHGroupChitRecordModel : NSObject
+(JHGroupChitRecordModel * )creatJHGroupChitRecordModelWithDictionary:(NSDictionary *)dic;
-(id)initWithDictionary:(NSDictionary *)dic;
@property(nonatomic,copy)NSString * count;
@property(nonatomic,copy)NSString * dateline;
@property(nonatomic,copy)NSString * ltime;
@property(nonatomic,copy)NSString * number;
@property(nonatomic,copy)NSString * order_id;
@property(nonatomic,copy)NSString * price;
@property(nonatomic,copy)NSString * shop_id;
@property(nonatomic,copy)NSString * status;
@property(nonatomic,copy)NSString * ticket_id;
@property(nonatomic,copy)NSString * title;
@property(nonatomic,copy)NSString * tuan_id;
@property(nonatomic,copy)NSString * type;
@property(nonatomic,copy)NSString * uid;
@property(nonatomic,copy)NSString * use_time;

@end
