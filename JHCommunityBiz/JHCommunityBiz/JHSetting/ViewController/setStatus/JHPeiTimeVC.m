//
//  JHPeiTimeVC.m
//  JHCommunityBiz
//
//  Created by jianghu1 on 17/2/6.
//  Copyright © 2017年 com.jianghu. All rights reserved.
//

#import "JHPeiTimeVC.h"
#import "JHAddAndEditPeiTimeVC.h"

@interface JHPeiTimeVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *timeT;//配送时间表
@property(nonatomic,strong)UIButton *editBtn;//右上角编辑按钮
@end

@implementation JHPeiTimeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    [self.view addSubview:self.timeT];
    [self addBottomBtn];
   
}
#pragma mark - 设置导航栏
- (void)initNav{
    self.navigationItem.title = NSLocalizedString(@"配送时间设置", @"JHPeiTimeVC");
    //添加右侧编辑按钮
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.editBtn];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
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
    [sureBtn setBackgroundColor:HEX(@"14c0cc", 1.0) forState:(UIControlStateNormal)];
    [sureBtn setTitle:NSLocalizedString(@"添加配送时间", @"JHPeiTimeVC") forState:(UIControlStateNormal)];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [sureBtn addTarget:self action:@selector(onClickAddBtn:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)uploadPeiTimeInfo{
    //处理时间数组为服务器所需格式
    
    SHOW_HUD
    [HttpTool postWithAPI:@"biz/waimai/update/yytime"
               withParams:@{@"yy_peitime":[_timeArr componentsJoinedByString:@","]}
                  success:^(id json) {
                      HIDE_HUD
                      if (ERROR_0) {
                         [JHShowAlert showAlertWithMsg:NSLocalizedString(@"保存成功", @"JHPeiTimeVC")];
                          //同步数据
                          [[NSNotificationCenter defaultCenter] postNotificationName:@"KGetNewBizInfoNoti" object:nil];
                      }else{
                         [JHShowAlert showAlertWithMsg:ERROR_MESSAGE];
                      }
                  } failure:^(NSError *error) {
                      HIDE_HUD
                      [JHShowAlert showAlertWithMsg:NSLocalizedString(@"服务器异常", @"JHPeiTimeVC")];
                  }];
    
}
- (void)onClickEditBtn:(UIButton *)sender{
    NSLog(@"点击编辑按钮");
//    if (_timeArr.count == 0) return;
    sender.selected = !sender.selected;
    if (sender.selected) {
        [_timeT setEditing:YES animated:YES];
    }else{
        [_timeT setEditing:NO animated:YES];
        //上传编辑后的时间
        [self uploadPeiTimeInfo];
    }
    
}
- (void)onClickAddBtn:(UIButton *)sender{
    __weak typeof(self)weakSelf = self;
    if (!_timeArr) {
             _timeArr = @[].mutableCopy;
    }

    JHAddAndEditPeiTimeVC *editPeiTimeVC = [[JHAddAndEditPeiTimeVC alloc] init];
    [editPeiTimeVC setTimeBlock:^(NSString *stime,NSString *ltime){
        NSString *str = [NSString stringWithFormat:@"%@-%@",stime,ltime];
        [_timeArr addObject:str];
        [weakSelf.timeT reloadData];
        [weakSelf uploadPeiTimeInfo];
    }];
    
    [self.navigationController pushViewController:editPeiTimeVC animated:YES];
}
#pragma mark - uitableviewdelegate  dataSouce

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _timeArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //获取需要展示的时间
    cell.textLabel.text = _timeArr[indexPath.row];
    cell.textLabel.textColor = HEX(@"333333", 1.0);
    cell.textLabel.font = FONT(14);
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self)weakSelf = self;
    [_timeT deselectRowAtIndexPath:indexPath animated:YES];
    JHAddAndEditPeiTimeVC *editPeiTimeVC = [[JHAddAndEditPeiTimeVC alloc] init];
    NSString *timeStr = _timeArr[indexPath.row];
    editPeiTimeVC.STime = [timeStr componentsSeparatedByString:@"-"][0];
    editPeiTimeVC.ETime = [timeStr componentsSeparatedByString:@"-"][1];
    [editPeiTimeVC setTimeBlock:^(NSString *stime,NSString *ltime){
        [_timeArr replaceObjectAtIndex:indexPath.row
                            withObject:[NSString stringWithFormat:@"%@-%@",stime,ltime]];
        [weakSelf.timeT reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [weakSelf uploadPeiTimeInfo];
    }];
    [self.navigationController pushViewController:editPeiTimeVC animated:YES];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return  YES;
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{

    [_timeArr removeObjectAtIndex:indexPath.row];
    
    [self.timeT deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
}

- (UITableView *)timeT{
    if (!_timeT) {
        _timeT = ({
            UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, WIDTH, HEIGHT - 64 - 60)
                                                                  style:UITableViewStylePlain];
            tableView.delegate = self;
            tableView.dataSource = self;
            tableView.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
            tableView.separatorColor = LINE_COLOR;
            tableView.showsVerticalScrollIndicator = NO;
            tableView.layoutMargins = UIEdgeInsetsZero;
            tableView.separatorInset = UIEdgeInsetsZero;
            tableView.tableFooterView = [UIView new];
            tableView;
        });
    }
    return _timeT;
}

- (UIButton *)editBtn{
    if (!_editBtn)
        _editBtn = [[UIButton alloc] initWithFrame:FRAME(0, 0, 40, 44)];
        [_editBtn setTitle:NSLocalizedString(@"编辑", @"JHPeiTimeVC") forState:(UIControlStateNormal)];
        [_editBtn setTitle:NSLocalizedString(@"完成", @"JHPeiTimeVC") forState:(UIControlStateSelected)];
        [_editBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        _editBtn.titleLabel.font = FONT(14);
        [_editBtn addTarget:self action:@selector(onClickEditBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        return _editBtn;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)clickBackBtn{
    
    if (self.timeBlock) self.timeBlock(_timeArr);
    [super clickBackBtn];
}
@end
