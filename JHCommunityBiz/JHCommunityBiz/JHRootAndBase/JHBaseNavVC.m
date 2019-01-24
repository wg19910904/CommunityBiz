//
//  JHBaseNavVC.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/9.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHBaseNavVC.h"

@interface JHBaseNavVC ()

@end

@implementation JHBaseNavVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationBar setBarTintColor:THEME_COLOR];
    self.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationBar.translucent = NO;
    [self.navigationBar setBackgroundImage:[UIImage new]
                            forBarPosition:UIBarPositionAny
                                barMetrics:UIBarMetricsDefault];
    self.navigationBar.shadowImage = [UIImage new];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18], NSForegroundColorAttributeName:[UIColor whiteColor]}];
}
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    NSLog(@"你开始push了哦");
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
     [super pushViewController:viewController animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
