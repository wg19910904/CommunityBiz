//
//  JHOpenShopVC.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/16.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHOpenShopVC.h"
#import "UIButton+BackgroundColor.h"
#import "JHOpenShopCellOne.h"
#import "JHOpenShopCellTwo.h"
#import "JHOpenShopCellThree.h"
#import <IQKeyboardManager.h>
#import "JHShopOpenSuccessVC.h"
#import "JHPickerView.h"
#import "GaoDe_Convert_BaiDu.h"
#import "JHShopTypeModel.h"
#import "UILabel+XHTool.h"
#import "JHWebVC.h"
#import "XHCodeTF.h"
@interface JHOpenShopVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate>
{
    UITableView * myTableView;//创建的表视图
    UITextView * myTextView;//店铺简介的输入框
    UILabel * label_num;//显示输入框还可以输入多少字
    UITextField * textField_name;//申请人姓名
    XHCodeTF * textField_phone;//申请人联系电话
    UITextField * textField_security;//验证码
    UITextField * textField_psd;//密码
    UITextField * textField_shopName;//店铺名称
    UITextField * textField_mobile;//服务电话
    UITextField * textField_type;//店铺类型
    UITextField * textField_address;//店铺地址
    NSInteger row1;//保存父类的选中行
    NSInteger row2;//保存子类的选中行
    NSMutableArray * array_father;//保存父类的数组
    NSMutableArray * array_son;//保存子类的数组
    NSString * lat;
    NSString * lng;
    NSString * cate_id;
    JHShopTypeModel * typeModel;
    UIButton *chooseBtn;
    UILabel *xieyiL;
}
@end

@implementation JHOpenShopVC
- (void)viewDidLoad {
    [super viewDidLoad];
    //舒适化一些方法
    [self initData];
    //创建表视图
    [self creatUITableView];
    //创建提交的按钮
    [self creatUIButton];
    //请求分类数据
    [self postShopTypeHttp];
}
#pragma mark - 请求商户分类的方法
-(void)postShopTypeHttp{
    SHOW_HUD
    NSMutableArray * fatherArray = @[].mutableCopy;
    NSMutableArray * children = @[].mutableCopy;
    NSMutableArray * fatherArray_cateID = @[].mutableCopy;
    NSMutableArray * children_cateID = @[].mutableCopy;
    [HttpTool postWithAPI:@"biz/account/cate" withParams:@{} success:^(id json) {
        NSLog(@"%@",json);
        HIDE_HUD
        NSArray * tempArray = json[@"data"][@"cate"];
        for (NSDictionary * dic  in tempArray) {
            [fatherArray addObject:dic[@"title"]];
            [fatherArray_cateID addObject:dic[@"cate_id"]];
            NSArray * temp = dic[@"childrens"];
            NSLog(@"%@",temp);
            NSMutableArray * childrenArray = @[].mutableCopy;
            NSMutableArray * childrenArray_cateID = @[].mutableCopy;
            if (temp) {
                for (NSDictionary * dictionary in temp) {
                    [childrenArray addObject:dictionary[@"title"]];
                    [childrenArray_cateID addObject:dictionary[@"cate_id"]];
                }
                [children addObject:childrenArray];
                [children_cateID addObject:childrenArray_cateID];
            }else{
                [children addObject:childrenArray];
                [children_cateID addObject:childrenArray_cateID];
            }
        }
        JHShopTypeModel * model = [JHShopTypeModel shareShopTypeModel];
        model.fatherArray = fatherArray;
        model.children = children;
        model.fatherArray_cateID = fatherArray_cateID;
        model.children_cateID = children_cateID;
        [myTableView reloadData];
    } failure:^(NSError *error) {
        HIDE_HUD
        NSLog(@"%@",error.localizedDescription);
    }];
}

#pragma mark - 这是初始化的一些方法
-(void)initData{
    self.title =  NSLocalizedString(@"我要开店", NSStringFromClass([self class]));
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextChange:) name:UITextViewTextDidChangeNotification object:myTextView];
    typeModel = [JHShopTypeModel shareShopTypeModel];
    array_father = typeModel.fatherArray;
    array_son = typeModel.children;
}
#pragma mark - 这是创建表的方法
-(void)creatUITableView{
    myTableView = [[UITableView alloc]initWithFrame:FRAME(0, 0, WIDTH, HEIGHT - 64 - 53) style:UITableViewStylePlain];
    myTableView.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    myTableView.tableFooterView = [UIView new];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    myTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:myTableView];
    [myTableView registerClass:[JHOpenShopCellOne class] forCellReuseIdentifier:@"cell1"];
    [myTableView registerClass:[JHOpenShopCellTwo class] forCellReuseIdentifier:@"cell2"];
    [myTableView registerClass:[JHOpenShopCellThree class] forCellReuseIdentifier:@"cell3"];
    myTableView.delegate = self;
    myTableView.dataSource = self;
}
#pragma mark - 这是表视图的代理和数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 2) {
            return 120;
    }else{
            return 170;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 46;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [self footView];
}
- (UIView *)footView{
    //添加入驻协议
    xieyiL = [[UILabel alloc] initWithFrame:FRAME(0, 0, WIDTH, 46)];
    xieyiL.textColor = THEME_COLOR;
    xieyiL.textAlignment = NSTextAlignmentCenter;
    xieyiL.font = FONT(14);
    //获取平台名称
    NSString *appName = [NSBundle mainBundle].infoDictionary[@"CFBundleDisplayName"];
    xieyiL.text = [NSString stringWithFormat:NSLocalizedString(@"我已阅读《%@平台服务协议》", nil) ,appName];
    [xieyiL setColor:HEX(@"333333", 1.0) string:NSLocalizedString(@"我已阅读", nil)];
    //添加勾选按钮
    CGFloat tem_w = [xieyiL.text  boundingRectWithSize:CGSizeMake(10000, 12) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.width;
    CGFloat x = WIDTH/2-tem_w/2-37;
    chooseBtn = [[UIButton alloc] initWithFrame:FRAME(x, 7, 32, 32)];
    [chooseBtn setImage:IMAGE(@"selector_disable") forState:(UIControlStateNormal)];
    [chooseBtn setImage:IMAGE(@"selector_enable") forState:(UIControlStateSelected)];
    chooseBtn.imageEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8);
    [chooseBtn addTarget:self action:@selector(clickXieyibtn:) forControlEvents:(UIControlEventTouchUpInside)];
    //添加手势
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(clickXieyi)];
    [xieyiL addGestureRecognizer:gesture];
    xieyiL.userInteractionEnabled = YES;
    [xieyiL addSubview:chooseBtn];
    return xieyiL;
}
#pragma mark - 点击阅读协议的按钮
- (void)clickXieyibtn:(UIButton *)sender{
    sender.selected = !sender.selected;
}
- (void)clickXieyi{
    JHWebVC *web = [[JHWebVC alloc] init];
    web.urlStr = [NSString stringWithFormat:@"http://%@/page/bizprotocol/",KReplace_Url];
    [self.navigationController pushViewController:web animated:YES];
}

-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        if (indexPath.row == 0) {
            JHOpenShopCellOne * cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
            textField_name = cell.textFieldArray[0];
            textField_name.delegate = self;
            textField_phone = cell.textFieldArray[1];
            textField_phone.delegate = self;
            if ([textField_phone isKindOfClass:[XHCodeTF class]]) {
                textField_phone.showCode = SHOW_COUNTRY_CODE;
                __weak typeof(self)weakself = self;
                textField_phone.fatherVC = weakself;
            }
            textField_security = cell.textFieldArray[2];
            textField_security.delegate = self;
            textField_psd = cell.textFieldArray[3];
            textField_psd.delegate = self;
            return cell;
        }else if (indexPath.row == 1){
            JHOpenShopCellTwo * cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
            textField_shopName = cell.textFieldArray[0];
            textField_shopName.delegate = self;
            textField_mobile = cell.textFieldArray[1];
            textField_mobile.delegate = self;
            textField_type = cell.textFieldArray[2];
            textField_type.delegate = self;
            textField_address = cell.textFieldArray[3];
            textField_address.delegate = self;
            [cell.btn_type addTarget:self action:@selector(clickToGetType:) forControlEvents:UIControlEventTouchUpInside];
            [cell.btn_address addTarget:self action:@selector(clickToMapView:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }else{
            JHOpenShopCellThree * cell = [tableView dequeueReusableCellWithIdentifier:@"cell3" forIndexPath:indexPath];
            myTextView = cell.textView;
            myTextView.delegate = self;
            label_num = cell.label;
            return cell;
        }
}
#pragma mark - 这是UITextView的文本发生改变的通知
-(void)textViewTextChange:(NSNotification *)noti{
//    if (200 - myTextView.text.length == 0) {
//        myTextView.editable = NO;
//        label_num.text = NSLocalizedString(@"字数已到", nil);
//    }else{
//        label_num.text = [NSString stringWithFormat:NSLocalizedString(@"还剩%ld个字", nil),200 - myTextView.text.length];
//    }
}
#pragma mark - 这是UITextView的代理方法
- (void)textViewDidBeginEditing:(UITextView *)textView{
    if (textView == myTextView) {
        if ([textView.text isEqualToString: NSLocalizedString(@"店铺简介", NSStringFromClass([self class]))]) {
            textView.text = @"";
            //label_num.text = NSLocalizedString(@"200字以内", nil);
            textView.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        }
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView == myTextView) {
        if(textView.text.length == 0){
            textView.text =  NSLocalizedString(@"店铺简介", NSStringFromClass([self class]));
            textView.textColor = [UIColor colorWithWhite:0.6 alpha:1];
        }
    }
}
#pragma mark - 这是UITextField的代理方法
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [IQKeyboardManager sharedManager].enable = YES;
    xieyiL.hidden = YES;
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    xieyiL.hidden = NO;
    return YES;
}
#pragma mark - 滑动表的时候让键盘下落
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([IQKeyboardManager sharedManager].enable) {
        
    }else{
        [self.view endEditing:YES];
        xieyiL.hidden = NO;
    }
}
#pragma mark - 这是表结束减速的时候
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [IQKeyboardManager sharedManager].enable = YES;
}
#pragma mark - 这是表开始拖动的时候
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [IQKeyboardManager sharedManager].enable = NO;
}
#pragma mark - 创建提交的按钮
-(void)creatUIButton{
    UIButton * btn = [[UIButton alloc]init];
    btn.frame = FRAME(10, HEIGHT - 53 - 64, WIDTH - 20, 45);
    btn.layer.cornerRadius = 3;
    btn.clipsToBounds = YES;
    [btn setTitle: NSLocalizedString(@"提交", NSStringFromClass([self class])) forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor colorWithRed:248/255.0 green:168/255.0 blue:37/255.0 alpha:1] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor colorWithRed:248/255.0 green:168/255.0 blue:37/255.0 alpha:0.5] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(clickToCommit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}
#pragma mark - 这是点击获取店铺类型的方法
-(void)clickToGetType:(UIButton *)sender{
    [self.view endEditing:YES];
   __block JHPickerView * pickerView = [[JHPickerView alloc]init];
    [pickerView showPickerViewWithArray1:array_father withArray2:array_son withSelectedRow1:row1 withSelectedRow2:row2 withBlock:^(NSInteger selected1, NSInteger selected2, NSString *result) {
        [pickerView removeFromSuperview];
         pickerView = nil;
        if (result) {
            textField_type.text = result;
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
#pragma mark - 这是点击进入地图界面的方法
-(void)clickToMapView:(UIButton *)sender{
    [self.view endEditing:YES];
    XHPlacePicker *placePicker = [[XHPlacePicker alloc] initWithPlaceCallback:^(XHLocationInfo *place) {
        lat = [@(place.bdCoordinate.latitude) stringValue];
        lng = [@(place.bdCoordinate.longitude) stringValue];
        textField_address.text = place.address;
        textField_address.enabled = YES;
        
    }];
    [placePicker startPlacePicker];
}

#pragma mark - 这是点击提交的方法
-(void)clickToCommit{
    if (textField_name.text.length == 0 || textField_phone.text.length == 0 || textField_security.text.length == 0||textField_psd.text.length == 0||textField_shopName.text.length == 0||textField_mobile.text.length == 0||textField_type.text.length == 0 || textField_address.text.length == 0 ||[myTextView.text isEqualToString: NSLocalizedString(@"店铺简介", NSStringFromClass([self class]))]) {
        [JHShowAlert showAlertWithMsg: NSLocalizedString(@"请将信息补充完整", NSStringFromClass([self class]))];
        return;
    }
    if (chooseBtn.selected == NO) {
        [JHShowAlert showAlertWithMsg: NSLocalizedString(@"请先阅读并勾选平台服务协议", NSStringFromClass([self class]))];
        return;
    }
    NSString *intro = myTextView.text;
    if (intro.length == 0 ||
        [intro isEqualToString: NSLocalizedString(@"店铺简介", NSStringFromClass([self class]))]) {
        intro = @"";
    }
    [HttpTool postWithAPI:@"biz/account/signup" withParams:@{@"contact":textField_name.text,
                                                             @"mobile":textField_phone.text,
                                                             @"sms_code":textField_security.text,
                                                             @"passwd":textField_psd.text,
                                                             @"title":textField_shopName.text,
                                                             @"phone":textField_mobile.text,
                                                             @"cate_id":cate_id,
                                                             @"addr":textField_address.text,
                                                             @"intro":intro,
                                                             @"lat":lat,
                                                             @"lng":lng}
    success:^(id json) {
        if ([json[@"error"]isEqualToString:@"0"]) {
            JHShopOpenSuccessVC * vc = [[JHShopOpenSuccessVC alloc]init];
            vc.phone = textField_phone.text;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [JHShowAlert showAlertWithMsg:json[@"message"]];
        }
    } failure:^(NSError * error) {
    [JHShowAlert showAlertWithMsg: NSLocalizedString(@"服务器繁忙,请稍后再试", NSStringFromClass([self class]))];
   }];
}
@end
