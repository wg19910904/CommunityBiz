//
//  DeliveryProductAddGuigeVC.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/7/7.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "DeliveryProductModifyGuigeVC.h"
#import "DeliveryProductAddCellOne.h"
#import "XHChoosePhoto.h"
#import "DeliveryProductCellOneAddModel.h"
@interface DeliveryProductModifyGuigeVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *mainTableView;
@end

@implementation DeliveryProductModifyGuigeVC
{
    UITextField *_productNameF;//规格名称
    UISwitch *_xianliangS;//限量开关
    UITextField *_kuCunNumF;//库存量
    //UITextField *_sortNumF;//排序号
    UITextField *_priceF;//售价
    UITextField *_pack_priceF;//打包费
    DeliveryProductCellOneAddModel *cellOneModel;
    NSInteger num ;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
}
- (UITableView *)mainTableView
{
    _mainTableView = ({
        
        UITableView *table = [[UITableView alloc] initWithFrame:FRAME(0, 0, WIDTH, HEIGHT - 64)
                                                          style:UITableViewStyleGrouped];
        table.delegate = self;
        table.dataSource = self;
        table.separatorColor = LINE_COLOR;
        table.separatorInset = UIEdgeInsetsZero;
        table.layoutMargins = UIEdgeInsetsZero;
        table;
    });
    return _mainTableView;
}
- (void)initData
{
    self.navigationItem.title = _dataModel.spec_name;
    if(_dataModel.sale_sku.integerValue > 0){
        num = 1;
    }else{
        num = 0;
    }
    cellOneModel = [DeliveryProductCellOneAddModel new];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        cellOneModel.imgArray = @[[NSData dataWithContentsOfURL:[NSURL URLWithString:[IMAGEADDRESS stringByAppendingString:_dataModel.spec_photo]]]].mutableCopy;
        dispatch_async(dispatch_get_main_queue(), ^{
            [_mainTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            //添加导航栏右侧按钮
            [self addRightBtn];
            HIDE_HUD
        });
    });
    [self.view addSubview:self.mainTableView];
}
#pragma mark - 添加导航栏右侧按钮
- (void)addRightBtn
{
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:FRAME(0, 0, 40, 30)];
    [rightBtn setTitle:NSLocalizedString(@"完成", nil) forState:(UIControlStateNormal)];
    [rightBtn setTitleColor:HEX(@"faaf19", 1.0f) forState:(UIControlStateNormal)];
    rightBtn.titleLabel.font = FONT(16);
    [rightBtn addTarget:self action:@selector(clickSaveBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}
#pragma mark - tableView delegate and dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    if (section == 1) {
        return 1;
    }
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section ==1) {
        return 0.01;
    }
    if (section == 2) {
        return 10;
    }
    return 0.01;
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
//        if(_xianliangS == nil){
//            _xianliangS = [[UISwitch alloc] initWithFrame:CGRectMake(WIDTH - 56, 5, 90,30)];
//            _xianliangS.transform = CGAffineTransformMakeScale( .8, .8);
//            _xianliangS.onTintColor = THEME_COLOR;
//            if(_dataModel.sale_sku.integerValue > 0){
//                _xianliangS.on = YES;
//            }else{
//                 _xianliangS.on = NO;
//            }
//           
//            [_xianliangS addTarget:self action:@selector(changeValue:) forControlEvents:UIControlEventValueChanged];
//        }
//        [bgV addSubview:_xianliangS];
//        
//        return bgV;
//    }else{
//        
//        return [UIView new];
//    }
//}
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
    if (indexPath.section == 0 && indexPath.row == 0) {
        return [DeliveryProductAddCellOne getHeight:cellOneModel.imgArray.count];
    }
    return 44;
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
            if (row == 0) {
                DeliveryProductAddCellOne *cell = [_mainTableView dequeueReusableCellWithIdentifier:@"DeliveryProductAddCellOneID2"];
                if (!cell) {
                    cell = [[DeliveryProductAddCellOne alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"DeliveryProductModifyCellOneID2"];
                }
                cell.dataModel = cellOneModel;
                [cell.addBtn addTarget:self action:@selector(clickAddBtn:) forControlEvents:(UIControlEventTouchUpInside)];
                return cell;
            }else{
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
                _productNameF.text = _dataModel.spec_name;
                [cell addSubview:_productNameF];
                return cell;
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
            }
            _kuCunNumF.text = _dataModel.sale_sku;
            [cell addSubview:_kuCunNumF];
            return cell;
        }
            break;
        default:
        {
            if (indexPath.row == 0) {
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
                    _priceF.keyboardType = UIKeyboardTypeNumberPad;
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
                _priceF.text = [NSString stringWithFormat:@"%g",[_dataModel.price floatValue]];
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
                if (!_pack_priceF) {
                    _pack_priceF = [[UITextField alloc] initWithFrame:FRAME(80, 5, WIDTH - 90, 34)];
                    _pack_priceF.textColor = THEME_COLOR;
                    _pack_priceF.font = FONT(15);
                    _pack_priceF.textAlignment = NSTextAlignmentRight;
                    _pack_priceF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                    //添加右侧文字
                    UILabel *remidLabel = [[UILabel alloc] initWithFrame:FRAME(0, 0, 30, 34)];
                    remidLabel.text = MS;
                    remidLabel.font = FONT(12);
                    remidLabel.textColor = THEME_COLOR;
                    remidLabel.backgroundColor = [UIColor whiteColor];
                    remidLabel.textAlignment = NSTextAlignmentCenter;
                    _pack_priceF.rightViewMode = UITextFieldViewModeAlways;
                    _pack_priceF.rightView = remidLabel;
                }
                _pack_priceF.text = [NSString stringWithFormat:@"%g",[_dataModel.package_price floatValue]];
                [cell addSubview:_pack_priceF];
                return cell;
            }
        }
            break;
    }
}
#pragma mark - 点击了添加图片按钮
- (void)clickAddBtn:(UIButton *)sender
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
                                                        [xhchooseP setGetImageBlock:^(UIImage *selectedImage,NSData *imageData){
                                                            cellOneModel.imgArray = @[].mutableCopy;
                                                            [cellOneModel.imgArray addObject:imageData];
                                                            [_mainTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                                                            
                                                        }];
                                                    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:NSLocalizedString(@"拍照", nil)
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * _Nonnull action) {
                                                        
                                                        XHChoosePhoto *xhchooseP = [[XHChoosePhoto alloc] init];
                                                        xhchooseP.scaleSize = CGSizeMake(800, 800);
                                                        [self addChildViewController:xhchooseP];
                                                        [xhchooseP startTakePhoto];
                                                        [xhchooseP setGetImageBlock:^(UIImage *selectedImage,NSData *imageData){
                                                            cellOneModel.imgArray = @[].mutableCopy;
                                                            [cellOneModel.imgArray addObject:imageData];
                                                            [_mainTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                                                        }];
                                                        
                                                    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [alert addAction:action3];
    [self presentViewController:alert animated:YES completion:nil];
    
}
#pragma mark - 点击完成按钮
- (void)clickSaveBtn:(UIButton *)sender
{
    //组建参数
    NSString *spec_name = _productNameF.text;
    NSString *sale_sku = _kuCunNumF.text ? _kuCunNumF.text:@"";
    NSString *price = _priceF.text;
    if (spec_name.length == 0 || price.length == 0) {
        [JHShowAlert showAlertWithMsg:NSLocalizedString(@"请填写完整信息", nil)];
        return;
    }
    SHOW_HUD
    [HttpTool postWithAPI:@"biz/waimai/product/spec/update"
                   params:@{@"spec_id":_dataModel.spec_id,
                            @"price":price,
                            @"spec_name":spec_name,
                            @"sale_sku":sale_sku,
                            @"package_price":_pack_priceF.text
                            }
                  dataDic:@{@"spec_photo":cellOneModel.imgArray[0]}
                  success:^(id json) {
                      HIDE_HUD
                      NSLog(@"biz/waimai/product/spec/create--%@",json);
                      if ([json[@"error"] isEqualToString:@"0"]) {
                          [self.navigationController popViewControllerAnimated:YES];
                          
                      }else{
                          [JHShowAlert showAlertWithMsg:json[@"message"]];
                      }
                      
                  } failure:^(NSError *error) {
                      HIDE_HUD
                      [JHShowAlert showAlertWithMsg:NSLocalizedString(@"连接服务器异常", nil)];
                  }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
