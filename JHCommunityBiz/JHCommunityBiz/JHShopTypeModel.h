//
//  JHShopTypeModel.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/6/24.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHShopTypeModel : NSObject
+(JHShopTypeModel *)shareShopTypeModel;
@property(nonatomic,retain)NSMutableArray * fatherArray;
@property(nonatomic,retain)NSMutableArray * children;
@property(nonatomic,retain)NSMutableArray * fatherArray_cateID;
@property(nonatomic,retain)NSMutableArray * children_cateID;
@end
