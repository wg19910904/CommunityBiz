//
//  DeliveryIntroCell.m
//  JHCommunityBiz
//
//  Created by xixixi on 16/5/19.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "DeliveryIntroCell.h"

@implementation DeliveryIntroCell
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.introTextView = [[UITextView alloc] initWithFrame:FRAME(5, 5, WIDTH-10, 140)];
        self.introTextView.textColor = HEX(@"666666", 1.0);
        self.introTextView.font = FONT(16);
        
        self.introTextView.delegate = self;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.introTextView];
    }
    return self;
}
-(void)setIsShop:(BOOL)isShop{
    _isShop = isShop;
    if (self.isShop) {
        self.introTextView.text = NSLocalizedString(@"店铺简介", nil);
    }else{
        self.introTextView.text = NSLocalizedString(@"商品简介", nil);
    }

}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if (self.isShop) {
        if ([textView.text isEqualToString:NSLocalizedString(@"店铺简介", nil)]) {
            textView.text = @"";
        }
    }else{
        if ([textView.text isEqualToString:NSLocalizedString(@"商品简介", nil)]) {
            textView.text = @"";
        }
    }
    
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length == 0) {
        if (self.isShop) {
             textView.text = NSLocalizedString(@"店铺简介", nil);
        }else{
             textView.text = NSLocalizedString(@"商品简介", nil);
        }
       
    }
}
#pragma mark - 获取高度
+ (CGFloat)getHeightWith:(NSString *)introString
{
    return 150;
}

@end
