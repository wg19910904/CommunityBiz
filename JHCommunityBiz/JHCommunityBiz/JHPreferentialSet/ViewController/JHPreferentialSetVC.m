//
//  JHPreferentialSetVC.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/27.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHPreferentialSetVC.h"
#import "JHPreferentialSetCellOne.h"
#import "JHPreferentialSetCellTwo.h"
#import "JHPreferentialSetCellThree.h"
#import "JHPreferentialSetCellFour.h"
#import "JHPreferentialSetCellFive.h"
#import "JHPreferentialSetCellSix.h"
#import "JHPerferentialFooterView.h"
#import <IQKeyboardManager.h>
#import "JHPLSetModel.h"
@implementation JHPreferentialSetVC
{
    UITableView * myTableView;
    float height_footer;//保存温馨提示的高度的
    BOOL isSelected;//保存折扣的按钮的选中状态
    NSInteger num;//保存满减情况下的活动个数的
    UISwitch * mySwitch;//开关
    UITextField * textField_max;//最大优惠金额
    UITextField * textField_scale;//设置比例的
    UIImageView * imageV_one;
    UIImageView * imageV_two;
    NSString * type;//优惠买单设置的类型(0:满减   1:折扣)
    UIButton * btn_save;
    NSMutableArray * modelArray;
    NSString * max_dicount;
    NSString * max_man;
    NSString * discount;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    //创建表视图
    [self creatUITableView];
    //初始化一些数据
    [self initData];
    //注册通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldTextChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)textFieldTextChange:(NSNotification * )noti{
    UITextField * textField = noti.object;
    if (textField.tag < 100) {
        return;
    }
    if (textField.tag == 10000) {
        if ([type isEqualToString:@"0"]) {
             max_man = textField.text;
        }else{
             max_dicount = textField_max.text;
        }
        return;
    }
    if (textField.tag == 20000) {
        discount = textField.text;
        return;
    }
    JHPLSetModel * model ;
    if (textField.tag >= 100 && textField.tag < 500) {
        model = modelArray[textField.tag - 100];
        model.man_money = textField.text;
        [modelArray replaceObjectAtIndex:textField.tag -100 withObject:model];//可以不用替换
    }else{
        model = modelArray[textField.tag - 500];
        model.youhui_money = textField.text;
        [modelArray replaceObjectAtIndex:textField.tag -500 withObject:model];//可以不用替换
    }
}
#pragma mark - 这是初始化一些数据的方法
-(void)initData{
    modelArray = @[].mutableCopy;
    SHOW_HUD
    [HttpTool postWithAPI:@"biz/maidan/youhui/get_youhui" withParams:@{} success:^(id json) {
        NSLog(@"%@",json);
        if ([json[@"error"] isEqualToString:@"0"]) {
            if ([json[@"data"][@"maidan"][@"type"] isEqualToString:@"0"] ) {
                isSelected = NO;
                type = @"0";
                if ([json[@"data"][@"maidan"][@"max_youhui"] floatValue]>0) {
                     max_man = json[@"data"][@"maidan"][@"max_youhui"];
                }else{
                     max_man = @"";
                }
                NSArray * tempArray = json[@"data"][@"maidan"][@"config"];
                num = tempArray.count;
                for (NSDictionary * dic in tempArray) {
                    JHPLSetModel * model = [[JHPLSetModel alloc]init];
                    model.man_money = dic[@"m"];
                    model.youhui_money = dic[@"d"];
                    [modelArray addObject:model];
                }
                
            }else{
                 isSelected = YES;
                if ([json[@"data"][@"maidan"][@"max_youhui"] integerValue] > 0) {
                  max_dicount = json[@"data"][@"maidan"][@"max_youhui"];
                }else{
                    max_dicount = @"";
                }
                
                 discount = json[@"data"][@"maidan"][@"discount"];
                 type = @"1";
                 num = 0;
            }
            
                 [myTableView reloadData];
        }else{
                 [JHShowAlert showAlertWithMsg:json[@"message"]];
        }
        HIDE_HUD
    } failure:^(NSError *error) {
        HIDE_HUD
        [JHShowAlert showAlertWithMsg: NSLocalizedString(@"服务器繁忙,请稍后访问", NSStringFromClass([self class]))];
        NSLog(@"%@",error.localizedDescription);
    }];
    
    self.navigationItem.title =  NSLocalizedString(@"优惠买单设置", NSStringFromClass([self class]));
    num = 0;
   
}
#pragma mark - 这是创建表格的方法
-(void)creatUITableView{
    if (myTableView == nil) {
        myTableView = [[UITableView alloc]initWithFrame:FRAME(0, 0, WIDTH, HEIGHT - 64) style:UITableViewStyleGrouped];
        myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        myTableView.tableFooterView = [UIView new];
        myTableView.showsVerticalScrollIndicator = NO;
        myTableView.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
        [myTableView registerClass:[JHPreferentialSetCellOne class] forCellReuseIdentifier:@"cell1"];
        [myTableView registerClass:[JHPreferentialSetCellTwo class] forCellReuseIdentifier:@"cell2"];
        [myTableView registerClass:[JHPreferentialSetCellThree class] forCellReuseIdentifier:@"cell3"];
        [myTableView registerClass:[JHPreferentialSetCellFour class] forCellReuseIdentifier:@"cell4"];
        [myTableView registerClass:[JHPreferentialSetCellSix class] forCellReuseIdentifier:@"cell6"];
        [myTableView registerClass:[JHPerferentialFooterView class] forHeaderFooterViewReuseIdentifier:@"cell7"];
        myTableView.delegate = self;
        myTableView.dataSource = self;
        [self.view addSubview:myTableView];
    }
}
#pragma mark - 这是表格的代理和数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 3;
            break;
        case 1:
        {
            if (isSelected) {
                return 1;
            }else{
                return num + 1;
            }
        }
            break;
        default:
            return 0;
            break;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                return 0;
            }else if (indexPath.row == 2) {
                return 50;
            }else{
                return 40;
            }
        }
           break;
        case 1:
        {
            return 40;
        }
            break;
        default:
            return 0;
            break;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        NSString * str = [NSString stringWithFormat:@"%@\n%@\n%@", NSLocalizedString(@"温馨提示", NSStringFromClass([self class])), NSLocalizedString(@"1.商家设置的优惠活动,优惠金额由商家自行承担", NSStringFromClass([self class])), NSLocalizedString(@"2.酒水不打折", NSStringFromClass([self class]))];
        CGSize size = [str boundingRectWithSize:CGSizeMake(WIDTH - 60, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
        height_footer = size.height*1.5;
        return 90 + height_footer;
    }
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1) {
        JHPerferentialFooterView * view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"cell7"];
        view.height = height_footer;
        btn_save = view.btn_save;
        [btn_save setBackgroundColor:[UIColor colorWithRed:250/255.0 green:175/255.0 blue:25/255.0 alpha:1] forState:UIControlStateNormal];
         btn_save.enabled = YES;
        [view.btn_save addTarget:self action:@selector(clickToSave) forControlEvents:UIControlEventTouchUpInside];
        return view;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                JHPreferentialSetCellOne * cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
//                mySwitch = cell.mySwitch;
//                if ([[NSUserDefaults standardUserDefaults] boolForKey:@"PreferentialSwithch"]) {
//                    [mySwitch setOn:YES animated:YES];
//                }else if([[NSUserDefaults standardUserDefaults] boolForKey:@"PreferentialSwithch"] == NO){
//                    [mySwitch setOn:NO animated:YES];
//                }else{
//                    [mySwitch setOn:YES animated:YES];
//                }
//                [mySwitch addTarget:self action:@selector(changeClick:) forControlEvents:UIControlEventValueChanged];
                return cell;
            }else if (indexPath.row == 1){
                JHPreferentialSetCellTwo * cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
                textField_max = cell.myTextField;
                textField_max.tag = 10000;
                textField_max.delegate = self;
                if ([type isEqualToString:@"0"]) {
                    textField_max.text = max_man;
                }else{
                    textField_max.text = max_dicount;
                }
                return cell;
            }else{
                JHPreferentialSetCellThree * cell = [tableView dequeueReusableCellWithIdentifier:@"cell3" forIndexPath:indexPath];
                imageV_one = cell.imageVOne;
                imageV_two = cell.imageVTwo;
                if (isSelected) {
                    imageV_one.image = [UIImage imageNamed:@"Delivery_selected"];
                    imageV_two.image = [UIImage imageNamed:@"Delivery_Not-selected"];
                }else{
                    imageV_one.image = [UIImage imageNamed:@"Delivery_Not-selected"];
                    imageV_two.image = [UIImage imageNamed:@"Delivery_selected"];
                }

                for (int i = 0; i < cell.btn_array.count; i ++) {
                    UIButton * btn = cell.btn_array[i];
                    [btn addTarget:self action:@selector(clickBtnToSelect:) forControlEvents:UIControlEventTouchUpInside];
                }
                return cell;
            }
        }
            break;
        case 1:
        {
            
            if (isSelected) {
                JHPreferentialSetCellFour * cell = [tableView dequeueReusableCellWithIdentifier:@"cell4" forIndexPath:indexPath];
                textField_scale = cell.myTextField;
                textField_scale.delegate = self;
                textField_scale.tag = 20000;
                textField_scale.text = discount;
                return cell;

            }else if (!isSelected && indexPath.row == num){
                JHPreferentialSetCellSix * cell = [tableView dequeueReusableCellWithIdentifier:@"cell6" forIndexPath:indexPath];
                [cell.btn_add addTarget:self action:@selector(clickToAdd) forControlEvents:UIControlEventTouchUpInside];
                return cell;
            }else{
               
                NSString * str_reusable = [NSString stringWithFormat:@"JHPreferentialSetCell%ld",indexPath.row];
                JHPreferentialSetCellFive *  cell = [[JHPreferentialSetCellFive alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str_reusable];
                cell.indexPath = indexPath;
                cell.textField_one.delegate = self;
                cell.textField_two.delegate = self;
                JHPLSetModel * model = modelArray[indexPath.row];
                cell.textField_one.text = model.man_money;
                cell.textField_two.text = model.youhui_money;
                NSLog(@"%@===%@",cell.textField_one.text,cell.textField_two.text);
//                textField_one = cell.textField_one;
//                textField_two = cell.textField_two;
                [cell.btn_remove addTarget:self action:@selector(clickToRemove:) forControlEvents:UIControlEventTouchUpInside];
                return cell;
            }
    }
            break;
        default:
            return nil;
            break;
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (![IQKeyboardManager sharedManager].enable) {
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
#pragma mark - 这是UITextField的代理方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [IQKeyboardManager sharedManager].enable = YES;
    return YES;
}
#pragma mark - 这是开关发生变化调用的方法
-(void)changeClick:(UISwitch *)sender{
    NSLog(@"%d",sender.on);
    if (sender.on) {
        [btn_save setBackgroundColor:[UIColor colorWithRed:250/255.0 green:175/255.0 blue:25/255.0 alpha:1] forState:UIControlStateNormal];
        btn_save.enabled = YES;
        
    }else{
        [btn_save setBackgroundColor:[UIColor grayColor] forState:UIControlStateNormal];
        btn_save.enabled = NO;
    }
    [[NSUserDefaults standardUserDefaults] setBool:sender.on forKey:@"PreferentialSwithch"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
#pragma mark - 这是点击选中折扣还是满减的按钮
-(void)clickBtnToSelect:(UIButton *)sender{
    if (sender.tag == 0) {
        isSelected = YES;
        type = @"1";
        textField_max.text = max_dicount;
        imageV_one.image = [UIImage imageNamed:@"Delivery_selected"];
        imageV_two.image = [UIImage imageNamed:@"Delivery_Not-selected"];
    }else{
        type = @"0";
        isSelected = NO;
        textField_max.text = max_man;
        imageV_one.image = [UIImage imageNamed:@"Delivery_Not-selected"];
        imageV_two.image = [UIImage imageNamed:@"Delivery_selected"];
    }
    NSIndexSet * set = [NSIndexSet indexSetWithIndex:1];
    [myTableView reloadSections:set withRowAnimation:UITableViewRowAnimationAutomatic];
}
#pragma mark - 这是点击保存修改的方法
-(void)clickToSave{
    [self.view endEditing:YES];
    SHOW_HUD
    NSDictionary * dic;
    if ([type isEqualToString:@"1"]) {
        //折扣
        dic = @{@"type":type,
                @"max_youhui":textField_max.text,
                @"discount":textField_scale.text};
    }else{
        if (modelArray.count == 0) {
            HIDE_HUD
            [JHShowAlert showAlertWithMsg: NSLocalizedString(@"请添加满减优惠", NSStringFromClass([self class]))];
            return;
        }
        NSMutableArray *youhuiArray = @[].mutableCopy;
        for (JHPLSetModel *model in modelArray) {
            if (!([model.man_money floatValue] == 0 || [model.youhui_money floatValue] == 0) ) {
                NSString *youhuiStr = [NSString stringWithFormat:@"%@:%@",model.man_money,model.youhui_money];
                [youhuiArray addObject:youhuiStr];
        }
    }
        dic = @{@"type":type,
                @"max_youhui":textField_max.text,
                @"youhui_str":[youhuiArray componentsJoinedByString:@","]};
}
    [HttpTool postWithAPI:@"biz/maidan/youhui/set_youhui" withParams:dic success:^(id json) {
        NSLog(@"%@",json);
        if ([json[@"error"] isEqualToString:@"0"]) {
            if ([[JHShareModel shareModel].infoDictionary[@"have_maidan"] isEqualToString:@"0"]) {
                [JHShowAlert showAlertWithMsg: NSLocalizedString(@"您还未开启优惠买单,请去开启优惠买单功能,否则将不予显示您的设置", NSStringFromClass([self class])) withBtnTitle: NSLocalizedString(@"知道了", NSStringFromClass([self class])) withBtnBlock:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }else{
                [JHShowAlert showAlertWithMsg: NSLocalizedString(@"设置成功", NSStringFromClass([self class])) withBtnTitle: NSLocalizedString(@"知道了", NSStringFromClass([self class])) withBtnBlock:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }
            
        }else{
            [JHShowAlert showAlertWithMsg:json[@"message"]];
        }
        HIDE_HUD
    } failure:^(NSError *error) {
        HIDE_HUD
        [JHShowAlert showAlertWithMsg: NSLocalizedString(@"服务器繁忙,请稍后访问", NSStringFromClass([self class]))];
    }];
}
#pragma mark - 这是点击添加的方法
-(void)clickToAdd{
    NSLog(@"点击了添加");
    num++;
    JHPLSetModel * model = [[JHPLSetModel alloc]init];
    model.man_money = @"";
    model.youhui_money = @"";
    [modelArray addObject:model];
    [myTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:num-1 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark - 这是点击移除优惠的方法
-(void)clickToRemove:(UIButton *)sender{
    NSLog(@"sender>>>>>%ld",sender.tag);
    JHPreferentialSetCellFive *cell = (JHPreferentialSetCellFive *)[sender superview];
    NSIndexPath *inde = [myTableView indexPathForCell:cell];
    if (inde == nil) {
        return;
    }
    NSLog(@"%ld",inde.row);
    [modelArray removeObjectAtIndex:inde.row];
    num --;
    if (num >= 0) {
      [myTableView deleteRowsAtIndexPaths:@[inde] withRowAnimation:UITableViewRowAnimationNone];
    }
}
@end
