//
//  BlueToothVC.m
//  WaimaiShop
//
//  Created by jianghu on 15/12/30.
//  Copyright © 2015年 ijianghu. All rights reserved.
//

#import "JHCloudPrinterSetVC.h"
#import <IQKeyboardManager.h>
@interface JHCloudPrinterSetVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITableView *_mainTableView;
    NSInteger num;
    UILabel *num_label;
    UITextField * _nameTextField;//打印机名称
    UITextField * _platIdTextField;//打印机id
    UITextField * _machina_codeTextField;//打印机终端号
    UITextField * _apikeyTextField;//打印机秘钥
    UITextField * _userIDTextField;//用户id
    UITextField * _machinaKey;//终端密钥
    NSString * plat_id;
}

@end

@implementation JHCloudPrinterSetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化数据
    [self initData];
    //初始化表视图
    [self createMainTableView];
    //添加右边的按钮
    [self creatRightBtn];
}
#pragma mark - 这是添加右边的按钮的方法
-(void)creatRightBtn{
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"完成", nil) style:UIBarButtonItemStylePlain target:self action:@selector(clickToCompletion)];
    self.navigationItem.rightBarButtonItem = rightItem;
}
#pragma mark - 这是点击完成调用的方法
-(void)clickToCompletion{
    if (self.model) {
        [self postHttpWithAPI:@"biz/printer/edit"];
    }else{
        if (_nameTextField.text.length == 0) {
            [JHShowAlert showAlertWithMsg:NSLocalizedString(@"请输入打印机名称", nil)];
            return;
        }else if(_machina_codeTextField.text.length == 0){
            [JHShowAlert showAlertWithMsg:NSLocalizedString(@"请输入打印机的终端号", nil)];
            return;
        }else if (_apikeyTextField.text.length == 0){
            [JHShowAlert showAlertWithMsg:NSLocalizedString(@"请输入API密钥", nil)];
            return;
        }else if (_userIDTextField.text.length == 0){
            [JHShowAlert showAlertWithMsg:NSLocalizedString(@"请输入用户UID", nil)];
            return;
        }else if(_machinaKey.text.length == 0){
            [JHShowAlert showAlertWithMsg:NSLocalizedString(@"请输入终端密钥", nil)];
            return;
        }
        [self postHttpWithAPI:@"biz/printer/create"];
    }
}
#pragma mark - 这是发送请求的方法
-(void)postHttpWithAPI:(NSString *)api{
    SHOW_HUD
    [HttpTool postWithAPI:api withParams:@{@"plat_id":plat_id,
                                           @"title":_nameTextField.text,
                                           @"partner":_userIDTextField.text,
                                           @"apikey":_apikeyTextField.text,
                                           @"machine_code":_machina_codeTextField.text,
                                           @"mkey":_machinaKey.text,
                                           @"num":@(num).stringValue} success:^(id json) {
                                               NSLog(@"**json:%@**",json);
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
#pragma mark - 初始化数据
- (void)initData
{
    if (self.model) {
        plat_id = self.model.plat_id;
    }else{
       plat_id = @"";
    }
    self.title = NSLocalizedString(@"云打印设置", nil);
    self.view.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
    self.automaticallyAdjustsScrollViewInsets = NO;
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"print_num"] == 0 || [[NSUserDefaults standardUserDefaults] integerForKey:@"print_num"] == 1) {
        num = 1;
    }else{
        num = [[NSUserDefaults standardUserDefaults] integerForKey:@"print_num"];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChange:) name:UITextFieldTextDidChangeNotification object:nil];
}
#pragma mark - 这是输入框改变的方法
-(void)textFieldChange:(NSNotification *)noti{
    if (self.model) {
        if (noti.object == _nameTextField) {
            self.model.title = _nameTextField.text;
        }else if (noti.object == _machina_codeTextField){
            self.model.machine_code = _machina_codeTextField.text;
        }else if (noti.object == _apikeyTextField){
            self.model.apikey = _apikeyTextField.text;
        }else if (noti.object == _userIDTextField){
            self.model.partner = _userIDTextField.text;
        }else if (noti.object == _platIdTextField)
            self.model.plat_id = _platIdTextField.text;
        else{
            self.model.mkey = _machinaKey.text;
        }
    }
}
#pragma mark - 初始化表视图
- (void)createMainTableView
{
    _mainTableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                              style:(UITableViewStyleGrouped)];
        
        tableView.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
        tableView.separatorColor = DEFAULT_BACKGROUNDCOLOR;
        tableView.delegate = self;
        tableView.dataSource = self;
        [self.view addSubview:tableView];
        tableView;
    });
    
}

#pragma mark - UITabelViewDelegate and dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
    
}
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 170;
    }else if (indexPath.row == 2){
        return 0;
    }
    else{
        return 40;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 170)];
            cell.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //添加图片和状态 Label
            UIImageView * iv = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH / 2 - 50, 20, 100, 100)];
            iv.image = IMAGE(@"printer");
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 130, WIDTH, 20)];
            titleLabel.textColor = [UIColor colorWithHex:@"333333" alpha:1.0];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.font = FONT(12);
            [cell addSubview:iv];
            [cell addSubview:titleLabel];
            return cell;
        }
            break;
        case 1:{
            UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //添加title
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 40)];
            titleLabel.text = NSLocalizedString(@"打印机名称:", nil);
            titleLabel.textColor = [UIColor colorWithHex:@"333333" alpha:1.0];
            titleLabel.font = FONT(14);
            [cell addSubview:titleLabel];
            if (_nameTextField == nil) {
                _nameTextField = [[UITextField alloc]initWithFrame:FRAME(120, 5, WIDTH - 130, 30)];
                _nameTextField.placeholder = NSLocalizedString(@"请输入打印机名称", nil);
                _nameTextField.delegate = self;
                _nameTextField.font = FONT(15);
                
            }
            [cell addSubview:_nameTextField];
            if (self.model) {
                _nameTextField.text = self.model.title;
            }
            return cell;

        }
        case 2:
        {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 40)];
//            titleLabel.text = NSLocalizedString(@"打印机ID:", nil);
//            titleLabel.textColor = [UIColor colorWithHex:@"333333" alpha:1.0];
//            titleLabel.font = FONT(14);
//            [cell addSubview:titleLabel];
//            if (_platIdTextField == nil) {
//                _platIdTextField = [[UITextField alloc]initWithFrame:FRAME(120, 5, WIDTH - 130, 30)];
//                _platIdTextField.placeholder = NSLocalizedString(@"请输入打印机ID", nil);
//                _platIdTextField.delegate = self;
//                _platIdTextField.font = FONT(15);
//            }
//            if (self.model) {
//                _platIdTextField.text = self.model.plat_id;
//            }
//            [cell addSubview:_platIdTextField];
            return cell;

        }
            break;
        case 3:
        {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //添加label
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 130, 40)];
            titleLabel.font = FONT(14);
            titleLabel.textColor = [UIColor colorWithHex:@"333333" alpha:1.0];
            titleLabel.text = NSLocalizedString(@"无线打印机终端号:", nil);
            [cell addSubview:titleLabel];
            if (_machina_codeTextField == nil) {
                _machina_codeTextField = [[UITextField alloc]initWithFrame:FRAME(150, 5, WIDTH - 160, 30)];
                _machina_codeTextField.placeholder = NSLocalizedString(@"请输入终端号", nil);
                _machina_codeTextField.delegate = self;
                _machina_codeTextField.font = FONT(15);
                
            }
            if (self.model) {
                _machina_codeTextField.text = self.model.machine_code;
            }
             [cell addSubview:_machina_codeTextField];
            return cell;
        }
            break;
        case 4:
        {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //添加label
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 130, 40)];
            titleLabel.font = FONT(14);
            titleLabel.textColor = [UIColor colorWithHex:@"333333" alpha:1.0];
            titleLabel.text = NSLocalizedString(@"无线打印机API密钥:", nil);
            [cell addSubview:titleLabel];
            if (_apikeyTextField == nil) {
                _apikeyTextField = [[UITextField alloc]initWithFrame:FRAME(150, 5, WIDTH - 160, 30)];
                _apikeyTextField.placeholder = NSLocalizedString(@"请输入API密钥", nil);
                _apikeyTextField.delegate = self;
                _apikeyTextField.font = FONT(15);
                
            }
            if (self.model) {
                _apikeyTextField.text = self.model.apikey;
            }
            [cell addSubview:_apikeyTextField];
            return cell;
        }
            break;
        case 5:
        {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //添加label
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 130, 40)];
            titleLabel.font = FONT(14);
            titleLabel.textColor = [UIColor colorWithHex:@"333333" alpha:1.0];
            titleLabel.text = NSLocalizedString(@"无线打印机用户UID:", nil);
            [cell addSubview:titleLabel];
            if (_userIDTextField == nil) {
                _userIDTextField = [[UITextField alloc]initWithFrame:FRAME(150, 5, WIDTH - 160, 30)];
                _userIDTextField.placeholder = NSLocalizedString(@"请输入用户UID", nil);
                _userIDTextField.delegate = self;
                _userIDTextField.font = FONT(15);
                
            }
            if (self.model) {
                _userIDTextField.text = self.model.partner;
            }
            [cell addSubview:_userIDTextField];
            return cell;
        }
            break;
        case 6:
        {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //添加label
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 135, 40)];
            titleLabel.font = FONT(14);
            titleLabel.textColor = [UIColor colorWithHex:@"333333" alpha:1.0];
            titleLabel.text = NSLocalizedString(@"无线打印机终端密钥:", nil);
            if (_machinaKey == nil) {
                _machinaKey = [[UITextField alloc]initWithFrame:FRAME(150, 5, WIDTH - 160, 30)];
                _machinaKey.placeholder = NSLocalizedString(@"请输入终端密钥", nil);
                _machinaKey.delegate = self;
                _machinaKey.font = FONT(15);
        }
            [cell addSubview:_machinaKey];
            if (self.model) {
                _machinaKey.text = self.model.mkey;
            }
            [cell addSubview:titleLabel];
            return cell;
        }
            break;
        case 7:
        {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //添加label
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, WIDTH - 108 - 10, 40)];
            titleLabel.font = FONT(14);
            titleLabel.textColor = [UIColor colorWithHex:@"333333" alpha:1.0];
            titleLabel.text = NSLocalizedString(@"默认打印份数", nil);
            [cell addSubview:titleLabel];
            //添加右侧加减及数量标签
            UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH - 100, 10, 20, 20)];
            [leftBtn setImage:[UIImage imageNamed:@"indexsubtraction"] forState:UIControlStateNormal];
            [leftBtn setImage:[UIImage imageNamed:@"indexsubtractionClick"] forState:UIControlStateHighlighted];
            [leftBtn addTarget:self action:@selector(clickLeftBtn:) forControlEvents:(UIControlEventTouchUpInside)];
            UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH -30, 10, 20, 20)];
            [rightBtn setImage:[UIImage imageNamed:@"indexadd"] forState:UIControlStateNormal];
            [rightBtn setImage:[UIImage imageNamed:@"indexaddClick"] forState:UIControlStateHighlighted];
            [rightBtn addTarget:self action:@selector(clickRightBtn:) forControlEvents:(UIControlEventTouchUpInside)];
            num_label = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH - 80, 0, 50, 40)];
            num_label.text =[NSString stringWithFormat:NSLocalizedString(@"%ld份", nil),num];
            num_label.textColor = [UIColor colorWithHex:@"999999" alpha:1.0];
            num_label.textAlignment = NSTextAlignmentCenter;
            num_label.font = FONT(14);
            [cell addSubview:leftBtn];
            [cell addSubview:rightBtn];
            [cell addSubview:num_label];
            return cell;
        }
            break;
            
        default:
            return NULL;
            break;
    }
}
#pragma mark - 点击左侧减号按钮
- (void)clickLeftBtn:(UIButton *)sender
{
    NSLog(@"点击了左侧按钮");
    (num > 1) ? (num-=1):(num-=0);
    num_label.text =[NSString stringWithFormat:@"%ld份",num];
    [[NSUserDefaults standardUserDefaults] setInteger:num forKey:@"print_num"];
}
#pragma mark - 点击右侧加号按钮
- (void)clickRightBtn:(UIButton *)sender
{
    NSLog(@"点击右侧按钮");
    num++;
    num_label.text =[NSString stringWithFormat:@"%ld份",num];
    [[NSUserDefaults standardUserDefaults] setInteger:num forKey:@"print_num"];
}
#pragma mark - 这是UITextField的代理方法
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
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
