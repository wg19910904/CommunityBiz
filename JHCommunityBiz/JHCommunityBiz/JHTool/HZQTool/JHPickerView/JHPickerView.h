//
//  JHPickerView.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/20.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHPickerView : UIControl<UIPickerViewDataSource,UIPickerViewDelegate>
@property(nonatomic,copy)void(^block)(NSInteger selected1,NSInteger selected2,NSString * result);
@property(nonatomic,copy)void(^block1)(NSString * result);
/**
 *   两列联动的情况
 *
 *  @param array1  父类数组
 *  @param array2  子类数字
 *  @param Row1    上次选中的第一个区的
 *  @param Row2    上次选中的第二个区的
 *  @param myBlock 回调
 */
-(void)showPickerViewWithArray1:(NSMutableArray *)array1 withArray2:(NSMutableArray *)array2 withSelectedRow1:(NSInteger )Row1 withSelectedRow2:(NSInteger )Row2 withBlock:(void(^)(NSInteger selected1,NSInteger selected2,NSString * result))myBlock;
/**
 *  一列的情况
 *
 *  @param data_array 数据
 *  @param myBlock    回调
 */
-(void)showpickerViewWithArray:(NSMutableArray *)data_array withBlock:(void(^)(NSString * result))myBlock;
-(void)showpickerViewWithArray:(NSMutableArray *)data_array withSelectedText:(NSString *)text withBlock:(void(^)(NSString * result))myBlock;
/**
 *  三列的情况
 *
 *  @param data_array 数据(数组中包含三个小数组)
 *  @param myBlock    回调
 */
-(void)showpickerViewWithDataArray:(NSMutableArray *)data_array  withBlock:(void(^)(NSString * result))myBlock;
/**
 *  两列不联动的情况
 *
 *  @param array1  传时的数组
 *  @param array2  传分的数组
 *  @param myBlock 回调
 */
-(void)showPickerViewWithArray1:(NSMutableArray *)array1 withArray2:(NSMutableArray *)array2  withBlock:(void (^)( NSString * result))myBlock;
@end
