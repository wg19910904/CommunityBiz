//
//  JHManagerAttentationCell.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/23.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHManagerAttentationCell.h"

@implementation JHManagerAttentationCell
-(void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    //创建分割线
    UIView * labe_line = [[UIView alloc]init];
    labe_line.frame = FRAME(0, 43.5, WIDTH, 0.5);
    labe_line.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    [self addSubview:labe_line];
    if (self.myTextField == nil) {
        UILabel * label = [[UILabel alloc]init];
        label.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        label.frame = FRAME(10, 12, 80, 20);
        label.font = [UIFont systemFontOfSize:15];
        [self addSubview:label];
        self.myTextField = [[UITextField alloc]init];
        self.myTextField.frame = FRAME(100, 7, WIDTH - 100, 30);
        self.myTextField.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.myTextField];
        if (indexPath.row == 0) {
            label.text =  NSLocalizedString(@"工商注册号", NSStringFromClass([self class]));
            self.myTextField.placeholder =  NSLocalizedString(@"请与营业执照上信息保持一致", NSStringFromClass([self class]));
            //创建分割线
            UIView * labe_line = [[UIView alloc]init];
            labe_line.frame = FRAME(0, 0, WIDTH, 0.5);
            labe_line.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
            [self addSubview:labe_line];
        }else{
            label.text =  NSLocalizedString(@"公司名称", NSStringFromClass([self class]));
            self.myTextField.placeholder =  NSLocalizedString(@"请填写营业执照上字号名称", NSStringFromClass([self class]));
        }
    }
}
@end
