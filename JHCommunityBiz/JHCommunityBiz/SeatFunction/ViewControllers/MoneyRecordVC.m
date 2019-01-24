//
//  MoneyRecordVC.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/9/29.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "MoneyRecordVC.h"
#import "MoneyRecordCell.h"
#import <MJRefresh.h>
#import "MoneyRecorderModel.h"
#import "JHHomePageVC.h"
#import "MoneyRecordSearchVC.h"
#import "UITableView+XHTool.h"
@interface MoneyRecordVC ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger _page;
    NSMutableArray *modelArray;//存放model类
    NSString *total_count;//总的收入
    NSString *total_money;//总的金额
}
@property(nonatomic,strong)UITableView *myTableView;
@property(nonatomic,strong)NSMutableDictionary *dic;
@end

@implementation MoneyRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化一些数据的方法
    [self initData];
    //添加表
    [self.view addSubview:self.myTableView];
    _dic = @{@"day":@"today",@"page":@"1"}.mutableCopy;
    _page = 1;
    modelArray = @[].mutableCopy;
    //获取数据
    [self postHttpToGetListWithPage:_page];
}

#pragma mark - 这是初始化一些数据的方法
-(void)initData{
    self.navigationItem.title =  NSLocalizedString(@"收款记录", NSStringFromClass([self class]));
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:IMAGE(@"btn_shaixuan") style:UIBarButtonItemStylePlain target:self action:@selector(clickSearch)];
    self.navigationItem.rightBarButtonItem = rightItem;
}
-(void)clickSearch{
    MoneyRecordSearchVC *searchVC = [[MoneyRecordSearchVC alloc]init];
    __weak typeof (self)weakSelf = self;
    [searchVC setClickBlock:^(NSMutableDictionary *dic) {
        weakSelf.dic = dic;
        _page = 1;
        //获取数据
        [weakSelf postHttpToGetListWithPage:_page];
    }];
    [self.navigationController pushViewController:searchVC animated:YES];
}
-(void)clickBackBtn{
    if (!self.isOther) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        NSArray * array = self.navigationController.viewControllers;
        for (JHBaseVC * vc  in array) {
            if ([vc isKindOfClass:[JHHomePageVC class]]) {
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
        
    }
}
#pragma mark - 这是创建表视图的方法
-(UITableView * )myTableView{
    if(_myTableView == nil){
        _myTableView = ({
            UITableView * table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64) style:UITableViewStyleGrouped];
            table.delegate = self;
            table.dataSource = self;
            table.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
            table.tableFooterView = [UIView new];
            table.showsVerticalScrollIndicator = NO;
            [table downToRefreshWithBlock:^{
                [self downRefresh];
            }];
            [table upToLoadWithBlock:^{
                [self upLoadData];
            }];
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
    return modelArray.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
    UILabel *label = [[UILabel alloc]init];
    label.backgroundColor = [UIColor whiteColor];
    [view addSubview:label];
    label.font = FONT(16);
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.offset = 0;
        make.height.offset = 50;
    }];
    
    label.text = [NSString stringWithFormat: NSLocalizedString(@"     共收款%@笔,合计¥%@", NSStringFromClass([self class])),total_money,total_count];
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc]initWithString:label.text];
    [attribute addAttributes:@{NSForegroundColorAttributeName:HEX(@"ff9900", 1)} range:NSMakeRange(8, [total_money length])];
    label.attributedText = attribute;
    NSMutableAttributedString *attr = label.attributedText.mutableCopy;
    [attr addAttributes:@{NSForegroundColorAttributeName:HEX(@"ff9900", 1)} range:NSMakeRange(12 + [total_money length] ,[total_count length]+1)];
     label.attributedText = attr;
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str_cell = @"cell_record";
    MoneyRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:str_cell];
    if (!cell) {
        cell = [[MoneyRecordCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str_cell];
    }
    cell.model = modelArray[indexPath.row];
    return cell;
}
#pragma mark - 这是下拉刷新
-(void)downRefresh{
    _page = 1;
    [self postHttpToGetListWithPage:_page];
}
#pragma mark - 上拉加载
-(void)upLoadData{
    _page ++;
    [self postHttpToGetListWithPage:_page];
}
#pragma mark - 这是获取已经支付列表的请求
-(void)postHttpToGetListWithPage:(NSInteger)page{
    SHOW_HUD
    [_dic setObject:@(page).stringValue forKey:@"page"];
    [HttpTool postWithAPI:@"biz/cashier/items" withParams:_dic success:^(id json) {
        NSLog(@"%@",json);
        HIDE_HUD
        if ([json[@"error"] isEqualToString:@"0"]) {
            total_count = json[@"data"][@"total_count"];
            total_money = json[@"data"][@"total_money"];
            if (page == 1) {
                [modelArray removeAllObjects];
            }
            NSArray * tempArray = json[@"data"][@"items"];
            for (NSDictionary * dic in tempArray) {
                MoneyRecorderModel * model = [MoneyRecorderModel creatMoneyRecorderModelWithDic:dic];
                [modelArray addObject:model];
            }
            [_myTableView reloadData];
        }else{
            [JHShowAlert showAlertWithMsg:json[@"message"]];
        };
        [_myTableView.mj_header endRefreshing];
        [_myTableView.mj_footer endRefreshing];
    }failure:^(NSError *error) {
        [_myTableView.mj_header endRefreshing];
        [_myTableView.mj_footer endRefreshing];
        HIDE_HUD
        NSLog(@"%@",error.localizedDescription);
    }];
}
@end
