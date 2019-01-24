//
//  XHChoosePhoto.h
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/20.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^GetImageBlock)(UIImage *,NSData *);
@interface XHChoosePhoto : UIViewController
<UIImagePickerControllerDelegate,
UINavigationControllerDelegate>
@property(nonatomic,assign)CGSize scaleSize;
/**
 *  选择的某张照片
 */
@property(nonatomic,strong)UIImage *selectedImage;
/**
 *  选择的某张照片的二进制数据
 */
@property(nonatomic,strong)NSData *imgData;
/**
 *  选择照片后的回调
 */
@property(nonatomic,copy)GetImageBlock getImageBlock;
/**
 *  开始选择照片
 */
- (void)startChoosePhoto;
/**
 *  开始拍照
 */
- (void)startTakePhoto;
@end
