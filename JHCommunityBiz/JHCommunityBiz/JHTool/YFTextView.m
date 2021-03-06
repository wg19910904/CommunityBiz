//
//  YFTextView.m
//  JHWaiMaiUpdate
//
//  Created by jianghu3 on 16/6/27.
//  Copyright © 2016年 jianghu2. All rights reserved.
//

#import "YFTextView.h"

@interface YFTextView()<UITextViewDelegate>
@property(nonatomic,strong)UITextView *textView;
@property(nonatomic,weak)UILabel *placeholderLab;
@property(nonatomic,weak)UILabel *countLab;
@property(nonatomic,weak)UIButton *clearBtn;

@end

@implementation YFTextView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self configUI];
    }
    return self;
}

-(void)configUI{

    UITextView *textView=[[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    textView.delegate=self;
    [self addSubview:textView];
    self.textView=textView;
    textView.textColor=HEX(@"333333", 1.0);
    textView.font=FONT(14);
    [textView setTextContainerInset:UIEdgeInsetsMake(10, 5, 10, 5)];

    UILabel *lab=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.width-20, 20)];
    [self addSubview:lab];
    self.placeholderLab=lab;
    self.placeholderLab.hidden=YES;
    lab.textColor=HEX(@"999999", 1.0);
    lab.font=FONT(14);
    
    UILabel *countLab=[[UILabel alloc] initWithFrame:CGRectMake(10, self.height-20-10,self.width-20, 20)];
    [self addSubview:countLab];
    self.countLab=countLab;
    self.countLab.hidden=YES;
    countLab.textAlignment=NSTextAlignmentRight;
    countLab.textColor=HEX(@"999999", 1.0);
    countLab.font=FONT(14);
    
    UIButton *clearBtn=[UIButton new];
    [self addSubview:clearBtn];
    [clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset=-20;
        make.centerY.offset=0;
        make.width.offset=20;
        make.height.offset=20;
    }];
    clearBtn.layer.cornerRadius=10;
    clearBtn.clipsToBounds=YES;
    [clearBtn setImage:IMAGE(@"receivables_cancel") forState:UIControlStateNormal];
    clearBtn.backgroundColor=HEX(@"ffffff",1.0);
    [clearBtn addTarget:self action:@selector(clearText) forControlEvents:UIControlEventTouchUpInside];
    clearBtn.hidden=YES;
    self.clearBtn=clearBtn;
    
}

//通过判断表层TextView的内容来实现底层TextView的显示于隐藏
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@" "]) return NO;
    
    //删除到最后一个字
    if([text isEqualToString:@""]  && range.location==0) [self.placeholderLab setHidden:NO];
    else if([text isEqualToString:@""] ){
        return YES;
    }
    //写入
    if(![text isEqualToString:@""]) self.placeholderLab.hidden=YES;
    
    if (textView.text.length >=self.maxCount) return NO;
    
    //回车
    if ([text isEqualToString:@"\n"]) {
        if (textView.text.length==0) self.placeholderLab.hidden=NO;
        [textView resignFirstResponder];
        return NO;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self textViewDidChange:textView];
    });
    
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView{
    if(textView.text.length>0) {
        self.placeholderLab.hidden=YES;
        if(self.showClearBtn) self.clearBtn.hidden=NO;
    } else {
        if(self.placeholderAutoCenterY) self.showPlaceholdInVerticalCenter=YES;
        self.clearBtn.hidden=YES;
    }
    
    if (textView.text.length > self.maxCount) {
        self.countLab.text=[NSString stringWithFormat: NSLocalizedString(@"还可以输入0字", NSStringFromClass([self class]))];
          textView.text=[textView.text substringToIndex:self.maxCount];
    }else  {
       self.countLab.text=[NSString stringWithFormat: NSLocalizedString(@"还可以输入%ld字", NSStringFromClass([self class])),self.maxCount - textView.text.length];
    }
}


-(void)clearText{
    self.placeholderLab.hidden=NO;
//    self.maxCount=self.maxCount;
    if (self.hiddenCountLab) self.countLab.hidden=YES;
    if (self.placeholderAutoCenterY) self.showPlaceholdInVerticalCenter=YES;
    self.clearBtn.hidden=YES;
    self.textView.text=@"";
}

#pragma mark ======setter and getter=======

-(void)setTextFont:(float)textFont{
    _textFont=textFont;
    self.textView.font=FONT(textFont);
}

-(void)setPlaceholderFont:(float)placeholderFont{
    _placeholderFont=placeholderFont;
    self.placeholderLab.font=[UIFont systemFontOfSize:placeholderFont];
}
-(void)setPlaceholderStr:(NSString *)placeholderStr{
    self.placeholderLab.hidden=NO;
    _placeholderStr=placeholderStr;
    self.placeholderLab.text=placeholderStr;
}

-(NSString *)inputText{
    return self.textView.text;
}

-(void)setInputText:(NSString *)inputText{
    self.textView.text=inputText;
    if (inputText.length > 0) {
        self.placeholderLab.hidden=YES;
        self.clearBtn.hidden=!self.showClearBtn;
    }
    [self textViewDidChange:self.textView];
}

-(void)setMaxCount:(NSInteger)maxCount{
    self.countLab.hidden=NO;
    _maxCount=maxCount;
    self.countLab.text=[NSString stringWithFormat: NSLocalizedString(@"还可以输入%ld字", NSStringFromClass([self class])),maxCount];
}

-(void)setBackgroundColor:(UIColor *)backgroundColor{
    self.textView.backgroundColor=backgroundColor;
}

-(void)setShowClearBtn:(BOOL)showClearBtn{
    _showClearBtn=showClearBtn;
}
-(void)setPlaceholderColor:(UIColor *)placeholderColor{
    _placeholderColor=placeholderColor;
    self.placeholderLab.textColor=placeholderColor;
}

-(void)setHiddenCountLab:(BOOL)hiddenCountLab{
    _hiddenCountLab=hiddenCountLab;
    self.countLab.hidden=hiddenCountLab;
}

-(void)setPlaceholderAutoCenterY:(BOOL)placeholderAutoCenterY{
    _placeholderAutoCenterY=placeholderAutoCenterY;
    self.showPlaceholdInVerticalCenter=YES;
}


-(void)setShowsVerticalScrollIndicator:(BOOL)showsVerticalScrollIndicator{
    _showsVerticalScrollIndicator=showsVerticalScrollIndicator;
    self.textView.showsVerticalScrollIndicator=showsVerticalScrollIndicator;
}

-(void)setShowPlaceholdInVerticalCenter:(BOOL)showPlaceholdInVerticalCenter{
    _showPlaceholdInVerticalCenter=showPlaceholdInVerticalCenter;
    if (showPlaceholdInVerticalCenter) {
        self.placeholderLab.centerY=self.height/2.0;
        float margin=(self.height-20)/2.0-10;
        [self.textView setTextContainerInset:UIEdgeInsetsMake(margin, 5, margin, 5)];
    } else{
        self.placeholderLab.y=5;
        [self.textView setTextContainerInset:UIEdgeInsetsMake(5, 5, 5, 5)];
    }
}

-(void)setKeyboardType:(UIKeyboardType)keyboardType{
    _keyboardType=keyboardType;
    self.textView.keyboardType=keyboardType;
}

@end
