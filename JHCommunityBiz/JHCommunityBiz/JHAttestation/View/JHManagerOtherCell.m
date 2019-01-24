//
//  JHManagerOtherCell.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/23.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHManagerOtherCell.h"

@implementation JHManagerOtherCell{
    NSArray * textArray;//存放单元格的textLabel的text
}
-(void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
    //self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if(textArray == nil){
        /*
        textArray = @[NSLocalizedString(@"营业类型", nil),NSLocalizedString(@"营业地址", nil),NSLocalizedString(@"营业执照", nil),NSLocalizedString(@"营业招牌", nil),NSLocalizedString(@"店铺内景", nil)];
        detailArray = @[NSLocalizedString(@"请选择", nil),NSLocalizedString(@"请选择", nil),NSLocalizedString(@"未上传", nil),NSLocalizedString(@"未上传", nil),NSLocalizedString(@"未上传", nil)];
         */
        textArray = @[ NSLocalizedString(@"身份认证", NSStringFromClass([self class])),
                        NSLocalizedString(@"个人工商户营业执照", NSStringFromClass([self class])),
                        NSLocalizedString(@"餐饮服务许可证", NSStringFromClass([self class]))];
    }
    if (self.label_left == nil) {
        self.label_left = [[UILabel alloc]init];
        self.label_left.frame = FRAME(10, 12, 150, 20);
        self.label_left.text = textArray[indexPath.row ];
        self.label_left.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        self.label_left.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.label_left];
    }
    if (self.label_right == nil) {
        self.label_right = [[UILabel alloc]init];
        self.label_right.frame = FRAME(160, 12, WIDTH - 190, 20);
        self.label_right.text = _detailArray[indexPath.row];
        self.label_right.textAlignment = NSTextAlignmentRight;
        self.label_right.font = [UIFont systemFontOfSize:13];
        self.label_right.textColor = THEME_COLOR;
        [self addSubview:self.label_right];
        //创建分割线
        UIView * label_line = [[UIView alloc]init];
        label_line.frame = FRAME(0, 43.5, WIDTH, 0.5);
        label_line.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        [self addSubview:label_line];
    }
}
@end
