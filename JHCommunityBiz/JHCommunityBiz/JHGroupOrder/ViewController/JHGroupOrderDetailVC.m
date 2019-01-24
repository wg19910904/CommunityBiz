//
//  JHGroupOrderDetailVC.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/30.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHGroupOrderDetailVC.h"
#import "JHGroupScanControl.h"
#import "JHGroupOrderDetailCellOne.h"
#import "JHGroupOrderDetailCellTwo.h"
#import "JHGroupOrderDetailCellThree.h"
#import "JHGroupDetailModel.h"
#import <MJRefresh.h>
#import "JHGroupOrderEvaluateCell.h"
#import "JHGroupOrderDetailCellFour.h"
#import "JHGroupOrderDetailCellFive.h"
#import "JHShopReplyVC.h"
#import "JHTrueToConsumeVC.h"
@implementation JHGroupOrderDetailVC
{
    UITableView * myTableView;
    MJRefreshNormalHeader * _header;
    float height_evaluate;
    float height_reply;
    JHGroupDetailModel * detailModel;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    //这是初始化一些数据方法
    [self initData];
    //创建验证的按钮
    if (self.type == 0 ||self.type == 2 ||self.type == 1 ) {
        [self creatUIButton];
    }
    //发送请求的方法
    SHOW_HUD
    [self postHttp];
}
#pragma mark - 这是请求数据的方法
-(void)postHttp{
    [HttpTool postWithAPI:@"biz/tuan/order/detail" withParams:@{@"order_id":self.order_id} success:^(id json) {
        NSLog(@"%@",json);
        if ([json[@"error"] isEqualToString:@"0"]) {
            detailModel = [JHGroupDetailModel creatJHGroupDetailModelWithDictioanaryWithDic:json[@"data"]];
            //这是创建表格的方法
            [self creatUITableView];
        }else{
            [JHShowAlert showAlertWithMsg:json[@"message"]];
        }
        HIDE_HUD
        [_header endRefreshing];
    } failure:^(NSError *error) {
        HIDE_HUD
        [_header endRefreshing];
        [JHShowAlert showAlertWithMsg: NSLocalizedString(@"服务器繁忙,请稍后访问", NSStringFromClass([self class]))];
        NSLog(@"%@",error.localizedDescription);
    }];
}
#pragma mark - 这是初始化一些数据的方法
-(void)initData{
    self.navigationItem.title = NSLocalizedString(@"订单详情", NSStringFromClass([self class]));
    self.view.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
}
#pragma mark - 创建底部验证的按钮
-(void)creatUIButton{
    UIButton * btn = [[UIButton alloc]init];
    btn.frame = FRAME(0, HEIGHT - 64 - 50, WIDTH, 50);
    if (self.type == 0 ) {
       [btn setTitle: NSLocalizedString(@"验证", NSStringFromClass([self class])) forState:UIControlStateNormal];
         btn.backgroundColor = [UIColor colorWithRed:250/255.0 green:175/255.0 blue:25/255.0 alpha:1];
    }else if(self.type == 2 ){
       [btn setTitle: NSLocalizedString(@"回复", NSStringFromClass([self class])) forState:UIControlStateNormal];
         btn.backgroundColor = [UIColor colorWithRed:250/255.0 green:175/255.0 blue:25/255.0 alpha:1];
    }else{
        [btn setTitle: NSLocalizedString(@"等待评价", NSStringFromClass([self class])) forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor colorWithWhite:0.6 alpha:1];
    }
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(clickToVerification:) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark - 这是验证按钮的方法
-(void)clickToVerification:(UIButton *)sender{
    if ([sender.titleLabel.text isEqualToString: NSLocalizedString(@"验证", NSStringFromClass([self class]))]) {
        [JHGroupScanControl showJHGroupScanControlWithNav:self.navigationController withBlock:^(NSDictionary *dic) {
            //点击的确定并且在密码正确的情况下才会调用
            JHTrueToConsumeVC * vc = [[JHTrueToConsumeVC alloc]init];
            vc.dictionary = dic;
            [self.navigationController pushViewController:vc animated:YES];
        } withSweepBlock:^(NSDictionary *dic) {
            JHTrueToConsumeVC * vc = [[JHTrueToConsumeVC alloc]init];
            vc.dictionary = dic;
            [self.navigationController pushViewController:vc animated:YES];
        }];
 
    }else if ([sender.titleLabel.text isEqualToString: NSLocalizedString(@"回复", NSStringFromClass([self class]))]){
        NSLog(@"点击了回复");
        JHShopReplyVC * vc = [[JHShopReplyVC alloc]init];
        vc.headUrl = detailModel.face;
        vc.name = detailModel.contact;
        vc.score = detailModel.score;
        vc.evaluate  = detailModel.content;
        vc.dateline = detailModel.evaluate_time;
        vc.photoArray = detailModel.photoArray;
        vc.comment_id = detailModel.comment_id;
        vc.isFromOrderDetail = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        
    }
}
#pragma mark - 这是创建表格的方法
-(void)creatUITableView{
    if (myTableView == nil) {
    if (self.type == 0 ||self.type == 2 ||self.type == 1) {
         myTableView = [[UITableView alloc]initWithFrame:FRAME(0, 0, WIDTH, HEIGHT - 64 - 50) style:UITableViewStyleGrouped];
    }else{
         myTableView = [[UITableView alloc]initWithFrame:FRAME(0, 0, WIDTH, HEIGHT - 64) style:UITableViewStyleGrouped];
    }
        myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        myTableView.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
        myTableView.showsVerticalScrollIndicator = NO;
        myTableView.tableFooterView = [UIView new];
        myTableView.tableHeaderView = [[UIView alloc]initWithFrame:FRAME(0, 0, WIDTH, 0.01)];
        [self.view addSubview:myTableView];
        [myTableView registerClass:[JHGroupOrderDetailCellOne class] forCellReuseIdentifier:@"cell1"];
        [myTableView registerClass:[JHGroupOrderDetailCellTwo class] forCellReuseIdentifier:@"cell2"];
        [myTableView registerClass:[JHGroupOrderDetailCellThree class] forCellReuseIdentifier:@"cell3"];
        [myTableView registerClass:[JHGroupOrderDetailCellFour class] forCellReuseIdentifier:@"cell4"];
        [myTableView registerClass:[JHGroupOrderDetailCellFive class] forCellReuseIdentifier:@"cell5"];
        [myTableView registerClass:[JHGroupOrderEvaluateCell class] forCellReuseIdentifier:@"cell6"];
        _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(downRefresh)];
        _header.lastUpdatedTimeLabel.hidden = YES;
        [_header setTitle: NSLocalizedString(@"下拉可以刷新", NSStringFromClass([self class])) forState:MJRefreshStateIdle];
        [_header setTitle: NSLocalizedString(@"现在可以刷新啦", NSStringFromClass([self class])) forState:MJRefreshStatePulling];
        [_header setTitle: NSLocalizedString(@"正在为您努力刷新中", NSStringFromClass([self class])) forState:MJRefreshStateRefreshing];
         myTableView.mj_header = _header;
        myTableView.delegate = self;
        myTableView.dataSource = self;
    }else{
        [myTableView reloadData];
    }
}
#pragma mark - 这是下拉刷新的方法
-(void)downRefresh{
    [self postHttp];
}
#pragma mark - 这是表视图的代理和数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section < 2) {
        return 2;
    }else{
        if (self.type == 0 ||self.type == 6 ||self.type == 5 ) {
            return 2;
        }else if(self.type == 2 ||self.type == 3){
            return 4;
        }else{
            return 3;
        }
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.01;
    }
        return 10.00;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0)
            {
                return 40;
            }else{
                return 70;
            }
        }
            break;
         case 1:
        {
            return 40;
        }
            break;
        case 2:
        {
            if(indexPath.row == 0){
               return 70;
            }else if (indexPath.row == 1){
                return 44;
            }else if (indexPath.row == 2&&self.type == 4){
                return 130;
            }else if(indexPath.row == 2 && self.type != 4){
                return 122;
            }else{
                
                CGSize size = [detailModel.content boundingRectWithSize:CGSizeMake(WIDTH - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
                height_evaluate = size.height;
                CGSize size1 = [detailModel.reply boundingRectWithSize:CGSizeMake(WIDTH - 40, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
                height_reply = size1.height;
                if (detailModel.photoArray.count == 0 && self.type == 2) {
                    return 105+height_evaluate;
                }else if(detailModel.photoArray.count > 0 && self.type==2){
                    return 115 + (WIDTH - 50)/4 + height_evaluate;
                }else if (detailModel.photoArray.count == 0 &&self.type == 3){
                    return 105+height_evaluate + 30 + height_reply;
                }else {
                    return 115 + (WIDTH - 50)/4 + height_evaluate + 30 + height_reply;
                }
            }
        }
            break;
        default:
            return 0;
            break;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) {
                JHGroupOrderDetailCellOne * cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
                cell.indexPath = indexPath;
                cell.model = detailModel;
                return cell;
            }else{
                JHGroupOrderDetailCellTwo * cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
                cell.model = detailModel;
                return cell;
            }
            break;
        case 1:
        {
            JHGroupOrderDetailCellOne * cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
            cell.indexPath = indexPath;
            cell.model = detailModel;
            return cell;
        }
            break;
        case 2:
        {
            if (indexPath.row == 0) {
                JHGroupOrderDetailCellThree * cell = [tableView dequeueReusableCellWithIdentifier:@"cell3" forIndexPath:indexPath];
                cell.model = detailModel;
                return cell;
            }else if (indexPath.row == 1) {
                UITableViewCell *cell = [[UITableViewCell alloc] init];
                
                UIView *lineView=[UIView new];
                [cell.contentView addSubview:lineView];
                [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.offset=0;
                    make.top.offset=0;
                    make.right.offset=0;
                    make.height.offset=0.5;
                }];
                lineView.backgroundColor=LINE_COLOR;
                
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(10, 13, 80, 12)];
                titleLabel.font = FONT(12);
                titleLabel.textColor = HEX(@"666666", 1.0f);
                titleLabel.text =  NSLocalizedString(@"红包抵扣", NSStringFromClass([self class]));
                [cell.contentView addSubview:titleLabel];
                
                UILabel *amountLab = [UILabel new];
                [cell.contentView addSubview:amountLab];
                [amountLab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.offset=-10;
                    make.centerY.offset=0;
                    make.height.offset=20;
                }];
                amountLab.font = FONT(12);
                amountLab.textColor = HEX(@"f85357", 1.0f);
                amountLab.textAlignment = NSTextAlignmentRight;
                if ([detailModel.hongbao floatValue] != 0) {
                    amountLab.text = [NSString stringWithFormat: NSLocalizedString(@"-¥%@", NSStringFromClass([self class])),detailModel.hongbao];
                }else{
                    amountLab.text =  NSLocalizedString(@"未使用红包", NSStringFromClass([self class]));
                }
                return cell;
            }else if (indexPath.row == 2&& self.type == 4 ){
                JHGroupOrderDetailCellFour * cell = [tableView dequeueReusableCellWithIdentifier:@"cell4" forIndexPath:indexPath];
                cell.model = detailModel;
                return cell;
            }else if (indexPath.row == 2 && self.type != 4){
                JHGroupOrderDetailCellFive * cell = [tableView dequeueReusableCellWithIdentifier:@"cell5" forIndexPath:indexPath];
                cell.model = detailModel;
                return cell;
            }else{
                JHGroupOrderEvaluateCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell6" forIndexPath:indexPath];
                cell.height_evaluate = height_evaluate;
                cell.height_reply = height_reply;
                JHGroupDetailModel * model = detailModel;
                //model.type = self.type;
                //model.isPhoto = YES;
                cell.model = model;
                return cell;
            }
        }
            break;
        default:
            return nil;
            break;
    }
}
#pragma mark - 这是弹出警告框的方法
-(void)creatUIAlertViewControllerWithMessage:(NSString *)msg withCancelBtn:(NSString *)cancelBtn withTrueBtn:(NSString *)trueBtn{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle: NSLocalizedString(@"温馨提示", NSStringFromClass([self class])) message:msg preferredStyle:UIAlertControllerStyleAlert];
    if (cancelBtn) {
        [alert addAction:[UIAlertAction actionWithTitle:cancelBtn style:UIAlertActionStyleCancel handler:nil]];
    }
    if (trueBtn) {
        [alert addAction:[UIAlertAction actionWithTitle:trueBtn style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
    }
    [self presentViewController:alert animated:YES completion:nil];
}
@end
