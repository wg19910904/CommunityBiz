//
//  JHShopReplyCellTwo.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/25.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHShopReplyCellTwo.h"

@implementation JHShopReplyCellTwo
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (_textView == nil) {
        self.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _textView = [[UITextView alloc]init];
        _textView.frame = FRAME(15, 10, WIDTH - 30, 100);
        _textView.layer.cornerRadius = 3;
        _textView.layer.masksToBounds  = YES;
        _textView.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:1].CGColor;
        _textView.layer.borderWidth = 1;
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.text = NSLocalizedString(@"请输入您想回复的内容", nil);
        _textView.textColor = [UIColor colorWithWhite:0.7 alpha:1];
        [self addSubview:_textView];
        self.label = [[UILabel alloc]init];
        self.label.frame = FRAME(WIDTH - 55, 85, 50, 20);
        self.label.text = [NSString stringWithFormat:@"200%@",NSLocalizedString(@"字", nil)];
        self.label.font= [UIFont systemFontOfSize:13];
        self.label.adjustsFontSizeToFitWidth = YES;
        self.label.textColor = [UIColor colorWithWhite:0.5 alpha:1];
        [self addSubview:self.label];
    }
    
}

@end
