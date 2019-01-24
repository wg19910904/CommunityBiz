//
//  JHShopInDoorVC.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/24.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHBaseVC.h"
typedef NS_ENUM(NSInteger,JHServiceLicenseType){
    EJHServiceLicenseTypeSubmit = -1,//提交
    EJHServiceLicenseTypeVerify,//审核中
    EJHServiceLicenseTypeCompletion,//审核完成
    EJHServiceLicenseTypeFail//失败
};
@interface JHServiceLicenseVC : JHBaseVC<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic,assign)JHServiceLicenseType type;
@property(nonatomic,copy)NSString * cy_number;
@property(nonatomic,copy)NSString * cy_photo;
@end
