//
//  DeliveryReplyCell.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/7/18.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "DeliveryReplyCell.h"
@implementation DeliveryReplyCell
{
    UIButton *btn1;
    UIButton *btn2;
    UITextView *replyTextView;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style  reuseIdentifier:reuseIdentifier];
    if (self) {
        //makeUI
        [self makeUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = DEFAULT_BACKGROUNDCOLOR;
    }
    return self;
}
- (void)makeUI
{
    btn1 = [[UIButton alloc] init];
    [btn1 setTitle:NSLocalizedString(@"您的外卖已送出,请留意电话", nil) forState:(UIControlStateNormal)];
    btn1.backgroundColor = HEX(@"faaf19", 1.0);
    btn1.layer.cornerRadius = 15;
    btn1.layer.masksToBounds = YES;
    btn1.titleLabel.font = FONT(16);
    btn1.tag = 100;
    btn1.frame = FRAME(10, 10, getSize(NSLocalizedString(@"您的外卖已送出,请留意电话", nil), 30, 16).width+20, 30);
    [btn1 addTarget:self action:@selector(clickBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:btn1];
    
    btn2 = [[UIButton alloc] init];
    [btn2 setTitle:NSLocalizedString(@"不好意思,马上送到", nil) forState:(UIControlStateNormal)];
    [btn2 setTitleColor:HEX(@"333333", 1.0) forState:(UIControlStateNormal)];
    btn2.backgroundColor = [UIColor whiteColor];
    btn2.layer.cornerRadius = 15;
    btn2.layer.masksToBounds = YES;
    btn2.titleLabel.font = FONT(18);
    btn2.layer.borderColor = LINE_COLOR.CGColor;
    btn2.layer.borderWidth = 0.7;
    btn2.tag = 200;
    btn2.frame = FRAME(10, 50, getSize(NSLocalizedString(@"不好意思,马上送到", nil), 30, 18).width+20, 30);
    [btn2 addTarget:self action:@selector(clickBtn:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:btn2];
    
    replyTextView = [[UITextView alloc] initWithFrame:FRAME(0, 100, WIDTH, 250)];
    replyTextView.contentSize = CGSizeMake(300, 230);
    replyTextView.delegate = self;
    replyTextView.showsVerticalScrollIndicator = NO;
    replyTextView.showsHorizontalScrollIndicator = NO;
    replyTextView.textColor = THEME_COLOR;
    replyTextView.font = FONT(16);
//    replyTextView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
    replyTextView.text = NSLocalizedString(@"请输入您的回复内容", nil);
    [self addSubview:replyTextView];
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView.text hasPrefix:NSLocalizedString(@"请输入您的回复内容", nil)]) {
        textView.text = @"";
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView
{
    if (self.replyRefreshBlock) {
        self.replyRefreshBlock(textView.text);
    }
}
- (void)clickBtn:(UIButton *)sender
{
    NSInteger tag = sender.tag;
    if (tag == 100) {
        btn1.backgroundColor = HEX(@"faaf19", 1.0);
        [btn1 setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        btn2.backgroundColor = [UIColor whiteColor];
        [btn2 setTitleColor:HEX(@"333333", 1.0) forState:(UIControlStateNormal)];
        replyTextView.text = NSLocalizedString(@"您的外卖已送出,请留意电话", nil);
        _replyRefreshBlock(NSLocalizedString(@"您的外卖已送出,请留意电话", nil));
    }else{
        btn2.backgroundColor = HEX(@"faaf19", 1.0);
        [btn2 setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        btn1.backgroundColor = [UIColor whiteColor];
        [btn1 setTitleColor:HEX(@"333333", 1.0) forState:(UIControlStateNormal)];
        replyTextView.text = NSLocalizedString(@"不好意思,马上送到", nil);
        _replyRefreshBlock(NSLocalizedString(@"不好意思,马上送到", nil));
    }
}
@end
