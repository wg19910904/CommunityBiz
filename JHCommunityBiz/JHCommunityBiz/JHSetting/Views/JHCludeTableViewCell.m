//
//  JHCludeTableViewCell.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/7/25.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHCludeTableViewCell.h"

@implementation JHCludeTableViewCell
{
    NSString * plat_id;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(JHCludeModel *)model{
    _model = model;
    if (self.title_label == nil) {
        self.title_label = [[UILabel alloc]init];
        self.title_label.frame = FRAME(10, 12, WIDTH - 230, 20);
        [self addSubview:self.title_label];
        self.title_label.font = FONT(15);
        self.title_label.textColor = [UIColor colorWithWhite:0.3 alpha:1];
    }
    self.title_label.text = model.title;
    if(self.btn_set == nil){
        self.btn_set = [[UIButton alloc]initWithFrame:FRAME(WIDTH - 210, 6, 60, 30)];
        self.btn_set.layer.borderColor = THEME_COLOR.CGColor;
        self.btn_set.layer.borderWidth = 1;
        self.btn_set.layer.cornerRadius = 3;
        self.btn_set.clipsToBounds = YES;
        [self.btn_set setTitleColor:THEME_COLOR forState:UIControlStateNormal];
        self.btn_set.titleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.btn_set];
    }

    if ([model.status isEqualToString:@"1"]) {
        [self.btn_set setTitle:NSLocalizedString(@"已启用", nil) forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"yunPrintState"];
        
    }else{
        [self.btn_set setTitle:NSLocalizedString(@"启用", nil) forState:UIControlStateNormal];
    }
    self.btn_set.tag = self.indexPath.row;
    if(self.btn_revise == nil){
        self.btn_revise = [[UIButton alloc]initWithFrame:FRAME(WIDTH - 140, 6, 60, 30)];
        self.btn_revise.layer.borderColor = THEME_COLOR.CGColor;
        self.btn_revise.layer.borderWidth = 1;
        self.btn_revise.layer.cornerRadius = 3;
        self.btn_revise.clipsToBounds = YES;
        [self.btn_revise setTitle:NSLocalizedString(@"修改", nil) forState:UIControlStateNormal];
        [self.btn_revise setTitleColor:THEME_COLOR forState:UIControlStateNormal];
        self.btn_revise.titleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.btn_revise];
    }
    self.btn_revise.tag = self.indexPath.row;
    if(self.btn_delete == nil){
        self.btn_delete = [[UIButton alloc]initWithFrame:FRAME(WIDTH - 70, 6, 60, 30)];
        self.btn_delete.layer.borderColor = THEME_COLOR.CGColor;
        self.btn_delete.layer.borderWidth = 1;
        self.btn_delete.layer.cornerRadius = 3;
        self.btn_delete.clipsToBounds = YES;
        [self.btn_delete setTitle:NSLocalizedString(@"删除", nil) forState:UIControlStateNormal];
        [self.btn_delete setTitleColor:THEME_COLOR forState:UIControlStateNormal];
        self.btn_delete.titleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.btn_delete];
    }
    self.btn_delete.tag = self.indexPath.row;
}
@end
