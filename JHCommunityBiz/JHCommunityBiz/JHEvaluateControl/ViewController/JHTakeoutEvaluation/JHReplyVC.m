//
//  JHReplyVC.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/13.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHReplyVC.h"
#import "JHReplyCellOne.h"
#import "JHReplyCellTwo.h"
#import "JHReplyCellThree.h"
#import "JHEvaluteModel.h"
#import "IQKeyboardManager.h"
@interface JHReplyVC ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
{
    UITableView * myTableView;//创建表格的方法
    float height;//高度
    UITextView * mytextView;//回复内容的输入框
    UILabel * label_num;//显示输入多少字的
}
@end
@implementation JHReplyVC
- (void)viewDidLoad {
    [super viewDidLoad];
    //这是初始化一些方法
    [self initData];
    //这是创建tableView的方法
    [self creatUITableView];
    //发送请求
    [self postHttp];
}
#pragma - mark - 这是获取外送详情请求的方法
-(void)postHttp{
    SHOW_HUD
    [HttpTool postWithAPI:@"biz/waimai/comment/comment/detail" withParams:@{@"comment_id":self.comment_id} success:^(id json) {
        NSLog(@"%@",json);
        if ([json[@"error"] isEqualToString:@"0"]) {
            self.face = [NSString stringWithFormat:@"%@%@",IMAGEADDRESS,json[@"data"][@"member"][@"face"]];
            self.nickname = json[@"data"][@"member"][@"nickname"];
            self.score_fuwu = json[@"data"][@"score_fuwu"];
            self.score_kouwei = json[@"data"][@"score_kouwei"];
            self.score = json[@"data"][@"score"];
            self.time_pei = json[@"data"][@"pei_time"];
            self.content = json[@"data"][@"content"];
            self.dateline = json[@"data"][@"dateline"];
            self.pei_time_label = json[@"data"][@"pei_time_label"];
            for (NSString * string  in json[@"data"][@"photo_list"]) {
                NSString * str = [NSString stringWithFormat:@"%@%@",IMAGEADDRESS,string];
                [self.photoArray addObject:str];
            }
            [myTableView reloadData];
        }else{
            [JHShowAlert showAlertWithMsg:json[@"message"]];
        }
        HIDE_HUD
    } failure:^(NSError *error) {
        HIDE_HUD
        NSLog(@"%@",error.localizedDescription);
    }];
    
}
#pragma mark - 这是初始化一些方法
-(void)initData{
    self.photoArray = @[].mutableCopy;
    //这是标题
    self.navigationItem.title = NSLocalizedString(@"评价回复", nil);
    //检测文本框发生文本发生改变的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewTextDidChangeOne:) name:UITextViewTextDidChangeNotification object:mytextView];
    
}
#pragma mark - 这是创建表格的方法
-(void)creatUITableView{
    myTableView = ({
        UITableView *tab = [[UITableView alloc] initWithFrame:FRAME(0, 0, WIDTH, HEIGHT - 64) style:UITableViewStylePlain];
        tab.tableFooterView = [UIView new];
        tab.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
        tab.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tab registerClass:[JHReplyCell class] forCellReuseIdentifier:@"cell"];
        [tab registerClass:[JHReplyCellTwo class] forCellReuseIdentifier:@"cell1"];
        [tab registerClass:[JHReplyCellThree class] forCellReuseIdentifier:@"cell2"];
        tab.delegate = self;
        tab.dataSource = self;
        tab;
    });
    [self.view addSubview:myTableView];
}
#pragma mark - 这是表格的代理和数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        CGSize size = [self.content boundingRectWithSize:CGSizeMake(WIDTH - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
        height = size.height;
        if (self.photoArray.count > 0) {
            return  40 + height + 10 +  60 + (WIDTH - 50)/4 + 5;
        }else{
            return 40 + height + 10 + 60;
        }
        
    }else if (indexPath.row == 1){
        return 120;
    }else{
        return 110;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        JHReplyCell * cell = [tableView  dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.face = self.face;
        cell.nickname = self.nickname;
        cell.score_kouwei = self.score_kouwei;
        cell.score_fuwu = self.score_fuwu;
        cell.time_pei = self.time_pei;
        cell.content = self.content;
        cell.dateline = self.dateline;
        cell.photoArray = self.photoArray;
        cell.score = self.score;
        cell.pei_time_label = self.pei_time_label;
        cell.height = height;
        
        return cell;
    }else if (indexPath.row ==1){
        JHReplyCellTwo * cell = [tableView dequeueReusableCellWithIdentifier:@"cell1" forIndexPath:indexPath];
        mytextView = cell.textView;
        mytextView.delegate = self;
        label_num = cell.label;
        return cell;
    }else{
        JHReplyCellThree * cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
        [cell.btn_replay addTarget:self action:@selector(clickToReplay) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}
#pragma mark - 这是检测输入文本发生改变的通知
-(void)textViewTextDidChangeOne:(NSNotification *)not{
    
    if(200-mytextView.text.length == 0){
        label_num.text = NSLocalizedString(@"字数已到", nil);
        mytextView.editable = NO;
    }else{
        label_num.text = [NSString stringWithFormat:@"%ld%@",200-mytextView.text.length,NSLocalizedString(@"字", nil)];
    }
}
#pragma mark － UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (textView == mytextView) {
        if ([textView.text isEqualToString:NSLocalizedString(@"请输入您想回复的内容", nil)]) {
            label_num.text = [NSString stringWithFormat:@"%@%@",@"200",NSLocalizedString(@"字", nil)];
            textView.text = @"";
            textView.textColor = [UIColor blackColor];
            
        }
    }
    [IQKeyboardManager sharedManager].enable = YES;
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView == mytextView) {
        if (textView.text.length == 0) {
            textView.text = NSLocalizedString(@"请输入您想回复的内容", nil);
            textView.textColor = [UIColor colorWithWhite:0.7 alpha:1];
        }
    }
}
#pragma mark - 滑动表的时候让键盘下落
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([IQKeyboardManager sharedManager].enable) {
        
    }else{
        [self.view endEditing:YES];
    }
}
#pragma mark - 这是表结束减速的时候
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [IQKeyboardManager sharedManager].enable = YES;
}
#pragma mark - 这是表开始拖动的时候
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [IQKeyboardManager sharedManager].enable = NO;
}
#pragma mark - 这是点击回复的方法
-(void)clickToReplay{
    [self.view endEditing:YES];
    NSLog(@"点击了回复的方法");
    if ([mytextView.text isEqualToString:NSLocalizedString(@"请输入您想回复的内容", nil)]) {
        [JHShowAlert showAlertWithMsg:NSLocalizedString(@"回复内容不能为空", nil)];
        return;
    }
    SHOW_HUD
    [HttpTool postWithAPI:@"biz/waimai/comment/comment/reply" withParams:@{@"comment_id":self.comment_id,@"reply":mytextView.text} success:^(id json) {
        HIDE_HUD
        NSLog(@"%@",json);
        if ([json[@"error"] isEqualToString:@"0"]) {
            if (self.myBlock) {
                self.myBlock();
            }
            if (self.delegate && [self.delegate respondsToSelector:@selector(replySuccess)]) {
                [self.delegate replySuccess];
            }
            [JHShowAlert showAlertWithTitle:NSLocalizedString(@"温馨提示", nil) withMessage:NSLocalizedString(@"回复成功", nil) withBtn_cancel:nil withBtn_sure:NSLocalizedString(@"知道了", nil) withCancelBlock:nil withSureBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }else{
            [JHShowAlert showAlertWithMsg:json[@"message"]];
        }
    } failure:^(NSError *error) {
        HIDE_HUD
        NSLog(@"%@",error.localizedDescription);
    }];
    
}
@end
