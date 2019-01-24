//
//  AddQRCodeVC.m
//  JHCommunityBiz
//
//  Created by ijianghu on 2017/11/14.
//  Copyright © 2017年 com.jianghu. All rights reserved.
//

#import "AddQRCodeVC.h"
#import <IQKeyboardManager.h>
@interface AddQRCodeVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    BOOL isFixed;
    NSString *name;
    NSString *money;
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,weak)UITextField *nameT;
@property(nonatomic,weak)UITextField *moneyT;
@end

@implementation AddQRCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
    self.navigationItem.title =  NSLocalizedString(@"添加收款码", NSStringFromClass([self class]));
    [self tableView];
}
#pragma mark - 这是创建表视图的方法
-(UITableView * )tableView{
    if(_tableView == nil){
        _tableView = ({
            UITableView * table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64) style:UITableViewStyleGrouped];
            table.delegate = self;
            table.dataSource = self;
            table.tableFooterView = [UIView new];
            table.showsVerticalScrollIndicator = NO;
            table.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
            [self.view addSubview:table];
            table.separatorColor = LINE_COLOR;
            table.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            table.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
            table;
        });
    }
    return _tableView;
}
#pragma mark - 这是UITableView的代理和方法和数据方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 113;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
    UIView *backView = [UIView new];
    backView.backgroundColor = [UIColor whiteColor];
    [view addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset = 0;
        make.height.offset = 49;
    }];
   
    if (isFixed) {
        UITextField *textF = [[UITextField alloc]init];
        textF.placeholder =  NSLocalizedString(@"请输入收款金额", NSStringFromClass([self class]));
        textF.font = FONT(13);
        textF.keyboardType = UIKeyboardTypeDecimalPad;
        [backView addSubview:textF];
        textF.text = money;
        _moneyT = textF;
        _moneyT.delegate = self;
        [textF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 21;
            make.right.offset = -50;
            make.centerY.mas_equalTo(backView.mas_centerY);
            make.height.offset = 35;
        }];
    }else{
        UIImageView *imgV = [UIImageView new];
        imgV.image = IMAGE(@"icon_tips");
        [backView addSubview:imgV];
        [imgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 20;
            make.width.height.offset = 16;
            make.centerY.mas_equalTo(backView.mas_centerY);
        }];
        
        UILabel *lab = [[UILabel alloc]init];
        lab.text =  NSLocalizedString(@"此时由客户输入收款金额", NSStringFromClass([self class]));
        lab.textColor = HEX(@"ff9900", 1);
        lab.font = FONT(14);
        [backView addSubview:lab];
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(imgV.mas_right).offset = 9;
            make.centerY.mas_equalTo(backView.mas_centerY);
            make.height.offset = 15;
        }];
    }
    
    UIButton *btn = [UIButton new];
    [btn setTitle: NSLocalizedString(@"确认添加", NSStringFromClass([self class])) forState:UIControlStateNormal];
    [btn setTitleColor:HEX(@"ffffff", 1) forState:UIControlStateNormal];
    btn.titleLabel.font = FONT(16);
    btn.backgroundColor = HEX(@"ff9900", 1);
    btn.layer.cornerRadius = 4;
    btn.layer.masksToBounds = YES;
    [view addSubview:btn];
    [btn addTarget:self action:@selector(clickSureBtn) forControlEvents:UIControlEventTouchUpInside];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset = 0;
        make.left.offset = 15;
        make.right.offset = -15;
        make.height.offset = 44;
    }];
    
    return view;
}
-(void)clickSureBtn{
    [self makeToAddCode];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc]init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *titleL = [[UILabel alloc]init];
        titleL.text =  NSLocalizedString(@"收款码名称", NSStringFromClass([self class]));
        titleL.font = FONT(14);
        titleL.textColor = HEX(@"333333", 1);
        [cell addSubview:titleL];
        [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 21;
            make.centerY.mas_equalTo(cell.mas_centerY);
            make.height.offset = 16;
            make.width.offset = 75;
        }];
            UITextField *textF = [[UITextField alloc]init];
            textF.placeholder = NSLocalizedString(@"请输入收款码名称", NSStringFromClass([self class]));
            textF.font = FONT(13);
            textF.text = name;
            _nameT = textF;
            _nameT.delegate = self;
            [cell addSubview:textF];
            [textF mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(titleL.mas_right).offset = 20;
                make.right.offset = -10;
                make.bottom.top.offset = 0;
            }];
        
        return cell;
    }else{
        UITableViewCell *cell = [[UITableViewCell alloc]init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *titleL = [[UILabel alloc]init];
        titleL.text = NSLocalizedString(@"收款金额", NSStringFromClass([self class]));
        titleL.font = FONT(14);
        titleL.textColor = HEX(@"333333", 1);
        [cell addSubview:titleL];
        [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset = 21;
            make.centerY.mas_equalTo(cell.mas_centerY);
            make.height.offset = 16;
            make.width.offset = 75;
        }];
        
        UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:@[ NSLocalizedString(@"固定", NSStringFromClass([self class])), NSLocalizedString(@"不固定", NSStringFromClass([self class]))]];
        segment.tintColor = HEX(@"ff9900", 1);
        if (isFixed) {
             segment.selectedSegmentIndex = 0;
        }else{
             segment.selectedSegmentIndex = 1;
        }
       
        [cell addSubview:segment];
        [segment addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
        [segment mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset = -10;
            make.height.offset = 30;
            make.top.offset = 5;
        }];
        return cell;
    }
    
}
-(void)valueChange:(UISegmentedControl *)sender{
    if (sender.selectedSegmentIndex == 0) {
        isFixed = YES;
    }else{
        [_moneyT resignFirstResponder];
        isFixed = NO;
        money = nil;
        _moneyT.text = nil;
    }
    [_tableView reloadData];
}
#pragma mark - 添加收款码的接口
-(void)makeToAddCode{
    if (_nameT.text.length == 0) {
        [self showToastAlertMessageWithTitle: NSLocalizedString(@"清输入台卡名称", NSStringFromClass([self class]))];
        return;
    }
    NSString *type = @"write";
    if (_moneyT.text.length > 0 && _moneyT.enabled) {
        type = @"fixation";
    }
    NSString *money = @"0";
    if (_moneyT.text.length > 0 && _moneyT.enabled) {
        money = _moneyT.text;
    }
    NSDictionary *dic = @{@"title":_nameT.text,
                          @"type":type,
                          @"money":money
                          };
    SHOW_HUD
    [HttpTool postWithAPI:@"biz/decca/create" withParams:dic success:^(id json) {
        HIDE_HUD
        if ([json[@"error"] isEqualToString:@"0"]) {
            [self showToastAlertMessageWithTitle: NSLocalizedString(@"添加成功", NSStringFromClass([self class]))];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self showToastAlertMessageWithTitle:json[@"message"]];
        }
    } failure:^(NSError *error) {
        HIDE_HUD
        NSLog(@"添加错误:%@",error);
    }];
}
#pragma mark - 这是UITextField的代理方法
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [IQKeyboardManager sharedManager].enable = YES;
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == _moneyT) {
        money = textField.text;
    }else{
        name = textField.text;
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"."] && [textField.text containsString:@"."] && textField == _moneyT) {
        [self showToastAlertMessageWithTitle: NSLocalizedString(@"请输入数字", NSStringFromClass([self class]))];
        return NO;
    }
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
