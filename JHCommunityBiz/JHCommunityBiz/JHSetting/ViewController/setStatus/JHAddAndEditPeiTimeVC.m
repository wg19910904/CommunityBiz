//
//  JHAddAndEditPeiTimeVC.m
//  JHCommunityBiz
//
//  Created by jianghu1 on 17/2/6.
//  Copyright © 2017年 com.jianghu. All rights reserved.
//

#import "JHAddAndEditPeiTimeVC.h"
#import "JHPickerView.h"
@interface JHAddAndEditPeiTimeVC ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *timeT;//配送时间表
@property(nonatomic,copy)NSMutableArray *timeArr;
@end

@implementation JHAddAndEditPeiTimeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNav];
    [self.view addSubview:self.timeT];
    [self addBottomBtn];
}
#pragma mark - 设置导航栏
- (void)initNav{
    if (self.STime) {
        self.navigationItem.title = NSLocalizedString(@"编辑配送时间", @"JHAddAndEditPeiTimeVC");
    }else{
        self.navigationItem.title = NSLocalizedString(@"添加配送时间", @"JHAddAndEditPeiTimeVC");
    }
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
    [sureBtn setTitle:NSLocalizedString(@"保存", @"JHAddAndEditPeiTimeVC") forState:(UIControlStateNormal)];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [sureBtn addTarget:self action:@selector(onClickSaveBtn:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onClickSaveBtn:(UIButton *)sender{
    //判断时间是否有效
    UITableViewCell *SCell = [_timeT cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UITableViewCell *ECell = [_timeT cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    NSString *SStr = SCell.detailTextLabel.text;
    NSString *EStr = ECell.detailTextLabel.text;
    if (SStr.length == 0){
        [JHShowAlert showAlertWithMsg:NSLocalizedString(@"请选择开始时间", @"JHAddAndEditPeiTimeVC")];
        return;
    }
    if (EStr.length == 0){
        [JHShowAlert showAlertWithMsg:NSLocalizedString(@"请选择结束时间", @"JHAddAndEditPeiTimeVC")];
        return;
    }
    NSInteger correct = [EStr compare:SStr];
    if (correct != 1){
       [JHShowAlert showAlertWithMsg:NSLocalizedString(@"请检查结束时间是否大于开始时间", @"JHAddAndEditPeiTimeVC")];
    }else{
        NSLog(@"时间格设置正确");
        NSString *stime = [[_timeT cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] detailTextLabel].text;
        NSString *ltime = [[_timeT cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]] detailTextLabel].text;
        
        if (_timeBlock) {
            _timeBlock(stime,ltime);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - uitableviewdelegate  dataSouce
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"JHAddAndEditPeiTimeVCID"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = (indexPath.section == 0) ? NSLocalizedString(@"开始时间", @"JHAddAndEditPeiTimeVC"):NSLocalizedString(@"结束时间", @"JHAddAndEditPeiTimeVC");
    cell.textLabel.textColor = HEX(@"333333", 1.0);
    cell.textLabel.font = FONT(14);
    cell.detailTextLabel.text = (indexPath.section == 0) ? _STime:_ETime;
    cell.detailTextLabel.textColor = HEX(@"333333", 1.0);
    cell.detailTextLabel.font = FONT(14);
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_timeT deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [_timeT cellForRowAtIndexPath:indexPath];
    __weak typeof(self)weakSelf = self;
    __block JHPickerView * pickerView = [[JHPickerView alloc]init];
    [pickerView showpickerViewWithArray:self.timeArr withSelectedText:cell.detailTextLabel.text  withBlock:^(NSString *result) {
        NSLog(@"%@",result);
        //更新对应的时间
        if (result.length > 0) [weakSelf update:indexPath time:result];
        [pickerView removeFromSuperview];
        pickerView = nil;
        
    }];
}
- (void)update:(NSIndexPath *)indexPath time:(NSString *)time{
    if (time.length == 0) return;
    UITableViewCell *cell = [_timeT cellForRowAtIndexPath:indexPath];
    cell.detailTextLabel.text = time;
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
- (NSMutableArray *)timeArr{
    NSArray *timeArray = [[JHShareModel shareModel].infoDictionary objectForKey:@"time_init"];
    return [timeArray mutableCopy];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
