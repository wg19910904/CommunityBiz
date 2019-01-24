//
//  JHAccountSetVC.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/17.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHAlbumVC.h"
#import "JHPhotoVC.h"
@interface JHAlbumVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *mainTableView;
@end

@implementation JHAlbumVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"相册管理", nil);
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.row == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:FRAME(0,0, WIDTH, 44)];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(10, 0, 100, 60)];
        titleLabel.text = NSLocalizedString(@"环境相册", nil);
        titleLabel.font = FONT(14);
        titleLabel.textColor = HEX(@"333333", 1.0f);
        [cell addSubview:titleLabel];
        return cell;
    }else{
        UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:FRAME(0,0, WIDTH, 44)];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(10, 0, 100, 60)];
        titleLabel.text = NSLocalizedString(@"商品相册", nil);
        titleLabel.font = FONT(14);
        titleLabel.textColor = HEX(@"333333", 1.0f);
        [cell addSubview:titleLabel];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    JHPhotoVC *vc = [[JHPhotoVC  alloc] init];
    if (indexPath.row == 0) {
        vc.titleStr = NSLocalizedString(@"环境相册", nil);
    }else{
        vc.titleStr = NSLocalizedString(@"商品相册", nil);
    }
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
