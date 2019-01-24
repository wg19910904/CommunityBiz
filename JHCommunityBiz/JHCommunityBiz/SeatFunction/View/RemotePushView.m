//
//  RemotePushView.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/11/4.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "RemotePushView.h"

@implementation RemotePushView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+(RemotePushView *)showView{
    RemotePushView * view = [[RemotePushView alloc]init];
    [view showWithView:view];
    return view;
}
-(void)showWithView:(RemotePushView *)view{
    view.frame = FRAME(10, -75, WIDTH - 20, 75);
    view.layer.cornerRadius =9;
    view.layer.masksToBounds = YES;
    view.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    //添加图标
    [view addSubview:self.imageV];
    //显示app名字
    [view addSubview:self.nameL];
    //添加显示现在的
    [view addSubview:self.label];
    //添加显示提示完成的
    [view addSubview:self.completionL];
    [UIView animateWithDuration:0.3 animations:^{
       view.frame = FRAME(10, 20, WIDTH - 20, 75);
    }];
    
    
}
//显示商家图标de
-(UIImageView *)imageV{
    if (!_imageV) {
        _imageV = [[UIImageView alloc]init];
        _imageV.frame = FRAME(5, 5, 27.5, 27.5);
        _imageV.layer.cornerRadius = 3;
        _imageV.layer.masksToBounds = YES;
        _imageV.image = [UIImage imageNamed:@"remote"];
    }
    return _imageV;
}
//显示app名字
-(UILabel *)nameL{
    if (!_nameL) {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        // app名称
        NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
        // app版本
        _nameL = [[UILabel alloc]init];
        _nameL.frame = FRAME(43, 5, app_Name.length*12+10, 20);
        _nameL.textColor = [UIColor colorWithWhite:0.3 alpha:0.8];
        _nameL.font = FONT(12);
        _nameL.text = app_Name;
    }
    return _nameL;
}
//显示现在
-(UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc]init];
        _label.frame = FRAME(WIDTH - 65, 5, 30, 20);
        _label.textColor = [UIColor colorWithWhite:0.3 alpha:0.8];
        _label.font = FONT(12);
        _label.text = NSLocalizedString(@"现在", NSStringFromClass([self class]));
    }
    return _label;
}
//提示支付完成的显示
-(UILabel *)completionL{
    if (!_completionL) {
        _completionL = [[UILabel alloc]init];
        _completionL.frame = FRAME(0, 37.5, WIDTH - 20, 37.5);
        _completionL.textColor = [UIColor colorWithWhite:0 alpha:0.8];
        _completionL.font = FONT(14);
        _completionL.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
        
    }
    return _completionL;
}
@end
