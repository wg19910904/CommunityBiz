//
//  JHPhotoCollectionCellModel.h
//  JHCommunityBiz
//
//  Created by jianghu1 on 16/8/29.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHPhotoCollectionCellModel : NSObject
@property(nonatomic,assign)NSInteger status; //0为非编辑状态,1为编辑未选中,2为编辑选中
@property(nonatomic,copy)NSString *url;
@property(nonatomic,copy)NSString *photo_id;
@end
