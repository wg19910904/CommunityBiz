//
//  JHPromptMessageVC.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/24.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHPromptMessageVC.h"
#import "JHHomePageVC.h"
@implementation JHPromptMessageVC{
    NSTimer * timer;//定时器
    UILabel * label_time;//显示提示用户还有几秒跳转的
    NSInteger num;
}
-(void)viewDidLoad{
//    [super viewDidLoad];
//    //这是初始化的一些数据
//    [self initData];
//    //这是创建子视图
//    [self creatSubView];
}
#pragma mark 这是初始化的一些数据
-(void)initData{
//    self.navigationItem.title = NSLocalizedString(@"信息提示", nil);
//    num = 6;
}
//#pragma mark - 这是点击返回的方法
//-(void)clickBackBtn{
//    for (JHBaseVC * vc in self.navigationController.viewControllers) {
//        if ([vc isKindOfClass:[JHHomePageVC class]]) {
//            [self.navigationController popToViewController:vc animated:YES];
//        }
//    }
//
//}
//#pragma mrak 这是添加子视图
//-(void)creatSubView{
//    UIImageView * imageView = [[UIImageView alloc]init];
//    imageView.frame = FRAME((WIDTH - 40)/2, 40, 40, 40);
//    imageView.image = [UIImage imageNamed:@"Logon_success"];
//    [self.view addSubview:imageView];
//    UILabel * label = [[UILabel alloc]init];
//    label.frame = FRAME(0, 100, WIDTH, 100);
//    label.textColor = [UIColor colorWithWhite:0.5 alpha:1];
//    label.numberOfLines = 0;
//    label.font = [UIFont systemFontOfSize:15];
//    label.text = [NSString stringWithFormat:@"%@\n%@\n%@",NSLocalizedString(@"您的认证信息已提交成功", nil),NSLocalizedString(@"工作人员将在1-2个工作日内通过", nil),NSLocalizedString(@"邮箱或短信通知您!", nil)];
//    NSRange range = [label.text rangeOfString:NSLocalizedString(@"您的认证信息已提交成功", nil)];
//    NSMutableAttributedString * attribute = [[NSMutableAttributedString alloc]initWithString:label.text];
//    NSMutableParagraphStyle * style = [[NSMutableParagraphStyle alloc]init];
//    [style setLineSpacing:8];
//    [attribute addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, label.text.length)];
//    [attribute addAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:102/255.0 green:204/255.0 blue:33/255.0 alpha:1]} range:range];
//    label.attributedText = attribute;
//    label.textAlignment = NSTextAlignmentCenter;
//    [self.view addSubview:label];
//    label_time = [[UILabel alloc]init];
//    label_time.frame = FRAME((WIDTH - 150)/2, 230, 150, 20);
//    label_time.textAlignment = NSTextAlignmentCenter;
//    label_time.textColor = [UIColor redColor];
//    label_time.font = [UIFont systemFontOfSize:15];
//    label_time.layer.cornerRadius = 5;
//    label_time.clipsToBounds = YES;
//    [self.view addSubview:label_time];
//    [self creatNSTimer];
//}
//#pragma mark - 这是打开定时器的方法
//-(void)creatNSTimer{
//    if (timer == nil) {
//        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onTime) userInfo:nil repeats:YES];
//        [timer fire];
//    }
//}
//-(void)onTime{
//    num --;
//    if (num==0) {
//        [self stopTimer];
//        for (JHBaseVC * vc in self.navigationController.viewControllers) {
//            if ([vc isKindOfClass:[JHHomePageVC class]]) {
//                [self.navigationController popToViewController:vc animated:YES];
//            }
//        }
//    }else{
//        label_time.text = [NSString stringWithFormat:@"%ldS后自动跳转到首页!",num];
//    }
//}
//#pragma mark - 这是关闭定时的方法
//-(void)stopTimer{
//    if (timer) {
//        [timer invalidate];
//        timer = nil;
//    }
//}
@end
