//
//  JHTuangouDetailOfButtomView.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/7/16.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHTuangouDetailOfButtomView.h"

@implementation JHTuangouDetailOfButtomView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUISubview];
    }
    self.backgroundColor = [UIColor whiteColor];
    return self;
}
#pragma mark - 创建子视图
-(void)creatUISubview{
    //上架/下架/延期
    self.shelfBtn = [[UIButton alloc]initWithFrame:FRAME(0, 5, WIDTH/2, 40)];
    [self.shelfBtn setTitleColor:HEX(@"faaf19", 1.0f) forState:UIControlStateNormal];
    self.shelfBtn.titleLabel.font = FONT(15);
    self.shelfBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    self.backgroundColor = [UIColor redColor];
    [self addSubview:self.shelfBtn];
    //删除的按钮
    self.deleteBtn = [[UIButton alloc]initWithFrame:FRAME(WIDTH/2, 5, WIDTH/2, 40)];
    [self.deleteBtn setTitle:NSLocalizedString(@"删除", nil) forState:UIControlStateNormal];
    [self.deleteBtn setTitleColor:HEX(@"faaf19", 1.0f) forState:UIControlStateNormal];
    self.deleteBtn.titleLabel.font = FONT(15);
    [self.deleteBtn setImage:IMAGE(@"Group-purchase_delete") forState:UIControlStateNormal];
    self.deleteBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    UILabel * label = [[UILabel alloc]init];
    label.frame = FRAME(0, 5, 1, 40);
    label.backgroundColor = [UIColor colorWithWhite:0.4 alpha:1];
    [self addSubview:label];
    [self addSubview:self.deleteBtn];
}
-(void)setButtomViewType:(ETuangouProductAllModifyType)buttomViewType{
    _buttomViewType = buttomViewType;
    switch (buttomViewType) {
        case ETuanStatusShelf://已上架
            [self.shelfBtn setTitle:NSLocalizedString(@"下架", nil) forState:UIControlStateNormal];
            [self.shelfBtn setImage:IMAGE(@"Delivery_Off-the-shelf") forState:UIControlStateNormal];
            break;
         case ETuanStatusNotShelf://未上架
            [self.shelfBtn setTitle:NSLocalizedString(@"上架", nil) forState:UIControlStateNormal];
            [self.shelfBtn setImage:IMAGE(@"Delivery_on-the-shelf") forState:UIControlStateNormal];
            break;
        case ETuanStatusOverdue://延期
            [self.shelfBtn setTitle:NSLocalizedString(@"延期", nil) forState:UIControlStateNormal];
            [self.shelfBtn setImage:IMAGE(@"Delivery_delay-the-shelf") forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}
@end
