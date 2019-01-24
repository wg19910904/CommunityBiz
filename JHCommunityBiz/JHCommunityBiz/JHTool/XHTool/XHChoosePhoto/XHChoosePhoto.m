//
//  XHChoosePhoto.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/20.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "XHChoosePhoto.h"

@implementation XHChoosePhoto
{
    UIImagePickerController *imagePicker;
}
- (instancetype)init
{
    self = [super init];
    if (!self) {
        self = [super init];
    }
    return self;
}

- (void)startChoosePhoto
{
    imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.navigationBar.barTintColor = THEME_COLOR;
    imagePicker.navigationBar.translucent = NO;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:imagePicker
                       animated:YES
                     completion:nil];
}
- (void)startTakePhoto
{
    imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.navigationBar.barTintColor = THEME_COLOR;
    imagePicker.navigationBar.translucent = NO;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:imagePicker
                       animated:YES
                     completion:nil];
}
#pragma  mark - 选择照片完成
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo{
    NSLog(@"选择照片已经完成");
}
#pragma mark - 选择某张照片时
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    if (imagePicker.allowsEditing) {
        _selectedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    }else{
        _selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    _selectedImage = [self scaleFromImage:_selectedImage scaledToSize:_scaleSize];
    _imgData = UIImagePNGRepresentation(_selectedImage);
    _getImageBlock(_selectedImage,_imgData);
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 点击取消
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  压缩照片
 */
#pragma mark - 压缩照片
//压缩图片
- (UIImage*)scaleFromImage:(UIImage*)img scaledToSize:(CGSize)newSize

{
    CGSize imageSize = img.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    if (width <= newSize.width && height <= newSize.height){
        return img;
    }
    if (width == 0 || height == 0){
        return img;
    }
    CGFloat widthFactor = newSize.width / width;
    CGFloat heightFactor = newSize.height / height;
    CGFloat scaleFactor = (widthFactor<heightFactor?widthFactor:heightFactor);
    CGFloat scaledWidth = width * scaleFactor;
    CGFloat scaledHeight = height * scaleFactor;
    CGSize targetSize = CGSizeMake(scaledWidth,scaledHeight);
    UIGraphicsBeginImageContext(targetSize);
    [img drawInRect:CGRectMake(0,0,scaledWidth,scaledHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
