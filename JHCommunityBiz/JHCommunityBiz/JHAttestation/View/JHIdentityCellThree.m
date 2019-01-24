//
//  JHIdentityCellThree.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/24.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHIdentityCellThree.h"
@implementation JHIdentityCellThree{
    UILabel * label_title;
}
-(void)setHeight:(float)height{
    _height = height;
//    self.selectionStyle = UITableViewCellSelectionStyleNone;
//    self.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
//    if (label_title == nil) {
//        label_title = [[UILabel alloc]init];
//        label_title.frame = FRAME(5, 5, WIDTH - 10, 20);
//        label_title.text = NSLocalizedString(@"以下情况需要您补充资质:", nil);
//        label_title.font = [UIFont systemFontOfSize:13];
//        label_title.textColor = [UIColor colorWithWhite:0.3 alpha:1];
//        [self addSubview:label_title];
//        UILabel * label = [[UILabel alloc]init];
//        label.frame = FRAME(5, 20, WIDTH - 10, height);
//        label.textColor = [UIColor colorWithWhite:0.6 alpha:1];
//        label.font = [UIFont systemFontOfSize:13];
//        label.text = [NSString stringWithFormat:@"%@\n%@\n%@",@"1.若您上传的身份证非营业执照上法人本人/若您的营业执照公司名称和地址与点评收录的门店信息出入较大,建议您下载经营权说明书模板,按格式填写后拍照上传",@"2.若您的店名与品牌相关,需补充上传品牌授权/加盟书",@"3.若您的门店与开锁(锁具)相关,请上传<<特种经营许可证>>"];
//        label.numberOfLines = 0;
//        NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc]initWithString:label.text];
//        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc]init];
//        [paragraphStyle setLineSpacing:5];
//        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [label.text length])];
//        label.attributedText = attributedString;
//        [self addSubview:label];
//        //创建显示是否阅读同意书的
//        self.label_text = [[UILabel alloc]init];
//        self.label_text.frame = FRAME(40, height+30, WIDTH - 50, 20);
//        self.label_text.text = NSLocalizedString(@"我已阅读并已同意<<社区合作协议>>", nil);
//        self.label_text.font = [UIFont systemFontOfSize:13];
//        self.label_text.textColor = [UIColor colorWithWhite:0.6 alpha:1];
//        NSRange range = [self.label_text.text rangeOfString:NSLocalizedString(@"社区合作协议", nil)];
//        NSMutableAttributedString * attribut = [[NSMutableAttributedString alloc]initWithString:self.label_text.text];
//        [attribut addAttributes:@{NSForegroundColorAttributeName:THEME_COLOR} range:range];
//        self.label_text.attributedText = attribut;
//        [self addSubview:self.label_text];
//        //创建打对勾的button
//        self.btn = [[UIButton alloc]init];
//        self.btn.frame = FRAME(10, height + 30, 20, 20);
//        self.btn.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:1].CGColor;
//        self.btn.layer.borderWidth = 0.5;
//        self.btn.backgroundColor = [UIColor whiteColor];
//        [self addSubview:self.btn];
//    }
}
@end
