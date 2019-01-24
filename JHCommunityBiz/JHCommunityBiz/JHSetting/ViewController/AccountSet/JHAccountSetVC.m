//
//  JHAccountSetVC.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/17.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHAccountSetVC.h"
#import "JHModifyPsdVC.h"
#import "JHModifyPhoneVC.h"
#import "JHModifyNameView.h"
@interface JHAccountSetVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *mainTableView;
@end

@implementation JHAccountSetVC
{
    JHModifyNameView *nameView;
    UILabel *nameLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"我的账号", nil);
    //创建表视图
    [self makeMainTableView];
}
#pragma mark - 创建表视图
- (void)makeMainTableView
{
    _mainTableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                              style:(UITableViewStyleGrouped)];
        
        tableView.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
        tableView.separatorColor = LINE_COLOR;
        tableView.delegate = self;
        tableView.dataSource = self;
        [self.view addSubview:tableView];
        tableView;
    });
}
#pragma mark - tableView delegate and dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 10;
    }
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:FRAME(0,0, WIDTH, 44)];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(10, 0, 100, 44)];
                titleLabel.text = NSLocalizedString(@"用户名", nil);
                titleLabel.font = FONT(14);
                titleLabel.textColor = HEX(@"333333", 1.0f);
                [cell addSubview:titleLabel];
                //添加用户名标签
                if (!nameLabel) {
                    nameLabel = [[UILabel alloc] initWithFrame:FRAME(WIDTH-140, 0,110, 44)];
                    nameLabel.textColor = HEX(@"666666", 1.0f);
                    nameLabel.textAlignment = NSTextAlignmentRight;
                    nameLabel.font = FONT(14);
                    nameLabel.text = [JHShareModel shareModel].contact;
                    nameLabel.adjustsFontSizeToFitWidth = YES;

                }
                [cell addSubview:nameLabel];
                return cell;
            }else{
                UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:FRAME(0,0, WIDTH, 44)];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(10, 0, 100, 44)];
                titleLabel.text = NSLocalizedString(@"手机号", nil);
                titleLabel.font = FONT(14);
                titleLabel.textColor = HEX(@"333333", 1.0f);
                [cell addSubview:titleLabel];
                //添加手机号码标签
                UILabel *phoneLabel = [[UILabel alloc] initWithFrame:FRAME(WIDTH-140, 0,110, 44)];
                phoneLabel.textColor = HEX(@"666666", 1.0f);
                phoneLabel.textAlignment = NSTextAlignmentRight;
                phoneLabel.font = FONT(14);
                phoneLabel.text = [JHShareModel shareModel].mobile;
                phoneLabel.adjustsFontSizeToFitWidth = YES;
                [cell addSubview:phoneLabel];
                return cell;
            }
        }
            break;
        default:
        {
            UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:FRAME(0,0, WIDTH, 44)];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(10, 0, 100, 44)];
            titleLabel.text = NSLocalizedString(@"修改密码", nil);
            titleLabel.font = FONT(14);
            titleLabel.textColor = HEX(@"333333", 1.0f);
            [cell addSubview:titleLabel];
            return cell;
        }
            break;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    [_mainTableView deselectRowAtIndexPath:indexPath animated:YES];
    if (section == 0 && row == 0) {
        //修改用户名
        if (!nameView) {
            nameView = [[JHModifyNameView alloc] init];
            nameView.navVC = self.navigationController;
            __weak typeof(self)weakSelf = self;
            [nameView setGetNameBlock:^(NSString *name){
                [weakSelf updateNameLabel:name];
            }];
        }
        [[UIApplication sharedApplication].delegate.window addSubview:nameView];
        
    }else if (section == 0 && row == 1){
        //修改手机号码
        JHModifyPhoneVC *vc = [[JHModifyPhoneVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        //修改密码
        JHModifyPsdVC *vc = [[JHModifyPsdVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - 更新用户名
- (void)updateNameLabel:(NSString *)name
{
    nameLabel.text = name;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
