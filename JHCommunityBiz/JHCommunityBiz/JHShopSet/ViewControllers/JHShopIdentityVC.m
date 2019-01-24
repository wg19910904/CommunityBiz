//
//  JHShopIdentityVC.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/31.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHShopIdentityVC.h"
#import "XHChoosePhoto.h"
@interface JHShopIdentityVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *mainTableView;
@end

@implementation JHShopIdentityVC
{
    UITextField *_nameF;//姓名
    UITextField *_IDNumF;//身份证号
    UIImageView *_IDIV;//身份证照片
    UIImageView *_shopIV;//店铺图片
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self createMainTableView];
    [self addBottomBtn];
}
#pragma mark - initData
- (void)initData
{
    self.view.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = NSLocalizedString(@"身份验证", nil);
}
#pragma mark - 初始化表视图
- (void)createMainTableView
{
    _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0 , 0, WIDTH, HEIGHT - 64 - 60) style:UITableViewStyleGrouped];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
    _mainTableView.separatorColor = LINE_COLOR;
    _mainTableView.layoutMargins = UIEdgeInsetsZero;
    _mainTableView.separatorInset = UIEdgeInsetsZero;
    _mainTableView.showsHorizontalScrollIndicator = NO;
    _mainTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_mainTableView];
}
#pragma mark - 添加底部按钮
- (void)addBottomBtn
{
    UIButton *sureBtn =  [UIButton new];
    [self.view addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_bottom).with.offset(-50);
        make.left.equalTo(self.view).with.offset(10);
        make.right.equalTo(self.view).with.offset(-10);
        make.bottom.equalTo(self.view).with.offset(-10);
    }];
    sureBtn.layer.cornerRadius = 3;
    sureBtn.layer.masksToBounds = YES;
    [sureBtn setBackgroundColor:HEX(@"faaf19", 1.0) forState:(UIControlStateNormal)];
    [sureBtn setTitle:NSLocalizedString(@"保存", nil) forState:(UIControlStateNormal)];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
}
#pragma mark - UITableViewDelegate and dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:return 2;break;
        case 1:return 1;break;
        case 2:return 1;break;
        default:return 0;break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:return 44;break;
        case 1:return 150;break;
        case 2:return 150;break;
        default:return 0;break;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:return 10;break;
        case 1:return 30;break;
        case 2:return 30;break;
        default:return 0;break;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 30)];
        UILabel *label1 =[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 120, 30)];
        label1.text = NSLocalizedString(@"拍摄店主身份证正面照", nil);
        label1.font = FONT(14);
        label1.textColor = [UIColor colorWithHex:@"333333" alpha:1.0];
        
        UILabel *label2 =[[UILabel alloc] initWithFrame:CGRectMake(150, 0, 140, 30)];
        label2.text = NSLocalizedString(@"(请保证所拍中文清晰)", nil);
        label2.font = FONT(14);
        label2.textColor = THEME_COLOR;
        
        [backView addSubview:label1];
        [backView addSubview:label2];
        return backView;
    }
    if (section == 2) {
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 30)];
        UILabel *label1 =[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 120, 30)];
        label1.text = NSLocalizedString(@"拍摄店面(含店主)照", nil);
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
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    switch (section) {
        case 0:
        {
            switch (row) {
                case 0:
                {
                    UITableViewCell *cell = [[UITableViewCell alloc] init];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
                    //add field
                    if (!_nameF) {
                        _nameF = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, WIDTH - 20, 44)];
                        _nameF.backgroundColor = [UIColor whiteColor];
                        _nameF.leftViewMode = UITextFieldViewModeAlways;
                        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
                        _nameF.leftView = leftView;
                        _nameF.placeholder = NSLocalizedString(@"真实姓名", nil);
                        _nameF.textColor = [UIColor colorWithHex:@"333333" alpha:1.0];
                        _nameF.font = FONT(14);
                        _nameF.text = NSLocalizedString(@"隔壁老王", nil);
                    }
                    [cell addSubview:_nameF];
                    return cell;
                }
                    break;
                case 1:
                {
                    UITableViewCell *cell = [[UITableViewCell alloc] init];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
                    //add field
                    if (!_IDNumF) {
                        _IDNumF = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, WIDTH - 20, 40)];
                        _IDNumF.backgroundColor = [UIColor whiteColor];
                        _IDNumF.leftViewMode = UITextFieldViewModeAlways;
                        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
                        _IDNumF.leftView = leftView;
                        _IDNumF.placeholder = NSLocalizedString(@"身份证号", nil);
                        _IDNumF.textColor = [UIColor colorWithHex:@"333333" alpha:1.0];
                        _IDNumF.font = FONT(14);
                        _IDNumF.text = @"759843759834";
                    }
                    [cell addSubview:_IDNumF];
                    return cell;
                }
                    break;
                    
                default:
                    return NULL;
                    break;
            }
        }
            break;
        case 1:
        {
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
            leftIv.image = [UIImage imageNamed:@"IDImg"];
            //添加右侧iv
            if (!_IDIV) {
                _IDIV = [[UIImageView alloc] initWithFrame:CGRectMake(width + 20, 30, width, 110)];
                _IDIV.image = IMAGE(@"add290D");
                //添加手势
                UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                action:@selector(tapIV:)];
                [_IDIV addGestureRecognizer:gesture];
                _IDIV.userInteractionEnabled = YES;
            }
            [cell addSubview:title1];
            [cell addSubview:title2];
            [cell addSubview:leftIv];
            [cell addSubview:_IDIV];
            return cell;
        }
            break;
        default:
        {
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
            leftIv.image = [UIImage imageNamed:@"shopImg"];
            //添加右侧iv
            if (!_shopIV) {
                _shopIV = [[UIImageView alloc] initWithFrame:CGRectMake(width + 20, 30, width, 110)];
                _shopIV.image = IMAGE(@"add290D");
                //添加手势
                UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(tapIV:)];
                [_shopIV addGestureRecognizer:gesture];
                _shopIV.userInteractionEnabled = YES;
            }
            [cell addSubview:title1];
            [cell addSubview:title2];
            [cell addSubview:leftIv];
            [cell addSubview:_shopIV];
            return cell;
        }
            break;
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
