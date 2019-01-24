//
//  JHDeliveryShopInfoVC.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/19.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHdeliveryOpenVC.h"
#import "DeliveryIntroCell.h"
#import "XHChoosePhoto.h"
#import <IQKeyboardManager.h>
#import "DeliveryShopInfoVM.h"
#import "JHPickerView.h"
@interface JHdeliveryOpenVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *mainTableView;
@end

@implementation JHdeliveryOpenVC
{
    //保存店铺名
    UITextField *nameField;
    //保存店铺logo
    UIImageView *logoIV;
    //保存电话
    UITextField *phoneField;
    //保存分类
    UILabel *classifyLabel;
    //简介分类
    DeliveryIntroCell *introCell;
    DeliveryShopInfoVM *vm;
    //保存图片数据流
    NSData *logoData;
    NSInteger row1;
    NSInteger row2;
    NSMutableArray * fatherArray;
    NSMutableArray * children;
    NSMutableArray * fatherArray_cateID;
    NSMutableArray * children_cateID;
    NSString *cate_id;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"外送开通", nil);
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    fatherArray = @[].mutableCopy;
    children = @[].mutableCopy;
    fatherArray_cateID = @[].mutableCopy;
    children_cateID = @[].mutableCopy;
    //创建表视图
    [self createTableView];
    //添加底部按钮
    [self addBottomBtn];
    //获取分类
    [self performSelectorInBackground:@selector(getCate) withObject:nil];
}
#pragma mark - 创建表视图
- (void)createTableView
{
    _mainTableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, WIDTH, HEIGHT - 64)
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
- (void)getCate
{
    [HttpTool postWithAPI:@"biz/waimai/cate/items"
               withParams:@{}
                  success:^(id json) {
                      NSLog(@"biz/waimai/items--%@",json);
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
                      [_mainTableView reloadData];
                  }
                  failure:^(NSError *error) {
                      
                  }];
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
    [sureBtn setTitle:NSLocalizedString(@"提交资料", nil) forState:(UIControlStateNormal)];
    [sureBtn addTarget:self action:@selector(clickSureBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
}
#pragma mark - tableView delegate and dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 1;
            break;
        default:
            return 1;
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0 && row == 1) {
        return 60;
    }else if(section == 3 && row == 0){
        
        return 150;
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
                UITableViewCell *cell = [UITableViewCell new];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(10, 0, 70, 44)];
                titleLabel.text = NSLocalizedString(@"店铺名称", nil);
                titleLabel.font = FONT(15);
                titleLabel.textColor = HEX(@"333333", 1.0f);
                [cell addSubview:titleLabel];
                if (!nameField) {
                    nameField = [[UITextField alloc] initWithFrame:FRAME(80, 5, WIDTH - 90, 34)];
                    nameField.textColor = THEME_COLOR;
                    nameField.font = FONT(15);
                    nameField.placeholder = NSLocalizedString(@"请输入店铺名称", nil);
                }
                [cell addSubview:nameField];
                return cell;
            }else{
                
                UITableViewCell *cell = [UITableViewCell new];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(10, 0, 70, 60)];
                titleLabel.text = NSLocalizedString(@"店铺Logo", nil);
                titleLabel.font = FONT(15);
                titleLabel.textColor = HEX(@"333333", 1.0f);
                [cell addSubview:titleLabel];
                if (!logoIV) {
                    logoIV = [[UIImageView alloc] initWithFrame:FRAME(0, 10, 40, 40)];
                    logoIV.center = CGPointMake(WIDTH-60, 30);
                    logoIV.layer.cornerRadius = 3;
                    logoIV.layer.masksToBounds = YES;
                }
                [cell addSubview:logoIV];
                return cell;
            }
        }
            break;
        case 1:
        {
            UITableViewCell *cell = [UITableViewCell new];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(10, 0, 70, 44)];
            titleLabel.text = NSLocalizedString(@"客服电话", nil);
            titleLabel.font = FONT(15);
            titleLabel.textColor = HEX(@"333333", 1.0f);
            [cell addSubview:titleLabel];
            if (!phoneField) {
                phoneField = [[UITextField alloc] initWithFrame:FRAME(80, 5, WIDTH - 90, 34)];
                phoneField.textColor = THEME_COLOR;
                phoneField.font = FONT(15);
                phoneField.placeholder = NSLocalizedString(@"请输入客服电话", nil);
            }
            [cell addSubview:phoneField];
            return cell;
        }
            break;
        case 2:
        {
            UITableViewCell *cell = [UITableViewCell new];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(10, 0, 70, 44)];
            titleLabel.text = NSLocalizedString(@"店铺分类", nil);
            titleLabel.font = FONT(15);
            titleLabel.textColor = HEX(@"333333", 1.0f);
            [cell addSubview:titleLabel];
            if (!classifyLabel) {
                classifyLabel = [[UILabel alloc] initWithFrame:FRAME(80, 5, WIDTH - 120, 34)];
                classifyLabel.textColor = THEME_COLOR;
                classifyLabel.font = FONT(15);
                classifyLabel.textAlignment = NSTextAlignmentRight;
            }
            [cell addSubview:classifyLabel];
            return cell;
        }
            break;
        default:
        {
//            DeliveryIntroCell *introCell = [[DeliveryIntroCell alloc]init];
            //简介cell
            if (!introCell) {
                introCell = [[DeliveryIntroCell alloc] init];
                introCell.frame = FRAME(0, 0, WIDTH, 150);
                introCell.isShop = YES;
            }
            return introCell;
        }
            break;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_mainTableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0 && row == 1) {
        [self.view endEditing:YES];
        //选择店铺logo
        [self chooseLogo];
    }else if(section == 2 && row == 0){
        
        if (fatherArray.count == 0) {
            [HttpTool postWithAPI:@"biz/waimai/cate/items"
                       withParams:@{}
                          success:^(id json) {
                              NSLog(@"biz/waimai/getcate--%@",json);
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
                                  if(fatherArray.count == 0){
                                      [JHShowAlert showAlertWithMsg:NSLocalizedString(@"请先设置店铺分类", nil)];
                                      return ;
                                      
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
                                                                  if ([result containsString:@"-"]) {
                                                                      cate_id = children_cateID[row1][row2];
                                                                  }else{
                                                                      cate_id = fatherArray_cateID[row1];
                                                                  }
                                                                  classifyLabel.text = result;
                                                                  [cate_picker removeFromSuperview];
                                                                  cate_picker = nil;
                                                              }];
                              }
                          }
                          failure:^(NSError *error) {
                              
                          }];
            
        }else{
            //进入选择分类界面
            __block JHPickerView *cate_picker = [[JHPickerView alloc] init];
            [cate_picker showPickerViewWithArray1:fatherArray
                                       withArray2:children
                                 withSelectedRow1:row1
                                 withSelectedRow2:row2
                                        withBlock:^(NSInteger selected1, NSInteger selected2, NSString *result) {
                                            if (result) {
                                                row1 = selected1;
                                                row2 = selected2;
                                                if ([result containsString:@"-"]) {
                                                    cate_id = children_cateID[row1][row2];
                                                }else{
                                                    cate_id = fatherArray_cateID[row1];
                                                }
                                                classifyLabel.text = result;
                                            }
                                            [cate_picker removeFromSuperview];
                                            cate_picker = nil;
                                        }];
        }
    }
}
#pragma mark - 选择店铺logo
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
#pragma mark - 点击提交按钮
- (void)clickSureBtn:(UIButton *)sender
{
    if (!cate_id || [cate_id integerValue] == 0 ) {
        [JHShowAlert showAlertWithMsg:NSLocalizedString(@"请选择分类", nil)];
        return;
    }
    if (nameField.text.length == 0) {
        [JHShowAlert showAlertWithMsg:NSLocalizedString(@"请输入店铺名称", nil)];
        return;
    }
    if (phoneField.text.length == 0) {
        [JHShowAlert showAlertWithMsg:NSLocalizedString(@"请输入客服电话", nil)];
        return;
    }
    if (logoData == nil) {
        [JHShowAlert showAlertWithMsg:NSLocalizedString(@"请选择店铺Logo", nil)];
        return;
    }
    SHOW_HUD
    NSDictionary *paramDic = @{@"title":nameField.text,
                               @"phone":phoneField.text,
                               @"cate_id":cate_id,
                               @"info":introCell.introTextView.text ? introCell.introTextView.text : @""};
    [HttpTool postWithAPI:@"biz/waimai/reg/index"
                   params:paramDic
                  dataDic:@{@"logo":logoData}
                  success:^(id json) {
                      NSLog(@"biz/waimai/reg/index--%@",json);
                      HIDE_HUD
                      if ([json[@"error"] isEqualToString:@"0"]) {
                          [JHShowAlert showAlertWithMsg:NSLocalizedString(@"修改成功", nil)];
                      }else{
                          [JHShowAlert showAlertWithMsg:json[@"message"]];
                      }
                  } failure:^(NSError *error) {
                      HIDE_HUD
                      [JHShowAlert showAlertWithMsg:NSLocalizedString(@"服务器连接异常", nil)];
                  }];
}
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
#pragma mark - 更新image
- (void)updateImageAndData:(UIImage *)img data:(NSData *)imgData
{
    logoData = imgData;
    logoIV.image = img;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
