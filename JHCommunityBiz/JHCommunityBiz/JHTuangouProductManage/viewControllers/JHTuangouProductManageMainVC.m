//
//  JHTuangouProductManageMainVC.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/31.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHTuangouProductManageMainVC.h"
#import "JHTuangouManageNav.h"
#import "JHTuangouProductManageCell.h"
#import "JHTuangouProductBottimView.h"
#import "JHTuangouProductAllModifyBottomView.h"
#import "JHTuangouProductAllModifyBottomView.h"
#import <MJRefresh.h>
#import "JHTuangouProductManagerModel.h"
#import "JHTuangouSelecterStyleModel.h"
#import "DSToast.h"
#import "JHTuangouManagerCellNone.h"
#import "JHPickerView.h"
#import "HZQChangeDateLine.h"
#import "JHTuanGouProductAddVC.h"
#import "HZQDatePicker.h"
@interface JHTuangouProductManageMainVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *mainTableView;
@property(nonatomic,copy)NSString *sale;
@property(nonatomic,assign)NSInteger selecter;//选中的各种状态
@property(nonatomic,retain)UIButton * rightBtn;//导航栏右侧按钮
@property(nonatomic,retain)MJRefreshNormalHeader * header;//下拉刷新的
@property(nonatomic,retain)MJRefreshAutoNormalFooter * footer;//上拉加载
@property(nonatomic,retain)JHTuangouManageNav * navV;
@property(nonatomic,retain)JHTuangouProductAllModifyBottomView * allModifyBottomView;//点击批量管理时,底部出现的view
@end
@implementation JHTuangouProductManageMainVC
{
    NSInteger selecterNum;
    NSMutableArray * selecterAray;//存放选中的cell的状态
    NSMutableArray * infoArray;//这是存放model类的
    NSInteger currentPage;//当前请求的页数
    DSToast * toast;
    BOOL isYes;
    BOOL isFirst;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if (isFirst) {
        [_header beginRefreshing];
    }
    isFirst = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"团购商品列表", nil);
    infoArray = @[].mutableCopy;
    selecterAray = @[].mutableCopy;
    self.selecter = 1;
    currentPage = 1;
    _sale = @"1";
    //添加导航栏右侧按钮
    [self addRightBtn];
    //创建navV
    [self createNavV];
    //创建底部view
    [self createBottomView];
    //这是请求未上架的请求
    [self postHttpWithPage:@"1" withType:@"1" withSales:@"1"];
}
- (void)createNavV
{
    _navV = [[JHTuangouManageNav alloc] initWithFrame:FRAME(0, 0, WIDTH, 40)];
    __weak typeof(self)weakSelf = self;
    __weak NSMutableArray * array = infoArray;
    __weak NSMutableArray * tempArray = selecterAray;
    __weak UIButton * sender = _rightBtn;
    [_navV setRefreshBlock:^(NSInteger num){
        [weakSelf clickRightBtn:sender];
        if (num <= 3) {
             weakSelf.selecter = num;
        }
        //判断类型
        if (weakSelf.navV.btn0.selected) weakSelf.allModifyBottomView.bottomViewType = ETuanStatusNotShelf;
        if (weakSelf.navV.btn1.selected) weakSelf.allModifyBottomView.bottomViewType = ETuanStatusShelf;
        if (weakSelf.navV.btn2.selected) weakSelf.allModifyBottomView.bottomViewType = ETuanStatusOverdue;
        [array removeAllObjects];
        [tempArray removeAllObjects];
        currentPage = 1;
        selecterNum = 0;
        if (num == 1) {
           //点击的是未上架
            [weakSelf postHttpWithPage:@"1" withType:@"1" withSales:weakSelf.sale];
        }else if(num == 2){
            //点击的是上架中
             [weakSelf postHttpWithPage:@"1" withType:@"2" withSales:weakSelf.sale];
        }else if(num == 3){
            //点击的是已过期
             [weakSelf postHttpWithPage:@"1" withType:@"3" withSales:weakSelf.sale];
        }else if(num == 4){
            //up_down>>>>>升序
              weakSelf.sale = @"0";
             [weakSelf postHttpWithPage:@"1" withType:@(weakSelf.selecter).stringValue withSales:weakSelf.sale];
        }else if(num == 5){
              weakSelf.sale = @"1";
            //down_up>>>降序
             [weakSelf postHttpWithPage:@"1" withType:@(weakSelf.selecter).stringValue withSales:weakSelf.sale];
        }
    }];
    [self.view addSubview:_navV];
}
#pragma mark - 这是发送请求的方法
-(void)postHttpWithPage:(NSString *)page withType:(NSString *)type withSales:(NSString *)sales{
    if ([page integerValue] == 1) {
        SHOW_HUD
    }
    NSDictionary * dic = @{@"page":page,
                           @"type":type,
                           @"sales":sales};
    [HttpTool postWithAPI:@"biz/tuan/tuan/items" withParams:dic success:^(id json) {
        NSLog(@"%@",json);
        if ([json[@"error"] isEqualToString:@"0"]) {
            NSArray * tempArray = json[@"data"][@"items"];
        for (NSDictionary * dictionary  in tempArray) {
            JHTuangouProductManagerModel * model = [JHTuangouProductManagerModel creatJHTuangouProductManagerModelWithDic:dictionary];
            model.type = type;
            [infoArray addObject:model];
            JHTuangouSelecterStyleModel * otherModel = [[JHTuangouSelecterStyleModel alloc]init];
            otherModel.status = NO;
            [selecterAray addObject:otherModel];
            }
            if (infoArray.count == 0) {
                isYes = NO;
                _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            }else{
                isYes = YES;
                _mainTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            }
            if (toast == nil && tempArray.count == 0 && [page integerValue] > 1) {
                toast = [[DSToast alloc]initWithText:NSLocalizedString(@"亲,没有更多数据了", nil)];
                [toast showInView:self.view  showType:DSToastShowTypeCenter withBlock:^{
                    toast = nil;
                }];
            }
            //创建表视图
            [self createMainTableView];
        }else{
             [JHShowAlert  showAlertWithMsg:json[@"message"]];
        }
        HIDE_HUD
        [_header endRefreshing];
        [_footer endRefreshing];
    } failure:^(NSError *error) {
        HIDE_HUD
        [_header endRefreshing];
        [_footer endRefreshing];
        [JHShowAlert showAlertWithMsg:NSLocalizedString(@"服务器繁忙,请稍后访问", nil)];
        NSLog(@"%@",error.localizedDescription);
    }];
}

#pragma mark - 创建表视图
- (void)createMainTableView
{
    if(_mainTableView == nil){
        _mainTableView = ({
            UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,40, WIDTH, HEIGHT-154)
                                                                  style:UITableViewStyleGrouped];
            tableView.delegate = self;
            tableView.dataSource = self;
            tableView.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
            tableView.separatorColor = LINE_COLOR;
            tableView.showsVerticalScrollIndicator = NO;
            [self.view addSubview:tableView];
            tableView.layoutMargins = UIEdgeInsetsZero;
            tableView.separatorInset = UIEdgeInsetsZero;
            if (!isYes) {
                tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            }else{
                tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            }
            tableView;
        });
        _header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(downRefresh)];
        _header.stateLabel.textColor = [UIColor colorWithRed:129/255.0 green:129/255.0 blue:129/255.0 alpha:1];
        _header.lastUpdatedTimeLabel.hidden = YES;
        [_header setTitle:NSLocalizedString(@"下拉可以刷新", nil) forState:MJRefreshStateIdle];
        [_header setTitle:NSLocalizedString(@"现在可以刷新啦", nil) forState:MJRefreshStatePulling];
        [_header setTitle:NSLocalizedString(@"正在为您努力刷新中", nil) forState:MJRefreshStateRefreshing];
        _mainTableView.mj_header = _header;
        _footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(upLoadData)];
        [_footer setTitle:@"" forState:MJRefreshStateIdle];
        [_footer setTitle:NSLocalizedString(@"正在加载更多的数据...", nil) forState:MJRefreshStateRefreshing];
        _mainTableView.mj_footer = _footer;
    }else{
        [_mainTableView reloadData];
    }
}
#pragma mark - 这是下拉刷新的方法
-(void)downRefresh{
    currentPage = 1;
    [infoArray removeAllObjects];
    [selecterAray removeAllObjects];
    if (self.selecter == 1) {
        NSLog(@"点击的是未上架");
        [self postHttpWithPage:@"1" withType:@"1" withSales:self.sale];
    }else if(self.selecter == 2){
        NSLog(@"点击的是上架中");
        [self postHttpWithPage:@"1" withType:@"2" withSales:self.sale];
    }else if(self.selecter == 3){
        NSLog(@"点击的是已过期");
        [self postHttpWithPage:@"1" withType:@"3" withSales:self.sale];
    }
}
#pragma mark - 这是上拉加载的方法
-(void)upLoadData{
    currentPage ++;
    if (self.selecter == 1) {
        NSLog(@"点击的是未上架");
        [self postHttpWithPage:@(currentPage).stringValue withType:@"1" withSales:self.sale];
    }else if(self.selecter == 2){
        NSLog(@"点击的是上架中");
        [self postHttpWithPage:@(currentPage).stringValue withType:@"2" withSales:self.sale];
    }else if(self.selecter == 3){
        NSLog(@"点击的是已过期");
        [self postHttpWithPage:@(currentPage).stringValue withType:@"3" withSales:self.sale];
    }

}
#pragma mark - 添加导航栏右侧按钮
- (void)addRightBtn
{
    //未选中时为未完成订单,选中时为已完成订单
    _rightBtn = [[UIButton alloc] initWithFrame:FRAME(0, 0, 55, 30)];
    [_rightBtn setTitle:NSLocalizedString(@"", nil) forState:(UIControlStateNormal)];
    [_rightBtn setTitle:NSLocalizedString(@"取消", nil) forState:(UIControlStateSelected)];
    [_rightBtn setTitleColor:HEX(@"faaf19", 1.0f) forState:(UIControlStateNormal)];
    _rightBtn.titleLabel.font = FONT(16);
    [_rightBtn addTarget:self action:@selector(clickRightBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBtn];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}
#pragma mark - 添加底部view
- (void)createBottomView
{
    JHTuangouProductBottimView *bottomView = [[JHTuangouProductBottimView alloc]
                                             initWithFrame:FRAME(0, HEIGHT - 50 - 64, WIDTH, 50)];
    [self.view addSubview:bottomView];
    //添加方法
    [bottomView.manageBtn addTarget:self
                             action:@selector(clickManageBtn:)
                   forControlEvents:(UIControlEventTouchUpInside)];
    [bottomView.addBtn addTarget:self action:@selector(clickAddBtn:)
                forControlEvents:(UIControlEventTouchUpInside)];
    
}
#pragma mark - tableView delegate and dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (isYes) {
         return infoArray.count;
    }else{
        return 1;
    }
   
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isYes) {
        return 200;
    }else{
        return HEIGHT - 50 - 64 - 40;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isYes) {
        JHTuangouProductManageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JHTuangouProductManageCellID"];
        if (!cell) {
            cell = [[JHTuangouProductManageCell alloc] initWithStyle:(UITableViewCellStyleDefault)
                                                     reuseIdentifier:@"JHTuangouProductManageCellID"];
        }
        if (infoArray.count > 0) {
            JHTuangouProductManagerModel * model = infoArray[indexPath.section];
            cell.model = model;
        }
        cell.navVC = self.navigationController;
        if (_navV.btn0.selected) cell.cellType = ETuangouProductCellTypeNotShelied;
        if (_navV.btn1.selected) cell.cellType = ETuangouProductCellTypeShelied;
        if (_navV.btn2.selected) cell.cellType = ETuangouProductCellTypeOverdue;
        //上架
        cell.shelfBtn.tag = indexPath.section;
        [cell.shelfBtn addTarget:self action:@selector(clickToGrounding:) forControlEvents:UIControlEventTouchUpInside];
        //下架
        cell.OffBtn.tag = indexPath.section;
        [cell.OffBtn addTarget:self action:@selector(clickToSoldOut:) forControlEvents:UIControlEventTouchUpInside];
        //延期
        cell.delayBtn.tag = indexPath.section;
        [cell.delayBtn addTarget:self action:@selector(clickToDelay:) forControlEvents:UIControlEventTouchUpInside];
        if (_mainTableView.editing) {
            cell.back_view.center = CGPointMake(WIDTH/2 + 40, 100);
        }else{
            cell.back_view.center = CGPointMake(WIDTH/2, 100);
        }
        return cell;
    }else{
        NSString * str_reusabel = @"JHTuangouManagerCell";
        JHTuangouManagerCellNone * cell = [tableView dequeueReusableCellWithIdentifier:str_reusabel];
        if (cell == nil) {
            cell = [[JHTuangouManagerCellNone alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str_reusabel];
        }
        return cell;
    }
}
//上架
-(void)clickToGrounding:(UIButton * )sender{
    NSLog(@"点击的是上架--->%ld",sender.tag);
    JHTuangouProductManagerModel * model = infoArray[sender.tag];
    [self postHttpWithStatus:@"1" withIds:model.tuan_id];
}
//下架
-(void)clickToSoldOut:(UIButton *)sender{
    NSLog(@"点击的是下架");
    JHTuangouProductManagerModel * model = infoArray[sender.tag];
    [self postHttpWithStatus:@"0" withIds:model.tuan_id];
}
//延期
-(void)clickToDelay:(UIButton *)sender{
    NSLog(@"点击的是延期");
    JHTuangouProductManagerModel * model = infoArray[sender.tag];
    [self postHttpWithIds:model.tuan_id];
}
#pragma mark - 这是延期发送请求的方法
-(void)postHttpWithIds:(NSString *)ids{
    HZQDatePicker * datePicker = [[HZQDatePicker alloc]init];
    [datePicker setMyBlock:^(NSString * time) {
        time = @([HZQChangeDateLine ExchangeWithTime:time]).stringValue;
        SHOW_HUD
        [HttpTool postWithAPI:@"biz/tuan/tuan/batch_time" withParams:@{@"ltime":time,@"ids":ids} success:^(id json) {
            NSLog(@"json---->%@",json);
            HIDE_HUD
            if ([json[@"error"] isEqualToString:@"0"]) {
                [JHShowAlert showAlertWithMsg:NSLocalizedString(@"设置成功", nil) withBtnTitle:NSLocalizedString(@"知道了", nil) withBtnBlock:^{
                    if (_mainTableView.mj_header==nil) {
                        _mainTableView.mj_header = _header;
                        _mainTableView.mj_footer = _footer;
                        [self clickRightBtn:_rightBtn];
                    }
                    [_header beginRefreshing];
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
    
    
    
    
    
    
//    NSDate * date = [NSDate date];
//    NSString * time =  [HZQChangeDateLine ExchangeWithdate:date withString:@"yyyy"];
//    __block JHPickerView * pickerView = [[JHPickerView alloc]init];
//    NSMutableArray *  dataArray = [NSMutableArray arrayWithObjects:@[time,@([time integerValue]+1).stringValue,@([time integerValue]+2).stringValue,@([time integerValue]+3).stringValue,@([time integerValue]+4).stringValue,@([time integerValue]+5).stringValue],
//                                   @[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12"],@[@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31"]
//                                   ,nil];
//        [pickerView showpickerViewWithDataArray:dataArray withBlock:^(NSString *result) {
//        [pickerView removeFromSuperview];
//        pickerView = nil;
//        if (result) {
//            result = @([HZQChangeDateLine ExchangeWithTime:result]).stringValue;
//            SHOW_HUD
//            [HttpTool postWithAPI:@"biz/tuan/tuan/batch_time" withParams:@{@"ltime":result,@"ids":ids} success:^(id json) {
//                NSLog(@"json---->%@",json);
//                HIDE_HUD
//                if ([json[@"error"] isEqualToString:@"0"]) {
//                    [JHShowAlert showAlertWithMsg:NSLocalizedString(@"设置成功", nil) withBtnTitle:NSLocalizedString(@"知道了", nil) withBtnBlock:^{
//                        if (_mainTableView.mj_header==nil) {
//                            _mainTableView.mj_header = _header;
//                            _mainTableView.mj_footer = _footer;
//                            [self clickRightBtn:_rightBtn];
//                        }
//                        [_header beginRefreshing];
//                    }];
//                }else{
//                    [JHShowAlert showAlertWithMsg:json[@"message"]];
//                }
//            } failure:^(NSError *error) {
//                HIDE_HUD
//                [JHShowAlert showAlertWithMsg:NSLocalizedString(@"服务器繁忙,请稍后访问", nil)];
//                NSLog(@"error----->%@",error.localizedDescription);
//            }];
//        }
//    }];
}
#pragma mark - 这是处理上架还是下架的方法
-(void)postHttpWithStatus:(NSString *)status withIds:(NSString *)ids{
    SHOW_HUD
    [HttpTool postWithAPI:@"biz/tuan/tuan/batch_status" withParams:@{@"status":status,@"ids":ids} success:^(id json) {
        NSLog(@"json---->%@",json);
         HIDE_HUD
        if ([json[@"error"] isEqualToString:@"0"]) {
           [JHShowAlert showAlertWithMsg:NSLocalizedString(@"设置成功", nil) withBtnTitle:NSLocalizedString(@"知道了", nil) withBtnBlock:^{
               if (_mainTableView.mj_header==nil) {
                   _mainTableView.mj_header = _header;
                   _mainTableView.mj_footer = _footer;
                   [self clickRightBtn:_rightBtn];
               }
               [_header beginRefreshing];
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (isYes) {
        if (_mainTableView.editing) {
            JHTuangouSelecterStyleModel * model = selecterAray[indexPath.section];
            [model setStatus:YES];
            selecterNum ++;
            if (selecterNum >= infoArray.count) {
                selecterNum = infoArray.count;
            }
            for (JHTuangouSelecterStyleModel * obj in selecterAray) {
                if (!obj.status) {
                    return;
                }
            }
            if (selecterNum == infoArray.count) {
                _allModifyBottomView.selectAllBtn.selected = YES;
            }
            NSLog(@"---------%ld--------",selecterNum);
        }else{
            JHTuangouProductManagerModel * model = infoArray[indexPath.section];
            JHTuanGouProductAddVC * productVC = [[JHTuanGouProductAddVC alloc]init];
            productVC.isRevise = YES;
            productVC.tuan_id = model.tuan_id;
            if (self.selecter == 1) {
                productVC.type = 1;
            }else if (self.selecter == 2){
                productVC.type = 0;
            }else{
                productVC.type = 2;
            }
            [self.navigationController pushViewController:productVC animated:YES];
        }

    }
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_mainTableView.editing ) {
        JHTuangouSelecterStyleModel * model = selecterAray[indexPath.section];
        [model setStatus:NO];
            selecterNum --;
        if (selecterNum <= 0) {
            selecterNum = 0;
        }
        if (selecterNum < infoArray.count) {
            _allModifyBottomView.selectAllBtn.selected = NO;
        }
        NSLog(@"---------%ld--------",selecterNum);
    }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(!_mainTableView.editing)return;
    JHTuangouSelecterStyleModel * model = selecterAray[indexPath.section];
    if(model.status){
        [_mainTableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:0];
        [self tableView:_mainTableView didSelectRowAtIndexPath:indexPath];
    }else{
        if (selecterNum == 0) {
            [_mainTableView deselectRowAtIndexPath:indexPath animated:NO];
            [self tableView:_mainTableView didDeselectRowAtIndexPath:indexPath];
        }
    }
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}
#pragma mark - 点击了批量管理按钮
- (void)clickManageBtn:(UIButton *)sender
{
    if (infoArray.count == 0) {
        return;
    }
    _rightBtn.selected = YES;
    if (!_mainTableView.editing) {
        _mainTableView.mj_header = nil;
        _mainTableView.mj_footer = nil;
        //将表视图切换到可编辑状态
        _mainTableView.editing = YES;
        NSArray<JHTuangouProductManageCell*> * cellArray = [_mainTableView visibleCells];
        for (JHTuangouProductManageCell *cell in cellArray) {
            [UIView animateWithDuration:0.3 animations:^{
                cell.back_view.center = CGPointMake(WIDTH/2 + 40, 100);
            }];
        }
        if (!_allModifyBottomView) {
            _allModifyBottomView = [[JHTuangouProductAllModifyBottomView alloc]
                                   initWithFrame:FRAME(0,HEIGHT - 64, WIDTH, 50)];
            //点击全选按纽调用的方法
            [_allModifyBottomView.selectAllBtn addTarget:self action:@selector(clickAllCell:) forControlEvents:UIControlEventTouchUpInside];
            //批量管理上架的方法
            [_allModifyBottomView.shelfBtn addTarget:self action:@selector(clickBatchToGrounding:) forControlEvents:UIControlEventTouchUpInside];
            //批量下架的方法
            [_allModifyBottomView.outShelfBtn addTarget:self action:@selector(clickBatchToSoldOut:) forControlEvents:UIControlEventTouchUpInside];
            //批量延期的方法
            [_allModifyBottomView.delayBtn addTarget:self action:@selector(clickBatchToDelay:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:_allModifyBottomView];
        }
        //判断类型
        if (_navV.btn0.selected) _allModifyBottomView.bottomViewType = ETuanStatusNotShelf;
        if (_navV.btn1.selected) _allModifyBottomView.bottomViewType = ETuanStatusShelf;
        if (_navV.btn2.selected) _allModifyBottomView.bottomViewType = ETuanStatusOverdue;
        //出现
        [UIView animateWithDuration:0.3 animations:^{
            _allModifyBottomView.frame = FRAME(0, HEIGHT - 64 - 50, WIDTH, 50);
        }];
    }
}
#pragma mark - 这是点击添加全选的按钮
-(void)clickAllCell:(UIButton *)sender{
    sender.selected = !sender.selected;
    NSArray * cellArray = _mainTableView.visibleCells;
    if (sender.selected) {
        [selecterAray enumerateObjectsUsingBlock:^(JHTuangouSelecterStyleModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.status = YES;
        }];
        for (JHTuangouProductManageCell * cell in cellArray) {
            
            [_mainTableView selectRowAtIndexPath:[_mainTableView indexPathForCell:cell] animated:NO scrollPosition:0];
            [self tableView:_mainTableView didSelectRowAtIndexPath:[_mainTableView indexPathForCell:cell]];
        }
        selecterNum = infoArray.count;
    }else{
        [selecterAray enumerateObjectsUsingBlock:^(JHTuangouSelecterStyleModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.status = NO;
        }];
        for (JHTuangouProductManageCell * cell in cellArray) {
            [_mainTableView deselectRowAtIndexPath:[_mainTableView indexPathForCell:cell] animated:NO];
            [self tableView:_mainTableView didDeselectRowAtIndexPath:[_mainTableView indexPathForCell:cell]];
        }
        selecterNum = 0;
    }
    
}
#pragma mark - 这是批量管理上架的方法
-(void)clickBatchToGrounding:(UIButton *)sender{
    NSLog(@"点击了批量上架的方法");
    NSMutableArray * tuan_idArray = @[].mutableCopy;
    for (int i = 0;i < selecterAray.count ; i ++) {
        JHTuangouSelecterStyleModel * model = selecterAray[i];
        if (model.status) {
            JHTuangouProductManagerModel * model = infoArray[i];
            [tuan_idArray addObject:model.tuan_id];
        }
        NSLog(@"model.status>>>>>>%d",model.status);
    }
     NSLog(@"tuan_idArray*******%@",[tuan_idArray componentsJoinedByString:@","]);
    if (tuan_idArray.count == 0) {
        [JHShowAlert showAlertWithMsg:NSLocalizedString(@"请先选择需要上架的团购", nil)];
    }else{
        [self postHttpWithStatus:@"1" withIds:[tuan_idArray componentsJoinedByString:@","]];
    }
}
#pragma mark - 这是批量下架的方法
-(void)clickBatchToSoldOut:(UIButton *)sender{
    NSLog(@"点击了批量下架的方法");
    NSMutableArray * tuan_idArray = @[].mutableCopy;
    for (int i = 0;i < selecterAray.count ; i ++) {
        JHTuangouSelecterStyleModel * model = selecterAray[i];
        if (model.status) {
            JHTuangouProductManagerModel * model = infoArray[i];
            [tuan_idArray addObject:model.tuan_id];
        }
        NSLog(@"model.status>>>>>>%d",model.status);
    }
    NSLog(@"tuan_idArray*******%@",[tuan_idArray componentsJoinedByString:@","]);
    if (tuan_idArray.count == 0) {
        [JHShowAlert showAlertWithMsg:NSLocalizedString(@"请先选择需要下架的团购", nil)];
    }else{
        [self postHttpWithStatus:@"0" withIds:[tuan_idArray componentsJoinedByString:@","]];
    }
}
#pragma mark - 这是点击批量延期的方法
-(void)clickBatchToDelay:(UIButton *)sender{
    NSLog(@"点击的是批量延期的方法");
    NSMutableArray * tuan_idArray = @[].mutableCopy;
    for (int i = 0;i < selecterAray.count ; i ++) {
        JHTuangouSelecterStyleModel * model = selecterAray[i];
        if (model.status) {
            JHTuangouProductManagerModel * model = infoArray[i];
            [tuan_idArray addObject:model.tuan_id];
        }
        
        NSLog(@"model.status>>>>>>%d",model.status);
    }
    NSLog(@"tuan_idArray*******%@",[tuan_idArray componentsJoinedByString:@","]);
    if (tuan_idArray.count == 0) {
        [JHShowAlert showAlertWithMsg:NSLocalizedString(@"请先选择需要延期的团购", nil)];
    }else{
        [self postHttpWithIds:[tuan_idArray componentsJoinedByString:@","]];
        
    }
}
#pragma mark - 点击了添加商品按钮
- (void)clickAddBtn:(UIButton *)sender
{
    Class vcCLass = NSClassFromString(@"JHTuanGouProductAddVC");
    [self.navigationController pushViewController:[vcCLass new] animated:YES];
}
#pragma mark - 点击取消编辑按钮
- (void)clickRightBtn:(UIButton *)sender
{
    if (![sender.titleLabel.text isEqualToString:NSLocalizedString(@"取消", nil)]) {
        return;
    }
    if (infoArray.count == 0) {
        return;
    }
    sender.selected = NO;
    if (!sender.selected) {
        selecterNum = 0;
        //点击将表视图不可编辑
        _mainTableView.mj_header = _header;
        _mainTableView.mj_footer = _footer;
        self.mainTableView.editing = NO;
        NSArray *cellArray = [_mainTableView visibleCells];
        for (JHTuangouProductManageCell *cell in cellArray) {
            [UIView animateWithDuration:0.3 animations:^{
                cell.back_view.center = CGPointMake(WIDTH/2, 100);
            }];
            cell.selected = NO;
        }
        _allModifyBottomView.selectAllBtn.selected = NO;
        //消失
        [UIView animateWithDuration:0.3 animations:^{
            _allModifyBottomView.frame = FRAME(0, HEIGHT - 64, WIDTH, 50);
        }];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    //Dispose of any resources that can be recreated.
}
@end
