//
//  JHBankSettingVC.m
//  WaimaiShop
//
//  Created by xixixi on 16/1/12.
//  Copyright © 2016年 ijianghu. All rights reserved.
//

#import "JHBankSettingVC.h"
#import "JHBankDetailModel.h"
@interface JHBankSettingVC ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property(nonatomic,strong)UITableView *mainTableView;
@end
@implementation JHBankSettingVC
{
    UITextField *_nameF;//姓名
    UITextField *_IDNumF;//身份证号
    UILabel *_bankL;//银行标签
    UITextField *_bank_branchF;//开户支行
    UIButton *_rightBtn;//开户行右侧箭头
    UITextField *_banNumF;//银行号码
    UIControl *_backView;//点击右侧箭头的背景
    UITableView *classifyTableView;
    NSMutableArray *classifyDataArray;
    JHBankDetailModel * detailModel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化必要信息
    [self initData];
    //创建表视图
    [self createMainTableView];
    //后台请求分类数据
    [self getClassifyData];
    //获取开户行信息的方法
    [self postHttpForDetail];
}
#pragma mark - 这是获取自己原先的数据
-(void)postHttpForDetail{
    SHOW_HUD
    [HttpTool postWithAPI:@"biz/shop/shop/my_bank" withParams:@{} success:^(id json) {
        NSLog(@"%@",json);
        if ([json[@"error"] isEqualToString:@"0"]) {
            if ([json[@"data"][@"my_bank"] isKindOfClass:[NSDictionary class]]) {
                detailModel = [[JHBankDetailModel alloc]initWithDictionary:json[@"data"][@"my_bank"]];
                if (detailModel.account_number.length > 0) {
                    self.view.userInteractionEnabled = NO;
                }
                [_mainTableView reloadData];
            }
        }else{
            [JHShowAlert showAlertWithMsg:json[@"message"]];
        }
        HIDE_HUD
    } failure:^(NSError *error) {
        HIDE_HUD
        [JHShowAlert showAlertWithMsg:NSLocalizedString(@"服务器繁忙,请稍后再试", nil)];
         NSLog(@"%@",error.localizedDescription);
    }];
}
#pragma mark - 后台请求分类数据信息
- (void)getClassifyData
{   
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [HttpTool postWithAPI:@"biz/shop/shop/bank_list" withParams:@{} success:^(id json) {
            NSLog(@"json=======%@",json);
            if ([json[@"error"] isEqualToString:@"0"]){
                NSArray  * tempArray = json[@"data"][@"bank_list"];
                for (NSString * str  in tempArray) {
                    [classifyDataArray addObject:str];
                }
            }
            [classifyTableView reloadData];
        } failure:^(NSError *error) {
            NSLog(@"%@",error.localizedDescription);
        }];
    });
}

#pragma mark - initData
- (void)initData
{
    self.view.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
    self.title = NSLocalizedString(@"开户行信息", nil);
    classifyDataArray = @[].mutableCopy;
}
#pragma mark - 初始化表视图
- (void)createMainTableView
{
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0 , 0, WIDTH, HEIGHT - 64 - 60) style:UITableViewStyleGrouped];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
    _mainTableView.separatorColor = DEFAULT_BACKGROUNDCOLOR;
    _mainTableView.layoutMargins = UIEdgeInsetsZero;
    _mainTableView.separatorInset = UIEdgeInsetsZero;
    _mainTableView.showsHorizontalScrollIndicator = NO;
    _mainTableView.showsVerticalScrollIndicator = NO;
    _mainTableView.tag = 100;
    [self.view addSubview:_mainTableView];
}
#pragma mark - UITableViewDelegate and dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 100) {
        if (detailModel.account_number.length) {
            return 5;
        }
        return 6;
    }
    return classifyDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 100 && indexPath.row == 5) {
        return 90;
    }
    return 44;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    if (tableView.tag == 100) {
        switch (row) {
            case 0:
            {
                UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:FRAME(0, 0, WIDTH, 44)];
                cell.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UILabel *titleL = [[UILabel alloc] initWithFrame:cell.bounds];
                titleL.text = NSLocalizedString(@"请确保姓名、银行卡开户人为同一人", nil);
                titleL.font = FONT(14);
                titleL.textColor = [UIColor redColor];
                titleL.textAlignment = NSTextAlignmentCenter;
                
                [cell addSubview:titleL];
                return cell;
            }
                break;
            case 1:
            {
                UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:FRAME(0, 0, WIDTH, 44)];
                cell.backgroundColor = [UIColor whiteColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UILabel *titleL = [[UILabel alloc] initWithFrame:FRAME(0, 0, 80, 44)];
                titleL.font = FONT(14);
                titleL.textColor = HEX(@"333333", 1.0);
                titleL.textAlignment = NSTextAlignmentCenter;
                titleL.text = NSLocalizedString(@"真实姓名", nil);
                [cell addSubview:titleL];
                if (!_nameF) {
                    _nameF = [[UITextField alloc] initWithFrame:FRAME(80, 0, WIDTH-90, 44)];
                    _nameF.placeholder = NSLocalizedString(@"请输入开户姓名", nil);
                    _nameF.font = FONT(14);
                    _nameF.textColor = THEME_COLOR;
                }
                if (detailModel) {
                    _nameF.text = detailModel.account_name;
                }
                [cell addSubview:_nameF];
                return cell;
            }
                break;
            case 2:
            {
                UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:FRAME(0, 0, WIDTH, 44)];
                cell.backgroundColor = [UIColor whiteColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UILabel *titleL = [[UILabel alloc] initWithFrame:FRAME(0, 0, 80, 44)];
                titleL.font = FONT(14);
                titleL.textColor = HEX(@"333333", 1.0);
                titleL.textAlignment = NSTextAlignmentCenter;
                titleL.text = NSLocalizedString(@"开户银行", nil);
                [cell addSubview:titleL];
                if (!_bankL) {
                    _bankL = [[UILabel alloc] initWithFrame:FRAME(80, 0, WIDTH - 140, 44)];
                    _bankL.font = FONT(14);
                    _bankL.textColor = HEX(@"333333", 1.0);
                }
                if (!_rightBtn) {
                    _rightBtn = [[UIButton alloc] initWithFrame:FRAME(WIDTH - 60, 4.5, 50, 35)];
                    _rightBtn.imageEdgeInsets = UIEdgeInsetsMake(10.5,20 , 10.5, 20);
                    [_rightBtn setImage:[UIImage imageNamed:@"shop_drop-down"]
                               forState:UIControlStateNormal];
                    [_rightBtn setImage:[UIImage imageNamed:@"up"]
                               forState:UIControlStateSelected];
                    [_rightBtn setBackgroundColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
                    [_rightBtn setBackgroundColor:THEME_COLOR forState:(UIControlStateSelected)];
                    [_rightBtn addTarget:self action:@selector(clickBankRightBtn:) forControlEvents:(UIControlEventTouchUpInside)];
                    _rightBtn.layer.borderColor = LINE_COLOR.CGColor;
                    _rightBtn.layer.borderWidth = 0.7;
                }
                [cell addSubview:_bankL];
                if (detailModel) {
                    _bankL.text = detailModel.account_type;
                }
                if (detailModel.account_number.length == NO) {
                    [cell addSubview:_rightBtn];
                }
                return cell;
            }
                break;
            case 3:
            {
                UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:FRAME(0, 0, WIDTH, 44)];
                cell.backgroundColor = [UIColor whiteColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UILabel *titleL = [[UILabel alloc] initWithFrame:FRAME(0, 0, 80, 44)];
                titleL.font = FONT(14);
                titleL.textColor = HEX(@"333333", 1.0);
                titleL.textAlignment = NSTextAlignmentCenter;
                titleL.text = NSLocalizedString(@"开户支行", nil);
                [cell addSubview:titleL];
                if (!_bank_branchF) {
                    _bank_branchF = [[UITextField alloc] initWithFrame:FRAME(80, 0, WIDTH-90, 44)];
                    _bank_branchF.placeholder = NSLocalizedString(@"没有时无需输入", nil);
                    _bank_branchF.keyboardType = UIKeyboardTypeNumberPad;
                    _bank_branchF.font = FONT(14);
                    _bank_branchF.textColor = THEME_COLOR;
                }
                
                if (_bank_branchF) {
                    _bank_branchF.text = detailModel.account_branch;
                }
                [cell addSubview:_bank_branchF];
                return cell;
            }
                break;
            case 4:
            { UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:FRAME(0, 0, WIDTH, 44)];
                cell.backgroundColor = [UIColor whiteColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UILabel *titleL = [[UILabel alloc] initWithFrame:FRAME(0, 0, 80, 44)];
                titleL.font = FONT(14);
                titleL.textColor = HEX(@"333333", 1.0);
                titleL.textAlignment = NSTextAlignmentCenter;
                titleL.text = NSLocalizedString(@"开户卡号", nil);
                [cell addSubview:titleL];
                if (!_banNumF) {
                    _banNumF = [[UITextField alloc] initWithFrame:FRAME(80, 0, WIDTH-90, 44)];
                    _banNumF.placeholder = NSLocalizedString(@"请输入开户账号", nil);
                    _banNumF.keyboardType = UIKeyboardTypeNumberPad;
                    _banNumF.font = FONT(14);
                    _banNumF.textColor = THEME_COLOR;
                }
                if (detailModel) {
                    _banNumF.text = detailModel.account_number;
                }
                [cell addSubview:_banNumF];
                return cell;

            }
                break;
        
            default:
            {
                UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:FRAME(0, 0, WIDTH, 90)];
                cell.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
                [sureBtn addTarget:self action:@selector(clickBottomBtn:)
                  forControlEvents:UIControlEventTouchUpInside];
                return cell;

            }
                break;
        }
    }else{
        UITableViewCell *cell = [classifyTableView dequeueReusableCellWithIdentifier:@"JHBankSetCellId1"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"JHBankSetCellId1"];
            cell.backgroundColor = [UIColor whiteColor];
            //添加label
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, CGRectGetWidth(cell.frame), 35)];
            titleLabel.tag = 1;
            [cell addSubview:titleLabel];
        }
        UILabel *titleLabel = (UILabel *)[cell viewWithTag:1];
        titleLabel.text = classifyDataArray[indexPath.row];
        titleLabel.font = FONT(12);
        titleLabel.textColor = [UIColor colorWithHex:@"999999" alpha:1.0];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == classifyTableView) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        _bankL.text = classifyDataArray[indexPath.row];
        /**
         *  在切换银行后,老总说不需要将名字和number清零.所以注释掉
         */
        //nameField.text = nil;
        //numfield.text = nil;
        [self tapBackView];
        [classifyTableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark - 点击分类cell右侧按钮
- (void)clickBankRightBtn:(UIButton *)sender
{
    NSLog(@"点击开户行右侧分类按钮");
    sender.selected = !sender.selected;
    if(sender.selected){
        [self createBackViewAndTable];
    }else{
        [self tapBackView];
    }
}
#pragma mark - 创建背景视图及分类表视图
- (void)createBackViewAndTable
{
    [self.view endEditing:YES];
    //在windows上添加视图
    _backView = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    _backView.backgroundColor = [UIColor colorWithRed:0/255.0
                                                green:0/255.0
                                                 blue:0/255.0 alpha:0.2];
    
    classifyTableView = [[UITableView alloc] initWithFrame:CGRectMake(90,196, WIDTH - 120, 200)];
    classifyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    classifyTableView.delegate = self;
    classifyTableView.dataSource = self;
    classifyTableView.tag = 200;
    //为_backView添加方法
    [_backView addTarget:self action:@selector(tapBackView) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:classifyTableView];
    _backView.alpha = 0.0;
    [[UIApplication sharedApplication].delegate.window addSubview:_backView];
    [UIView transitionWithView:_backView
                      duration:0.3
                       options:UIViewAnimationOptionCurveLinear
                    animations:^{
                        _backView.alpha = 1;
                    } completion:nil];
}
#pragma mark - 点击背景view
- (void)tapBackView
{
    _rightBtn.selected = NO;
    [UIView animateWithDuration:0.3
                     animations:^{
                         _backView.backgroundColor = [UIColor colorWithRed:0/255.0
                                                                     green:0/255.0
                                                                      blue:0/255.0
                                                                     alpha:0.0];
                         classifyTableView.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         [classifyTableView removeFromSuperview];
                         [_backView removeFromSuperview];
                         _backView = nil;
                         classifyTableView = nil;
                     }];

}
#pragma mark - 点击底部确认添加按钮
- (void)clickBottomBtn:(UIButton *)sender
{
    SHOW_HUD
    [HttpTool postWithAPI:@"biz/shop/shop/account" withParams:@{@"account_name":_nameF.text,
                                                                @"account_type":_bankL.text,
                                                                @"account_number":_banNumF.text,
                                                                @"account_branch":_bank_branchF.text?_bank_branchF.text:@""
                                                                } success:^(id json) {
        NSLog(@"%@",json);
        if ([json[@"error"] isEqualToString:@"0"]) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [JHShowAlert showAlertWithMsg:json[@"message"]];
        }
        HIDE_HUD
    } failure:^(NSError *error) {
        HIDE_HUD
        [JHShowAlert showAlertWithMsg:NSLocalizedString(@"服务器繁忙,请稍后再试", nil)];
        NSLog(@"%@",error.localizedDescription);
    }];
}
@end
