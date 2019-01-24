//
//  DeliveryTemPlateVC.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/8/4.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "DeliveryTemPlateVC.h"

@interface DeliveryTemPlateVC ()
{
    UIImageView * left_imageView;
    UIImageView * right_imageView;
    UIButton * btn;
    UIImageView * left_icon;
    UIImageView * right_icon;
    
}
@end

@implementation DeliveryTemPlateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if (![JHShareModel shareModel].tmpl_type) {
        _type = @"market";
    }else{
        _type = [JHShareModel shareModel].tmpl_type;
    }

    self.navigationItem.title = NSLocalizedString(@"外送模板设置", nil);
    [self creatUIImageView];
    [self creatTrueBtn];
}
#pragma mark - 创建两个imageView的方法
-(void)creatUIImageView{
    left_imageView = [[UIImageView alloc]init];
    left_imageView.frame = FRAME(10, 10, (WIDTH - 40)/2,280);
    left_imageView.layer.borderColor = [UIColor grayColor].CGColor;
    left_imageView.layer.borderWidth = 1;
    left_imageView.image = [UIImage imageNamed:@"wai"];
    [self.view addSubview:left_imageView];
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clicktoChoseLeft)];
    left_imageView.userInteractionEnabled = YES;
    [left_imageView addGestureRecognizer:tapGesture];
    
    left_icon = [[UIImageView alloc]init];
    left_icon.frame = FRAME(0, 0, 30,30);
    left_icon.image = [UIImage imageNamed:@"select"];
    [left_imageView addSubview:left_icon];
    right_imageView = [[UIImageView alloc]init];
    right_imageView.frame = FRAME((WIDTH - 40)/2 + 30, 10, (WIDTH - 40)/2,280);
    right_imageView.layer.borderColor = [UIColor orangeColor].CGColor;
    right_imageView.layer.borderWidth = 1;
    right_imageView.image = [UIImage imageNamed:@"shop"];
    [self.view addSubview:right_imageView];
    UITapGestureRecognizer * tapGesture1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clicktoChoseRight)];
    right_imageView.userInteractionEnabled = YES;
    [right_imageView addGestureRecognizer:tapGesture1];
    right_icon = [[UIImageView alloc]init];
    right_icon.frame = FRAME(0, 0, 30,30);
    right_icon.image = [UIImage imageNamed:@"select"];
    [right_imageView addSubview:right_icon];
    if ([_type isEqualToString:@"market"]) {
        _type = @"market";
        left_imageView.layer.borderColor = [UIColor grayColor].CGColor;
        left_icon.hidden = YES;
        right_imageView.layer.borderColor = [UIColor orangeColor].CGColor;
        right_icon.hidden = NO;
    }else{
        _type = @"waimai";
        left_imageView.layer.borderColor = [UIColor orangeColor].CGColor;
        left_icon.hidden = NO;
        right_imageView.layer.borderColor = [UIColor grayColor].CGColor;
        right_icon.hidden = YES;
    }
    
}
#pragma mark - 这是选择左边的模板的方法
-(void)clicktoChoseLeft{
    _type = @"waimai";
    left_imageView.layer.borderColor = [UIColor orangeColor].CGColor;
    left_icon.hidden = NO;
    right_imageView.layer.borderColor = [UIColor grayColor].CGColor;
    right_icon.hidden = YES;

}
#pragma mark - 这是选择右边的模板的方法
-(void)clicktoChoseRight{
    _type = @"market";
    left_imageView.layer.borderColor = [UIColor grayColor].CGColor;
    left_icon.hidden = YES;
    right_imageView.layer.borderColor = [UIColor orangeColor].CGColor;
    right_icon.hidden = NO;
}
#pragma mark - 创建确定提交的按钮
-(void)creatTrueBtn{
    btn = [[UIButton alloc]init];
    btn.frame = FRAME(0, HEIGHT - 50 -64, WIDTH, 50);
    [btn setBackgroundColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor orangeColor] forState:UIControlStateSelected];
    [btn setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(clickToTrue) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark - 这是点击确认的方法
-(void)clickToTrue{
    SHOW_HUD
    NSLog(@"这是点击确认的方法>>>>>%@",_type);
    [HttpTool postWithAPI:@"biz/waimai/info/settmpl" withParams:@{@"tmpl_type":_type} success:^(id json) {
        NSLog(@"%@",json);
        if ([json[@"error"] isEqualToString:@"0"]) {
            [JHShowAlert showAlertWithMsg:NSLocalizedString(@"设置成功", nil) withBtnTitle:NSLocalizedString(@"知道了", nil) withBtnBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }else{
            [JHShowAlert showAlertWithMsg:json[@"message"]];
        }
        HIDE_HUD
    } failure:^(NSError *error) {
        HIDE_HUD
        [JHShowAlert showAlertWithMsg:NSLocalizedString(@"服务器繁忙,请稍后再试", nil)];
        NSLog(@"error>>>>%@",error.localizedDescription);
    }];
}
@end
