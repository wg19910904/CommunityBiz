//
//  JHDeliveryMainVC.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/19.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHDeliveryMainVC.h"
#import "JHServiceLicenseVC.h"
@interface JHDeliveryMainVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *mainTableView;
@end

@implementation JHDeliveryMainVC
{
    NSArray *dataArray;
    NSArray *vcArray;
    UIImageView *logoIV;
    UILabel *shopTitleLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createDataArray];
    //创建表视图
    [self createTableView];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //请求数据
    [self loadData];
}
#pragma mark - 创建参数字典
- (void)createDataArray
{
    self.navigationItem.title = NSLocalizedString(@"外送管理", nil);
    dataArray = @[@[@""],@[NSLocalizedString(@"外送订单管理", nil)],@[NSLocalizedString(@"外送模板设置", nil),NSLocalizedString(@"商品分类", nil),NSLocalizedString(@"商品管理", nil)],@[NSLocalizedString(@"外送评价管理", nil)],
                  @[NSLocalizedString(@"起配送管理", nil),NSLocalizedString(@"外送优惠设置", nil)
//                    ,NSLocalizedString(@"餐饮服务许可证", nil)
                    ]];
    vcArray = @[@[@"DeliveryShopInfoVC"],
                @[@"DeliveryOrderVC"],
                @[@"DeliveryTemPlateVC",@"DeliveryClassifyVC",@"DeliveryProductVC"],
                @[@"JHEvaluateMainVC"],
                @[@"DeliveryQiPeiSetVC",@"DeliveryYouhuiSetVC"
//                  ,@"DeliveryLicenceVC"
                  ]];
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
        tableView.separatorColor = DEFAULT_BACKGROUNDCOLOR;
        tableView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:tableView];
        tableView.layoutMargins = UIEdgeInsetsZero;
        tableView.separatorInset = UIEdgeInsetsZero;
        tableView;
    });
    
}
#pragma mark - tableView delegate and dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 3;
            break;
        case 3:
            return 1;
            break;
        default:
            return 2;
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
        UITableViewCell *cell = [UITableViewCell new];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.layoutMargins = UIEdgeInsetsZero;
        if (!logoIV) {
            logoIV = [[UIImageView alloc] initWithFrame:FRAME(10, 10, 40, 40)];
            logoIV.layer.cornerRadius = 3;
            logoIV.layer.masksToBounds = YES;
            logoIV.image = IMAGE(@"100*100");
        }
        [cell addSubview:logoIV];
        if (!shopTitleLabel) {
            shopTitleLabel = [[UILabel alloc] initWithFrame:FRAME(60, 0, WIDTH - 100, 60)];
            shopTitleLabel.textColor = HEX(@"333333", 1.0);
            shopTitleLabel.font = FONT(16);
        }
        [cell addSubview:shopTitleLabel];
        return cell;
    }else if (section == 4 && row == 3){
//        UITableViewCell *cell = [UITableViewCell new];
//        cell.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
//        cell.layoutMargins = UIEdgeInsetsZero;
//        UILabel *remindLabel = [[UILabel alloc] initWithFrame:FRAME(10, 10, WIDTH - 20, 34)];
//        remindLabel.text = NSLocalizedString(@"温馨提示:餐饮类商家必须提供餐饮许可证,其他类型商家可不提交", nil);
//        remindLabel.font = FONT(12);
//        remindLabel.numberOfLines = 0;
//        remindLabel.textColor = HEX(@"f70000", 1.0);
//        [cell addSubview:remindLabel];
        return nil;
    }else{
        UITableViewCell *cell = [UITableViewCell new];
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(10, 0, WIDTH - 50, 44)];
        titleLabel.text = dataArray[section][row];
        titleLabel.font = FONT(14);
        titleLabel.textColor = HEX(@"3333333", 1.0);
        [cell addSubview:titleLabel];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_mainTableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 4 && row == 2) {
        JHServiceLicenseVC * idVC = [[JHServiceLicenseVC alloc]init];
        idVC.type = EJHServiceLicenseTypeCompletion;
        [self.navigationController pushViewController:idVC animated:YES];
    }else if(!(section == 4 && row == 3)){
        Class vcClass = NSClassFromString(vcArray[section][row]);
        [self.navigationController pushViewController:[vcClass new] animated:YES];
    }
}
#pragma mark - 请求数据并刷新
- (void)loadData
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [HttpTool postWithAPI:@"biz/waimai/info"
                   withParams:@{}
                      success:^(id json) {
                          NSLog(@"biz/waimai/info--%@",json);
                          dispatch_async(dispatch_get_main_queue(), ^{
                              
                              if ([json[@"error"] isEqualToString:@"0"]) {
                                  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEADDRESS,json[@"data"][@"logo"]]];
                                  [logoIV sd_setImageWithURL:url placeholderImage:IMAGE(@"100*100")];
                                  shopTitleLabel.text = json[@"data"][@"title"];
                                  JHShareModel * shareModel = [JHShareModel  shareModel];
                                  shareModel.tmpl_type = json[@"data"][@"tmpl_type"];
                              }else{
                                  [JHShowAlert showAlertWithMsg:json[@"message"]];
                              }
                          });
                      }
                      failure:^(NSError *error) {
                          dispatch_async(dispatch_get_main_queue(), ^{
                              [JHShowAlert showAlertWithMsg:NSLocalizedString(@"服务器连接异常", nil)];
                          });
                      }];
    });
}

@end
