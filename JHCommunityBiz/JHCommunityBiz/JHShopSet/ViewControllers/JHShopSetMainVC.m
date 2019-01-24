//
//  JHDeliveryMainVC.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/19.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHShopSetMainVC.h"
#import "JHSetMainCell.h"
#import "JHGetSetStatusModel.h"
#import "JHSetMaincCellZero.h"
#import "JHShopInfoSetVC.h"
#import "JHIdentityAttestationVC.h"
#import "JHSignageVC.h"
#import "JHServiceLicenseVC.h"
#import "JHBankSettingVC.h"
#import "JHPublicNotiVC.h"
#import "JHAlbumVC.h"
@interface JHShopSetMainVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *mainTableView;
@end

@implementation JHShopSetMainVC
{
    NSArray *titleArray;
    UIImageView *logoIV;
    UILabel *shopTitleLabel;
    
    //状态数据
    NSArray *statusArray;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self postHttpForBizInfo];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
    [self createDataArray];
    //创建表视图
    [self createTableView];

}
#pragma mark - 创建参数字典
- (void)createDataArray
{
    self.navigationItem.title = NSLocalizedString(@"店铺设置", nil);
    titleArray = @[@[NSLocalizedString(@"基本资料", nil)],
                   @[NSLocalizedString(@"身份验证", nil),NSLocalizedString(@"营业执照", nil),NSLocalizedString(@"餐饮服务许可证", nil),NSLocalizedString(@"开户行设置", nil),NSLocalizedString(@"公告管理", nil),NSLocalizedString(@"相册管理", nil)]];
   
}
#pragma mark - 请求商户信息
-(void)postHttpForBizInfo{
    [HttpTool postWithAPI:@"biz/shop/shop/info" withParams:@{} success:^(id json) {
        NSLog(@"%@",json);
        if ([json[@"error"] isEqualToString:@"0"]) {
            JHShareModel * model = [JHShareModel shareModel];
            model.infoDictionary = json[@"data"];
            [_mainTableView reloadData];
        }else{
            
        }
    } failure:^(NSError *error) {
       
    }];
}

#pragma mark - 创建表视图
- (void)createTableView
{
    _mainTableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, WIDTH, HEIGHT - 64)
                                                              style:UITableViewStyleGrouped];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
        tableView.separatorColor = LINE_COLOR;
        tableView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:tableView];
        tableView.layoutMargins = UIEdgeInsetsZero;
        tableView.separatorInset = UIEdgeInsetsZero;
        tableView;
    });
    
}
#pragma mark - 刷新数据
- (void)refreshData
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //处理状态数组
            JHGetSetStatusModel *model = [JHGetSetStatusModel new];
            statusArray = [model getStatusArray:@[]];
            
            statusArray = @[@[NSLocalizedString(@"已通过", nil)],
                            @[NSLocalizedString(@"已验证", nil),NSLocalizedString(@"已验证", nil),NSLocalizedString(@"已验证", nil),NSLocalizedString(@"已验证", nil),NSLocalizedString(@"已验证", nil)]];
            NSArray<JHSetMainCell *>*cellArray = [_mainTableView visibleCells];
            [cellArray enumerateObjectsUsingBlock:^(JHSetMainCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.statusLabel.text = statusArray[idx>0?1:0][idx>0?(idx - 1):0];
            }];
        });
        
    });
}
#pragma mark - tableView delegate and dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        default:
            return 6;
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 0.01;
            break;
        default:
            return 10;
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 60;
            break;
            
        default:
            return 44;
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        JHSetMaincCellZero *cell = [_mainTableView dequeueReusableCellWithIdentifier:@"JHSetMaincCellZeroID"];
        if (!cell) {
            cell = [[JHSetMaincCellZero alloc] initWithStyle:(UITableViewCellStyleDefault)
                                             reuseIdentifier:@"JHSetMaincCellZeroID"];
        }
        if (!statusArray || statusArray.count == 0) {
            cell.statusLabel.text = NSLocalizedString(@"获取中...", nil);
        }else{
            cell.statusLabel.text = statusArray[section][row];
        }
        cell.titleLabel.text = [JHShareModel shareModel].infoDictionary[@"title"];
        [cell.logoIV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEADDRESS,[JHShareModel shareModel].infoDictionary[@"logo"]]] placeholderImage:[UIImage imageNamed:@"evaluateDefault"]];
        return cell;
       
    }else{
        JHSetMainCell *cell = [_mainTableView dequeueReusableCellWithIdentifier:@"JHSetMainCellID"];
        if (!cell) {
            cell = [[JHSetMainCell alloc] initWithStyle:(UITableViewCellStyleDefault)
                                        reuseIdentifier:@"JHSetMainCellID"];
        }
        cell.titleLabel.text = titleArray[section][row];
        if (!statusArray || statusArray.count == 0) {
            cell.statusLabel.text = NSLocalizedString(@"获取中...", nil);
        }else{
            cell.statusLabel.text = statusArray[section][row];
        }
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_mainTableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    JHBaseVC * vc = nil;
    if (section == 0) {
        vc = [JHShopInfoSetVC new];
    }else{
        switch (row) {
            case 0:{
                JHIdentityAttestationVC * idVC = [[JHIdentityAttestationVC alloc]init];
                idVC.type = EJHAttesstationTypeCompletion;
                vc = idVC;
            }
                break;
            case 1:{
                JHSignageVC * idVC = [[JHSignageVC alloc]init];
                idVC.type = EJHSignageTypeCompletion;
                vc = idVC;
            }
                break;
            case 2:{
                JHServiceLicenseVC * idVC = [[JHServiceLicenseVC alloc]init];
                idVC.type = EJHServiceLicenseTypeCompletion;
                vc = idVC;
            }
                break;
            case 3:{
                vc = [JHBankSettingVC new];
            }
                break;
            case 4:{
                vc = [JHPublicNotiVC new];
            }
                break;
            
            default:{
                vc = [JHAlbumVC new];
            }
                break;
        }
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}
@end
