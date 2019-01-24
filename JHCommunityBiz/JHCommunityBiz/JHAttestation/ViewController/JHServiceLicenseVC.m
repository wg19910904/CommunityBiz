//
//  JHShopInDoorVC.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/24.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHServiceLicenseVC.h"
#import "JHShopInDoorCell.h"
#import "JHOriginImage.h"
#import "JHShopInDoorCellOne.h"
@implementation JHServiceLicenseVC{
    UITableView * myTableView;//创建表视图
    UIImageView * imageView_add;//点击增加照片的方法
    UIImage * image_chose;//选择的图片
    NSData * data_image;//保存图片的数据流
    UITextField * mytextField_code;//填写许可证编号
    
}

-(void)viewDidLoad{
    [super viewDidLoad];
    //这是初始化一些数据
    [self initData];
    //这是创建表视图的方法
    [self creatUITableView];
    SHOW_HUD
    [self postHttp];
}
-(void)postHttp{
    [HttpTool postWithAPI:@"biz/shop/shop/info" withParams:@{} success:^(id json) {
        NSLog(@"json>>>>%@",json);
        if ([json[@"error"] isEqualToString:@"0"]) {
            self.cy_number = json[@"data"][@"verify"][@"cy_number"];
            self.cy_photo = json[@"data"][@"verify"][@"cy_photo"];
            if (self.type == EJHServiceLicenseTypeSubmit) {
                data_image = nil;
                
            }else{
                data_image = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEADDRESS,self.cy_photo]]];
            }
            
        }else{
            [JHShowAlert showAlertWithMsg:json[@"message"]];
        }
        HIDE_HUD
        //这是创建表视图的方法
        [self creatUITableView];
    } failure:^(NSError *error) {
        HIDE_HUD
        [JHShowAlert showAlertWithMsg: NSLocalizedString(@"服务器繁忙,请稍后访问", NSStringFromClass([self class]))];
        NSLog(@"%@",error.localizedDescription);
    }];
}

#pragma mark - 初始化一些数据
-(void)initData{
    self.navigationItem.title =  NSLocalizedString(@"服务许可证", NSStringFromClass([self class]));
}
#pragma mark - 这是创建表格的方法
-(void)creatUITableView{
    if (myTableView == nil) {
        myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64) style:UITableViewStylePlain];
        myTableView.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
        myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        myTableView.tableFooterView = [UIView new];
        [self.view addSubview:myTableView];
        [myTableView registerClass:[JHShopInDoorCell class] forCellReuseIdentifier:@"cell"];
        [myTableView registerClass:[JHShopInDoorCellOne class] forCellReuseIdentifier:@"cell1"];
        myTableView.delegate = self;
        myTableView.dataSource = self;
    }else{
        [myTableView reloadData];
    }
    
}
#pragma mark - 这是表视图的代理和数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 50;
    }
    return HEIGHT - 64;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        JHShopInDoorCellOne * cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
         mytextField_code = cell.myTextField;
        if (self.type == EJHServiceLicenseTypeSubmit) {
            mytextField_code.enabled = YES;
        }else if(self.type == EJHServiceLicenseTypeVerify) {
            mytextField_code.enabled = NO;
        }else if (self.type == EJHServiceLicenseTypeFail){
            mytextField_code.enabled = YES;
        }
        else{
            mytextField_code.enabled = NO;
        }
        if (self.cy_number.length) {
            mytextField_code.text = self.cy_number;
        }

        return cell;
    }
    JHShopInDoorCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    imageView_add = cell.imageV_add;
    [imageView_add sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEADDRESS,self.cy_photo]] placeholderImage:[UIImage imageNamed:@"certified_add-to"]];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToChoseImage:)];
    imageView_add.userInteractionEnabled = YES;
    [imageView_add addGestureRecognizer:tap];
    [cell.btn_completion addTarget:self action:@selector(clickToCompletion) forControlEvents:UIControlEventTouchUpInside];
    if (self.type == EJHServiceLicenseTypeSubmit) {
        [cell.btn_completion setTitle: NSLocalizedString(@"保存", NSStringFromClass([self class])) forState:UIControlStateNormal];
        [cell.btn_completion setBackgroundColor:[UIColor colorWithRed:250/255.0 green:175/255.0 blue:25/255.0 alpha:1] forState:UIControlStateNormal];
        [cell.btn_completion setBackgroundColor:[UIColor colorWithRed:250/255.0 green:175/255.0 blue:25/255.0 alpha:0.5] forState:UIControlStateHighlighted];
        cell.btn_completion.enabled = YES;
        cell.btn_completion.hidden = NO;
    }else if (self.type == EJHServiceLicenseTypeVerify){
        [cell.btn_completion setTitle: NSLocalizedString(@"正在审核", NSStringFromClass([self class])) forState:UIControlStateNormal];
        [cell.btn_completion setBackgroundColor:[UIColor grayColor] forState:UIControlStateNormal];
        [cell.btn_completion setBackgroundColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        cell.btn_completion.enabled = NO;
        cell.btn_completion.hidden = NO;
    }else if (self.type == EJHServiceLicenseTypeFail){
        [cell.btn_completion setTitle: NSLocalizedString(@"重新审核", NSStringFromClass([self class])) forState:UIControlStateNormal];
        [cell.btn_completion setBackgroundColor:[UIColor colorWithRed:250/255.0 green:175/255.0 blue:25/255.0 alpha:1] forState:UIControlStateNormal];
        [cell.btn_completion setBackgroundColor:[UIColor colorWithRed:250/255.0 green:175/255.0 blue:25/255.0 alpha:0.5] forState:UIControlStateHighlighted];
        cell.btn_completion.enabled = YES;
        cell.btn_completion.hidden = NO;
    }
    else {
        cell.btn_completion.hidden = YES;
    }

    return cell;
}
#pragma mark - 这是点击选择拍照/从相册选择照片的方法
-(void)clickToChoseImage:(UITapGestureRecognizer *)tap{
    if (self.type == EJHServiceLicenseTypeVerify || self.type == EJHServiceLicenseTypeCompletion) {
        return;
    }
    [self.view endEditing:YES];
    if (image_chose) {
        [self creatUIAlertControlWithCamera: NSLocalizedString(@"删除", NSStringFromClass([self class])) withAlbum: NSLocalizedString(@"查看原图", NSStringFromClass([self class]))];
    }else{
        [self creatUIAlertControlWithCamera: NSLocalizedString(@"拍照", NSStringFromClass([self class])) withAlbum: NSLocalizedString(@"从相册选取", NSStringFromClass([self class]))];
    }
}
#pragma mark - 这是弹出底部的选择框的方法
-(void)creatUIAlertControlWithCamera:(NSString *)title withAlbum:(NSString *)text{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([title isEqualToString: NSLocalizedString(@"删除", NSStringFromClass([self class]))]) {
            imageView_add.image = [UIImage imageNamed:@"certified_add-to"];
            image_chose = nil;
            data_image = nil;
        }else{
            [self creatUIImagePickerControllerWithType:UIImagePickerControllerSourceTypeCamera];
        }
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:text style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([text isEqualToString: NSLocalizedString(@"查看原图", NSStringFromClass([self class]))]) {
            __block JHOriginImage * control = [JHOriginImage new];
            [control showWithImage:image_chose withBlock:^(void){
                [control removeFromSuperview];
                control = nil;
            }];
        }else{
            [self creatUIImagePickerControllerWithType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
        }
    }]];
    [alert addAction:[UIAlertAction actionWithTitle: NSLocalizedString(@"取消", NSStringFromClass([self class])) style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark - 这是创建UIImagePickerController的方法
-(void)creatUIImagePickerControllerWithType:(NSInteger)type{
    UIImagePickerController * imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType = type;
    [self presentViewController:imagePicker animated:YES completion:nil];
}
#pragma mark - 这是UIImagePickerController的代理和数据源方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo{
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    if (picker.allowsEditing) {
        image_chose = info[UIImagePickerControllerEditedImage];
    }else{
        image_chose = info[UIImagePickerControllerOriginalImage];
    }
    image_chose = [HZQChangeImageSize scaleFromImage:image_chose scaledToSize:CGSizeMake(800, 800)];
    imageView_add.image = image_chose;
    data_image = UIImagePNGRepresentation(image_chose);
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 这是提交信息的方法
-(void)clickToCompletion{
    if (mytextField_code.text.length == 0) {
        [JHShowAlert showAlertWithMsg: NSLocalizedString(@"请填写许可证编号", NSStringFromClass([self class]))];
        return;
    }
    SHOW_HUD
    NSMutableDictionary * dataDic = @{}.mutableCopy;
    if (data_image) {
        [dataDic addEntriesFromDictionary:@{@"cy_photo":data_image}];
    }
    [HttpTool postWithAPI:@"biz/shop/shop/cyzy" params:@{@"cy_number":mytextField_code.text} dataDic:dataDic success:^(id json) {
        NSLog(@"%@",json);
        if ([json[@"error"] isEqualToString:@"0"]) {
            [JHShowAlert showAlertWithMsg: NSLocalizedString(@"信息提交成功,等待审核", NSStringFromClass([self class])) withBtnTitle: NSLocalizedString(@"知道了", NSStringFromClass([self class])) withBtnBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }else{
            [JHShowAlert showAlertWithMsg:json[@"message"]];
        }
        HIDE_HUD
    } failure:^(NSError *error) {
        HIDE_HUD
        [JHShowAlert showAlertWithMsg: NSLocalizedString(@"服务器繁忙,请稍后访问", NSStringFromClass([self class]))];
        NSLog(@"%@",error.localizedDescription);
    }];
 
}
@end
