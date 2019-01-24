//
//  ReconderSearchInputCell.h
//  JHCommunityBiz
//
//  Created by ijianghu on 2017/11/11.
//  Copyright © 2017年 com.jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReconderSearchInputCell : UITableViewCell
@property(nonatomic,strong)UITextField *inputText;
@property(nonatomic,copy)void(^searchBlock)();
@end
