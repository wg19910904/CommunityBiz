//
//  JHManagerAttestationVC.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/23.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHManagerAttestationVC.h"
#import "JHManagerAttentationCell.h"
#import "JHManagerOtherCell.h"
#import <IQKeyboardManager.h>
#import "JHPickerView.h"
#import "JHSignageVC.h"
#import "JHServiceLicenseVC.h"
#import "JHIdentityAttestationVC.h"
#import "JHHomePageVC.h"
@implementation JHManagerAttestationVC
{
    UITableView * myTableView;//创建表视图
//    UIButton * btn;//下一步的按钮
    UILabel * label_prompt;//显示提示的label
    UITextField * textField_registCode;//工商注册号
    UITextField * textField_name;//公司名称
    NSInteger row1;//保存父类的选中行
    NSInteger row2;//保存子类的选中行
    NSMutableArray * array_father;//保存父类的数组
    NSMutableArray * array_son;//保存子类的数组
    UILabel * label_type;//保存营业类型的
    UILabel * label_address;//保存营业地址的
    NSMutableArray * state_array;
    NSString * str_identity;//判断身份认证的状态的
    NSString * str_yingye;//判断营业执照的认证状态的
    NSString * str_canyin;//判断餐饮服务许可证的认证状态的
    NSString *  a;//身份认证
    NSString * b;//营业执照
    NSString * c;//餐饮服务许可证
    NSString *refuse;//需要重新认证时的拒绝原因
    NSDictionary *responseDic;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    //初始化一些数据
    [self initData];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //发送请求
    SHOW_HUD
    [self postHttp];
}
#pragma mark - 这是请求获取状态的方法
-(void)postHttp{
    [HttpTool postWithAPI:@"biz/shop/shop/info" withParams:@{} success:^(id json) {
        NSLog(@"%@",json);
        if ([json[@"error"] isEqualToString:@"0"]) {
//            a = json[@"data"][@"verify"][@"verify_dianzhu"];
//            b  = json[@"data"][@"verify"][@"verify_yyzz"];
//            c  = json[@"data"][@"verify"][@"verify_cy"];
            refuse = json[@"data"][@"refuse"];
            responseDic = json;
            NSInteger verify = [json[@"data"][@"verify"][@"verify"] integerValue];
            NSInteger updatetime = [json[@"data"][@"verify"][@"updatetime"] integerValue];
            if ((verify + updatetime) == 0 ||
                MIN(c.integerValue, MIN(a.integerValue, b.integerValue)) == -1) {
                //待提交
                str_identity = NSLocalizedString(@"去设置", NSStringFromClass([self class]));
                str_yingye = NSLocalizedString(@"去设置", NSStringFromClass([self class]));
                str_canyin = NSLocalizedString(@"去设置", NSStringFromClass([self class]));
                a = @"-1";
                b = @"-1";
                c = @"-1";
            } else if (verify == 0 && updatetime > 0) {
                //待审核
                str_identity = NSLocalizedString(@"待审核", NSStringFromClass([self class]));
                str_yingye = NSLocalizedString(@"待审核", NSStringFromClass([self class]));
                str_canyin = NSLocalizedString(@"待审核", NSStringFromClass([self class]));
                a = @"0";
                b = @"0";
                c = @"0";
            }else if (verify == 1) {
                //认证通过
                str_identity = NSLocalizedString(@"认证通过", NSStringFromClass([self class]));
                str_yingye = NSLocalizedString(@"认证通过", NSStringFromClass([self class]));
                str_canyin = NSLocalizedString(@"认证通过", NSStringFromClass([self class]));
                a = @"1";
                b = @"1";
                c = @"1";
            }else if (verify == 2) {
                //重新认证
                str_identity = NSLocalizedString(@"去设置", NSStringFromClass([self class]));
                str_yingye = NSLocalizedString(@"去设置", NSStringFromClass([self class]));
                str_canyin = NSLocalizedString(@"去设置", NSStringFromClass([self class]));
                a = @"2";
                b = @"2";
                c = @"2";
            }
            state_array = @[str_identity,str_yingye,str_canyin].mutableCopy;
            //添加表视图
            [self creatUITableView];
        }else{
            [JHShowAlert showAlertWithMsg:json[@"message"]];
        }
        HIDE_HUD
    } failure:^(NSError *error) {
        [JHShowAlert showAlertWithMsg: NSLocalizedString(@"服务器繁忙,请稍后访问", NSStringFromClass([self class]))];
        HIDE_HUD
        NSLog(@"%@",error.localizedDescription);
    }];
}
-(void)clickBackBtn{
    NSArray * array = self.navigationController.viewControllers;
    for (JHBaseVC * vc in array) {
        if ([vc isKindOfClass:[JHHomePageVC class]]) {
            [self.navigationController popToViewController:vc animated:YES];
        }
    }
}
#pragma mark - 这是初始化一些数据的方法
-(void)initData{
    self.navigationItem.title =  NSLocalizedString(@"掌柜认证", NSStringFromClass([self class]));
    refuse = @"";
    responseDic = @{};
    self.view.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    [IQKeyboardManager sharedManager].enable = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
}
#pragma mark - 这是收到通知需要调用的方法
-(void)doSomeThring:(NSNotification * )noti{
    NSLog(@"%@",noti.userInfo[@"address"]);
    label_address.text = noti.userInfo[@"address"];
}
#pragma mark - 这是创建表格的方法
-(void)creatUITableView{
    if (myTableView == nil) {
        myTableView = [[UITableView alloc]initWithFrame:FRAME(0, 10, WIDTH, HEIGHT - 64) style:UITableViewStylePlain];
        myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        myTableView.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
        [self.view addSubview:myTableView];
        [myTableView registerClass:[JHManagerAttentationCell class] forCellReuseIdentifier:@"cell"];
        [myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell1"];
        [myTableView registerClass:[JHManagerOtherCell class] forCellReuseIdentifier:@"cell2"];
        myTableView.delegate = self;
        myTableView.dataSource = self;
    }else{
        [myTableView reloadData];
    }
}
#pragma mark - 这是表格的代理和数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < 3) {
        return 44;
    }else{
        return 80;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 4) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *reasonL = [[UILabel alloc] initWithFrame:FRAME(10, 0, WIDTH-20, 30)];
        reasonL.font = FONT(15);
        reasonL.textColor = [UIColor orangeColor];
        reasonL.text = [ NSLocalizedString(@"拒绝原因:", NSStringFromClass([self class])) stringByAppendingString:refuse];
        reasonL.hidden = YES;
        [cell addSubview:reasonL];
        
        
        UIButton *resubmitBtn = [[UIButton alloc] initWithFrame:FRAME(40,40, WIDTH-80, 40)];
        [resubmitBtn setBackgroundColor:[UIColor orangeColor] forState:(UIControlStateNormal)];
        [resubmitBtn setTitleColor:[UIColor whiteColor] forState:(UIControlState)UIControlStateNormal];
        resubmitBtn.layer.cornerRadius = 5;
        resubmitBtn.clipsToBounds = YES;
        resubmitBtn.userInteractionEnabled = NO;
        //设置背景颜色 和文字
        NSInteger verify = [responseDic[@"data"][@"verify"][@"verify"] integerValue];
        NSInteger updatetime = [responseDic[@"data"][@"verify"][@"updatetime"] integerValue];
        switch (verify) {
            case 0: //等待审核和提交审核
            {
                if (updatetime) {
                    [resubmitBtn setTitle: NSLocalizedString(@"等待审核", NSStringFromClass([self class])) forState:(UIControlStateNormal)];
                }else{
                    [resubmitBtn setTitle: NSLocalizedString(@"提交审核", NSStringFromClass([self class])) forState:(UIControlStateNormal)];
                    resubmitBtn.userInteractionEnabled = YES;
                }
            }
                break;
            case 1: //审核通过
            {
                [resubmitBtn setTitle: NSLocalizedString(@"审核通过", NSStringFromClass([self class])) forState:(UIControlStateNormal)];
            }
            case 2: //重新审核
            {
                [resubmitBtn setTitle: NSLocalizedString(@"重新审核", NSStringFromClass([self class])) forState:(UIControlStateNormal)];
                resubmitBtn.userInteractionEnabled = YES;
                reasonL.hidden = NO;
            }
                break;
                
            default:
                break;
        }
        
        [resubmitBtn addTarget:self action:@selector(clickResubmitBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        
        [cell addSubview:resubmitBtn];
        return cell;
        
    }
    if ( indexPath.row == 3){
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
        if(label_prompt == nil){
            label_prompt = [[UILabel alloc]init];
            label_prompt.frame = FRAME(10, 10, WIDTH -20, 60);
            label_prompt.numberOfLines = 0;
            label_prompt.font = [UIFont systemFontOfSize:15];
            label_prompt.textColor = [UIColor colorWithWhite:0.6 alpha:1];
            label_prompt.text =  NSLocalizedString(@"温馨提示: 餐饮类商家必须提供餐饮许可证,其他类型商家可不提交", NSStringFromClass([self class]));
            [cell addSubview:label_prompt];
            NSMutableAttributedString * attributed = [[NSMutableAttributedString alloc]initWithString:label_prompt.text];
            NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            [paragraphStyle setLineSpacing:8];
            [attributed addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, label_prompt.text.length)];
            label_prompt.attributedText = attributed;
        }
        return cell;
    }else{
        JHManagerOtherCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
        cell.indexPath = indexPath;
        cell.label_right.text = state_array[indexPath.row];
        switch (indexPath.row) {
            case 0:
                break;
            case 1:
                break;
            case 2:
                break;
            default:
                break;
        }
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row >=0 && indexPath.row != 3) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self.view endEditing:YES];
        switch (indexPath.row) {
            /*
            case 2:{
                __block JHPickerView * pickerView = [[JHPickerView alloc]init];
                [pickerView showPickerViewWithArray1:array_father withArray2:array_son withSelectedRow1:row1 withSelectedRow2:row2 withBlock:^(NSInteger selected1, NSInteger selected2, NSString *result) {
                    [pickerView removeFromSuperview];
                    pickerView = nil;
                    if (result) {
                        label_type.text = result;
                        row1 = selected1;
                        row2 = selected2;
                    }
                }];

            }
                break;
            case 3:{
                JHBusinessAddress * vc = [[JHBusinessAddress alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
             */
            case 0:{
                JHIdentityAttestationVC * vc = [[JHIdentityAttestationVC alloc]init];
                vc.type = [a integerValue];
                [self.navigationController pushViewController:vc animated:YES];

            }
                break;
            case 1:{
                JHSignageVC * vc = [[JHSignageVC alloc]init];
                vc.type = [b integerValue];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case 2:{
                JHServiceLicenseVC * vc = [[JHServiceLicenseVC alloc]init];
                vc.type = [c integerValue];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            default:
                break;
        }
    }
}
- (void)clickResubmitBtn:(UIButton *)sender{
    //重新提交审核
    SHOW_HUD
    [HttpTool postWithAPI:@"biz/shop/shop/verify"
               withParams:@{}
                  success:^(id json) {
                      HIDE_HUD
                      [JHShowAlert showAlertWithMsg:json[@"message"]];
                      
                  } failure:^(NSError *error) {
                      HIDE_HUD
                  }];
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
#pragma mark - 这是UITextField的代理方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}
//#pragma mark - 这是点击下一步的方法
//-(void)clickToNext{
//    NSLog(@"这是点击下一步的方法");
//    JHIdentityAttestationVC * vc = [[JHIdentityAttestationVC alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
//}
@end
