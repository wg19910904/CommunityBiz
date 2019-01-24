//
//  DeliveryReplyVC.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/7/18.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "DeliveryReplyVC.h"
#import "DeliveryReplyCell.h"
#import <IQKeyboardManager.h>
@interface DeliveryReplyVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *mainTV;
@property(nonatomic,copy)NSString *contentStr;
@end

@implementation DeliveryReplyVC
{
    UIButton *bottomBtn;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"回复催单", nil);
    [self.view addSubview:self.mainTV];
    [self addBottomView];
}
#pragma mark - 添加底部按钮
- (void)addBottomView
{
    bottomBtn = [UIButton new];
    [bottomBtn setBackgroundColor:HEX(@"faaf19", 1.0) forState:(UIControlStateNormal)];
    [self.view addSubview:bottomBtn];
    [bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@50);
    }];
    [bottomBtn setTitle:NSLocalizedString(@"确定回复", nil) forState:(UIControlStateNormal)];
    [bottomBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [bottomBtn addTarget:self action:@selector(clickBottomBtn:) forControlEvents:(UIControlEventTouchUpInside)];
}
- (UITableView *)mainTV
{
    _mainTV = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, WIDTH, HEIGHT - 64 - 45)
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
    return _mainTV;
}
#pragma mark - tableView delegate and dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 350;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DeliveryReplyCell *cell = [_mainTV dequeueReusableCellWithIdentifier:@"DeliveryReplyCellID"];
    if (!cell) {
        cell = [[DeliveryReplyCell alloc] initWithStyle:(UITableViewCellStyleDefault)
                                        reuseIdentifier:@"DeliveryReplyCellID"];
        cell.replyRefreshBlock = ^(NSString *text){
            self.contentStr = text;
        };
    }
    return cell;
}
#pragma mark - 点击底部按钮
- (void)clickBottomBtn:(UIButton *)sender
{
    if (!self.contentStr || self.contentStr.length == 0) {
        [JHShowAlert showAlertWithMsg:NSLocalizedString(@"请输入回复内容", nil)];
        return;
    }
    SHOW_HUD
    [HttpTool postWithAPI:@"biz/waimai/order/order/cui_reply"
               withParams:@{@"order_id":self.order_id,
                            @"reply" :self.contentStr}
                  success:^(id json) {
                      HIDE_HUD
                      if (ERROR_0) {
                          [JHShowAlert showAlertWithMsg:NSLocalizedString(@"回复催单成功", nil)
                                           withBtnTitle:NSLocalizedString(@"确认", nil)
                                           withBtnBlock:^{
                                               [self.navigationController popViewControllerAnimated:YES];
                                           }];
                      }else{
                          [JHShowAlert showAlertWithMsg:ERROR_MESSAGE];
                      }
                  }
                  failure:^(NSError *error) {
                      HIDE_HUD
                      [JHShowAlert showAlertWithMsg:NSLocalizedString(@"服务器连接异常", nil)];
                  }];
}
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
    // Dispose of any resources that can be recreated.
}
@end
