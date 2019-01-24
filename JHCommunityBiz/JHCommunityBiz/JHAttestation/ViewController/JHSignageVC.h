//
//  JHSignageVC.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/23.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHBaseVC.h"
typedef  NS_ENUM(NSInteger,JHSignageType){
    EJHSignageTypeSubmit = -1,//待提交
    EJHSignageTypeVerity ,//正在审核
    EJHSignageTypeCompletion,//审核通过
    EJHSignageTypeFail //审核失败
};
@interface JHSignageVC : JHBaseVC<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic,assign)JHSignageType type;
@property(nonatomic,copy)NSString *  company_name;//公司名称
@property(nonatomic,copy)NSString *  yz_number;//工商注册号
@property(nonatomic,copy)NSString *  yz_photo;//个体共商户照片
@end
