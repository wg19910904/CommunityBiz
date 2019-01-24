//
//  DeliveryProductModifyVC.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/28.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "DeliveryProductAddVC.h"
#import "DeliveryProductAddCellOne.h"
#import "DeliveryProductModifyCellTwo.h"
#import "DeliveryIntroCell.h"
#import "DeliveryProductCellOneAddModel.h"
#import "JHPickerView.h"
#import <IQKeyboardManager.h>
#import "XHChoosePhoto.h"
@interface DeliveryProductAddVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate>
@property(nonatomic,strong)UITableView *mainTableView;
@end

@implementation DeliveryProductAddVC
{
    UITextField *_productNameF;//商品名
    UILabel *_productClssifyL;//商品分类
    UISwitch *_xianliangS;//限量开关
    UITextField *_kuCunNumF;//库存量
    UITextField *_sortNumF;//排序号
    UITextField *_priceF;//售价
    UITextField *_packagePriceF;//打包费
    UILabel *_productUnitL;//售价单位
    UIButton *_guigeYesB;//可选规格是按钮
    UIButton *_guigeNoB;//可选规格否按钮
    
    DeliveryIntroCell *_introCell;
    DeliveryProductCellOneAddModel *cellOneAddModel;
    //商品分类
    NSInteger row1;
    NSInteger row2;
    NSMutableArray * fatherArray;
    NSMutableArray * children;
    NSMutableArray * fatherArray_cateID;
    NSMutableArray * children_cateID;
    NSString *cate_id;
    NSInteger num;
    UISwitch * _isShelf;
    BOOL is_onsale;
    XHChoosePhoto *choosePhoto;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    //添加导航栏右侧按钮
    [self addRightBtn];
    //初始化表视图
    [self createTableView];
    [self performSelectorInBackground:@selector(getCate) withObject:nil];
}
- (void)initData
{   is_onsale = YES;
    self.navigationItem.title = NSLocalizedString(@"添加外送商品", nil);
    cellOneAddModel = [DeliveryProductCellOneAddModel new];
    cellOneAddModel.imgArray = @[].mutableCopy;
    fatherArray = @[].mutableCopy;
    children = @[].mutableCopy;
    fatherArray_cateID = @[].mutableCopy;
    children_cateID = @[].mutableCopy;
    num = 1;
}
#pragma mark - 添加导航栏右侧按钮
- (void)addRightBtn
{
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:FRAME(0, 0, 40, 30)];
    [rightBtn setTitle:NSLocalizedString(@"完成", nil) forState:(UIControlStateNormal)];
    [rightBtn setTitleColor:HEX(@"faaf19", 1.0f) forState:(UIControlStateNormal)];
    rightBtn.titleLabel.font = FONT(16);
    [rightBtn addTarget:self action:@selector(clickRightBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}
#pragma mark - 获取商品分类
- (void)getCate
{
    [HttpTool postWithAPI:@"biz/waimai/product/cate/items"
               withParams:@{}
                  success:^(id json) {
                      NSLog(@"biz/waimai/product/cate/items--%@",json);
                      if ([json[@"error"] isEqualToString:@"0"]) {
                          NSArray * tempArray = json[@"data"][@"items"];
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
                      }
                  }
                  failure:^(NSError *error) {
                      
                  }];
}
#pragma mark - 初始化表视图
- (void)createTableView
{
    self.mainTableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:FRAME(0, 0, WIDTH, HEIGHT - 64-10)
                                                              style:(UITableViewStyleGrouped)];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.layoutMargins = UIEdgeInsetsZero;
        tableView.separatorInset = UIEdgeInsetsZero;
        tableView.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
        tableView.separatorColor = LINE_COLOR;
        [self.view addSubview:tableView];
        tableView;
    });
}
#pragma mark - tableView delegate and dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 3;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 1;
            break;
        case 3:
            return 2;
            break;
        case 4:
            return 0;
            break;
        default:
        {
            return 1;
        }
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 1:
            return 0.01;
            break;
        case 3:
            return 10;
            break;
        case 4:
            return 10;
            break;
        case 5:
            return 10;
            break;
        default:
            return 0.01;
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 44;
    }
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        UIView *bgV = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 44)];
        bgV.backgroundColor = [UIColor whiteColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(10, 0, 70, 44)];
        titleLabel.text = NSLocalizedString(@"是否上架", nil);
        titleLabel.font = FONT(15);
        titleLabel.textColor = HEX(@"333333", 1.0f);
        [bgV addSubview:titleLabel];
        if (_isShelf == nil) {
            //添加右侧开关
            _isShelf = [[UISwitch alloc] initWithFrame:CGRectMake(WIDTH - 56, 5, 90,30)];
            _isShelf.transform = CGAffineTransformMakeScale( .8, .8);
            _isShelf.onTintColor = THEME_COLOR;
            [_isShelf addTarget:self action:@selector(changShelfSwitch:) forControlEvents:UIControlEventValueChanged];
            _isShelf.on = YES;
            [bgV addSubview:_isShelf];
        }
        return bgV;
    }
    return NULL;
    
}
#pragma mark - 这是是否上架的方法
-(void)changShelfSwitch:(UISwitch *)sender{
    if (sender.on) {
        is_onsale = YES;
    }else{
        is_onsale = NO;
    }
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    if (section == 1) {
//        UIView *bgV = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 44)];
//        bgV.backgroundColor = [UIColor whiteColor];
//        UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(10, 0, 70, 44)];
//        titleLabel.text = NSLocalizedString(@"限量", nil);
//        titleLabel.font = FONT(15);
//        titleLabel.textColor = HEX(@"333333", 1.0f);
//        [bgV addSubview:titleLabel];
//        //添加右侧开关
//        if (!_xianliangS) {
//            _xianliangS = [[UISwitch alloc] initWithFrame:CGRectMake(WIDTH - 56, 5, 90,30)];
//            _xianliangS.transform = CGAffineTransformMakeScale( .8, .8);
//            _xianliangS.onTintColor = THEME_COLOR;
//            _xianliangS.on = YES;
//            [_xianliangS addTarget:self action:@selector(changeValue:) forControlEvents:UIControlEventValueChanged];
//        }
//        [bgV addSubview:_xianliangS];
//        return bgV;
//    }else{
//        
//        return [UIView new];
//    }
//}
#pragma mark - 这是限量的开关发生改变的方法
-(void)changeValue:(UISwitch *)sender{
    if (sender.on) {
        num = 1;
    }else{
        num = 0;
        _kuCunNumF.text = @"";
    }
    [_mainTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0 && row == 0) {
        return [DeliveryProductAddCellOne getHeight:cellOneAddModel.imgArray.count];
    }else if(section == 5){
        return 150;
    }else{
        return 44;
    }
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
                    DeliveryProductAddCellOne *cell = [_mainTableView dequeueReusableCellWithIdentifier:@"DeliveryProductAddCellOneID"];
                    if (!cell) {
                        cell = [[DeliveryProductAddCellOne alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"DeliveryProductModifyCellOneID"];
                    }
                    cell.dataModel = cellOneAddModel;
                    [cell.addBtn addTarget:self action:@selector(clickAddBtn:) forControlEvents:(UIControlEventTouchUpInside)];
                    return cell;
                }
                    break;
                case 1:
                {
                    UITableViewCell *cell = [UITableViewCell new];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(10, 0, 70, 44)];
                    titleLabel.text = NSLocalizedString(@"商品名称", nil);
                    titleLabel.font = FONT(15);
                    titleLabel.textColor = HEX(@"333333", 1.0f);
                    [cell addSubview:titleLabel];
                    if (!_productNameF) {
                        _productNameF = [[UITextField alloc] initWithFrame:FRAME(80, 5, WIDTH - 90, 34)];
                        _productNameF.textColor = THEME_COLOR;
                        _productNameF.font = FONT(15);
                    }
                    [cell addSubview:_productNameF];
                    return cell;
                }
                    break;
                default:
                {
                    UITableViewCell *cell = [UITableViewCell new];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(10, 0, 70, 44)];
                    titleLabel.text = NSLocalizedString(@"商品分类", nil);
                    titleLabel.font = FONT(15);
                    titleLabel.textColor = HEX(@"333333", 1.0f);
                    [cell addSubview:titleLabel];
                    if (!_productClssifyL) {
                        _productClssifyL = [[UILabel alloc] initWithFrame:FRAME(80, 5, WIDTH - 120, 34)];
                        _productClssifyL.textColor = THEME_COLOR;
                        _productClssifyL.font = FONT(15);
                        _productClssifyL.textAlignment = NSTextAlignmentRight;
                        _productClssifyL.text = NSLocalizedString(@"去选择", nil);
                    }
                    
                    [cell addSubview:_productClssifyL];
                    return cell;
                }
                    break;
            }
        }
            break;
        case 1:
        {
            UITableViewCell *cell = [UITableViewCell new];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(10, 0, 70, 44)];
            titleLabel.text = NSLocalizedString(@"库存", nil);
            titleLabel.font = FONT(15);
            titleLabel.textColor = HEX(@"333333", 1.0f);
            [cell addSubview:titleLabel];
            if (!_kuCunNumF) {
                _kuCunNumF = [[UITextField alloc] initWithFrame:FRAME(80, 5, WIDTH - 90, 34)];
                _kuCunNumF.textColor = THEME_COLOR;
                _kuCunNumF.font = FONT(15);
                _kuCunNumF.keyboardType = UIKeyboardTypeNumberPad;
                _kuCunNumF.delegate = self;
            }
            [cell addSubview:_kuCunNumF];
            return cell;
        }
            break;
        case 2:
        {
            UITableViewCell *cell = [UITableViewCell new];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(10, 0, 70, 44)];
            titleLabel.text = NSLocalizedString(@"排序号", nil);
            titleLabel.font = FONT(15);
            titleLabel.textColor = HEX(@"333333", 1.0f);
            [cell addSubview:titleLabel];
            if (!_sortNumF) {
                _sortNumF = [[UITextField alloc] initWithFrame:FRAME(80, 5, WIDTH - 90, 34)];
                _sortNumF.textColor = THEME_COLOR;
                _sortNumF.font = FONT(15);
                _sortNumF.delegate = self;
                _sortNumF.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
                UIView *leftView = [[UIView alloc] initWithFrame:FRAME(0, 0, 10, 34)];
                _sortNumF.leftViewMode = UITextFieldViewModeAlways;
                _sortNumF.leftView = leftView;
                //添加右侧文字
                UILabel *remidLabel = [[UILabel alloc] initWithFrame:FRAME(0, 0, WIDTH - 170, 34)];
                remidLabel.text = [@"  " stringByAppendingString:NSLocalizedString(@"提示:数字越小越靠前", nil)];
                remidLabel.font = FONT(12);
                remidLabel.textColor = THEME_COLOR;
                remidLabel.backgroundColor = [UIColor whiteColor];
                _sortNumF.rightViewMode = UITextFieldViewModeAlways;
                _sortNumF.rightView = remidLabel;
                
                _sortNumF.keyboardType = UIKeyboardTypeNumberPad;
            }
            [cell addSubview:_sortNumF];
            return cell;
        }
            break;
        case 3:
        {
            if (row == 0) {
                UITableViewCell *cell = [UITableViewCell new];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(10, 0, 70, 44)];
                titleLabel.text = NSLocalizedString(@"售价", nil);
                titleLabel.font = FONT(15);
                titleLabel.textColor = HEX(@"333333", 1.0f);
                [cell addSubview:titleLabel];
                if (!_priceF) {
                    _priceF = [[UITextField alloc] initWithFrame:FRAME(80, 5, WIDTH - 90, 34)];
                    _priceF.textColor = THEME_COLOR;
                    _priceF.font = FONT(15);
                    _priceF.textAlignment = NSTextAlignmentRight;
                    _priceF.keyboardType = UIKeyboardTypeDecimalPad;
                    _priceF.delegate = self;
                    //添加右侧文字
                    UILabel *remidLabel = [[UILabel alloc] initWithFrame:FRAME(0, 0, 30, 34)];
                    remidLabel.text = MS;
                    remidLabel.font = FONT(12);
                    remidLabel.textColor = THEME_COLOR;
                    remidLabel.backgroundColor = [UIColor whiteColor];
                    remidLabel.textAlignment = NSTextAlignmentCenter;
                    _priceF.rightViewMode = UITextFieldViewModeAlways;
                    _priceF.rightView = remidLabel;
                }
                [cell addSubview:_priceF];
                return cell;
            }else{
                UITableViewCell *cell = [UITableViewCell new];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(10, 0, 70, 44)];
                titleLabel.text = NSLocalizedString(@"打包费", nil);
                titleLabel.font = FONT(15);
                titleLabel.textColor = HEX(@"333333", 1.0f);
                [cell addSubview:titleLabel];
                if (!_packagePriceF) {
                    _packagePriceF = [[UITextField alloc] initWithFrame:FRAME(80, 5, WIDTH - 90, 34)];
                    _packagePriceF.textColor = THEME_COLOR;
                    _packagePriceF.font = FONT(15);
                    _packagePriceF.textAlignment = NSTextAlignmentRight;
                    _packagePriceF.keyboardType = UIKeyboardTypeDecimalPad;
                    _packagePriceF.delegate = self;
                    //添加右侧文字
                    UILabel *remidLabel = [[UILabel alloc] initWithFrame:FRAME(0, 0, 30, 34)];
                    remidLabel.text = MS;
                    remidLabel.font = FONT(12);
                    remidLabel.textColor = THEME_COLOR;
                    remidLabel.backgroundColor = [UIColor whiteColor];
                    remidLabel.textAlignment = NSTextAlignmentCenter;
                    _packagePriceF.rightViewMode = UITextFieldViewModeAlways;
                    _packagePriceF.rightView = remidLabel;
                }
                [cell addSubview:_packagePriceF];
                return cell;
            }
        }
            break;
        case 4:
        {
            UITableViewCell *cell = [UITableViewCell new];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(10, 0, 70, 44)];
            titleLabel.text = NSLocalizedString(@"售价单位", nil);
            titleLabel.font = FONT(15);
            titleLabel.textColor = HEX(@"333333", 1.0f);
            [cell addSubview:titleLabel];
            if (!_productUnitL) {
                _productUnitL = [[UILabel alloc] initWithFrame:FRAME(80, 5, WIDTH - 120, 34)];
                _productUnitL.textColor = THEME_COLOR;
                _productUnitL.font = FONT(15);
                _productUnitL.textAlignment = NSTextAlignmentRight;
            }
            [cell addSubview:_productUnitL];
            return cell;
        }
            break;
        default:
        {
            //简介cell
            if (!_introCell) {
                _introCell = [[DeliveryIntroCell alloc] init];
                _introCell.frame = FRAME(0, 0, WIDTH, 150);
                _introCell.isShop = NO;
                _introCell.introTextView.delegate = self;
            }
            return _introCell;
        }
            break;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_mainTableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
    if (indexPath.section == 0 && indexPath.row == 2) {
        if(fatherArray.count == 0){
            [JHShowAlert showAlertWithMsg:NSLocalizedString(@"您还没有分类,请先去添加分类", nil)];
            return;
        }
        //进入选择分类界面
        __block JHPickerView *cate_picker = [[JHPickerView alloc] init];
        [cate_picker showPickerViewWithArray1:fatherArray
                                   withArray2:children
                             withSelectedRow1:row1
                             withSelectedRow2:row2
                                    withBlock:^(NSInteger selected1, NSInteger selected2, NSString *result) {
                                        row1 = selected1;
                                        row2 = selected2;
                                        if (result) {
                                            if ([result containsString:@"-"]) {
                                                cate_id = children_cateID[row1][row2];
                                            }else{
                                                cate_id = fatherArray_cateID[row1];
                                            }
                                            _productClssifyL.text = result;
                                        }
                                        [cate_picker removeFromSuperview];
                                        cate_picker = nil;
                                    }];

    }
    if (indexPath.section == 4) {
        //组件单位数组
        NSArray *unitArray = @[NSLocalizedString(@"份", nil)];
        __block JHPickerView *cate_picker = [[JHPickerView alloc] init];
        [cate_picker showpickerViewWithArray:unitArray.mutableCopy withBlock:^(NSString *result) {
            if (result) {
                _productUnitL.text = result;
            }
            [cate_picker removeFromSuperview];
            cate_picker = nil;
        }];
    }
}
#pragma mark - 点击了添加图片按钮
- (void)clickAddBtn:(UIButton *)sender
{
    __weak typeof(self)weakSelf = self;
    if (!choosePhoto) {
        choosePhoto = [[XHChoosePhoto alloc] init];
        choosePhoto.scaleSize = CGSizeMake(800, 800);
        [self addChildViewController:choosePhoto];
        choosePhoto.getImageBlock = ^(UIImage *image,NSData *imageData){
            [weakSelf getImage:imageData];
        };
    }
    [choosePhoto startChoosePhoto];
}
- (void)getImage:(NSData*)imageData
{
    [cellOneAddModel.imgArray removeAllObjects];
    [cellOneAddModel.imgArray addObject:imageData];
    [_mainTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]
                          withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark - 点击完成按钮
- (void)clickRightBtn:(UIButton *)sender
{
    //组建参数
    if (cellOneAddModel.imgArray.count == 0) {
        [JHShowAlert showAlertWithMsg:NSLocalizedString(@"请选择菜品图片", nil)];
    }
    NSString *title = _productNameF.text;
    NSString *orderby = _sortNumF.text;
    NSString *price = _priceF.text;
    NSString *package_price = _packagePriceF.text;
    NSString *intro = _introCell.introTextView.text;
    NSString *sale_sku = _kuCunNumF.text;
    if (title.length == 0 || orderby.length == 0 || price.length == 0
        ||  (_xianliangS.on ? sale_sku.length == 0 : NO)) {
        [JHShowAlert showAlertWithMsg:NSLocalizedString(@"商品信息不完善!", nil)];
        return;
    }
    NSDictionary *paramDic = @{@"cate_id":cate_id,
                               @"title":title,
                               @"price":price,
                               @"package_price":package_price,
                               @"sale_type":@(_xianliangS.on),
                               @"sale_sku":sale_sku,
                               @"intro":intro,
                               @"orderby":orderby,
                               @"is_onsale":@(is_onsale)};
    SHOW_HUD
    [HttpTool postWithAPI:@"biz/waimai/product/product/create"
                   params:paramDic
                  dataDic:@{@"photo":cellOneAddModel.imgArray[0]}
                  success:^(id json) {
                      HIDE_HUD
                      NSLog(@"biz/waimai/product/product/create--%@",json);
                      if ([json[@"error"] isEqualToString:@"0"]) {
                          [JHShowAlert showAlertWithMsg:NSLocalizedString(@"添加成功", nil)
                                           withBtnTitle:NSLocalizedString(@"确定", nil)
                                           withBtnBlock:^{
                                               [self.navigationController popViewControllerAnimated:YES];
                                           }];
                      }else{
                          [JHShowAlert showAlertWithMsg:json[@"message"]];
                      }
                      
                  }failure:^(NSError *error) {
                      HIDE_HUD
                      [JHShowAlert showAlertWithMsg:NSLocalizedString(@"服务器连接异常", nil)];
                  }];
}

#pragma mark - 这是UITextField的代理方法
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [IQKeyboardManager sharedManager].enable = YES;
    return YES;
}
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [IQKeyboardManager sharedManager].enable = YES;
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}
#pragma mark - 滑动表的时候让键盘下落
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([IQKeyboardManager sharedManager].enable) {
    }else{
        [self.view endEditing:YES];
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

@end
