//
//  BlueToothVC.m
//  WaimaiShop
//
//  Created by jianghu on 15/12/30.
//  Copyright © 2015年 ijianghu. All rights reserved.
//

#import "JHBlueToothPriterSetVC.h"

@interface JHBlueToothPriterSetVC ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_mainTableView;
    NSInteger num;
    UILabel *num_label;
}

@end

@implementation JHBlueToothPriterSetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化数据
    [self initData];
    //初始化表视图
    [self createMainTableView];
}

#pragma mark - 初始化数据
- (void)initData
{
    self.title = NSLocalizedString(@"蓝牙打印设置", nil);
    self.view.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
    self.automaticallyAdjustsScrollViewInsets = NO;
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"print_num"] == 0 || [[NSUserDefaults standardUserDefaults] integerForKey:@"print_num"] == 1) {
        num = 1;
    }else{
        num = [[NSUserDefaults standardUserDefaults] integerForKey:@"print_num"];
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
    return 4;
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
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 170;
    }else{
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
        case 1:
        {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //添加title
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 40)];
            titleLabel.text = NSLocalizedString(@"打印数量", nil);
            titleLabel.textColor = [UIColor colorWithHex:@"333333" alpha:1.0];
            titleLabel.font = FONT(14);
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
            [cell addSubview:titleLabel];
            [cell addSubview:num_label];
            return cell;
        }
            break;
        case 2:
        {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            //添加label
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, WIDTH - 108 - 10, 40)];
            titleLabel.font = FONT(14);
            titleLabel.textColor = [UIColor colorWithHex:@"333333" alpha:1.0];
            titleLabel.text = NSLocalizedString(@"小票样式", nil);
            UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH - 128, 0, 100, 40)];
            contentLabel.textColor = [UIColor colorWithHex:@"999999" alpha:1.0];
            contentLabel.text = NSLocalizedString(@"经典样式", nil);
            contentLabel.font = FONT(14);
            contentLabel.textAlignment = NSTextAlignmentRight;
            [cell addSubview:titleLabel];
            [cell addSubview:contentLabel];
            return cell;
        }
            break;
        case 3:
        {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            //添加label
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, WIDTH - 108 - 10, 40)];
            titleLabel.font = FONT(14);
            titleLabel.textColor = [UIColor colorWithHex:@"333333" alpha:1.0];
            titleLabel.text = NSLocalizedString(@"小票间距", nil);
            UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH - 128, 0, 100, 40)];
            contentLabel.textColor = [UIColor colorWithHex:@"999999" alpha:1.0];
            contentLabel.text = NSLocalizedString(@"默认", nil);
            contentLabel.font = FONT(14);
            contentLabel.textAlignment = NSTextAlignmentRight;
            [cell addSubview:titleLabel];
            [cell addSubview:contentLabel];
            return cell;
        }
            break;
        default:
            return NULL;
            break;
    }
}
#pragma mark - 点击左侧按钮
- (void)clickLeftBtn:(UIButton *)sender
{
    NSLog(@"点击了左侧按钮");
    (num > 1) ? (num-=1):(num-=0);
    num_label.text =[NSString stringWithFormat:@"%ld份",num];
    [[NSUserDefaults standardUserDefaults] setInteger:num forKey:@"print_num"];
}
#pragma mark - 点击右侧按钮
- (void)clickRightBtn:(UIButton *)sender
{
    NSLog(@"点击右侧按钮");
    num++;
    num_label.text =[NSString stringWithFormat:@"%ld份",num];
    [[NSUserDefaults standardUserDefaults] setInteger:num forKey:@"print_num"];
}
#pragma mark - 点击左侧返回按钮
- (void)clickBackBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
