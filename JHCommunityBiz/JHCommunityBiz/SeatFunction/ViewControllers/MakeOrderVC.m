//
//  MakeOrderVC.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/9/30.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "MakeOrderVC.h"
#import "MakeOrderCellOne.h"
#import "ChoseControl.h"
#import <IQKeyboardManager.h>
#import "ChoseNumemberModel.h"
@interface MakeOrderVC ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UIButton *btn;
    UITextField *myTextField;
    NSMutableArray * infoArray;
    NSIndexPath * _indexPath;
    UITableViewCell * _cell;
    NSString * str;
}
@property(nonatomic,retain)UITableView *myTableView;
@end
@implementation MakeOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化一些数据的方法
    [self initData];
    //添加表视图
    [self.view addSubview:self.myTableView];
    [self postHttpGetType];
}
#pragma mark - 这是初始化一些数据
-(void)initData{
    infoArray = @[].mutableCopy;
    self.navigationItem.title =  NSLocalizedString(@"接单", NSStringFromClass([self class]));
    self.view.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
    str = NSLocalizedString( NSLocalizedString(@"请选择桌号", nil), NSStringFromClass([self class]));
}
-(void)clickBackBtn{
    [JHShareModel shareModel].indexP = nil;
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - 这是创建表视图的方法
-(UITableView * )myTableView{
    if(_myTableView == nil){
        _myTableView = ({
            UITableView * table = [[UITableView alloc]initWithFrame:CGRectMake(0, 10, WIDTH, HEIGHT - 64 - 10) style:UITableViewStylePlain];
            table.delegate = self;
            table.dataSource = self;
            table.tableFooterView = [UIView new];
            table.showsVerticalScrollIndicator = NO;
            table.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
            table;
        });
    }
    return _myTableView;
}
#pragma mark 这是补齐UITableViewCell分割线
-(void)viewDidLayoutSubviews {
    if ([_myTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_myTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        [_myTableView setSeparatorColor:LINE_COLOR];
    }
    if ([_myTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_myTableView setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
#pragma mark - 这是UITableView的代理和方法和数据方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < 2) {
        return 44;
    }else{
       return 70;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
           static NSString * cell_time = @"cell_time";
            MakeOrderCellOne * cell = [tableView dequeueReusableCellWithIdentifier:cell_time];
            if (!cell) {
                cell = [[MakeOrderCellOne alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_time];
            }
            cell.isPaidui = self.isPaidui;
            myTextField = cell.myTextField;
            return cell;
        }
            break;
        case 1:
        {
            static NSString * cell_str = @"cell_str";
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cell_str];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cell_str];
            }
            _cell = cell;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text =  NSLocalizedString(@"桌号", NSStringFromClass([self class]));
            cell.textLabel.font = FONT(14);
            cell.detailTextLabel.font = FONT(14);
            cell.detailTextLabel.text = str;
            return cell;

        }
            break;
        default:
        {
            static NSString * cell_str = @"cell_str";
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cell_str];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_str];
            }
            cell.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (!btn) {
                btn = [[UIButton alloc]init];
                btn.frame = FRAME(10, 30, WIDTH - 20, 40);
                [btn setTitle: NSLocalizedString(@"确认", NSStringFromClass([self class])) forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                btn.backgroundColor = THEME_COLOR;
                btn.titleLabel.font = FONT(14);
                btn.layer.cornerRadius = 3;
                btn.layer.masksToBounds = YES;
                [btn addTarget:self action:@selector(clickToSure) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:btn];
 
            }
        return cell;
        }
            break;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    if (indexPath.row == 1) {
        ChoseControl * control = [ChoseControl showChoseControlWithArray:infoArray];
        [control setMyBlock:^(NSIndexPath *indexPath) {
            _indexPath = indexPath;
            ChoseNumemberModel * model = infoArray[_indexPath.section];
            childrenModel * _model = model.childrenModelArray[_indexPath.item];
            _cell.detailTextLabel.text = [NSString stringWithFormat:@"%@-%@",model.title,_model.title];
            str = [NSString stringWithFormat:@"%@-%@",model.title,_model.title];
        }];
    }
}
#pragma mark - 这是点击确认调用的方法
-(void)clickToSure{
    [self.view endEditing:YES];
    [self postJieHttp];
}
#pragma mark - 这是点击确认接单的方法
-(void)postJieHttp{
    if (self.isPaidui) {
        if(myTextField.text.length == 0){
            [JHShowAlert showAlertWithMsg: NSLocalizedString(@"请填写预计等待时间", NSStringFromClass([self class]))];
            return;
        }else if (_indexPath == nil){
            [JHShowAlert showAlertWithMsg: NSLocalizedString(@"请选择桌号", NSStringFromClass([self class]))];
            return;
        }
        SHOW_HUD
        ChoseNumemberModel * model = infoArray[_indexPath.section];
        childrenModel * _model = model.childrenModelArray[_indexPath.item];
        
        NSDictionary * dic = @{@"paidui_id":self.paidui_id,
                               @"zhuohao_id":_model.zhuohao_id,
                               @"wait_time":myTextField.text};
        [HttpTool postWithAPI:@"biz/yuyue/paidui/jiedan" withParams:dic success:^(id json) {
            NSLog(@"json:%@",json);
            if ([json[@"error"] isEqualToString:@"0"]) {
                [JHShareModel shareModel].indexP = nil;
                if (self.myBlcok) {
                    self.myBlcok();
                }
                [JHShowAlert showAlertWithMsg: NSLocalizedString(@"温馨提示", NSStringFromClass([self class])) withBtnTitle: NSLocalizedString(@"接单成功", NSStringFromClass([self class])) withBtnBlock:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }else{
                [JHShowAlert showAlertWithMsg:json[@"message"]];
            }
            HIDE_HUD
        } failure:^(NSError *error) {
            HIDE_HUD
            [JHShowAlert showAlertWithMsg: NSLocalizedString(@"网络连接错误,请检查网络", NSStringFromClass([self class]))];
            NSLog(@"error:%@",error.localizedDescription);
        }];

    }else{
        if (_indexPath == nil){
            [JHShowAlert showAlertWithMsg: NSLocalizedString(@"请选择桌号", NSStringFromClass([self class]))];
            return;
        }
        SHOW_HUD
        ChoseNumemberModel * model = infoArray[_indexPath.section];
        childrenModel * _model = model.childrenModelArray[_indexPath.item];
        
        NSDictionary * dic = @{@"dingzuo_id":self.paidui_id,
                               @"zhuohao_id":_model.zhuohao_id,
                               };
        [HttpTool postWithAPI:@"biz/yuyue/dingzuo/jiedan" withParams:dic success:^(id json) {
            NSLog(@"json:%@",json);
            if ([json[@"error"] isEqualToString:@"0"]) {
                [JHShareModel shareModel].indexP = nil;
                if (self.myBlcok) {
                    self.myBlcok();
                }
                [JHShowAlert showAlertWithMsg: NSLocalizedString(@"接单成功", NSStringFromClass([self class])) withBtnTitle: NSLocalizedString(@"知道了", NSStringFromClass([self class])) withBtnBlock:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }else{
                [JHShowAlert showAlertWithMsg:json[@"message"]];
            }
            HIDE_HUD
        } failure:^(NSError *error) {
            HIDE_HUD
            [JHShowAlert showAlertWithMsg: NSLocalizedString(@"网络连接错误,请检查网络", NSStringFromClass([self class]))];
            NSLog(@"error:%@",error.localizedDescription);
        }];

    }
}
#pragma mark - 这是获取分类的方法
-(void)postHttpGetType{
    SHOW_HUD
    [HttpTool postWithAPI:@"biz/yuyue/zhuohao/cateItems" withParams:@{} success:^(id json) {
        NSLog(@"json:%@",json);
        HIDE_HUD
        if ([json[@"error"] isEqualToString:@"0"]) {
            NSArray * tempArray = json[@"data"][@"items"];
            for (NSDictionary * dic in tempArray) {
                ChoseNumemberModel * model = [ChoseNumemberModel shareChoseNumemberModelWithDic:dic];
                [infoArray addObject:model];
            }
        }else{
            [JHShowAlert showAlertWithMsg:json[@"message"]];
        }
    } failure:^(NSError *error) {
        HIDE_HUD
         [JHShowAlert showAlertWithMsg: NSLocalizedString(@"网络连接错误,请检查网络", NSStringFromClass([self class]))];
        NSLog(@"error:%@",error.localizedDescription);
    }];
}
#pragma mark - 这是点击表视图背景的方法
-(void)clickToReturn{
    [self.view endEditing:YES];
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
