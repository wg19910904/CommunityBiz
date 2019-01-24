//
//  JHSignageVC.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/23.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHSignageVC.h"
#import "JHSignageCell.h"
#import "JHOriginImage.h"
#import "JHIdentityCellOne.h"
#import <UIImageView+WebCache.h>
#import "HZQChangeImageSize.h"
@implementation JHSignageVC{
    UITableView * myTableView;//创建表视图
    UIImageView * imageView_add;//点击增加照片的方法
    UIImage * image_chose;//选择的图片
    NSData * data_image;//保存图片的数据流
    UITextField * mytextField_code;//工商注册号
    UITextField * mytextField_name;//公司名称
}

-(void)viewDidLoad{
    [super viewDidLoad];
     //这是初始化一些数据
    [self initData];
    //这是创建表视图的方法
    [self creatUITableView];
    //发送请求
    SHOW_HUD
    [self postHttp];
}

#pragma mark - 初始化一些数据
-(void)initData{
    self.navigationItem.title =  NSLocalizedString(@"营业执照", NSStringFromClass([self class]));
}
-(void)postHttp{
    [HttpTool postWithAPI:@"biz/shop/shop/info" withParams:@{} success:^(id json) {
        NSLog(@"json>>>>%@",json);
        if ([json[@"error"] isEqualToString:@"0"]) {
              self.company_name = json[@"data"][@"verify"][@"company_name"];
              self.yz_number = json[@"data"][@"verify"][@"yz_number"];
              self.yz_photo = json[@"data"][@"verify"][@"yz_photo"];
            if (self.type == EJHSignageTypeSubmit) {
                data_image = nil;
                
            }else{
                data_image = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEADDRESS,self.yz_photo]]];
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

#pragma mark - 这是创建表格的方法
-(void)creatUITableView{
    if (myTableView == nil) {
        myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64) style:UITableViewStylePlain];
        myTableView.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
        myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        myTableView.tableFooterView = [UIView new];
        [self.view addSubview:myTableView];
        [myTableView registerClass:[JHSignageCell class] forCellReuseIdentifier:@"cell"];
        [myTableView registerClass:[JHIdentityCellOne class] forCellReuseIdentifier:@"cell1"];
        myTableView.delegate = self;
        myTableView.dataSource = self;
    }else{
        [myTableView reloadData];
    }
}
#pragma mark - 这是表视图的代理和数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < 2) {
        return 40;
    }
    return HEIGHT - 64;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < 2) {
        JHIdentityCellOne * cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        cell.array = [NSMutableArray arrayWithObjects: NSLocalizedString(@"工商注册号", NSStringFromClass([self class])), NSLocalizedString(@"公司名称", NSStringFromClass([self class])), nil];
        cell.placeArray = [NSMutableArray arrayWithObjects: NSLocalizedString(@"请与营业执照上的信息保持一致", NSStringFromClass([self class])), NSLocalizedString(@"请填写营业执照上的名称", NSStringFromClass([self class])), nil];
        cell.indexPath = indexPath;
        if (indexPath.row == 0) {
            mytextField_code = cell.mytextField;
        }else if (indexPath.row == 1){
            mytextField_name = cell.mytextField;
        }
        if (self.type == EJHSignageTypeSubmit) {
            mytextField_code.enabled = YES;
            mytextField_name.enabled = YES;
        }else if(self.type == EJHSignageTypeVerity) {
            mytextField_name.enabled = NO;
            mytextField_code.enabled = NO;
        }else if (self.type == EJHSignageTypeFail){
            mytextField_name.enabled = YES;
            mytextField_code.enabled = YES;
        }
        else{
            mytextField_name.enabled = NO;
            mytextField_code.enabled = NO;
        }
        if (self.company_name.length) {
             mytextField_name.text = self.company_name;
        }
        if (self.yz_number.length) {
            mytextField_code.text = self.yz_number;
        }
        return cell;
    }
    JHSignageCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    imageView_add = cell.imageV_add;
    [imageView_add sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEADDRESS,self.yz_photo]] placeholderImage:[UIImage imageNamed:@"certified_add-to"]];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToChoseImage:)];
    imageView_add.userInteractionEnabled = YES;
    [cell.btn_completion addTarget:self action:@selector(clickToCompletion) forControlEvents:UIControlEventTouchUpInside];
    if (self.type == EJHSignageTypeSubmit) {
        [cell.btn_completion setTitle: NSLocalizedString(@"保存", NSStringFromClass([self class])) forState:UIControlStateNormal];
        [cell.btn_completion setBackgroundColor:[UIColor colorWithRed:250/255.0 green:175/255.0 blue:25/255.0 alpha:1] forState:UIControlStateNormal];
        [cell.btn_completion setBackgroundColor:[UIColor colorWithRed:250/255.0 green:175/255.0 blue:25/255.0 alpha:0.5] forState:UIControlStateHighlighted];
        cell.btn_completion.enabled = YES;
        cell.btn_completion.hidden = NO;
    }else if (self.type == EJHSignageTypeVerity){
        [cell.btn_completion setTitle: NSLocalizedString(@"正在审核", NSStringFromClass([self class])) forState:UIControlStateNormal];
        [cell.btn_completion setBackgroundColor:[UIColor grayColor] forState:UIControlStateNormal];
        [cell.btn_completion setBackgroundColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        cell.btn_completion.enabled = NO;
        cell.btn_completion.hidden = NO;
    }else if (self.type == EJHSignageTypeFail){
        [cell.btn_completion setTitle: NSLocalizedString(@"重新审核", NSStringFromClass([self class])) forState:UIControlStateNormal];
        [cell.btn_completion setBackgroundColor:[UIColor colorWithRed:250/255.0 green:175/255.0 blue:25/255.0 alpha:1] forState:UIControlStateNormal];
        [cell.btn_completion setBackgroundColor:[UIColor colorWithRed:250/255.0 green:175/255.0 blue:25/255.0 alpha:0.5] forState:UIControlStateHighlighted];
        cell.btn_completion.enabled = YES;
        cell.btn_completion.hidden = NO;
    }
    else {
        cell.btn_completion.hidden = YES;
    }

    [imageView_add addGestureRecognizer:tap];
    return cell;
}
#pragma mark - 这是点击选择拍照/从相册选择照片的方法
-(void)clickToChoseImage:(UITapGestureRecognizer *)tap{
    if (self.type == EJHSignageTypeVerity || self.type == EJHSignageTypeCompletion) {
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
    //UIImage * img = [HZQChangeImageSize scaleFromImage:image_chose scaledToSize:CGSizeMake(10, 10)];
    data_image = UIImagePNGRepresentation(image_chose);
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 这是点击完成的方法
-(void)clickToCompletion{
    NSLog(@"点击完成的方法");
    if (mytextField_code.text.length == 0) {
        [JHShowAlert showAlertWithMsg: NSLocalizedString(@"请先填写工商注册号", NSStringFromClass([self class]))];
        return;
    }
    if (mytextField_name.text.length == 0) {
        [JHShowAlert showAlertWithMsg: NSLocalizedString(@"请先填写公司名称", NSStringFromClass([self class]))];
        return;
    }
   
    NSMutableDictionary * dataDic = @{}.mutableCopy;
    if (data_image) {
        [dataDic addEntriesFromDictionary:@{@"yz_photo":data_image}];
    }else{
        [JHShowAlert showAlertWithMsg: NSLocalizedString(@"请上传您的营业执照", NSStringFromClass([self class]))];
        return;
    }
     SHOW_HUD
    [HttpTool postWithAPI:@"biz/shop/shop/yyzy" params:@{@"yz_number":mytextField_code.text,@"company_name":mytextField_name.text} dataDic:dataDic success:^(id json) {
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
