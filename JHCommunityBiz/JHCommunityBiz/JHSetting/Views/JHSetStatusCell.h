//
//  JHSetStatusCell.h
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/17.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^StatusBlock)(NSInteger);
@interface JHSetStatusCell : UITableViewCell
@property(nonatomic,strong)UIButton *on_btn;
@property(nonatomic,strong)UIButton *busy_btn;
@property(nonatomic,strong)UIButton *off_btn;
@property(nonatomic,copy)StatusBlock statusBlock;
@property(nonatomic,assign)NSInteger statusCode;
/**
 *  外部默认状态调用的点击方法
 *
 *  @param sender 传入的Btn
 */
- (void)cilckBtn:(UIButton *)sender;
@end
