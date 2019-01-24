//
//  JHOpenShopCellTwo.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/17.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHOpenShopCellTwo : UITableViewCell
@property(nonatomic,retain)NSMutableArray * textFieldArray;//输入框的数组
@property(nonatomic,retain)UIButton * btn_type;//点击获取店铺类型的方法
@property(nonatomic,retain)UIButton * btn_address;//点击进入地图界面的方法
@end
