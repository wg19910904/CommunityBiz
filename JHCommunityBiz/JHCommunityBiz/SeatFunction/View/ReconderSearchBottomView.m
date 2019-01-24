//
//  ReconderSearchBottomView.m
//  JHCommunityBiz
//
//  Created by ijianghu on 2017/11/11.
//  Copyright © 2017年 com.jianghu. All rights reserved.
//

#import "ReconderSearchBottomView.h"
@interface ReconderSearchBottomView()<UITableViewDelegate,UITableViewDataSource>
{
    NSInteger index;
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *selectorArr;
@end
@implementation ReconderSearchBottomView
-(instancetype)init{
    self = [super init];
    if (self) {
        [self configUI];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}
-(void)configUI{
    _selectorArr = @[].mutableCopy;
    self.backgroundColor = HEX(@"000000", 0.5);
    self.frame = FRAME(0, 0, WIDTH, HEIGHT);
    [self addTarget:self action:@selector(clickRemove) forControlEvents:UIControlEventTouchUpInside];
    [self tableView];
}
#pragma mark - 这是创建表视图的方法
-(UITableView * )tableView{
    if(_tableView == nil){
        _tableView = ({
            UITableView * table = [[UITableView alloc]initWithFrame:FRAME(0, HEIGHT, WIDTH, 0) style:UITableViewStyleGrouped];
            table.delegate = self;
            table.dataSource = self;
            table.tableFooterView = [UIView new];
            table.showsVerticalScrollIndicator = NO;
            table.backgroundColor = [UIColor whiteColor];
            table.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
            table.separatorColor = LINE_COLOR;
            table.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
            [self addSubview:table];
            table;
        });
    }
    return _tableView;
}

#pragma mark - 这是UITableView的代理和方法和数据方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _nameArr.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = HEX(@"ffffff", 1);
    UIView *line = [UIView new];
    line.backgroundColor = LINE_COLOR;
    line.frame = FRAME(0, 49.5, WIDTH, 0.5);
    [view addSubview:line];
    UILabel *lab = [UILabel new];
    lab.text =  NSLocalizedString(@"请选择台卡", NSStringFromClass([self class]));
    [view addSubview:lab];
    lab.textColor = HEX(@"333333", 1);
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(view.mas_centerX);
        make.height.offset = 20;
        make.centerY.mas_equalTo(view.mas_centerY);
    }];
    UIButton *cancelBtn = [[UIButton alloc]init];
    [cancelBtn setTitle: NSLocalizedString(@"取消", NSStringFromClass([self class])) forState:UIControlStateNormal];
    [cancelBtn setTitleColor:HEX(@"999999", 1) forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = FONT(14);
    [view addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset = 0;
        make.centerY.mas_equalTo(view.mas_centerY);
        make.top.offset = 0;
        make.bottom.mas_equalTo(line.mas_top).offset = 0;
        make.width.offset = 100;
    }];
    cancelBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    [cancelBtn addTarget:self action:@selector(clickRemove) forControlEvents:UIControlEventTouchUpInside];
    UIButton *sureBtn = [[UIButton alloc]init];
    [sureBtn setTitle: NSLocalizedString(@"确定", NSStringFromClass([self class])) forState:UIControlStateNormal];
    [sureBtn setTitleColor:HEX(@"999999", 1) forState:UIControlStateNormal];
    sureBtn.titleLabel.font = FONT(14);
    [view addSubview:sureBtn];
    [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset = 0;
        make.centerY.mas_equalTo(view.mas_centerY);
        make.top.offset = 0;
        make.bottom.mas_equalTo(line.mas_top).offset = 0;
        make.width.offset = 100;
    }];
    sureBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -30);
    [sureBtn addTarget:self action:@selector(clickSure) forControlEvents:UIControlEventTouchUpInside];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    cell.textLabel.text = _nameArr[indexPath.row];
    cell.textLabel.font = FONT(16);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    BOOL isSelector = [_selectorArr[indexPath.row] integerValue];
    if (isSelector) {
         cell.accessoryType = UITableViewCellAccessoryCheckmark;
         cell.textLabel.textColor = HEX(@"ff9900", 1);
    }else{
         cell.accessoryType = UITableViewCellAccessoryNone;
         cell.textLabel.textColor = HEX(@"666666", 1);
    }
   
    cell.tintColor = HEX(@"ff9900", 1);
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    for (int i = 0; i < _selectorArr.count; i++) {
        if (i == indexPath.row) {
             index = i;
             [_selectorArr replaceObjectAtIndex:indexPath.row withObject:@"1"];
        }else{
             [_selectorArr replaceObjectAtIndex:i withObject:@"0"];
        }
    }
    [tableView reloadData];
}
-(void)setNameArr:(NSArray *)nameArr{
    _nameArr = nameArr;
    if (_seleterStr.length > 0) {
        index = [nameArr indexOfObject:_seleterStr];
    }else{
        index = -1;
    }
    
    [_selectorArr removeAllObjects];
    for (NSInteger i = 0; i < nameArr.count; i ++) {
        if (i == index) {
            [_selectorArr addObject:@"1"];
        }else{
            [_selectorArr addObject:@"0"];
        }
        
    }
    [UIView animateWithDuration:0.25 animations:^{
        _tableView.frame = FRAME(0, HEIGHT - (nameArr.count+1)*50, WIDTH, (nameArr.count+1)*50);
    }];
    [_tableView reloadData];
}
-(void)showView{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self];
    self.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
    }];
}
-(void)clickRemove{
    [UIView animateWithDuration:0.25 animations:^{
        _tableView.frame = FRAME(0, HEIGHT, WIDTH, 0);
        self.alpha = 0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
-(void)clickSure{
    
    if (self.sureBlock && index >= 0) {
        self.sureBlock(_nameArr[index],index);
    }
    [self clickRemove];
}
@end
