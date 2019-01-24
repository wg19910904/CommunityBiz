//
//  JHTuanGouProductAddVC.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/6/1.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHTuanGouProductAddVC.h"
#import "TuanGouProductCellOne.h"
#import <IQKeyboardManager.h>
#import "JhTuanGouProductRuleVC.h"
#import "JHPickerView.h"
#import "HZQChangeDateLine.h"
#import "RichTextViewController.h"
#import "NSJSON+Extension.h"
#import "PictureModel.h"
#import "JHTuangouDetailOfButtomView.h"
#import "HZQChangeImageSize.h"
#import "JHTuangouDetailModel.h"
#import <UIImageView+WebCache.h>
#import "HZQChangeDateLine.h"
#import "HZQChangeImageSize.h"
#import "JHTuanTypeBtn.h"
#import "HZQDatePicker.h"
#import "JHTuanProductDescVC.h"
@interface JHTuanGouProductAddVC ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,RichTextViewControllerDelegate>
@property(nonatomic,strong)UITableView *mainTableView;
@end

@implementation JHTuanGouProductAddVC
{
    UITextField *_tuanNameF;
    UITextField *_minNumF;
    UITextField *_maxNumF;
    UISwitch *_xianGouS;
    UITextField *_kuCunNumF;
    UITextField *_sortNumF;
    UITextField *_tuanPriceF;
    UITextField *_salePriceF;
    UITextField * _descTextField;
    UILabel *_sTimeL;
    UILabel *_lTimeL;
    UILabel *_ruleL;
    UILabel *_picL;
    UIImageView * imageView_add;//点击添加图片的
    UIImage * image_chose;//保存每次选择的图片
    NSData * data_image; //保存每次选择的图片的数据流
    UIView * myView;//这是点击图片查看原图的方法
    NSInteger num;
    NSString * jsonString;
    NSString * htmlString;
    NSString * ruleString;
    JHTuangouDetailModel * detailModel;
    JHTuanTypeBtn * oldbtn;
    UISwitch * _isShelf;
    NSString * tuan_type;
    BOOL isShelf;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self addRightBtn];
    if (!self.isRevise) {
        [self createMainTableView];
    }
}
- (void)initData
{
    num = 1;
    if (self.isRevise) {
        self.navigationItem.title = NSLocalizedString(@"修改商品", nil);
        //获取信息
        [self postHttpForGetInfomation];
    }else{
         tuan_type = @"tuan";
         isShelf = YES;
         self.navigationItem.title = NSLocalizedString(@"添加新商品", nil);
    }
}
#pragma mark - 这是添加底部的View的方法
-(void)creatButtomView{
    JHTuangouDetailOfButtomView * buttomView = [[JHTuangouDetailOfButtomView alloc]initWithFrame:FRAME(0, HEIGHT - 50 - 64, WIDTH, 50)];
    if (self.type == 0) {
        buttomView.buttomViewType = ETuanStatusShelf;
    }else if (self.type == 1){
        buttomView.buttomViewType = ETuanStatusNotShelf;
    }else{
         buttomView.buttomViewType = ETuanStatusOverdue;
    }
    buttomView.shelfBtn.tag = self.type;
    [buttomView.shelfBtn addTarget:self action:@selector(clickToShelfBtn:) forControlEvents:UIControlEventTouchUpInside];
    [buttomView.deleteBtn addTarget:self action:@selector(clickToDelete:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttomView];
}
#pragma mark - 这是点击上架/下架/延期的方法
-(void)clickToShelfBtn:(UIButton *)sender{
    if (sender.tag == 0) {
        NSLog(@"点击的是下架");
        [self postHttpWithStatus:@"0" withIds:self.tuan_id];
    }else if(sender.tag == 1){
        NSLog(@"点击的是上架");
        [self postHttpWithStatus:@"1" withIds:self.tuan_id];
    }else{
        NSLog(@"点击的是延期");
        [self postHttpWithIds:self.tuan_id];
    }
}
#pragma mark - 这是点击删除的方法
-(void)clickToDelete:(UIButton *)sender{
    NSLog(@"点击的是删除的方法");
    [self postHttpForDeleteWithIds:self.tuan_id];
}
#pragma mark - 这是点击删除的方法
-(void)postHttpForDeleteWithIds:(NSString *)ids{
    SHOW_HUD
    [HttpTool postWithAPI:@"biz/tuan/tuan/delete" withParams:@{@"tuan_id":self.tuan_id} success:^(id json) {
        NSLog(@"json------>%@",json);
        if ([json[@"error"] isEqualToString:@"0"]) {
            [JHShowAlert showAlertWithMsg:NSLocalizedString(@"设置成功", nil) withBtnTitle:NSLocalizedString(@"知道了", nil) withBtnBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }else{
            [JHShowAlert showAlertWithMsg:json[@"message"]];
        }
        HIDE_HUD
    } failure:^(NSError *error) {
        HIDE_HUD
        [JHShowAlert showAlertWithMsg:NSLocalizedString(@"服务器繁忙,请稍后访问", nil)];
        NSLog(@"%@",error.localizedDescription);
    }];
}
#pragma mark - 这是延期发送请求的方法
-(void)postHttpWithIds:(NSString *)ids{
    HZQDatePicker * datePicker = [[HZQDatePicker alloc]init];
    [datePicker setMyBlock:^(NSString * time) {
        NSLog(@"<<<<<<<<<你选择的时间是%@>>>>>>>>",time);
        if ([time compare:_sTimeL.text] == 1 ||  [time compare:_sTimeL.text] == 0) {
            time = @([HZQChangeDateLine ExchangeWithTime:time]).stringValue;
        }else{
            [JHShowAlert showAlertWithMsg:NSLocalizedString(@"券截止时间请大于或等于开始时间", nil)];
        }
        
        SHOW_HUD
        [HttpTool postWithAPI:@"biz/tuan/tuan/batch_time" withParams:@{@"ltime":time,@"ids":ids} success:^(id json) {
            NSLog(@"json---->%@",json);
            HIDE_HUD
            if ([json[@"error"] isEqualToString:@"0"]) {
                [JHShowAlert showAlertWithMsg:NSLocalizedString(@"设置成功", nil) withBtnTitle:NSLocalizedString(@"知道了", nil) withBtnBlock:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }else{
                [JHShowAlert showAlertWithMsg:json[@"message"]];
            }
            
        } failure:^(NSError *error) {
            HIDE_HUD
            [JHShowAlert showAlertWithMsg:NSLocalizedString(@"服务器繁忙,请稍后访问", nil)];
            NSLog(@"error----->%@",error.localizedDescription);
        }];
    }];
    [datePicker creatDatePickerWithObj:datePicker withDate:[NSDate date]];
}
#pragma mark - 这是处理上架还是下架的方法
-(void)postHttpWithStatus:(NSString *)status withIds:(NSString *)ids{
    SHOW_HUD
    [HttpTool postWithAPI:@"biz/tuan/tuan/batch_status" withParams:@{@"status":status,@"ids":ids} success:^(id json) {
        NSLog(@"json---->%@",json);
        HIDE_HUD
        if ([json[@"error"] isEqualToString:@"0"]) {
            [JHShowAlert showAlertWithMsg:NSLocalizedString(@"设置成功", nil) withBtnTitle:NSLocalizedString(@"知道了", nil) withBtnBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }else{
            [JHShowAlert showAlertWithMsg:json[@"message"]];
        }
        
    } failure:^(NSError *error) {
        HIDE_HUD
        [JHShowAlert showAlertWithMsg:NSLocalizedString(@"服务器繁忙,请稍后访问", nil)];
        NSLog(@"error----->%@",error.localizedDescription);
    }];
}

#pragma mark - 这是修改商品时获取商品信息的方法
-(void)postHttpForGetInfomation{
    SHOW_HUD
    [HttpTool postWithAPI:@"biz/tuan/tuan/detail" withParams:@{@"tuan_id":self.tuan_id} success:^(id json) {
        NSLog(@"json>>>>>>>>%@",json);
        if ([json[@"error"] isEqualToString:@"0"]) {
            detailModel = [JHTuangouDetailModel creatJHTuangouDetailModelWithDictionary:json[@"data"][@"tuan"]];
            if ([detailModel.stock_type isEqualToString:@"1"]) {
                num = 1;
            }else{
                num = 0;
            }
            if (detailModel.is_onsale.integerValue == 0) {
                isShelf = NO;
            }else{
                isShelf = YES;
            }
            tuan_type  = detailModel.type;
            htmlString = detailModel.detail;
            ruleString = detailModel.notice;
        }else{
            [JHShowAlert showAlertWithMsg:json[@"message"]];
        }
        HIDE_HUD
        [self createMainTableView];
        //创建添加底部的按钮的方法
        [self creatButtomView];
    } failure:^(NSError *error) {
        HIDE_HUD
     [JHShowAlert showAlertWithMsg:NSLocalizedString(@"服务器繁忙,请稍后访问", nil)];
      NSLog(@"%@",error.localizedDescription);
    }];
}
#pragma mark - 添加导航栏右侧按钮
- (void)addRightBtn
{
    //未选中时为未完成订单,选中时为已完成订单
    UIButton  *rightBtn = [[UIButton alloc] initWithFrame:FRAME(0, 0, 55, 30)];
    [rightBtn setTitle:NSLocalizedString(@"完成", nil) forState:(UIControlStateNormal)];
    [rightBtn setTitleColor:HEX(@"faaf19", 1.0f) forState:(UIControlStateNormal)];
    rightBtn.titleLabel.font = FONT(16);
    [rightBtn addTarget:self action:@selector(clickRightBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}
#pragma mark - 创建表视图
- (void)createMainTableView
{
    if (_mainTableView == nil) {
        _mainTableView = ({
            UITableView * tableView = nil;
            if (self.isRevise) {
                tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, WIDTH, HEIGHT-64-50)
                                                        style:UITableViewStyleGrouped];
            }else{
                tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, WIDTH, HEIGHT-64)
                                                        style:UITableViewStyleGrouped];
            }
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

    }else{
        [_mainTableView reloadData];
    }
}
#pragma mark - tableView delegate and dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 5;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 1;
            break;
        case 3:
            return 1;
            break;
        case 4:
            return 2;
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
        case 1:
            return 0.01;
            break;
        case 2:
            return 0.01;
            break;
        default:
            return 10;
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        return [TuanGouProductCellOne getHeight:1];
    }
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0 && !self.isRevise) {
        return 44;
    }
        return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0&&!self.isRevise) {
        UIView *bgV = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 44)];
        bgV.backgroundColor = [UIColor whiteColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(10, 0, 70, 44)];
        titleLabel.text = NSLocalizedString(@"是否上架", nil);
        titleLabel.font = FONT(15);
        titleLabel.textColor = HEX(@"333333", 1.0f);
        [bgV addSubview:titleLabel];
        if (_isShelf == nil) {
            //添加右侧开关
            _isShelf = [[UISwitch alloc] initWithFrame:CGRectMake(WIDTH - 56, 5, 90,30)];
            _isShelf.transform = CGAffineTransformMakeScale( .8, .8);
            _isShelf.onTintColor = THEME_COLOR;
            [_isShelf addTarget:self action:@selector(changShelfSwitch:) forControlEvents:UIControlEventValueChanged];
            _isShelf.on = YES;
            [bgV addSubview:_isShelf];
        }
        return bgV;
    }
    return NULL;

}
#pragma mark - 这是是否上架的方法
-(void)changShelfSwitch:(UISwitch *)sender{
    if (sender.on) {
        isShelf = YES;
    }else{
        isShelf = NO;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    if (section == 1) {
//        UIView *bgV = [[UIView alloc] initWithFrame:FRAME(0, 0, WIDTH, 44)];
//        bgV.backgroundColor = [UIColor whiteColor];
//        UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(10, 0, 70, 44)];
//        titleLabel.text = NSLocalizedString(@"限量", nil);
//        titleLabel.font = FONT(15);
//        titleLabel.textColor = HEX(@"333333", 1.0f);
//        [bgV addSubview:titleLabel];
//            //添加右侧开关
//            _xianGouS = [[UISwitch alloc] initWithFrame:CGRectMake(WIDTH - 56, 5, 90,30)];
//            _xianGouS.transform = CGAffineTransformMakeScale( .8, .8);
//            _xianGouS.onTintColor = THEME_COLOR;
//            [_xianGouS addTarget:self action:@selector(changSwitch:) forControlEvents:UIControlEventValueChanged];
//            [bgV addSubview:_xianGouS];
//        if (num == 1) {
//            [_xianGouS setOn:YES animated:NO];
//        }else{
//            [_xianGouS setOn:NO animated:NO];
//        }
//        return bgV;
//    }
        return NULL;
}
-(void)changSwitch:(UISwitch * )sender{
    if (sender.on) {
        num = 1;
    }else{
        num = 0;
    }
    [_mainTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
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
                    TuanGouProductCellOne *cell = [_mainTableView dequeueReusableCellWithIdentifier:@"TuanGouProductCellOneID"];
                    if (!cell) {
                        cell = [[TuanGouProductCellOne alloc] initWithStyle:(UITableViewCellStyleDefault)
                                                            reuseIdentifier:@"TuanGouProductCellOneID"];
                    }
                    cell.dataDic = @{};
                    if (self.isRevise) {
                        if (image_chose) {
                            cell.tem_iv.img.image = image_chose;
                        }else{
                            [cell.tem_iv.img sd_setImageWithURL:[NSURL URLWithString:detailModel.photo] placeholderImage:[UIImage imageNamed:@"evaluateDefault"]];
                            data_image = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:detailModel.photo]];
                            image_chose = [UIImage imageWithData:data_image];
                        }
                    }else{
                        if (image_chose) {
                            cell.tem_iv.img.image = image_chose;
                        }else{
                            cell.tem_iv.img.image = [UIImage imageNamed:@"Delivery_pic_add"];
                        }
                    }
                    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToChoseImage:)];
                    cell.tem_iv.img.userInteractionEnabled = YES;
                    [cell.tem_iv.img addGestureRecognizer:tapGesture];
                    imageView_add = cell.tem_iv.img;
                    return cell;
                }
                    break;
                case 1:
                {
                    UITableViewCell * cell = [UITableViewCell new];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(10, 0, 70, 44)];
                    titleLabel.text = NSLocalizedString(@"商品标题", nil);
                    titleLabel.font = FONT(15);
                    titleLabel.textColor = HEX(@"333333", 1.0f);
                    [cell addSubview:titleLabel];
                    if (!_tuanNameF) {
                        _tuanNameF = [[UITextField alloc] initWithFrame:FRAME(80, 5, WIDTH - 90, 34)];
                        _tuanNameF.textColor = THEME_COLOR;
                        _tuanNameF.font = FONT(14);
                        _tuanNameF.placeholder = NSLocalizedString(@"请输入商品标题", nil);
                    }
                    if (self.isRevise) {
                        _tuanNameF.text = detailModel.title;
                    }
                    [cell addSubview:_tuanNameF];
                    return cell;
                }
                case 2:{
                    UITableViewCell * cell = [UITableViewCell new];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(10, 0, 80, 44)];
                    titleLabel.text = NSLocalizedString(@"商品副标题", nil);
                    titleLabel.font = FONT(15);
                    titleLabel.textColor = HEX(@"333333", 1.0f);
                    [cell addSubview:titleLabel];
                    if (!_descTextField) {
                        _descTextField = [[UITextField alloc] initWithFrame:FRAME(90, 5, WIDTH - 90, 34)];
                        _descTextField.textColor = THEME_COLOR;
                        _descTextField.font = FONT(14);
                        _descTextField.placeholder = NSLocalizedString(@"请输入商品副标题", nil);
                    }
                    if (self.isRevise) {
                        _descTextField.text = detailModel.desc;
                    }
                    [cell addSubview:_descTextField];
                    return cell;

                }
                case 3:{
                    UITableViewCell *cell = [UITableViewCell new];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    UILabel * titleLabel = [[UILabel alloc] initWithFrame:FRAME(10, 0, WIDTH/4-10, 44)];
                    titleLabel.text = NSLocalizedString(@"最小购买数", nil);
                    titleLabel.font = FONT(15);
                    titleLabel.textColor = HEX(@"333333", 1.0f);
                    titleLabel.adjustsFontSizeToFitWidth = YES;
                    [cell addSubview:titleLabel];
                    
                    if (!_minNumF) {
                        _minNumF = [[UITextField alloc] initWithFrame:FRAME(WIDTH/4+10, 5, WIDTH/4-10, 34)];
                        _minNumF.textColor = THEME_COLOR;
                        _minNumF.font = FONT(15);
                        _minNumF.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
                        _minNumF.keyboardType = UIKeyboardTypeNumberPad;
                        _minNumF.textAlignment = NSTextAlignmentCenter;
                    }
                    if (self.isRevise) {
                        _minNumF.text = detailModel.min_buy;
                    }
                    [cell addSubview:_minNumF];
                    UILabel * titleLabel2 = [[UILabel alloc] initWithFrame:FRAME(WIDTH/2+ 10, 0, WIDTH/4 - 10, 44)];
                    titleLabel2.text = NSLocalizedString(@"最大购买数", nil);
                    titleLabel2.font = FONT(15);
                    titleLabel2.textColor = HEX(@"333333", 1.0f);
                    titleLabel2.adjustsFontSizeToFitWidth = YES;
                    [cell addSubview:titleLabel2];
                    if (!_maxNumF) {
                        _maxNumF = [[UITextField alloc] initWithFrame:FRAME(WIDTH/4 * 3, 5, WIDTH/4-10, 34)];
                        _maxNumF.textColor = THEME_COLOR;
                        _maxNumF.font = FONT(15);
                        _maxNumF.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
                        _maxNumF.keyboardType = UIKeyboardTypeNumberPad;
                        _maxNumF.textAlignment = NSTextAlignmentCenter;
                    }
                    if (self.isRevise) {
                        _maxNumF.text = detailModel.max_buy;
                    }
                    [cell addSubview:_maxNumF];
                    return cell;
                }
                    break;
                default:
                {
                    UITableViewCell *cell = [UITableViewCell new];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    for (int i = 0; i < 2; i ++) {
                        JHTuanTypeBtn * btn = [[JHTuanTypeBtn alloc]init];
                        //[btn setTitleColor:[UIColor colorWithWhite:0.5 alpha:1] forState:UIControlStateNormal];
                        //btn.titleLabel.font = FONT(15);
                        btn.tag = i;
                        if (!self.isRevise) {
                            if (i == 0) {
                                btn.textLabel.text = NSLocalizedString(@"团购套餐", nil);
                                btn.selected = YES;
                                oldbtn = btn;
                            }else{
                                btn.center = CGPointMake(btn.center.x+WIDTH/2, btn.center.y);
                                btn.textLabel.text = NSLocalizedString(@"团购代金券", nil);
                            }

                        }else{
                            if (i == 0) {
                                btn.textLabel.text = NSLocalizedString(@"团购套餐", nil);
                                if ([tuan_type isEqualToString:@"tuan"]) {
                                    btn.selected = YES;
                                    oldbtn = btn;
                                }
                                
                            }else{
                                if ([tuan_type isEqualToString:@"quan"]) {
                                    btn.selected = YES;
                                    oldbtn = btn;
                                }
                                btn.center = CGPointMake(btn.center.x+WIDTH/2, btn.center.y);
                                btn.textLabel.text = NSLocalizedString(@"团购代金券", nil);
                            }
                    }
                        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
                        [cell addSubview:btn];
                    }
                    return cell;
                }
                    break;
            }
        }
            break;
        case 1:
        {
            UITableViewCell *cell = [UITableViewCell new];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(10, 0, 70, 44)];
            titleLabel.text = NSLocalizedString(@"库存", nil);
            titleLabel.font = FONT(15);
            titleLabel.textColor = HEX(@"333333", 1.0f);
            [cell addSubview:titleLabel];
            if (!_kuCunNumF) {
                _kuCunNumF = [[UITextField alloc] initWithFrame:FRAME(80, 5, WIDTH/2 - 70, 34)];
                _kuCunNumF.textColor = THEME_COLOR;
                _kuCunNumF.font = FONT(15);
                _kuCunNumF.keyboardType = UIKeyboardTypeNumberPad;
                _kuCunNumF.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
                _kuCunNumF.textAlignment = NSTextAlignmentCenter;
            }
            if (self.isRevise) {
                _kuCunNumF.text = detailModel.stock_num;
            }
            [cell addSubview:_kuCunNumF];
            return cell;
        }
            break;
        case 2:
        {
            UITableViewCell *cell = [UITableViewCell new];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(10, 0, 70, 44)];
            titleLabel.text = NSLocalizedString(@"排序号", nil);
            titleLabel.font = FONT(15);
            titleLabel.textColor = HEX(@"333333", 1.0f);
            [cell addSubview:titleLabel];
            if (!_sortNumF) {
                _sortNumF = [[UITextField alloc] initWithFrame:FRAME(80, 5, WIDTH - 90, 34)];
                _sortNumF.textColor = THEME_COLOR;
                _sortNumF.font = FONT(15);
                _sortNumF.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
                UIView *leftView = [[UIView alloc] initWithFrame:FRAME(0, 0, 10, 34)];
                _sortNumF.leftViewMode = UITextFieldViewModeAlways;
                _sortNumF.leftView = leftView;
                //添加右侧文字
                UILabel *remidLabel = [[UILabel alloc] initWithFrame:FRAME(0, 0, WIDTH - 170, 34)];
                remidLabel.text = NSLocalizedString(@"提示:数字越小越靠前", nil);
                remidLabel.font = FONT(12);
                remidLabel.textColor = THEME_COLOR;
                remidLabel.backgroundColor = [UIColor whiteColor];
                remidLabel.textAlignment = NSTextAlignmentCenter;
                _sortNumF.rightViewMode = UITextFieldViewModeAlways;
                _sortNumF.rightView = remidLabel;
                _sortNumF.textAlignment = NSTextAlignmentCenter;
                _sortNumF.keyboardType = UIKeyboardTypeNumberPad;
            }
            if (self.isRevise) {
                _sortNumF.text = detailModel.orderby;
            }
            [cell addSubview:_sortNumF];
            return cell;
        }
            break;
        case 3:
        {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:FRAME(0, 0, WIDTH, 44)];
            UILabel *title1 = [[UILabel alloc] initWithFrame:FRAME(10, 0, 60, 44)];
            title1.text = NSLocalizedString(@"团购价", nil);
            title1.textColor = HEX(@"333333", 1.0);
            title1.font = FONT(14);
            [cell addSubview:title1];
            UILabel *title2 = [[UILabel alloc] initWithFrame:FRAME(WIDTH/2+10, 0, 60, 44)];
            title2.text = NSLocalizedString(@"门市价", nil);
            title2.textColor = HEX(@"333333", 1.0);
            title2.font = FONT(14);
            [cell addSubview:title2];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (!_tuanPriceF) {
                _tuanPriceF = ({
                    UITextField * textF = [[UITextField alloc] initWithFrame:FRAME(70, 5, WIDTH/2 - 80, 34)];
                    textF.backgroundColor = [UIColor whiteColor];
                    textF.font = FONT(14);
                    textF.textAlignment = NSTextAlignmentCenter;
                    textF.textColor = THEME_COLOR;
                    UILabel *rightL = [[UILabel alloc] initWithFrame:FRAME(0, 5, 30, 34)];
                    rightL.textColor = HEX(@"666666", 1.0);
                    rightL.text = NSLocalizedString(@"¥", nil);
                    rightL.font = FONT(14);
                    rightL.textAlignment = NSTextAlignmentCenter;
                    rightL.backgroundColor = [UIColor whiteColor];
                    textF.rightViewMode = UITextFieldViewModeAlways;
                    textF.rightView = rightL;
                    textF.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
                    textF;
                });
            }
            if (!_salePriceF) {
                _salePriceF = ({
                    UITextField * textF = [[UITextField alloc] initWithFrame:FRAME(WIDTH/2+70, 5, WIDTH/2 - 70, 34)];
                    textF.backgroundColor = [UIColor whiteColor];
                    textF.font = FONT(14);
                    textF.textAlignment = NSTextAlignmentCenter;
                    textF.textColor = THEME_COLOR;
                    UILabel *rightL = [[UILabel alloc] initWithFrame:FRAME(0, 5, 30, 34)];
                    rightL.textColor = HEX(@"666666", 1.0);
                    rightL.text = NSLocalizedString(@"¥", nil);
                    rightL.font = FONT(14);
                    rightL.textAlignment = NSTextAlignmentCenter;
                    rightL.backgroundColor = [UIColor whiteColor];
                    textF.rightViewMode = UITextFieldViewModeAlways;
                    textF.rightView = rightL;
                    textF.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
                    textF;
                });
            }
            if (self.isRevise) {
                _tuanPriceF.text = detailModel.price;
                _salePriceF.text = detailModel.market_price;
            }
            [cell addSubview:_tuanPriceF];
            [cell addSubview:_salePriceF];
            return cell;
        }
            break;
        case 4:
        {
            if (row == 0) {
                UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:FRAME(0, 0, WIDTH, 44)];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(10, 0, 150, 44)];
                titleLabel.font = FONT(14);
                titleLabel.textColor = [UIColor colorWithHex:@"333333" alpha:1.0];
                titleLabel.text = NSLocalizedString(@"券使用开始时间", nil);
                [cell addSubview:titleLabel];
                if (!_sTimeL) {
                    _sTimeL = ({
                        UILabel *label = [[UILabel alloc] initWithFrame:FRAME(160,0, WIDTH-190,44)];
                        label.font = FONT(14);
                        label.textColor = THEME_COLOR;
                        label.textAlignment = NSTextAlignmentRight;
                        NSDate * date = [NSDate date];
                        NSString * time =  [HZQChangeDateLine ExchangeWithdate:date withString:@"yyyy-MM-dd"];
                        label.text = time;
                        label;
                    });
                }
                if (self.isRevise) {
                    _sTimeL.text = detailModel.stime;
                }
                [cell addSubview:_sTimeL];
                return cell;
            }else{
                UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:FRAME(0, 0, WIDTH, 44)];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(10, 0, 150, 44)];
                titleLabel.font = FONT(14);
                titleLabel.textColor = [UIColor colorWithHex:@"333333" alpha:1.0];
                titleLabel.text = NSLocalizedString(@"券使用截止时间", nil);
                [cell addSubview:titleLabel];
                if (!_lTimeL) {
                    _lTimeL = ({
                        UILabel *label = [[UILabel alloc] initWithFrame:FRAME(160,0, WIDTH-190,44)];
                        label.font = FONT(14);
                        label.textColor = THEME_COLOR;
                        label.textAlignment = NSTextAlignmentRight;
                        NSDate * date = [NSDate date];
                        NSInteger dateLine = [date timeIntervalSince1970];
                        NSString * time = [HZQChangeDateLine ExchangeWithDateline:@(dateLine+3600*24*30).stringValue];
                        label.text = time;
                        label;
                    });
                }
                if (self.isRevise) {
                    _lTimeL.text = detailModel.ltime;
                }
                [cell addSubview:_lTimeL];
                return cell;
            }
        }
            break;
        default:
        {
            if (row == 0) {
                UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:FRAME(0, 0, WIDTH, 44)];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(10, 0, 150, 44)];
                titleLabel.font = FONT(14);
                titleLabel.textColor = [UIColor colorWithHex:@"333333" alpha:1.0];
                titleLabel.text = NSLocalizedString(@"使用规则描述", nil);
                [cell addSubview:titleLabel];
                if (!_ruleL) {
                    _ruleL = ({
                        UILabel *label = [[UILabel alloc] initWithFrame:FRAME(160,0, WIDTH-190,44)];
                        label.font = FONT(14);
                        label.textColor = THEME_COLOR;
                        label.textAlignment = NSTextAlignmentRight;
                        label;
                    });
                }
                if (self.isRevise || [_ruleL.text isEqualToString:NSLocalizedString(@"去修改", nil)]) {
                    _ruleL.text =  NSLocalizedString(@"去修改", nil);
                }else{
                    _ruleL.text = NSLocalizedString(@"去完善", nil);
                }
                [cell addSubview:_ruleL];
                return cell;
            }else{
                UITableViewCell * cell = [[UITableViewCell alloc] initWithFrame:FRAME(0, 0, WIDTH, 44)];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(10, 0, 150, 44)];
                titleLabel.font = FONT(14);
                titleLabel.textColor = [UIColor colorWithHex:@"333333" alpha:1.0];
                titleLabel.text = NSLocalizedString(@"商品图文描述", nil);
                [cell addSubview:titleLabel];
                if (!_picL) {
                    _picL = ({
                        UILabel *label = [[UILabel alloc] initWithFrame:FRAME(160,0, WIDTH-190,44)];
                        label.font = FONT(14);
                        label.textColor = THEME_COLOR;
                        label.textAlignment = NSTextAlignmentRight;
                        label;
                    });
                }
                if (self.isRevise || [_picL.text isEqualToString:NSLocalizedString(@"去修改", nil)]) {
                    _picL.text = NSLocalizedString(@"去修改", nil);
                }else{
                    _picL.text = NSLocalizedString(@"去完善", nil);
                }
                [cell addSubview:_picL];
                return cell;
            }
        }
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 4 && row == 0) {
        NSLog(@"券使用开始时间");
        HZQDatePicker * datePicker = [[HZQDatePicker alloc]init];
        [datePicker setMyBlock:^(NSString * time) {
            if ([time compare:_lTimeL.text] == -1) {
                _sTimeL.text = time;
            }else{
                [JHShowAlert showAlertWithMsg:NSLocalizedString(@"券开始时间请小于截止时间", nil)];
            }
        }];
        [datePicker creatDatePickerWithObj:datePicker withDate:[HZQChangeDateLine ExchangeWithTimeString:_sTimeL.text]];
        }else if (section == 4 && row == 1){
            HZQDatePicker * datePicker = [[HZQDatePicker alloc]init];
            [datePicker setMyBlock:^(NSString * time) {
                if ([time compare:_sTimeL.text] == 1 || [time compare:_sTimeL.text] == 0 ) {
                    _lTimeL.text = time;
                }else{
                    [JHShowAlert showAlertWithMsg:NSLocalizedString(@"券截止时间请大于或等于开始时间", nil)];
                }
            }];
            [datePicker creatDatePickerWithObj:datePicker withDate:[HZQChangeDateLine ExchangeWithTimeString:_lTimeL.text]];
            
    }else if (section == 5 && row == 0){
        JhTuanGouProductRuleVC * vc = [[JhTuanGouProductRuleVC alloc] init];
        vc.notice = ruleString;
        vc.block = ^(NSString * result){
            ruleString = result;
            _ruleL.text = NSLocalizedString(@"去修改", nil);
        };
        [self.navigationController pushViewController:vc animated:YES];
    }else if (section == 5 && row == 1){
//        //图文
//        RichTextViewController * vc = [RichTextViewController ViewController];
//        vc.RTDelegate = self;
//        vc.feedbackHtml = self;
//        if (self.isRevise) {
//             vc.htmlString = detailModel.detail;
//        }else{
//            vc.htmlString = htmlString;
//        }
//        [vc setContent:[NSArray arrayWithJSON:jsonString]];
////        __weak typeof(self) weakSelf=self;
////        vc.finished = ^(NSArray * content,NSArray * imageArr){
////            //[weakSelf uploadData:content withImageArray:imageArr];
////            
////            [weakSelf.navigationController popViewControllerAnimated:YES];
////        };
//        [self.navigationController pushViewController:vc animated:YES];
        //跳转网页添加活动介绍
        JHTuanProductDescVC *desc = [[JHTuanProductDescVC alloc] init];
        desc.htmlStr = htmlString;
        [desc setActivityInfoBlock:^(NSString *htmlStr) {
            htmlString = htmlStr;
        }];
        [self.navigationController pushViewController:desc animated:YES];
    }
}
#pragma mark - 这是选择种类的方法
-(void)clickBtn:(JHTuanTypeBtn *)sender{
    oldbtn.selected = NO;
    sender.selected = !sender.selected;
    oldbtn = sender;
    if (sender.tag == 0) {
        tuan_type = @"tuan";
    }else{
        tuan_type = @"quan";
    }
}
#pragma mark RichTextViewControllerDelegate
-(void)uploadImageArray:(NSArray *)imageArr withCompletion:(NSString * (^)(NSArray * urlArray))completion;
{
    NSLog(@"%@",imageArr);
    _picL.text = NSLocalizedString(@"去修改", nil);
    //上传图片
    //把图片地址传入
    NSMutableArray * urlArr=[NSMutableArray array];
    //模拟图片上传，返回每个图片的地址和大小
    if (imageArr.count == 0) {
        //获取到网页
        NSString * htmlStr = completion(urlArr);
        htmlString = htmlStr;
        NSLog(@"htmlStr--%@",htmlStr);
        return;
    }
    for (int i=0; i<imageArr.count; i++) {
        UIImage * newImage = [HZQChangeImageSize scaleFromImage:imageArr[i] scaledToSize:CGSizeMake(500, 500)];
        NSData * data = UIImagePNGRepresentation(newImage);
        [HttpTool postWithAPI:@"biz/photo/upload" params:@{} dataDic:@{@"photo":data} success:^(id json) {
            NSLog(@"json>>>%@",json);
            PictureModel * model=[[PictureModel alloc]init];
            model.imageurl=[NSString stringWithFormat:@"%@%@",IMAGEADDRESS,json[@"data"][@"photo"]];
            [urlArr addObject:model];
            if (i == imageArr.count - 1) {
                //获取到网页
                NSString * htmlStr = completion(urlArr);
                htmlString = htmlStr;
                NSLog(@"htmlStr--%@",htmlStr);
            }
        } failure:^(NSError *error) {
            NSLog(@"error>>>%@",error.localizedDescription);
        }];
        
    }
}
#pragma mark - 这是点击选择照片的方法
-(void)clickToChoseImage:(UITapGestureRecognizer *)sender{
    NSLog(@"这是点击添加照片");
    [self.view endEditing:YES];
    if (image_chose == nil) {
        //点击选择图片
        [self creatButtomChoseWithAlertCountrol];
    }else{
        //点击删除或者查看图片原图
        [self creatButtomTocherkOrRemoveImage];
    }
}
#pragma mark - 点击完成按钮
- (void)clickRightBtn:(UIButton *)sender
{
    NSLog(@"点击了完成按钮");
    if (!image_chose) {
        [JHShowAlert showAlertWithMsg:NSLocalizedString(@"请添加商品的图片", nil)];
        return;
    }
    if (_tuanNameF.text.length == 0 || _minNumF.text.length == 0 || _maxNumF.text.length == 0  || _sortNumF.text.length == 0 || _tuanPriceF.text.length == 0 || _salePriceF.text.length == 0 || _sTimeL.text.length == 0 || _lTimeL.text.length == 0 || !ruleString
        //|| !htmlString || _descTextField.text.length == 0
        ) {
        [JHShowAlert showAlertWithMsg:NSLocalizedString(@"请将信息补充完整", nil)];
        return;
    }
    NSMutableDictionary * dic = @{}.mutableCopy;
    if (self.isRevise) {
        [dic addEntriesFromDictionary:@{@"tuan_id":self.tuan_id}];
    }
    [dic addEntriesFromDictionary:@{@"title":_tuanNameF.text,
                                    @"min_buy":_minNumF.text,
                                    @"max_buy":_maxNumF.text,
                                    @"stock_type":@(num).stringValue,
                                    @"stock_num":_kuCunNumF.text,
                                    @"orderby":_sortNumF.text,
                                    @"price":_tuanPriceF.text,
                                    @"market_price":_salePriceF.text,
                                    @"stime":@([HZQChangeDateLine ExchangeWithTime:_sTimeL.text]).stringValue,
                                    @"ltime":@([HZQChangeDateLine ExchangeWithTime:_lTimeL.text]).stringValue,
                                    @"notice":ruleString,
                                    @"detail":htmlString?htmlString:@"",
                                    @"is_onsale":@(isShelf),
                                    @"type":tuan_type,
                                    @"desc":_descTextField.text?_descTextField.text:@""}];

    SHOW_HUD
    NSString * api = nil;
    if (self.isRevise) {
        api = @"biz/tuan/tuan/update";
    }else{
        api = @"biz/tuan/tuan/create";
    }
    [HttpTool postWithAPI:api params:dic dataDic:@{@"photo":data_image} success:^(id json) {
        NSLog(@"json----->%@",json);
        if ([json[@"error"] isEqualToString:@"0"]) {
            if ([[JHShareModel shareModel].infoDictionary[@"have_tuan"] isEqualToString:@"0"]) {
                [JHShowAlert showAlertWithMsg:NSLocalizedString(@"您还未开启团购,请去开启团购功能,否则将不予显示您的团购设置", nil) withBtnTitle:NSLocalizedString(@"知道了", nil) withBtnBlock:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }else{
               [self.navigationController popViewControllerAnimated:YES];
            }
        }else{
            [JHShowAlert showAlertWithMsg:json[@"message"]];
        }
        HIDE_HUD
    } failure:^(NSError *error) {
        HIDE_HUD
        [JHShowAlert showAlertWithMsg:NSLocalizedString(@"服务器繁忙,请稍后访问", nil)];
        NSLog(@"%@",error.localizedDescription);
    }];
}
//-----IQKeyBoard----
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([IQKeyboardManager sharedManager].enable) {
        
    }else{
        [self.view endEditing:YES];
    }
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [IQKeyboardManager sharedManager].enable = NO;
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [IQKeyboardManager sharedManager].enable = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - 这是创建底部的选择照片和拍照的方法
-(void)creatButtomChoseWithAlertCountrol{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //创建图片选择控制
    UIImagePickerController * imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    //添加button
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"拍照", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //处理点击拍照
        NSLog(@"点击了拍照");
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"从相册选取", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //处理点击从相册选取
        NSLog(@"点击了相册选照片");
        imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark - 这是UIImagePickerController的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo{
    NSLog(@"哈哈");
}
//选择某张图片的时候调用
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    if (picker.allowsEditing) {
        image_chose = [info objectForKey:UIImagePickerControllerEditedImage];
    }else{
        image_chose = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    UIImage * newImage = [HZQChangeImageSize scaleFromImage:image_chose scaledToSize:CGSizeMake(500, 500)];
    data_image = UIImagePNGRepresentation(newImage);
    imageView_add.image = image_chose;
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//点击取消的时候调用
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 这是已经选择了图片之后点击图片出现删除或者查看原图的按钮
-(void)creatButtomTocherkOrRemoveImage{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"查看原图", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //查看原图
        [self creatImageMengBan];
        //}];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"删除图片", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //删除图片
        imageView_add.image = [UIImage imageNamed:@"Delivery_pic_add"];
        image_chose = nil;
        data_image = nil;
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //取消
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}
//创建一层蒙版和imageview
-(void)creatImageMengBan{
    if (myView == nil) {
        myView = [[UIView alloc]init];
        myView.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
        myView.backgroundColor = [UIColor blackColor];
        UIWindow * window = [UIApplication sharedApplication].delegate.window;
        [window addSubview:myView];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeImage)];
        [myView addGestureRecognizer:tap];
        UIImageView * imageView = [[UIImageView alloc]init];
        imageView.bounds = CGRectMake(0, 0, WIDTH, HEIGHT/2);
        imageView.center = myView.center;
        imageView.image = image_chose;
        //缩放手势
        UIPinchGestureRecognizer * pinchGesture = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handlePinch:)];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:pinchGesture];
        //旋转手势
        UIRotationGestureRecognizer * panGesture = [[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)];
        [imageView addGestureRecognizer:panGesture];
        [myView addSubview:imageView];
    }
}
-(void)removeImage{
    [myView removeFromSuperview];
     myView = nil;
}
//缩放手势调用的方法
-(void)handlePinch:(UIPinchGestureRecognizer *)recognizer{
    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
    recognizer.scale = 1;
}
//旋转手势
- (void) handlePan:(UIRotationGestureRecognizer*) recognizer
{
    recognizer.view.transform = CGAffineTransformRotate(recognizer.view.transform, recognizer.rotation);
    recognizer.rotation = 0;
}
@end
