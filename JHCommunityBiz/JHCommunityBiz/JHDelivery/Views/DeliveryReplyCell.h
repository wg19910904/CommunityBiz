//
//  DeliveryReplyCell.h
//  JHCommunityBiz
//
//  Created by xixixi on 16/7/18.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ReplyRefreshBlock)(NSString *);
@interface DeliveryReplyCell : UITableViewCell<UITextViewDelegate>
@property(nonatomic,copy)ReplyRefreshBlock replyRefreshBlock;
@end
