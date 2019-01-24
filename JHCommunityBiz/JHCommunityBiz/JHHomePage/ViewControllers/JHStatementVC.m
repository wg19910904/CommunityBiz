//
//  JHStatementVC.m
//  JHCommunityBiz
//
//  Created by ijianghu on 2017/11/17.
//  Copyright © 2017年 com.jianghu. All rights reserved.
//

#import "JHStatementVC.h"
#import "JHStateMentCell.h"
#import "JHStateMentModel.h"
#import "JHWebVC.h"
@interface JHStatementVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSDictionary *dic;
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *infoArr;
@end

@implementation JHStatementVC

- (void)viewDidLoad {
    [super viewDidLoad];
    dic = [JHShareModel shareModel].infoDictionary[@"count"];
    self.navigationItem.title =  NSLocalizedString(@"对账单", NSStringFromClass([self class]));
    _infoArr = @[].mutableCopy;
    NSArray *imgArr = @[@"icon_reconciliation01",@"icon_reconciliation02",@"icon_reconciliation03",@"icon_reconciliation04"];
    NSArray *titleArr = @[ NSLocalizedString(@"外送对账单", NSStringFromClass([self class])),
                            NSLocalizedString(@"团购对账单", NSStringFromClass([self class])),
                            NSLocalizedString(@"优惠买单对账单", NSStringFromClass([self class])),
                            NSLocalizedString(@"收款对账单", NSStringFromClass([self class]))];
    for (int i = 0; i < 4; i++) {
        NSDictionary *tempDic;
        if (i == 0) {
            tempDic = dic[@"waimai"];
        }else if (i == 1){
            tempDic = dic[@"tuan"];
        }else if (i == 2){
            tempDic = dic[@"maidan"];
        }else{
            tempDic = dic[@"cashier"];
        }
        JHStateMentModel *model = [JHStateMentModel new];
        model.imgStr = imgArr[i];
        model.titleStr = titleArr[i];
        model.numStr = tempDic[@"num"];
        model.moneyStr = tempDic[@"amount"];
        [_infoArr addObject:model];
    }
    [self tableView];
}
#pragma mark - 这是创建表视图的方法
-(UITableView * )tableView{
    if(_tableView == nil){
        _tableView = ({
            UITableView * table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64) style:UITableViewStyleGrouped];
            table.delegate = self;
            table.dataSource = self;
            table.tableHeaderView = [self creatTableViewHeader];
            table.tableFooterView = [UIView new];
            table.showsVerticalScrollIndicator = NO;
            table.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
            table.separatorStyle = UITableViewCellSeparatorStyleNone;
            [self.view addSubview:table];
            table;
        });
    }
    return _tableView;
}
#pragma mark - 添加表头
-(UIView *)creatTableViewHeader{
    
    UIView *view = [UIView new];
    view.backgroundColor = HEX(@"424879", 1);
    view.frame = FRAME(0, 0, WIDTH, 160);
    UILabel *titleL = [[UILabel alloc]init];
    titleL.text =  NSLocalizedString(@"今日全部收入", NSStringFromClass([self class]));
    titleL.font = FONT(14);
    titleL.textColor = [UIColor whiteColor];
    [view addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset = 32;
        make.centerX.mas_equalTo(view.mas_centerX);
        make.height.offset = 16;
    }];
    
    UILabel *moneyL = [UILabel new];
    moneyL.textColor = [UIColor whiteColor];
    moneyL.font = FONT(32);
    moneyL.text = [NSString stringWithFormat: NSLocalizedString(@"¥%@", NSStringFromClass([self class])),dic[@"all"][@"amount"]];
    [view addSubview:moneyL];
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc]initWithString:moneyL.text];
    [attribute addAttributes:@{NSFontAttributeName:FONT(20)} range:NSMakeRange(0, 1)];
    moneyL.attributedText = attribute;
    [moneyL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleL.mas_bottom).offset = 15;
        make.centerX.mas_equalTo(view.mas_centerX);
        make.height.offset = 40;
    }];
    
    UILabel *numL = [[UILabel alloc]init];
    numL.text = [NSString stringWithFormat: NSLocalizedString(@"共计%@笔", NSStringFromClass([self class])),dic[@"all"][@"num"]];
    numL.font = FONT(14);
    numL.textColor = [UIColor whiteColor];
    [view addSubview:numL];
    [numL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(moneyL.mas_bottom).offset = 16;
        make.centerX.mas_equalTo(view.mas_centerX);
        make.height.offset = 16;
    }];
    return view;
}
#pragma mark - 这是UITableView的代理和方法和数据方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _infoArr.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 84;
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
    return 0.01;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = @"JHStateMentCell";
    JHStateMentCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[JHStateMentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    cell.model = _infoArr[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *tempDic = [JHShareModel shareModel].infoDictionary[@"bills_url"];
    NSString *str;
    if (indexPath.row == 0) {
        str = tempDic[@"waimai_bills_url"];
    }else if (indexPath.row  == 1){
        str = tempDic[@"tuan_bills_url"];
    }else if (indexPath.row  == 2){
        str = tempDic[@"maidan_bills_url"];
    }else{
        str = tempDic[@"cashier_bills_url"];
    }
    JHWebVC *vc = [[JHWebVC alloc]init];
    vc.urlStr = str;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
