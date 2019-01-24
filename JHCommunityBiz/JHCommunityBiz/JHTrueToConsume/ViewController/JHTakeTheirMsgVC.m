//
//  JHTakeTheirMsgVC.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/26.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHTakeTheirMsgVC.h"
#import "JHTakeTheirCellOne.h"
#import "JHTakeTheirCellTwo.h"
#import "JHTakeTheirCellThree.h"
#import "JHTakeTheirCellFour.h"
#import "JHTakeTheirCellFive.h"
#import "JHTakeTheirModel.h"
@implementation JHTakeTheirMsgVC{
    UITableView * myTableView;
    float height1;//保存的是备注的高度
    JHTakeTheirModel * detailModel;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    //这是初始化的一些数据的方法
    [self initData];
    //这是创建UIButton
    [self creatUIButton];
    //添加表视图
    [self creatUITableView];
    
}
#pragma mark - 这是初始化一些数据的方法
-(void)initData{
    detailModel = [[JHTakeTheirModel alloc]initJHTakeTheirModelWithDictionary:self.dictionary];
    self.navigationItem.title =  NSLocalizedString(@"自提单信息确认", NSStringFromClass([self class]));
    self.view.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
}
#pragma mark - 这是取消和确定的按钮创建的方法
-(void)creatUIButton{
        UIColor * color = [UIColor colorWithWhite:0.9 alpha:1];
        UIColor * color1 = [UIColor colorWithRed:250/255.0 green:175/255.0 blue:25/255.0 alpha:1];
        NSArray * array = @[ NSLocalizedString(@"取消", NSStringFromClass([self class])), NSLocalizedString(@"确定", NSStringFromClass([self class])),color,color1];
        for (int i = 0; i < 2; i++) {
            UIButton * btn = [[UIButton alloc]init];
            btn.frame = FRAME(10+((WIDTH - 40)/2+20)*i, HEIGHT - 64 - 45, (WIDTH - 40)/2, 35);
            [btn setTitle:array[i] forState:UIControlStateNormal];
            [btn setBackgroundColor:array[i+2] forState:UIControlStateNormal];
            btn.layer.cornerRadius = 3;
            btn.layer.masksToBounds = YES;
            btn.tag = i;
            [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:btn];
        }
}
#pragma mark - 这是点击取消或者确定按钮调用的方法
-(void)clickBtn:(UIButton *)sender{
    if (sender.tag == 0) {
        NSLog(@"点击的是取消");
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        SHOW_HUD
        NSLog(@"点击的是确定");
        [HttpTool postWithAPI:@"biz/quan/set" withParams:@{@"code":detailModel.spend_number} success:^(id json) {
            HIDE_HUD
            if ([json[@"error"] isEqualToString:@"0"]) {
                [JHShowAlert showAlertWithMsg: NSLocalizedString(@"核销成功", NSStringFromClass([self class])) withBtnTitle: NSLocalizedString(@"知道了", NSStringFromClass([self class])) withBtnBlock:^{
                    if (self.completionBlock) {
                        self.completionBlock();
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }else{
                [JHShowAlert showAlertWithMsg:json[@"message"]];
            }
        } failure:^(NSError *error) {
            HIDE_HUD
            [JHShowAlert showAlertWithMsg: NSLocalizedString(@"服务器繁忙,请稍后访问", NSStringFromClass([self class]))];
            NSLog(@"%@",error.localizedDescription);
        }];
    }
}
#pragma mark - 这是表视图的方法
-(void)creatUITableView{
    myTableView = [[UITableView alloc]initWithFrame:FRAME(0, 0, WIDTH, HEIGHT - 64 - 45) style:UITableViewStylePlain];
    myTableView.tableFooterView = [UIView new];
    myTableView.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:myTableView];
    myTableView.showsVerticalScrollIndicator = NO;
    [myTableView registerClass:[JHTakeTheirCellOne class] forCellReuseIdentifier:@"cell1"];
    [myTableView registerClass:[JHTakeTheirCellTwo class] forCellReuseIdentifier:@"cell2"];
    [myTableView registerClass:[JHTakeTheirCellThree class] forCellReuseIdentifier:@"cell3"];
    [myTableView registerClass:[JHTakeTheirCellFour class] forCellReuseIdentifier:@"cell4"];
    [myTableView registerClass:[JHTakeTheirCellFive class] forCellReuseIdentifier:@"cell5"];
    myTableView.delegate = self;
    myTableView.dataSource = self;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            return 80;
            break;
        case 1:
            return 130;
            break;
        case 2:
        {
            CGSize size = [detailModel.intro boundingRectWithSize:CGSizeMake(WIDTH - 80, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
            height1 = size.height;
            return 120+height1;
        }
            break;
        case 3:
            return 55+20*detailModel.infoArray.count;
            break;
        case 4:
            return 80;
            break;
        default:
            return 0;
            break;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:{
            JHTakeTheirCellOne * cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
            return cell;
        }
            break;
        case 1:
        {
            JHTakeTheirCellTwo * cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
            cell.model = detailModel;
            return cell;
        }
            break;
        case 2:
        {
            JHTakeTheirCellThree * cell = [tableView dequeueReusableCellWithIdentifier:@"cell3" forIndexPath:indexPath];
            cell.height = height1;
            cell.model = detailModel;
            return cell;
        }
            break;
        case 3:{
            JHTakeTheirCellFour * cell = [tableView dequeueReusableCellWithIdentifier:@"cell4" forIndexPath:indexPath];
            cell.model = detailModel;
            return cell;
        }
        break;
        case 4:{
            JHTakeTheirCellFive * cell = [tableView dequeueReusableCellWithIdentifier:@"cell5" forIndexPath:indexPath];
            cell.model = detailModel;
            return cell;
        }
            break;
        default:
            return 0;
            break;
    }
}
@end
