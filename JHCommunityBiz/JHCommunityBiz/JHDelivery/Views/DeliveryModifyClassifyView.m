//
//  DeliveryAddClassifyView.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/6/29.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "DeliveryModifyClassifyView.h"
#define CenterView_WIDTH  WIDTH - 60
@implementation DeliveryModifyClassifyView
{
    UIView *centerView;
    UILabel *titleL;
    UILabel *subL;
    UITextField *classifyField;
    UITextField *sortNumField;
    UIButton *cancelBtn;
    UIButton *sureBtn;
    NSString *cate_id;
}
- (instancetype)initWithTitle:(NSString *)title
                 withSubTitle:(NSString *)subTitle
              withRemindTitle:(NSString *)remindTitle
              withCancelBlock:(void(^)())cancelBlock
                withSureBlock:(void(^)())sureBlock
                withCateTitle:(NSString *)cateTitle
                  withOrderBy:(NSString *)orderBy
                  withCate_id:(NSString *)cateid
{
    self = [super init];
    if (self) {
        //添加子控件
        self.frame = FRAME(0, 0, WIDTH, HEIGHT - 64);
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBack:)]];
        self.backgroundColor = HEX(@"000000", 0.3);
        [self makeUIWithTitle:title
                 withSubTitle:subTitle
              withRemindTitle:remindTitle
                withCateTitle:cateTitle
                  withOrderBy:orderBy];
        self.cancelB = cancelBlock;
        self.sureB = sureBlock;
        cate_id = cateid;
        [cancelBtn addTarget:self action:@selector(clickCancelBtn) forControlEvents:(UIControlEventTouchUpInside)];
        [sureBtn addTarget:self action:@selector(clickSureBtn) forControlEvents:(UIControlEventTouchUpInside)];
        self.urlLink=@"biz/waimai/product/cate/update";
    }
    
    return self;
}
- (void)makeUIWithTitle:(NSString *)title
           withSubTitle:(NSString *)subTitle
        withRemindTitle:(NSString *)remindTitle
          withCateTitle:(NSString *)cateTitle
            withOrderBy:(NSString *)orderBy
{
    if (subTitle.length > 0) {
        centerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CenterView_WIDTH, 205)];
        centerView.layer.cornerRadius = 5;
        centerView.layer.masksToBounds = YES;
        centerView.backgroundColor = [UIColor whiteColor];
        titleL = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, CenterView_WIDTH - 20, 30)];
        titleL.textColor = HEX(@"333333", 1.0f);
        titleL.font = FONT(16);
        titleL.text = title;
        titleL.textAlignment = NSTextAlignmentLeft;
        [centerView addSubview:titleL];
        
        subL = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, CenterView_WIDTH-20, 30)];
        subL.textColor = THEME_COLOR;
        subL.font = FONT(14);
        subL.textAlignment = NSTextAlignmentLeft;
        subL.text = subTitle;
        [centerView addSubview:subL];
        
        classifyField = [[UITextField alloc] initWithFrame:CGRectMake(10, 65, CenterView_WIDTH - 20, 35)];
        classifyField.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
        classifyField.textColor = THEME_COLOR;
        classifyField.font = FONT(14);
        classifyField.placeholder = remindTitle;
        classifyField.text = cateTitle;
        UIView *leftview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 35)];
        classifyField.leftViewMode = UITextFieldViewModeAlways;
        classifyField.leftView = leftview;
        classifyField.backgroundColor = HEX(@"eeeeee", 1.0);
        classifyField.layer.cornerRadius = 3;
        classifyField.layer.masksToBounds = YES;
        classifyField.layer.borderWidth = 0.7;
        classifyField.layer.borderColor = LINE_COLOR.CGColor;
        [centerView addSubview:classifyField];
        
        //添加排序
        sortNumField = [[UITextField alloc] initWithFrame:CGRectMake(10, 115, 100, 35)];
        sortNumField.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
        sortNumField.textColor = THEME_COLOR;
        sortNumField.font = FONT(14);
        sortNumField.placeholder = NSLocalizedString(@"排序号", nil);
        sortNumField.text = orderBy;
        UIView *leftview1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 35)]; //此处必须从新创建
        sortNumField.leftViewMode = UITextFieldViewModeAlways;
        sortNumField.leftView = leftview1;
        sortNumField.backgroundColor = HEX(@"eeeeee", 1.0);
        sortNumField.layer.cornerRadius = 3;
        sortNumField.layer.masksToBounds = YES;
        sortNumField.layer.borderWidth = 0.7;
        sortNumField.layer.borderColor = LINE_COLOR.CGColor;
        [centerView addSubview:sortNumField];
        
        //添加右侧提示
        UILabel *remindLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 115, 150, 35)];
        remindLabel.text = NSLocalizedString(@"提示:数字越小越靠前", nil);
        remindLabel.textColor = THEME_COLOR;
        remindLabel.font = FONT(13);
        [centerView addSubview:remindLabel];
        self.remindLabel=remindLabel;
        
        //添加取消按钮
        CGFloat button_width = (CenterView_WIDTH - 30) / 2;
        cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 165, button_width, 40)];
        cancelBtn.backgroundColor = [UIColor whiteColor];
        [cancelBtn setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor colorWithHex:@"eb6100" alpha:1.0] forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = FONT(16);
        [centerView addSubview:cancelBtn];
        
        //添加确定按钮
        sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(button_width + 20, 165, button_width, 40)];
        [sureBtn setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
        [sureBtn setTitleColor:THEME_COLOR forState:UIControlStateNormal];
        sureBtn.titleLabel.font = FONT(16);
        sureBtn.layer.cornerRadius = 4;
        sureBtn.layer.masksToBounds = YES;
        [centerView addSubview:sureBtn];
        
        //添加分割线
        CALayer *line1 = [CALayer layer];
        line1.frame = FRAME(0, 165, CenterView_WIDTH, 0.5);
        line1.backgroundColor = LINE_COLOR.CGColor;
        [centerView.layer addSublayer:line1];
        
        CALayer *line2 = [CALayer layer];
        line2.frame = FRAME(CenterView_WIDTH/2, 165, 0.5, 40);
        line2.backgroundColor = LINE_COLOR.CGColor;
        [centerView.layer addSublayer:line2];
        
        
    }else{
        
        centerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CenterView_WIDTH, 180)];
        centerView.layer.cornerRadius = 5;
        centerView.layer.masksToBounds = YES;
        centerView.backgroundColor = [UIColor whiteColor];
        
        titleL = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, CenterView_WIDTH - 20, 40)];
        titleL.textColor = HEX(@"333333", 1.0f);
        titleL.font = FONT(16);
        titleL.text = title;
        titleL.textAlignment = NSTextAlignmentLeft;
        [centerView addSubview:titleL];
        
        classifyField = [[UITextField alloc] initWithFrame:CGRectMake(10, 40, CenterView_WIDTH - 20, 35)];
        classifyField.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
        classifyField.textColor = THEME_COLOR;
        classifyField.font = FONT(14);
        classifyField.placeholder = remindTitle;
        classifyField.text = cateTitle;
        UIView *leftview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 35)];
        classifyField.leftViewMode = UITextFieldViewModeAlways;
        classifyField.leftView = leftview;
        classifyField.backgroundColor = HEX(@"eeeeee", 1.0);
        classifyField.layer.cornerRadius = 3;
        classifyField.layer.masksToBounds = YES;
        classifyField.layer.borderWidth = 0.7;
        classifyField.layer.borderColor = LINE_COLOR.CGColor;
        [centerView addSubview:classifyField];
        
        //添加排序
        sortNumField = [[UITextField alloc] initWithFrame:CGRectMake(10, 85, 100, 35)];
        sortNumField.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
        sortNumField.textColor = THEME_COLOR;
        sortNumField.font = FONT(14);
        sortNumField.placeholder = NSLocalizedString(@"排序号", nil);
        sortNumField.text = orderBy;
        UIView *leftview1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 35)]; //此处必须从新创建
        sortNumField.leftViewMode = UITextFieldViewModeAlways;
        sortNumField.leftView = leftview1;
        sortNumField.backgroundColor = HEX(@"eeeeee", 1.0);
        sortNumField.layer.cornerRadius = 3;
        sortNumField.layer.masksToBounds = YES;
        sortNumField.layer.borderWidth = 0.7;
        sortNumField.layer.borderColor = LINE_COLOR.CGColor;
        [centerView addSubview:sortNumField];
        
        //添加右侧提示
        UILabel *remindLabel = [[UILabel alloc] initWithFrame:CGRectMake(120, 85, 150, 35)];
        remindLabel.text = NSLocalizedString(@"提示:数字越小越靠前", nil);
        remindLabel.textColor = THEME_COLOR;
        remindLabel.font = FONT(13);
        [centerView addSubview:remindLabel];
        
        //添加取消按钮
        CGFloat button_width = (CenterView_WIDTH - 30) / 2;
        cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 140, button_width, 40)];
        cancelBtn.backgroundColor = [UIColor whiteColor];
        [cancelBtn setTitle:NSLocalizedString(@"取消", nil) forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor colorWithHex:@"eb6100" alpha:1.0] forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = FONT(16);
        [centerView addSubview:cancelBtn];
        
        //添加确定按钮
        sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(button_width + 20, 140, button_width, 40)];
        
        [sureBtn setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
        [sureBtn setTitleColor:THEME_COLOR forState:UIControlStateNormal];
        sureBtn.titleLabel.font = FONT(16);
        sureBtn.layer.cornerRadius = 4;
        sureBtn.layer.masksToBounds = YES;
        [centerView addSubview:sureBtn];
        
        //添加分割线
        CALayer *line1 = [CALayer layer];
        line1.frame = FRAME(0, 140, CenterView_WIDTH, 0.5);
        line1.backgroundColor = LINE_COLOR.CGColor;
        [centerView.layer addSublayer:line1];
        
        CALayer *line2 = [CALayer layer];
        line2.frame = FRAME(CenterView_WIDTH/2, 140, 0.5, 40);
        line2.backgroundColor = LINE_COLOR.CGColor;
        [centerView.layer addSublayer:line2];
        
    }
    [self addSubview:centerView];
    centerView.center = self.center;
}

- (void)clickCancelBtn
{
    if (self.cancelB) {
        self.cancelB();
    }
}

- (void)clickSureBtn
{
    //获取参数
    NSString *title = classifyField.text;
    NSString *sort_num = sortNumField.text;
    if (title.length == 0 || sort_num.length == 0) {
        [JHShowAlert showAlertWithMsg:NSLocalizedString(@"请填写完整信息", nil)];
        return;
    }
    SHOW_HUD_IN_SELF
    NSMutableDictionary *paramDic = @{@"title":title,
                                      @"cate_id":cate_id}.mutableCopy;
    
    if(self.is_sub){
        paramDic[@"number"]=sort_num;
        paramDic[@"zhuohao_id"]=self.zhuohao_id;
    }else{
        paramDic[@"orderby"]=sort_num;
    }
    [HttpTool postWithAPI:self.urlLink
               withParams:paramDic
                  success:^(id json) {
                      HIDE_HUD_IN_SELF
                      NSLog(@"修改--%@",json);
                      if ([json[@"error"] isEqualToString:@"0"]) {
                          if (self.sureB) {
                              self.sureB();
                          }
                      }else{
                          [JHShowAlert showAlertWithMsg:json[@"messagez"]];
                      }
                      
                  }
                  failure:^(NSError *error) {
                      HIDE_HUD_IN_SELF
                      [JHShowAlert showAlertWithMsg:NSLocalizedString(@"服务器连接异常", nil)];
                      
                  }];
}
- (void)tapBack:(UITapGestureRecognizer *)gesture
{
    [self endEditing:YES];
}

-(void)setNumPlaceHolder:(NSString *)numPlaceHolder{
    _numPlaceHolder=numPlaceHolder;
    sortNumField.placeholder=numPlaceHolder;
}

@end
