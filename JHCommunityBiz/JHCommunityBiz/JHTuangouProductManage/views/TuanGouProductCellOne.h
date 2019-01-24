//
//  TuanGouProductCellOne.h
//  JHCommunityBiz
//
//  Created by xixixi on 16/6/1.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PhotoIV1;
@interface TuanGouProductCellOne : UITableViewCell
@property(nonatomic,copy)NSDictionary *dataDic;
@property(nonatomic,retain)PhotoIV1 * tem_iv;
//获取高度
+ (CGFloat)getHeight:(NSInteger)count;
@end



@interface PhotoIV1 : UIView
@property(nonatomic,strong)UIImageView *img;
//@property(nonatomic,strong)UIButton *cancelBtn;
@end