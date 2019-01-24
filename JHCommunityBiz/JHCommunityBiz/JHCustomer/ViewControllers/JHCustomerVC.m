//
//  JHCustomerVC.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/17.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHCustomerVC.h"
#import <MessageUI/MessageUI.h>
#import "JHCustomerDerailCellOne.h"
#import "JHCustomerDetailCellTwo.h"
#import "JHCustomerDetailModel.h"
#import "JHCustomerDetailNoneCell.h"
#import <MJRefresh.h>
#import <UIImageView+WebCache.h>
#import "DSToast.h"
@interface JHCustomerVC ()<MFMessageComposeViewControllerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UIImageView * imageV_header;//头像
    UILabel * label_name;//姓名
    UILabel * label_mobile;//电话号码
    UIButton * btn_phone;//点击打电话的按钮
    UILabel * label_orderNum;//显示订单数的
    UILabel * label_money;//显示消费金额的
    UITableView * myTableView;//创建表视图
    MJRefreshNormalHeader * _header;//这是下拉刷新的
//    MJRefreshAutoNormalFooter * _footer;//这是上拉加载的
    BOOL isYes;//模拟用的
    NSInteger num;
    NSMutableArray * infoArray;
    NSString * mobile;
    DSToast * toast;
    UILabel * label_fans;
}
@end
@implementation JHCustomerVC
- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化一些数据
    [self initData];
    //创建白色区域
    [self creatWhiteArea];
    //创建第二块浅蓝色区域
    [self creatBlueArea];
    //创建表示图
    [self creatUITableView];
    //发送请求
    SHOW_HUD
    [self postHttpWithPage:@(num).stringValue];
}
#pragma mark - 这是发送请求的方法
-(void)postHttpWithPage:(NSString *)page{
    [HttpTool postWithAPI:@"biz/member/detail" withParams:@{@"uid":self.uid,@"page":page} success:^(id json) {
        NSLog(@"%@",json);
        if ([json[@"error"] isEqualToString:@"0"]) {
            if (page.integerValue == 1) {
                [infoArray removeAllObjects];
            }
            NSArray * tempArray = json[@"data"][@"items"];
            for (NSDictionary * dic in tempArray) {
                JHCustomerDetailModel * model = [JHCustomerDetailModel showJHCustomerDetailModelWithDictionary:dic];
                [infoArray addObject:model];
            }
            if(infoArray.count > 0){
                isYes = NO;
            }else{
                isYes = YES;
            }
            [imageV_header sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",IMAGEADDRESS,json[@"data"][@"custom"][@"face"]]] placeholderImage:[UIImage imageNamed:@"client_Photos"]];
            label_name.text = json[@"data"][@"custom"][@"nickname"];
            float length = [json[@"data"][@"custom"][@"nickname"] boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.width;
            label_name.frame = FRAME(60, 20, length, 20);
            label_fans.frame = FRAME(65+length, 20, 40, 20);
            label_mobile.text = json[@"data"][@"custom"][@"mobile"];
            mobile = json[@"data"][@"custom"][@"mobile"];
            label_orderNum.text = [NSString stringWithFormat:@"%@\n%@",json[@"data"][@"custom"][@"total_order"],NSLocalizedString(@"本店订单数", nil)];
            label_money.text = [NSString stringWithFormat:@"%@%@\n%@",@"¥",json[@"data"][@"custom"][@"total_amount"],NSLocalizedString(@"本店消费金额", nil)];
            [myTableView reloadData];
            if (toast == nil && tempArray.count == 0 && [page integerValue] > 1) {
                toast = [[DSToast alloc]initWithText:NSLocalizedString(@"亲,没有更多数据了", nil)];
                [toast showInView:self.view  showType:DSToastShowTypeCenter withBlock:^{
                    toast = nil;
                }];
            }

        }else{
            [JHShowAlert showAlertWithMsg:json[@"message"]];
        }
        HIDE_HUD
        [_header endRefreshing];
        //[_footer endRefreshing];

    } failure:^(NSError *error) {
        HIDE_HUD
        [_header endRefreshing];
        //[_footer endRefreshing];
        [JHShowAlert showAlertWithMsg:NSLocalizedString(@"服务器繁忙,请稍后访问", nil)];
        NSLog(@"%@",error.localizedDescription);
 
    }];
}
#pragma mark -初始化一些数据
-(void)initData{
    num = 1;
    infoArray = @[].mutableCopy;
    self.navigationItem.title = NSLocalizedString(@"客户详情", nil);
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //创建导航上的右边的调短信的按钮
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"client_news"] style:UIBarButtonItemStylePlain target:self action:@selector(clickToSendMessage)];
    self.navigationItem.rightBarButtonItem = rightItem;
}
#pragma mark - 这是创建白色区域
-(void)creatWhiteArea{
    UIView * view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    view.frame = FRAME(0, 0, WIDTH, 80);
    [self.view addSubview:view];
    //创建头像
    imageV_header = [[UIImageView alloc]init];
    imageV_header.frame = FRAME(10, 20, 40, 40);
    imageV_header.backgroundColor = THEME_COLOR;
    imageV_header.layer.cornerRadius = 20;
    imageV_header.layer.masksToBounds = YES;
    [view addSubview:imageV_header];
    //创建显示姓名的label
    label_name = [[UILabel alloc]init];
    label_name.frame = FRAME(60, 20, 100, 20);
    label_name.textColor = THEME_COLOR;
    label_name.font = [UIFont systemFontOfSize:15];
    [view addSubview:label_name];
    //显示粉丝的标签
    if (self.isFans) {
        label_fans = [[UILabel alloc]init];
        label_fans.frame = FRAME(95, 20, 40, 20);
        label_fans.textAlignment = NSTextAlignmentCenter;
        label_fans.text = NSLocalizedString(@"粉丝", nil);
        label_fans.textColor = [UIColor whiteColor];
        label_fans.font = [UIFont systemFontOfSize:14];
        label_fans.layer.cornerRadius = 3;
        label_fans.layer.masksToBounds = YES;
        label_fans.backgroundColor = [UIColor colorWithRed:251/255.0 green:58/255.0 blue:128/255.0 alpha:1];
        [view addSubview:label_fans];

    }
    //显示电话号码的label
    label_mobile = [[UILabel alloc]init];
    label_mobile.frame = FRAME(60, 45, 150, 20);
    label_mobile.font = [UIFont systemFontOfSize:15];
    label_mobile.textColor = THEME_COLOR;
    [view addSubview:label_mobile];
    //点击打电话的按钮
    btn_phone = [[UIButton alloc]init];
    btn_phone.frame = FRAME(WIDTH - 60, 15, 50, 50);
    [btn_phone setImage:[UIImage imageNamed:@"client_phone"] forState:UIControlStateNormal];
    [btn_phone addTarget:self action:@selector(clickToCall:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn_phone];
    //底部的分割线
    UIView * label = [[UIView alloc]init];
    label.backgroundColor = THEME_COLOR;
    label.frame = FRAME(0, 79.5, WIDTH, 0.5);
    [view addSubview:label];
}
#pragma mark - 创建第二块浅蓝色区
-(void)creatBlueArea{
    UIView * view = [[UIView alloc]init];
    view.frame = FRAME(0, 80, WIDTH, 80);
    view.backgroundColor = [UIColor colorWithRed:221/255.0 green:224/255.0 blue:244/255.0 alpha:1];
    [self.view addSubview:view];
    //中间的分割线
    UIView * label = [[UIView alloc]init];
    label.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1];
    label.frame = FRAME(WIDTH/2 - 0.5, 5, 1, 70);
    [view addSubview:label];
    //底部的分割线
    UIView * label_line = [[UIView alloc]init];
    label_line.frame = FRAME(0, 79.5, WIDTH, 0.5);
    label_line.backgroundColor = THEME_COLOR;
    [view addSubview:label_line];
    //创建显示订单数的
    label_orderNum = [[UILabel alloc]init];
    label_orderNum.frame = FRAME(1, 5, WIDTH/2- 2, 70);
    label_orderNum.textColor = THEME_COLOR;
    label_orderNum.font = [UIFont systemFontOfSize:18];
    label_orderNum.textAlignment = NSTextAlignmentCenter;
    label_orderNum.numberOfLines = 0;
    [view addSubview:label_orderNum];
    //创建显示消费金额的
    label_money = [[UILabel alloc]init];
    label_money.frame = FRAME(WIDTH/2 + 1, 5,WIDTH/2- 2, 70);
    label_money.textColor = THEME_COLOR;
    label_money.font = [UIFont systemFontOfSize:18];
    label_money.textAlignment = NSTextAlignmentCenter;
    label_money.numberOfLines = 0;
    [view addSubview:label_money];

}
#pragma mark - 创建表视图
-(void)creatUITableView{
    myTableView = [[UITableView alloc]init];
    myTableView.frame = FRAME(0, 160, WIDTH, HEIGHT - 224);
    myTableView.showsVerticalScrollIndicator = NO;
    myTableView.tableFooterView = [UIView new];
    myTableView.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [myTableView registerClass:[JHCustomerDerailCellOne class] forCellReuseIdentifier:@"cell1"];
    [myTableView registerClass:[JHCustomerDetailCellTwo class] forCellReuseIdentifier:@"cell2"];
    [myTableView registerClass:[JHCustomerDetailNoneCell class] forCellReuseIdentifier:@"cell3"];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    [self.view addSubview:myTableView];
    _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(downRefresh)];
    _header.stateLabel.textColor = [UIColor colorWithRed:129/255.0 green:129/255.0 blue:129/255.0 alpha:1];
    _header.lastUpdatedTimeLabel.hidden = YES;
    [_header setTitle:NSLocalizedString(@"下拉可以刷新", nil) forState:MJRefreshStateIdle];
    [_header setTitle:NSLocalizedString(@"现在可以刷新啦", nil) forState:MJRefreshStatePulling];
    [_header setTitle:NSLocalizedString(@"正在为您努力刷新中", nil) forState:MJRefreshStateRefreshing];
    myTableView.mj_header = _header;
//    _footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(upLoadData)];
//    [_footer setTitle:@"" forState:MJRefreshStateIdle];
//    [_footer setTitle:NSLocalizedString(@"正在加载更多的数据...", nil) forState:MJRefreshStateRefreshing];
//    myTableView.mj_footer = _footer;
}
#pragma mark - 这是下拉刷新的方法
-(void)downRefresh{
    num = 1;
   
    [self postHttpWithPage:@(num).stringValue];
}
#pragma mark - 这是上拉加载的方法
-(void)upLoadData{
    num ++;
    [self postHttpWithPage:@(num).stringValue];
}

#pragma mark - 这是UITableView的代理和数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!isYes) {
        return infoArray.count + 1;
    }else{
        return 1;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!isYes) {
        if (indexPath.row == 0) {
            return 35;
        }else{
            return 60;
        }

    }else{
        return HEIGHT - 104;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!isYes) {
        if (indexPath.row == 0) {
            JHCustomerDerailCellOne * cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
            cell.num = infoArray.count;
            return cell;
        }else{
            JHCustomerDetailCellTwo * cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
            cell.indexPath = indexPath;
            if (infoArray.count > 0) {
                JHCustomerDetailModel * model = infoArray[indexPath.row - 1];
                cell.model = model;
            }
            return cell;
        }
 
    }else{
        JHCustomerDetailNoneCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell3" forIndexPath:indexPath];
        return cell;
    }
}
#pragma mark - 这是点击按钮进行打电话的方法
-(void)clickToCall:(UIButton *)sender{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:mobile preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",mobile]]];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark 这是点击导航右边的按钮的方法
-(void)clickToSendMessage{
    //[self showMessageView:@[mobile] title:NSLocalizedString(@"发送短信", nil) body:@""];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms:%@",mobile]]];
}
//应用内发送信息的方法
-(void)showMessageView:(NSArray *)phones title:(NSString *)title body:(NSString *)body{
    if ([MFMessageComposeViewController canSendText])
    {
        MFMessageComposeViewController * msgController = [[MFMessageComposeViewController alloc]init];
        msgController.messageComposeDelegate = self;
        msgController.recipients = phones;
        msgController.navigationBar.barTintColor = THEME_COLOR;
        msgController.navigationBar.tintColor = [UIColor whiteColor];
        msgController.body = body;
        [[[[msgController viewControllers] lastObject] navigationItem] setTitle:title];//修改短信界面标题
        [self presentViewController:msgController animated:YES completion:nil];
    }else{
        [JHShowAlert showAlertWithMsg:NSLocalizedString(@"该设备不支持短信功能", nil)];
    }
}
#pragma mark - MFMessageComposeViewController这是
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    
    switch (result) {
        case MessageComposeResultSent:
            //信息传送成功
            break;
        case MessageComposeResultFailed:
            //信息传送失败
            break;
        case MessageComposeResultCancelled:
            //信息被用户取消传送
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
