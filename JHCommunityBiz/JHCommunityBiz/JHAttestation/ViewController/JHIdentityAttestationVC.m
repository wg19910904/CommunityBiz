//
//  JHIdentityAttestationVC.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/24.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHIdentityAttestationVC.h"
#import "JHIdentityCellOne.h"
#import "JHIdentityCellTwo.h"
#import "JHIdentityCellThree.h"
#import "JHOriginImage.h"
#import "MyTapGestureRecognizer.h"
#import "JHCooperationAgreement.h"
#import "JHPromptMessageVC.h"
#import <UIImageView+WebCache.h>
@implementation JHIdentityAttestationVC{
    UITableView * myTableView;//表视图的对象
    UITextField * mytextField_name;//姓名输入框
    UITextField * mytextField_Lisense;//输入身份证号码的
    UITextField * mytextField_email;//输入电子邮件的
    UIImageView * imageView_Lisense;//指向身份证件相框的
    UIImage * image_Lisense;//保存身份证照片的
    NSData * data_Lisense;//保存身份证照片的数据流的
    UIImageView * imageView_shop;//指向店面照片相框的
    UIImage * image_shop;//保存店面照片的
    NSData * data_shop;//保存店面照片的数据流的
//    UIImageView * imageView_resource;//指向更多资源相框的
//    UIImage * image_resource;//保存更多资源照片的
//    NSData * data_resource;//保存更多资源的数据流的
    NSInteger num;//保存当前点击的是哪个增加图片的按钮
    float height;//记录高度
    
}
-(void)viewDidLoad{
    [super viewDidLoad];
    //初始化一些方法
    [self initData];
    //这是创建表视图的方法
    [self creatUITableView];
    //创建马上认证的按钮
    [self creatUIButton];
    //发送请求
    SHOW_HUD
    [self postHttp];
}
-(void)postHttp{
    [HttpTool postWithAPI:@"biz/shop/shop/info" withParams:@{} success:^(id json) {
        NSLog(@"json>>>>%@",json);
        if ([json[@"error"] isEqualToString:@"0"]) {
            self.id_name = json[@"data"][@"verify"][@"id_name"];
            self.id_number = json[@"data"][@"verify"][@"id_number"];
            self.id_photo = json[@"data"][@"verify"][@"id_photo"];
            self.shop_photo = json[@"data"][@"verify"][@"shop_photo"];
            if (self.type == EJHAttesstationTypeSubmit) {
                data_Lisense = nil;
                data_shop = nil;
            }else{
                data_Lisense = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEADDRESS,self.id_photo]]];
                data_shop = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEADDRESS,self.shop_photo]]];
            }
        }else{
            [JHShowAlert showAlertWithMsg:json[@"message"]];
        }
        HIDE_HUD
        //这是创建表视图的方法
        [self creatUITableView];
        //创建马上认证的按钮
        [self creatUIButton];
    } failure:^(NSError *error) {
        HIDE_HUD
         [JHShowAlert showAlertWithMsg: NSLocalizedString(@"服务器繁忙,请稍后访问", NSStringFromClass([self class]))];
        NSLog(@"%@",error.localizedDescription);
    }];
}
#pragma mark - 这是初始化的一些方法
-(void)initData{
    self.navigationItem.title =  NSLocalizedString(@"身份认证", NSStringFromClass([self class]));
    self.view.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
}
#pragma mark - 这是创建表格的方法
-(void)creatUITableView{
    if (myTableView == nil) {
        myTableView = [[UITableView alloc]initWithFrame:FRAME(0, 0, WIDTH, HEIGHT - 64 -50) style:UITableViewStylePlain];
        myTableView.tableFooterView = [UIView new];
        myTableView.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
        myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        myTableView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:myTableView];
        [myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        [myTableView registerClass:[JHIdentityCellOne class] forCellReuseIdentifier:@"cell1"];
        [myTableView registerClass:[JHIdentityCellTwo class] forCellReuseIdentifier:@"cell2"];
        [myTableView registerClass:[JHIdentityCellThree class] forCellReuseIdentifier:@"cell3"];
        myTableView.delegate = self;
        myTableView.dataSource = self;
    }else{
        [myTableView reloadData];
    }
}
#pragma mark - 这是表格的代理和数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //return 8;
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
    if (indexPath.row == 2) {
        return 10;
    }else if (indexPath.row < 4 && indexPath.row != 2){
        return 40;
    }else if (indexPath.row == 7){
        //暂时的模拟加载本地的
        NSString * str = [NSString stringWithFormat:@"%@\n%@\n%@",@"1.若您上传的身份证非营业执照上法人本人/若您的营业执照公司名称和地址与点评收录的门店信息出入较大,建议您下载经营权说明书模板,按格式填写后拍照上传",@"2.若您的店名与品牌相关,需补充上传品牌授权/加盟书",@"3.若您的门店与开锁(锁具)相关,请上传<<特种经营许可证>>"];
        CGSize size = [str boundingRectWithSize:CGSizeMake(WIDTH - 10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
        height = size.height;
        return 30+height*1.5+60;
    }
    else{
        return 190;
    }
     */
    if (indexPath.row < 2){
        return 40;
    }else{
        return 190;
    }

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < 2){
        JHIdentityCellOne * cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        cell.array = [NSMutableArray arrayWithObjects: NSLocalizedString(@"真实姓名", NSStringFromClass([self class])), NSLocalizedString(@"身份证号", NSStringFromClass([self class])), nil];
        cell.placeArray = [NSMutableArray arrayWithObjects: NSLocalizedString(@"请输入您的姓名", NSStringFromClass([self class])), NSLocalizedString(@"请输入您的身份证号", NSStringFromClass([self class])), nil];
        cell.indexPath = indexPath;
        if (indexPath.row == 0) {
            mytextField_name = cell.mytextField;
        }else if (indexPath.row == 1){
            mytextField_Lisense = cell.mytextField;
        }
        if (self.type == EJHAttesstationTypeSubmit) {
            mytextField_name.enabled = YES;
            mytextField_Lisense.enabled = YES;
        }else if(self.type == EJHAttesstationTypeVerity) {
            mytextField_name.enabled = NO;
            mytextField_Lisense.enabled = NO;
        }else if (self.type == EJHAttesstationTypeFail){
            mytextField_name.enabled = YES;
            mytextField_Lisense.enabled = YES;
        }
        else{
            mytextField_name.enabled = NO;
            mytextField_Lisense.enabled = NO;
        }
        if (self.id_name.length) {
            mytextField_name.text = self.id_name;
        }
        if (self.id_number.length) {
            mytextField_Lisense.text = self.id_number;
        }
        return cell;
    }
    else{
        JHIdentityCellTwo * cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
        cell.indexPath = indexPath;
        if (indexPath.row == 2) {
            imageView_Lisense = cell.imageV_add;
        }else if (indexPath.row == 3){
            imageView_shop = cell.imageV_add;
        }
        [imageView_Lisense sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEADDRESS,self.id_photo]] placeholderImage:[UIImage imageNamed:@"certified_add-to"]];
        [imageView_shop sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEADDRESS,self.shop_photo]] placeholderImage:[UIImage imageNamed:@"certified_add-to"]];
        cell.imageV_add.userInteractionEnabled = YES;
        MyTapGestureRecognizer * tap = [[MyTapGestureRecognizer alloc]initWithTarget:self action:@selector(choseImage:)];
        tap.tag = indexPath.row;
        [cell.imageV_add addGestureRecognizer:tap];
        return cell;
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
#pragma mark - 这是点击去看社区合作协议的方法
-(void)clickToSeeTerms{
    NSLog(@"一起去看社区合作协议吧");
    JHCooperationAgreement * vc = [[JHCooperationAgreement alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - 这是点击选择照片的方法
-(void)choseImage:(MyTapGestureRecognizer *)tap{
    if (self.type == EJHAttesstationTypeVerity || self.type == EJHAttesstationTypeCompletion) {
        return;
    }
    [self.view endEditing:YES];
    if (tap.tag == 2) {
        if (image_Lisense) {
            [self creatUIAlertControlWithCamera: NSLocalizedString(@"删除", NSStringFromClass([self class])) withAlbum: NSLocalizedString(@"查看原图", NSStringFromClass([self class])) withTag:tap.tag];
        }else{
            [self creatUIAlertControlWithCamera: NSLocalizedString(@"拍照", NSStringFromClass([self class])) withAlbum: NSLocalizedString(@"从相册选取", NSStringFromClass([self class])) withTag:tap.tag];
        }
    }else if (tap.tag == 3){
        if (image_shop) {
            [self creatUIAlertControlWithCamera: NSLocalizedString(@"删除", NSStringFromClass([self class])) withAlbum: NSLocalizedString(@"查看原图", NSStringFromClass([self class])) withTag:tap.tag];
        }else{
            [self creatUIAlertControlWithCamera: NSLocalizedString(@"拍照", NSStringFromClass([self class])) withAlbum: NSLocalizedString(@"从相册选取", NSStringFromClass([self class])) withTag:tap.tag];
        }
    }
}
#pragma mark - 这是点击创建底部的UIAlertControl
-(void)creatUIAlertControlWithCamera:(NSString *)title withAlbum:(NSString *)text withTag:(NSInteger)tag{
    num = tag;
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([title isEqualToString: NSLocalizedString(@"删除", NSStringFromClass([self class]))]) {
            if (tag == 2) {
                image_Lisense = nil;
                data_Lisense  = nil;
                imageView_Lisense.image = [UIImage imageNamed:@"certified_add-to"];
            }else if (tag == 3){
                image_shop = nil;
                data_shop  = nil;
                imageView_shop.image = [UIImage imageNamed:@"certified_add-to"];;
            }
            
        }else{
            [self creatUIImagePickerControllerWithType:UIImagePickerControllerSourceTypeCamera];
        }
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:text style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([text isEqualToString: NSLocalizedString(@"查看原图", NSStringFromClass([self class]))]) {
            UIImage * image = nil;
            if (tag == 2) {
                image = image_Lisense;
            }else if (tag == 3){
                image = image_shop;
            }
            __block JHOriginImage * control = [JHOriginImage new];
            [control showWithImage:image withBlock:^(void){
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
        if (num == 2) {
           image_Lisense = info[UIImagePickerControllerEditedImage];
        }else if (num == 3){
           image_shop  = info[UIImagePickerControllerEditedImage];
        }
        
       
    }else{
        if (num == 2) {
            image_Lisense = info[UIImagePickerControllerOriginalImage];
        }else if (num == 3){
            image_shop  = info[UIImagePickerControllerOriginalImage];
        }
    }
     image_Lisense = [HZQChangeImageSize scaleFromImage:image_Lisense scaledToSize:CGSizeMake(800, 800)];
     image_shop = [HZQChangeImageSize scaleFromImage:image_shop scaledToSize:CGSizeMake(800, 800)];
    if (num == 2) {
        imageView_Lisense.image = image_Lisense;
        data_Lisense = UIImagePNGRepresentation(image_Lisense);
    }else if (num == 3){
        imageView_shop.image = image_shop;
        data_shop = UIImagePNGRepresentation(image_shop);
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 这是创建点击马上认证的方法
-(void)creatUIButton{
    UIButton * btn = [[UIButton alloc]init];
    btn.frame = FRAME(10, HEIGHT - 64 - 50, WIDTH - 20, 40);
    btn.layer.cornerRadius = 3;
    btn.layer.masksToBounds = YES;
    if (self.type == EJHAttesstationTypeSubmit) {
        [btn setTitle: NSLocalizedString(@"保存", NSStringFromClass([self class])) forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor colorWithRed:250/255.0 green:175/255.0 blue:25/255.0 alpha:1] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor colorWithRed:250/255.0 green:175/255.0 blue:25/255.0 alpha:0.5] forState:UIControlStateHighlighted];
        btn.enabled = YES;
        btn.hidden = NO;
    }else if (self.type == EJHAttesstationTypeVerity){
        [btn setTitle: NSLocalizedString(@"正在审核", NSStringFromClass([self class])) forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        btn.enabled = NO;
        btn.hidden = NO;
    }else if (self.type == EJHAttesstationTypeFail){
        [btn setTitle: NSLocalizedString(@"重新审核", NSStringFromClass([self class])) forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor colorWithRed:250/255.0 green:175/255.0 blue:25/255.0 alpha:1] forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor colorWithRed:250/255.0 green:175/255.0 blue:25/255.0 alpha:0.5] forState:UIControlStateHighlighted];
        btn.enabled = YES;
        btn.hidden = NO;
    }
    else {
        btn.hidden = YES;
    }
    [btn addTarget:self action:@selector(clickToAttestation:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
#pragma mark - 这是按钮的点击方法
-(void)clickToAttestation:(UIButton *)sender{
    
    if (mytextField_name.text.length == 0) {
        [JHShowAlert showAlertWithMsg: NSLocalizedString(@"请先输入姓名", NSStringFromClass([self class]))];
        return;
    }else if(mytextField_Lisense.text.length == 0){
        [JHShowAlert showAlertWithMsg: NSLocalizedString(@"请输入您的身份证号", NSStringFromClass([self class]))];
        return;
    }
    NSMutableDictionary * dataDic = @{}.mutableCopy;
    if (data_Lisense) {
        [dataDic addEntriesFromDictionary:@{@"id_photo":data_Lisense}];
    }else{
        [JHShowAlert showAlertWithMsg: NSLocalizedString(@"请添加身份证照", NSStringFromClass([self class]))];
        return;
    }
    SHOW_HUD
    [HttpTool postWithAPI:@"biz/shop/shop/dianzhu"
                   params:@{@"id_name":mytextField_name.text,
                            @"id_number":mytextField_Lisense.text}
                  dataDic:dataDic success:^(id json) {
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
