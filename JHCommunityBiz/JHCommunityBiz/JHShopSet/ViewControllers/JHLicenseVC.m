//
//  JHShopIdentityVC.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/31.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHLicenseVC.h"
#import "XHChoosePhoto.h"
@interface JHLicenseVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *mainTableView;
@end

@implementation JHLicenseVC
{
    UITextField *_licenseNumF;//营业执照注册号
    UIImageView *_licenseIV;//营业执照图片
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self createMainTableView];
}
#pragma mark - initData
- (void)initData
{
    self.view.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = NSLocalizedString(@"营业执照", nil);
}
#pragma mark - 初始化表视图
- (void)createMainTableView
{
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0 , 0, WIDTH, HEIGHT - 64 - 60) style:UITableViewStyleGrouped];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
    _mainTableView.separatorColor = DEFAULT_BACKGROUNDCOLOR;
    _mainTableView.layoutMargins = UIEdgeInsetsZero;
    _mainTableView.separatorInset = UIEdgeInsetsZero;
    _mainTableView.showsHorizontalScrollIndicator = NO;
    _mainTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_mainTableView];
}

#pragma mark - UITableViewDelegate and dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:return 60;break;
        case 1:return 150;break;
        case 2:return 90;break;
        default:return 0;break;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:return 0.01;break;
        case 1:return 30;break;
        case 2:return 0.01;break;
        default:return 0;break;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 30)];
        UILabel *label1 =[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, 30)];
        label1.text = NSLocalizedString(@"拍摄营业执照", nil);
        label1.font = FONT(14);
        label1.textColor = [UIColor colorWithHex:@"333333" alpha:1.0];
        
        UILabel *label2 =[[UILabel alloc] initWithFrame:CGRectMake(130, 0, 140, 30)];
        label2.text = NSLocalizedString(@"(请保证所拍中文清晰)", nil);
        label2.font = FONT(14);
        label2.textColor = THEME_COLOR;
        
        [backView addSubview:label1];
        [backView addSubview:label2];
        return backView;
    }
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    if (section == 0) {
        
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
        //add field
        if (!_licenseNumF) {
            _licenseNumF = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, WIDTH - 20, 45)];
            _licenseNumF.backgroundColor = [UIColor whiteColor];
            _licenseNumF.leftViewMode = UITextFieldViewModeAlways;
            UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 45)];
            _licenseNumF.leftView = leftView;
            _licenseNumF.placeholder = NSLocalizedString(@"填写营业执照注册号", nil);
            _licenseNumF.textColor = [UIColor colorWithHex:@"333333" alpha:1.0];
            _licenseNumF.font = FONT(14);
            _licenseNumF.text = @"463782648";
            _licenseNumF.layer.cornerRadius = 4;
            _licenseNumF.layer.masksToBounds = YES;
        }
        [cell addSubview:_licenseNumF];
        return cell;
    }else if(section == 1){
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //添加label
        UILabel *title1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH / 2, 30)];
        title1.textColor = [UIColor colorWithHex:@"999999" alpha:1.0];
        title1.font = FONT(12);
        title1.text = NSLocalizedString(@"参考照片", nil);
        title1.textAlignment = NSTextAlignmentCenter;
        
        UILabel *title2 = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH / 2, 0, WIDTH / 2, 30)];
        title2.textColor = [UIColor colorWithHex:@"999999" alpha:1.0];
        title2.font = FONT(12);
        title2.text = NSLocalizedString(@"你的照片", nil);
        title2.textAlignment = NSTextAlignmentCenter;
        CGFloat width = (WIDTH - 30)/2;
        //添加左侧iv
        UIImageView *leftIv = [[UIImageView alloc] initWithFrame:CGRectMake(10, 30, width, 110)];
        leftIv.image = [UIImage imageNamed:@"businessLicense"];
        //添加右侧iv
        if (!_licenseIV) {
            _licenseIV = [[UIImageView alloc] initWithFrame:CGRectMake(width + 20, 30, width, 110)];
            _licenseIV.image = IMAGE(@"add290D");
            //添加手势
            UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(tapIV:)];
            [_licenseIV addGestureRecognizer:gesture];
            _licenseIV.userInteractionEnabled = YES;
        }
        [cell addSubview:title1];
        [cell addSubview:title2];
        [cell addSubview:leftIv];
        [cell addSubview:_licenseIV];
        return cell;
    }else{
        UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:FRAME(0, 0, WIDTH, 90)];
        cell.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
        UIButton *sureBtn =  [UIButton new];
        [cell addSubview:sureBtn];
        [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell).with.offset(25);
            make.left.equalTo(cell).with.offset(10);
            make.right.equalTo(cell).with.offset(-10);
            make.bottom.equalTo(cell).with.offset(-25);
        }];
        sureBtn.layer.cornerRadius = 3;
        sureBtn.layer.masksToBounds = YES;
        [sureBtn setBackgroundColor:HEX(@"faaf19", 1.0) forState:(UIControlStateNormal)];
        [sureBtn setTitle:NSLocalizedString(@"保存", nil) forState:(UIControlStateNormal)];
        [sureBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        
        return cell;
    }
}
#pragma mark -点击上传身份证图片
- (void)tapIV:(UITapGestureRecognizer *)gesture
{
    UIImageView *imgIV = (UIImageView *)gesture.view;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil)
                                                      style:UIAlertActionStyleCancel
                                                    handler:nil];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:NSLocalizedString(@"相册", nil)
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * _Nonnull action) {
                                                        
                                                        XHChoosePhoto *xhchooseP = [[XHChoosePhoto alloc] init];
                                                        xhchooseP.scaleSize = CGSizeMake(800, 800);
                                                        [self addChildViewController:xhchooseP];
                                                        [xhchooseP startChoosePhoto];
                                                        [xhchooseP setGetImageBlock:^(UIImage *selectedImage,NSData *imageData){
                                                            imgIV.image = selectedImage;
                                                        }];
                                                    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:NSLocalizedString(@"拍照", nil)
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * _Nonnull action) {
                                                        
                                                        XHChoosePhoto *xhchooseP = [[XHChoosePhoto alloc] init];
                                                        xhchooseP.scaleSize = CGSizeMake(800, 800);
                                                        [self addChildViewController:xhchooseP];
                                                        [xhchooseP startTakePhoto];
                                                        [xhchooseP setGetImageBlock:^(UIImage *selectedImage,NSData *imageData){
                                                            imgIV.image = selectedImage;
                                                        }];
                                                        
                                                    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [alert addAction:action3];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
