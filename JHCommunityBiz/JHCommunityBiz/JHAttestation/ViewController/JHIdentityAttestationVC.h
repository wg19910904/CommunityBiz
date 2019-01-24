//
//  JHIdentityAttestationVC.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/24.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHBaseVC.h"
typedef NS_ENUM(NSInteger,JHAttesstationType){
    EJHAttesstationTypeSubmit = -1,//待提交
    EJHAttesstationTypeVerity ,//正在审核
    EJHAttesstationTypeCompletion,//审核通过
    EJHAttesstationTypeFail //审核失败
};
@interface JHIdentityAttestationVC : JHBaseVC<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic,assign)JHAttesstationType type;
@property(nonatomic,copy)NSString *  id_name;//姓名
@property(nonatomic,copy)NSString *  id_number;//省份证号
@property(nonatomic,copy)NSString *  id_photo;//省份证证件照
@property(nonatomic,copy)NSString *  shop_photo;//店铺照片
@end
