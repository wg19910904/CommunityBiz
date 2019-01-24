//
//  JHShopInfoSetVC.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/30.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHShopInfoSetVC.h"
#import <IQKeyboardManager.h>
#import "XHChoosePhoto.h"
#import "GaoDe_Convert_BaiDu.h"
#import "JHPickerView.h"
#import "JHShopTypeModel.h"
#import <UIImageView+WebCache.h>
#import "YFTextView.h"
@interface JHShopInfoSetVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate>
@property(nonatomic,strong)UITableView *mainTableView;
@end

@implementation JHShopInfoSetVC
{
    UITextField *_shopNameF;//店铺名
    UIImageView *_logoIV;//店铺logo
    UITextField *_contactF;//联系人
    UITextField *_phoneF;//联系电话
    UITextField *_kefuF;//客服电话
    UILabel *_shopClassifyL;//店铺分类
    UITextField *_avg_costF;//人均消费
    YFTextView *_shopIntroTV;//店铺介绍
    UITextField *_addressF;//商家地址
    NSString * lat;//保存选取的地址的纬度
    NSString * lng;//保存选取的地址的经度
    NSData * image_data;//接收商家logo的数据流
    NSData * banner_data;//接收商家logo的数据流
    NSInteger row1;//保存父类的选中行
    NSInteger row2;//保存子类的选中行
    NSMutableArray * array_father;//保存父类的数组
    NSMutableArray * array_son;//保存子类的数组
    JHShopTypeModel * typeModel;
    NSString * cate_id;
    UIImageView * banner;
    NSInteger type;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
     SHOW_HUD
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       
        [self createTableView];
        [self addBottomBtn];
    });
}
- (void)initData
{
    self.view.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
    self.navigationItem.title = NSLocalizedString(@"基本资料", nil);
    typeModel = [JHShopTypeModel shareShopTypeModel];
    array_father = typeModel.fatherArray;
    array_son = typeModel.children;

}
#pragma mark - 创建表视图
- (void)createTableView
{
    
    _mainTableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, WIDTH, HEIGHT - 64 - 60)
                                                              style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
        tableView.separatorColor = LINE_COLOR;
        tableView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:tableView];
        tableView.layoutMargins = UIEdgeInsetsZero;
        tableView.separatorInset = UIEdgeInsetsZero;
        tableView;
    });
    
}
#pragma mark - 添加底部按钮
- (void)addBottomBtn
{
    UIButton *sureBtn =  [UIButton new];
    [self.view addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_bottom).with.offset(-50);
        make.left.equalTo(self.view).with.offset(10);
        make.right.equalTo(self.view).with.offset(-10);
        make.bottom.equalTo(self.view).with.offset(-10);
    }];
    sureBtn.layer.cornerRadius = 3;
    sureBtn.layer.masksToBounds = YES;
    [sureBtn setBackgroundColor:HEX(@"faaf19", 1.0) forState:(UIControlStateNormal)];
    [sureBtn setTitle:NSLocalizedString(@"保存", nil) forState:(UIControlStateNormal)];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [sureBtn addTarget:self action:@selector(clickToCompletion:) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark - 这是点击完成的方法
-(void)clickToCompletion:(UIButton *)sender{
    if (_shopNameF.text.length == 0) {
        [JHShowAlert showAlertWithMsg:NSLocalizedString(@"请输入店铺名称", nil)];
        return;
    }else if (_contactF.text.length == 0){
        [JHShowAlert showAlertWithMsg:NSLocalizedString(@"请输入联系人姓名", nil)];
        return;
    }else if(_phoneF.text.length == 0){
        [JHShowAlert showAlertWithMsg:NSLocalizedString(@"请输入联系方式", nil)];
        return;
    }else if (_kefuF.text.length == 0){
        [JHShowAlert showAlertWithMsg:NSLocalizedString(@"请输入客服电话", nil)];
        return;
    }else if(_shopClassifyL.text.length == 0){
        [JHShowAlert showAlertWithMsg:NSLocalizedString(@"请选择店铺分类", nil)];
        return;
    }else if(_shopIntroTV.inputText.length == 0){
       [JHShowAlert showAlertWithMsg:NSLocalizedString(@"请输入店铺简介", nil)];
        return;
    }
    NSMutableDictionary * dic = @{}.mutableCopy;
    if (image_data == nil) {
        [JHShowAlert showAlertWithMsg:NSLocalizedString(@"请选择商家logo", nil)];
        return;
    }else{
        [dic addEntriesFromDictionary:@{@"logo":image_data}];
    }
    if (banner_data == nil) {
        [JHShowAlert showAlertWithMsg:NSLocalizedString(@"请选择商家logo", nil)];
        return;
    }else{
        [dic addEntriesFromDictionary:@{@"banner":banner_data}];
    }
    SHOW_HUD
    [HttpTool postWithAPI:@"biz/shop/shop/base" params:@{@"title":_shopNameF.text,
                                                         @"contact":_contactF.text,
                                                         @"mobile":_phoneF.text,
                                                         @"phone":_kefuF.text,
                                                         @"cate_id":cate_id,
                                                         @"intro":_shopIntroTV.inputText,
                                                         @"addr":_addressF ? _addressF.text :
                                                             [JHShareModel shareModel].infoDictionary[@"addr"],
                                                         @"lat":lat,
                                                         @"lng":lng} dataDic:dic success:^(id json) {
        if ([json[@"error"] isEqualToString:@"0"]) {
            [JHShowAlert showAlertWithMsg:NSLocalizedString(@"设置成功", nil) withBtnTitle:NSLocalizedString(@"知道了", nil) withBtnBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }else{
            [JHShowAlert showAlertWithMsg:json[@"message"]];
        }
      HIDE_HUD
    } failure:^(NSError *error) {
        HIDE_HUD
        [JHShowAlert showAlertWithMsg:NSLocalizedString(@"服务器繁忙,请稍后访问", nil)];
        NSLog(@"%@",error.localizedDescription);
    }];
}
#pragma mark - tableView delegate and dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 5;
            break;
        default:
            return 1;
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 3) {
        return 0.01;
    }
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0 && (row == 1 || row == 2)) {
        return 60;
    }else if(section == 4){
        return 150;
    }else{
        return 44;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    switch (section) {
        case 0:
        {
            switch (row) {
                case 0:
                {
                    UITableViewCell *cell = [[UITableViewCell alloc] init];
                    cell.backgroundColor = [UIColor whiteColor];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    //添加左侧label
                    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0,70,44)];
                    titleLabel.font = FONT(14);
                    titleLabel.textColor = [UIColor colorWithHex:@"333333" alpha:1.0];
                    titleLabel.text = NSLocalizedString(@"店铺名称", nil);
                    [cell addSubview:titleLabel];
                    //添加输入文本框
                    if (!_shopNameF) {
                        _shopNameF= [[UITextField alloc] initWithFrame:CGRectMake(80, 0, WIDTH - 90, 44)];
                        _shopNameF.textColor = THEME_COLOR;
                        _shopNameF.font = FONT(14);
                        _shopNameF.text = [JHShareModel shareModel].infoDictionary[@"title"];
                        _shopNameF.placeholder = NSLocalizedString(@"请填写店铺名称", nil);
                    }
                    [cell addSubview:_shopNameF];
                    return cell;
                }
                    break;
                case 1:
                {
                    UITableViewCell *cell = [[UITableViewCell alloc] init];
                    cell.backgroundColor = [UIColor whiteColor];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    //添加左侧label
                    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0,70,60)];
                    titleLabel.font = FONT(14);
                    titleLabel.textColor = [UIColor colorWithHex:@"333333" alpha:1.0];
                    titleLabel.text = NSLocalizedString(@"店铺logo", nil);
                    [cell addSubview:titleLabel];
                    if (!_logoIV) {
                        
                        _logoIV = [[UIImageView alloc] initWithFrame:FRAME(WIDTH - 70, 10, 40, 40)];
                        [_logoIV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEADDRESS,[JHShareModel shareModel].infoDictionary[@"logo"]]] placeholderImage:[UIImage imageNamed:@"evaluateDefault"]];
                        NSString * logo = [JHShareModel shareModel].infoDictionary[@"logo"];
                        if (logo.length > 0) {
                            image_data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEADDRESS,[JHShareModel shareModel].infoDictionary[@"logo"]]]];
                        }
                        
                    }
                    [cell addSubview:_logoIV];
                    return cell;
                }
                    break;
                case 2:
                {
                    UITableViewCell *cell = [[UITableViewCell alloc] init];
                    cell.backgroundColor = [UIColor whiteColor];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    //添加左侧label
                    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0,90,60)];
                    titleLabel.font = FONT(14);
                    titleLabel.textColor = [UIColor colorWithHex:@"333333" alpha:1.0];
                    titleLabel.text = NSLocalizedString(@"店铺banner", nil);
                    [cell addSubview:titleLabel];
                    if (!banner) {
                        
                        banner = [[UIImageView alloc] initWithFrame:FRAME(WIDTH - 70, 10, 40, 40)];
                        [banner sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEADDRESS,[JHShareModel shareModel].infoDictionary[@"banner"]]] placeholderImage:[UIImage imageNamed:@"evaluateDefault"]];
                        NSString * logo = [JHShareModel shareModel].infoDictionary[@"banner"];
                        if (logo.length > 0) {
                            banner_data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEADDRESS,[JHShareModel shareModel].infoDictionary[@"banner"]]]];
                        }
                        
                    }
                    [cell addSubview:banner];
                    return cell;
                }
                    break;

                case 3:
                {
                    UITableViewCell *cell = [[UITableViewCell alloc] init];
                    cell.backgroundColor = [UIColor whiteColor];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    //添加左侧label
                    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0,70,44)];
                    titleLabel.font = FONT(14);
                    titleLabel.textColor = [UIColor colorWithHex:@"333333" alpha:1.0];
                    titleLabel.text = NSLocalizedString(@"联系人", nil);
                    [cell addSubview:titleLabel];
                    //添加输入文本框
                    if (!_contactF) {
                        _contactF= [[UITextField alloc] initWithFrame:CGRectMake(80, 0, WIDTH - 90, 44)];
                        _contactF.textColor = THEME_COLOR;
                        _contactF.font = FONT(14);
                        _contactF.placeholder = NSLocalizedString(@"请填写联系人", nil);
                        _contactF.text = [JHShareModel shareModel].infoDictionary[@"contact"];
                        
                    }
                    [cell addSubview:_contactF];
                    return cell;
                }
                    break;
                default:
                {
                    UITableViewCell *cell = [[UITableViewCell alloc] init];
                    cell.backgroundColor = [UIColor whiteColor];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    //添加左侧label
                    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0,70,40)];
                    titleLabel.font = FONT(14);
                    titleLabel.textColor = [UIColor colorWithHex:@"333333" alpha:1.0];
                    titleLabel.text = NSLocalizedString(@"联系电话", nil);
                    [cell addSubview:titleLabel];
                    //添加输入文本框
                    if (!_phoneF) {
                        _phoneF= [[UITextField alloc] initWithFrame:CGRectMake(80, 0, WIDTH - 90, 44)];
                        _phoneF.textColor = THEME_COLOR;
                        _phoneF.font = FONT(14);
                        _phoneF.placeholder = NSLocalizedString(@"请输入您的联系电话", nil);
                        _phoneF.text = [JHShareModel shareModel].infoDictionary[@"mobile"];
                    }
                    [cell addSubview:_phoneF];
                    return cell;

                }
                    break;
            }
        }
            break;
        case 1:
        {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //添加左侧label
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0,70,44)];
            titleLabel.font = FONT(14);
            titleLabel.textColor = [UIColor colorWithHex:@"333333" alpha:1.0];
            titleLabel.text = NSLocalizedString(@"客服电话", nil);
            [cell addSubview:titleLabel];
            //添加输入文本框
            if (!_kefuF) {
                _kefuF= [[UITextField alloc] initWithFrame:CGRectMake(80, 0, WIDTH - 90, 44)];
                _kefuF.textColor = THEME_COLOR;
                _kefuF.font = FONT(14);
                _kefuF.placeholder = NSLocalizedString(@"请输入客服电话", nil);
                _kefuF.text = [JHShareModel shareModel].infoDictionary[@"phone"];
            }
            [cell addSubview:_kefuF];
            return cell;
        }
            break;
        case 2:
        {
            if (indexPath.row == 0) {
                UITableViewCell * cell = [[UITableViewCell alloc] init];
                cell.backgroundColor = [UIColor whiteColor];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                //添加左侧label
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0,70,44)];
                titleLabel.font = FONT(14);
                titleLabel.textColor = [UIColor colorWithHex:@"333333" alpha:1.0];
                titleLabel.text = NSLocalizedString(@"店铺分类", nil);
                [cell addSubview:titleLabel];
                //添加输入文本框
                if (!_shopClassifyL) {
                    _shopClassifyL= [[UILabel alloc] initWithFrame:CGRectMake(80, 0, WIDTH - 110, 44)];
                    _shopClassifyL.textColor = THEME_COLOR;
                    _shopClassifyL.font = FONT(14);
                    _shopClassifyL.textAlignment = NSTextAlignmentRight;
                    _shopClassifyL.text = [NSString stringWithFormat:@"%@",[JHShareModel shareModel].infoDictionary[@"cate_name"]];
                    cate_id = [JHShareModel shareModel].infoDictionary[@"cate_id"];
                }
                //_shopClassifyL.text = NSLocalizedString(@"快餐", nil);
                [cell addSubview:_shopClassifyL];
                return cell;
            }else{
                UITableViewCell * cell = [[UITableViewCell alloc] init];
                cell.backgroundColor = [UIColor whiteColor];
                //添加左侧label
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0,70,44)];
                titleLabel.font = FONT(14);
                titleLabel.textColor = [UIColor colorWithHex:@"333333" alpha:1.0];
                titleLabel.text = NSLocalizedString(@"人均消费", nil);
                [cell addSubview:titleLabel];
                //添加输入文本框
                if (!_avg_costF) {
                    _avg_costF= [[UITextField alloc] initWithFrame:CGRectMake(80, 0, WIDTH - 110, 44)];
                    _avg_costF.textColor = THEME_COLOR;
                    _avg_costF.font = FONT(14);
                    _avg_costF.placeholder = NSLocalizedString(@"请输入人均消费", nil);
                    _avg_costF.textAlignment = NSTextAlignmentRight;
                    _avg_costF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
//                    _avg_costF.text = [JHShareModel shareModel].infoDictionary[@"mobile"];
                }
                [cell addSubview:_avg_costF];
                return cell;
            }  
        }
            break;
        case 4:
        {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:FRAME(0, 0, WIDTH, 150)];
            cell.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //添加输入文本框
            if (!_shopIntroTV) {
                _shopIntroTV= [[YFTextView alloc] initWithFrame:FRAME(0, 0, WIDTH, 150)];
                _shopIntroTV.placeholderColor = HEX(@"666666", 1.0);
                _shopIntroTV.placeholderFont = 14;
                _shopIntroTV.placeholderStr = NSLocalizedString(@"请输入店铺简介", nil);
                _shopIntroTV.maxCount = 10000;
                _shopIntroTV.hiddenCountLab = YES;
                NSString * info = [JHShareModel shareModel].infoDictionary[@"intro"];
                if (info.length > 0) {
                    _shopIntroTV.inputText = [JHShareModel shareModel].infoDictionary[@"intro"];
                }
            }
            [cell addSubview:_shopIntroTV];
            return cell;
        }
            break;
        default:
        {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //添加左侧label
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0,70,44)];
            titleLabel.font = FONT(14);
            titleLabel.textColor = [UIColor colorWithHex:@"333333" alpha:1.0];
            titleLabel.text = NSLocalizedString(@"商家地址", nil);
            [cell addSubview:titleLabel];
            //添加文本框
            if (!_addressF) {
                _addressF= [[UITextField alloc] initWithFrame:CGRectMake(80, 7, WIDTH - 90, 30)];
                _addressF.textColor = THEME_COLOR;
                _addressF.font = FONT(14);
                _addressF.delegate = self;
                _addressF.enabled = NO;
                _addressF.text = [JHShareModel shareModel].infoDictionary[@"addr"];
                lat = [JHShareModel shareModel].infoDictionary[@"lat"];
                lng = [JHShareModel shareModel].infoDictionary[@"lng"];
                UIButton *rightBtn2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
                rightBtn2.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
                [rightBtn2 setImage:[UIImage imageNamed:@"position"] forState:UIControlStateNormal];
                rightBtn2.backgroundColor = THEME_COLOR;
                _addressF.rightViewMode = UITextFieldViewModeAlways;
                _addressF.rightView = rightBtn2;
                //添加左侧view
                UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
                _addressF.leftViewMode = UITextFieldViewModeAlways;
                _addressF.leftView = leftView;
            }
            [cell addSubview:_addressF];
            return cell;
        }
            break;
    }
    HIDE_HUD
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_mainTableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0 && row ==1) {
        //选择logo
        type = 1;
        [self chooseLogo];
    }else if (section == 0 && row ==2){
        //选择banner
        type = 2;
        [self chooseLogo];
    }
    else if(section == 2 && row ==0){
        [_shopIntroTV resignFirstResponder];
        __block JHPickerView * pickerView = [[JHPickerView alloc]init];
        [pickerView showPickerViewWithArray1:array_father withArray2:array_son withSelectedRow1:row1 withSelectedRow2:row2 withBlock:^(NSInteger selected1, NSInteger selected2, NSString *result) {
            [pickerView removeFromSuperview];
            pickerView = nil;
            if (result) {
                _shopClassifyL.text = result;
                row1 = selected1;
                row2 = selected2;
                if ([result containsString:@"-"]) {
                    cate_id = typeModel.children_cateID[row1][row2];
                }else{
                    cate_id = typeModel.fatherArray_cateID[row1];
                }
            }
        }];

    }
    else if (section == 3 && row == 0){
        XHPlacePicker *placePicker = [[XHPlacePicker alloc] initWithPlaceCallback:^(XHLocationInfo *place) {
            _addressF.text = place.address;
            lat = @(place.bdCoordinate.latitude).stringValue;
            lng = @(place.bdCoordinate.longitude).stringValue;
            
        }];
        [placePicker startPlacePicker];
    }
}
#pragma mark - chooseLogo
- (void)chooseLogo
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil)
                                                      style:UIAlertActionStyleCancel
                                                    handler:nil];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:NSLocalizedString(@"相册", nil)
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * _Nonnull action) {
                                                        
                                                        XHChoosePhoto *xhchooseP = [[XHChoosePhoto alloc] init];
                                                        xhchooseP.scaleSize = CGSizeMake(800, 800);
                                                        [self addChildViewController:xhchooseP];
                                                        [xhchooseP startChoosePhoto];
                                                        __weak typeof(self)weakSelf = self;
                                                        [xhchooseP setGetImageBlock:^(UIImage *selectedImage,NSData *imageData){
                                                            [weakSelf updateImageAndData:selectedImage data:imageData];
                                            
                                                        }];
                                                    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:NSLocalizedString(@"拍照", nil)
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * _Nonnull action) {
                                                        
                                                        XHChoosePhoto *xhchooseP = [[XHChoosePhoto alloc] init];
                                                        xhchooseP.scaleSize = CGSizeMake(800, 800);
                                                        [self addChildViewController:xhchooseP];
                                                        [xhchooseP startTakePhoto];
                                                        __weak typeof(self)weakSelf = self;
                                                        [xhchooseP setGetImageBlock:^(UIImage *selectedImage,NSData *imageData){
                                                            [weakSelf updateImageAndData:selectedImage data:imageData];
                                                
                                                        }];
                                                        
                                                    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [alert addAction:action3];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark - 更新image
- (void)updateImageAndData:(UIImage *)img data:(NSData *)imgData
{
    if (type == 1) {
        _logoIV.image = img;
        image_data = imgData;
    }else{
        banner.image = img;
        banner_data = imgData;
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:NSLocalizedString(@"请输入店铺简介", nil)]) {
        textView.text = @"";
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length == 0) {
        textView.text = NSLocalizedString(@"请输入店铺简介", nil);
    }
}
//-------------------------IQKeyBoard------
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([IQKeyboardManager sharedManager].enable) {
        
    }else{
        [self.view endEditing:YES];
    }
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [IQKeyboardManager sharedManager].enable = NO;
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [IQKeyboardManager sharedManager].enable = YES;
}

@end
