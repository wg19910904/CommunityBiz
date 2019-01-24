//
//  JHReplyCellTwo.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/13.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHReplyCellTwo.h"

@implementation JHReplyCellTwo

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (_textView == nil) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _textView = [[UITextView alloc]init];
        _textView.frame = FRAME(15, 10, WIDTH - 30, 100);
        _textView.layer.cornerRadius = 3;
        _textView.layer.masksToBounds  = YES;
        _textView.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
        _textView.text = NSLocalizedString(@"请输入您想回复的内容", nil);
        _textView.textColor = [UIColor colorWithWhite:0.7 alpha:1];
        _textView.font = FONT(15);
        [self addSubview:_textView];
        self.label = [[UILabel alloc]init];
        self.label.frame = FRAME(WIDTH - 55, 85, 50, 20);
        self.label.text = NSLocalizedString(@"200字", nil);
        self.label.font= [UIFont systemFontOfSize:13];
        self.label.adjustsFontSizeToFitWidth = YES;
        self.label.textColor = [UIColor colorWithWhite:0.5 alpha:1];
//        [self addSubview:self.label];
    }
    
}

@end
