//
//  JHLicenseSubVC.m
//  WaimaiShop
//
//  Created by xixixi on 16/1/12.
//  Copyright © 2016年 ijianghu. All rights reserved.
//

#import "DeliveryLicenceVC.h"
#import <UIImageView+WebCache.h>
@interface DeliveryLicenceVC ()
<
UITableViewDelegate,
UITableViewDataSource,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
UIAlertViewDelegate
>
{
    UITableView *_mainTableView;
    UITextField *numField;
    UIImage *licenseImage;
    NSData *licenseImageData;
    UIImagePickerController *imagePicker;
    UIImageView *licenseIv;
    NSDictionary *verifyInfo;
}

@end

@implementation DeliveryLicenceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化必要信息
    [self initData];
    //创建表视图
    [self createMainTableView];
    //创建底部btn
    [self addBottomBtn];
}

#pragma mark - initData
- (void)initData
{
    self.view.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
    self.title = NSLocalizedString(@"餐饮许可证设置", nil);
}
#pragma mark - 初始化表视图
- (void)createMainTableView
{
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0 ,0, WIDTH, HEIGHT - 124) style:UITableViewStyleGrouped];
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
    _mainTableView.showsHorizontalScrollIndicator = NO;
    _mainTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_mainTableView];
}
#pragma mark - UITableViewDelegate and dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) return 40;
    if (indexPath.section == 1 && indexPath.row == 0) return 150;
    return 90;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }
    return 30;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 30)];
        UILabel *label1 =[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 30)];
        label1.text = NSLocalizedString(@"拍摄餐饮许可证", nil);
        label1.font = FONT(13);
        label1.textColor = [UIColor colorWithHex:@"333333" alpha:1.0];
        
        UILabel *label2 =[[UILabel alloc] initWithFrame:CGRectMake(130, 0, 140, 30)];
        label2.text = NSLocalizedString(@"(请保证所拍中文清晰)", nil);
        label2.font = FONT(13);
        label2.textColor = THEME_COLOR;
        
        [backView addSubview:label1];
        [backView addSubview:label2];
        return backView;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
        //add field
        if (!numField) {
            numField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, WIDTH - 20, 40)];
            numField.backgroundColor = [UIColor whiteColor];
            numField.leftViewMode = UITextFieldViewModeAlways;
            UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
            numField.leftView = leftView;
            numField.placeholder = NSLocalizedString(@"填写餐饮许可证号", nil);
            numField.textColor = [UIColor colorWithHex:@"333333" alpha:1.0];
            numField.font = FONT(14);

        }
        [cell addSubview:numField];
        return cell;
    }else{
        if (indexPath.row == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //添加label
            UILabel *title1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH / 2, 30)];
            title1.textColor = [UIColor colorWithHex:@"999999" alpha:1.0];
            title1.font = FONT(14);
            title1.text = NSLocalizedString(@"参考照片", nil);
            title1.textAlignment = NSTextAlignmentCenter;
            
            UILabel *title2 = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH / 2, 0, WIDTH / 2, 30)];
            title2.textColor = [UIColor colorWithHex:@"999999" alpha:1.0];
            title2.font = FONT(14);
            title2.text = NSLocalizedString(@"你的照片", nil);
            title2.textAlignment = NSTextAlignmentCenter;
            
            CGFloat width = (WIDTH - 30)/2;
            
            //添加左侧iv
            UIImageView *leftIv = [[UIImageView alloc] initWithFrame:CGRectMake(10, 30, width, 110)];
            leftIv.image = [UIImage imageNamed:@"businessLicense"];
            //添加右侧iv
            if (!licenseIv) {
                licenseIv = [[UIImageView alloc] initWithFrame:CGRectMake(width + 20, 30, width, 110)];
                [licenseIv setImage:[UIImage imageNamed:@"add290C"]];
                if ([verifyInfo[@"yz_photo"] length] > 0) {
                    NSURL *url = [NSURL URLWithString:[IMAGEADDRESS stringByAppendingString:verifyInfo[@"yz_photo"]]];
                    [licenseIv sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"add290C"]];
                }else{
                    
                    [licenseIv setImage:[UIImage imageNamed:@"add290C"]];
                }
                //添加手势
                UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                          action:@selector(tapLicenseIv:)];
                [licenseIv addGestureRecognizer:gesture];
                licenseIv.userInteractionEnabled = YES;
            }
            [cell addSubview:title1];
            [cell addSubview:title2];
            [cell addSubview:leftIv];
            [cell addSubview:licenseIv];
            return cell;

        }else{
            UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:FRAME(0, 0, WIDTH, 90)];
            cell.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
            UIButton *sureBtn =  [UIButton new];
            [cell addSubview:sureBtn];
            [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(cell).with.offset(25);
                make.left.equalTo(cell).with.offset(10);
                make.right.equalTo(cell).with.offset(-10);
                make.bottom.equalTo(cell).with.offset(-25);
            }];
            sureBtn.layer.cornerRadius = 3;
            sureBtn.layer.masksToBounds = YES;
            [sureBtn setBackgroundColor:HEX(@"faaf19", 1.0) forState:(UIControlStateNormal)];
            [sureBtn setTitle:NSLocalizedString(@"保存", nil) forState:(UIControlStateNormal)];
            [sureBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
            return cell;
        }
    }
}

#pragma mark -点击上传身份证图片
- (void)tapLicenseIv:(UITapGestureRecognizer *)gesture
{
    imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    imagePicker.navigationBar.barTintColor = THEME_COLOR;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma  mark - 这是UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo{
    NSLog(@"选择照片已经完成");
}
//选择某张图片的时候调用
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    
    if (picker.allowsEditing) {
        licenseImage = [info objectForKey:UIImagePickerControllerEditedImage];
        
    }else{
        licenseImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    //        identityIv.image = [self scaleFromImage:selectedImage scaledToSize:CGSizeMake(800, 800)];
    licenseIv.image = licenseImage;
    licenseImageData = UIImagePNGRepresentation(licenseImage);
    [picker dismissViewControllerAnimated:YES completion:nil];
}
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
//点击取消的时候调用
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 创建底部按钮
- (void)addBottomBtn
{
    UIButton *bottomBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, HEIGHT - 50, WIDTH - 20, 40)];
    [bottomBtn setBackgroundColor:[UIColor colorWithHex:@"eb6100" alpha:0.8] forState:UIControlStateHighlighted];
    [bottomBtn setBackgroundColor:[UIColor colorWithHex:@"eb6100" alpha:1.0] forState:UIControlStateNormal];
    
    [bottomBtn setTitle:NSLocalizedString(@"完成", nil) forState:UIControlStateNormal];
    [bottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [bottomBtn addTarget:self action:@selector(clickBottomBtn:) forControlEvents:UIControlEventTouchUpInside];
    bottomBtn.titleLabel.font = FONT(14);
    bottomBtn.layer.cornerRadius = 4;
    bottomBtn.layer.masksToBounds = YES;
    [self.view addSubview:bottomBtn];
}
#pragma mark - 点击底部确认添加按钮
- (void)clickBottomBtn:(UIButton *)sender
{
//    NSDictionary *dic = @{@"yz_number":numField.text};
//    NSDictionary *imageDataDic = licenseImageData ? @{@"yz_photo":licenseImageData} : @{};
//    SHOW_HUD
//    [WMHttpTool postWithAPI:@"biz/verify/yyzz"
//                     params:dic
//              formDataArray:imageDataDic
//                    success:^(id json) {
//                        NSLog(@"%@",json);
//                        HIDE_HUD
//                        if ([json[@"error"] integerValue] == 0) {
//                            [self showAlertWithMsg:NSLocalizedString(@"修改成功", nil)];
//                            
//                            //请求biz/info接口获取最新的信息
//                            [WMHttpTool postWithAPI:@"biz/verify" withParams:@{} success:^(id json) {
//                                NSLog(@"biz/verify===%@",json);
//                                MainInfoModel * model = [MainInfoModel sharedModel];
//                                NSDictionary * dictionary = json[@"data"];
//                                model.verifyInfo = dictionary;
//                            }
//                                            failure:^(NSError *error) {
//                                                NSLog(@"%@",error.localizedDescription);
//                                            }];
//                        }else{
//                            
//                            [self showAlertWithMsg:json[@"message"]];
//                        }
//                        
//                    }
//                    failure:^(NSError *error) {
//                        NSLog(@"%@",error.localizedDescription);
//                        HIDE_HUD
//                    }];
}
#pragma mark - 提醒弹窗
- (void)showAlertWithMsg:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提醒", nil)
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                          otherButtonTitles:nil];
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.message isEqualToString:NSLocalizedString(@"修改成功", nil)]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 实现左侧按钮点击事件
- (void)clickBackBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
