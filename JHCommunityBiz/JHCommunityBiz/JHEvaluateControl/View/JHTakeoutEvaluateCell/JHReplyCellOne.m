//
//  JHReplyCell.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/13.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHReplyCellOne.h"
#import <UIImageView+WebCache.h>
#import "HZQChangeDateLine.h"
@implementation JHReplyCell
{
    UIView * bj_view;//白色的背景view
    UIImageView * imageHead;//头像
    UILabel * label_phone;//显示用户号码的
    UIView * starViewOne;//星星1
    UIView * starViewTwo;//星星2
    UILabel * label_comeTiem;//显示准时送达的时间
    UILabel * label_evaluate;//显示评价内容的
    UIImageView * photo1;//照片1
    UIImageView * photo2;//照片2
    UIImageView * photo3;//照片3
    UIImageView * photo4;//照片4
    UILabel * label_evaluateTime;//显示评价时间的
    UIView * view_replay;//回复内容的View
    UILabel * label_reply;//回复内容的
    UILabel * label_replyTime;//显示回复时间的
    UIImageView * replayImageView;//回复的小三角形
    DisplayImageInView * displayView;//这是展示大图
    UIView * starViewThree;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setHeight:(float)height{
    _height = height;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    if (bj_view == nil) {
        bj_view = [[UIView alloc]init];
        bj_view.backgroundColor = [UIColor whiteColor];
        [self addSubview:bj_view];
        [bj_view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(0);
            make.left.offset(0);
            make.right.offset(-0);
            make.bottom.offset(-10);
        }];
        //创建第一根分割线
        UIView * label_lineOne = [[UIView alloc]init];
        label_lineOne.frame = CGRectMake(0, 0, WIDTH, 0.5);
        label_lineOne.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        [bj_view addSubview:label_lineOne];
        //创建第二根分割线
        UIView * label_lineTwo = [[UIView alloc]init];
        label_lineTwo.frame = FRAME(0, 29.5, WIDTH, 0.5);
        label_lineTwo.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        [bj_view addSubview:label_lineTwo];
    }
    if(imageHead == nil){
        //显示用户头像的
        imageHead = [[UIImageView alloc]init];
        imageHead.frame = FRAME(10, 5, 20, 20);
        imageHead.layer.cornerRadius = 10;
        imageHead.clipsToBounds = YES;
        [self addSubview:imageHead];
        //显示用户号码的
        label_phone = [[UILabel alloc]init];
        label_phone.frame = FRAME(40, 5, WIDTH - 50, 20);
        label_phone.textColor = [UIColor colorWithWhite:0.5 alpha:1];
        label_phone.font = [UIFont systemFontOfSize:13];
        [bj_view addSubview:label_phone];
        //创建显示服/味道/配/这的三个图
        NSArray * array = @[@"zon",@"evaluation01",@"evaluation02",@"evaluation03"];
        for(int i = 0; i < 4;i ++){
            UIImageView * imageView = [[UIImageView alloc]init];
            imageView.frame = FRAME(10+(13+80)*(i%2), 35+(18)*(i/2), 13, 13);
            imageView.image = [UIImage imageNamed:array[i]];
            [bj_view addSubview:imageView];
        }
    }
    [imageHead sd_setImageWithURL:[NSURL URLWithString:self.face] placeholderImage:[UIImage imageNamed:@"evaluateHead"]];
     label_phone.text = self.nickname;
    if (starViewOne) {
        [starViewOne removeFromSuperview];
        starViewOne = nil;
    }
    if (starViewTwo ) {
        [starViewTwo removeFromSuperview];
        starViewTwo = nil;
    }
    //创建星星
    if (starViewOne == nil) {
        starViewOne = [StarView addEvaluateViewWithStarNO:[self.score integerValue] withStarSize:10 withBackViewFrame:FRAME(30, 32, 80, 10)];
        [bj_view addSubview:starViewOne];
        starViewTwo = [StarView addEvaluateViewWithStarNO:[self.score_fuwu integerValue] withStarSize:10 withBackViewFrame:FRAME(130, 32, 80, 10)];
        [bj_view addSubview:starViewTwo];
        starViewThree = [StarView addEvaluateViewWithStarNO:[self.score_kouwei integerValue] withStarSize:10 withBackViewFrame:FRAME(30, 50, 100, 10)];
        [bj_view addSubview:starViewThree];

    }
    if (label_comeTiem) {
        [label_comeTiem removeFromSuperview];
        label_comeTiem = nil;
        [label_evaluate removeFromSuperview];
        label_evaluate = nil;
    }
    //创建准时送达
    if(label_comeTiem == nil){
        label_comeTiem = [[UILabel alloc]init];
        label_comeTiem.frame = FRAME(130, 50, 200, 20);
        label_comeTiem.font = [UIFont systemFontOfSize:11];
        label_comeTiem.textColor = [UIColor colorWithWhite:0.6 alpha:1];
        [bj_view addSubview:label_comeTiem];
        //显示评价内容的
        label_evaluate = [[UILabel alloc]init];
        label_evaluate.frame = FRAME(10, 70, WIDTH - 20, self.height);
        label_evaluate.font = [UIFont systemFontOfSize:13];
        label_evaluate.textColor = [UIColor colorWithWhite:0.4 alpha:1];
        label_evaluate.numberOfLines = 0;
        [bj_view addSubview:label_evaluate];
    }
//    if ([self.time_pei integerValue] < 60) {
//        label_comeTiem.text = [NSString stringWithFormat:@"%@%@",self.time_pei,NSLocalizedString(@"分钟", nil)];
//    }else{
//        NSInteger a =  [self.time_pei integerValue]%60;
//        NSInteger b =  [self.time_pei integerValue]/60;
//        label_comeTiem.text = [NSString stringWithFormat:@"%@小时%@分钟",@(b).stringValue,@(a).stringValue];
//    }
    label_comeTiem.text = self.pei_time_label;
    label_evaluate.text = self.content;
    //创建照片的
    if (photo1) {
        [photo1 removeFromSuperview];
        photo1 = nil;
    }
    if (photo2) {
        [photo2 removeFromSuperview];
        photo2 = nil;
    }
    if (photo3) {
        [photo3 removeFromSuperview];
        photo3 = nil;
    }
    if (photo4) {
        [photo4 removeFromSuperview];
        photo4 = nil;
    }
    if(self.photoArray.count > 0){
        photo1 = [[UIImageView alloc]init];
        photo1.frame = FRAME(10, 75 +self.height, (WIDTH - 50)/4, (WIDTH - 50)/4);
        [bj_view addSubview:photo1];
        MyTapGestureRecognizer * tap1 = [[MyTapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToSee:)];
        photo1.userInteractionEnabled = YES;
        tap1.tag = 1;
        [photo1 addGestureRecognizer:tap1];
        photo2 = [[UIImageView alloc]init];
        photo2.frame = FRAME(20+(WIDTH - 50)/4, 75 +self.height, (WIDTH - 50)/4, (WIDTH - 50)/4);
        [bj_view addSubview:photo2];
        MyTapGestureRecognizer * tap2 = [[MyTapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToSee:)];
        photo2.userInteractionEnabled = YES;
        [photo2 addGestureRecognizer:tap2];
        tap2.tag = 2;
        photo3 = [[UIImageView alloc]init];
        photo3.frame = FRAME(30+(WIDTH - 50)/4*2, 75 +self.height, (WIDTH - 50)/4, (WIDTH - 50)/4);
        [bj_view addSubview:photo3];
        MyTapGestureRecognizer * tap3 = [[MyTapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToSee:)];
        photo3.userInteractionEnabled = YES;
        tap3.tag = 3;
        [photo3 addGestureRecognizer:tap3];
        photo4 = [[UIImageView alloc]init];
        photo4.frame = FRAME(40+(WIDTH - 50)/4*3, 75 +self.height, (WIDTH - 50)/4, (WIDTH - 50)/4);
        [bj_view addSubview:photo4];
        MyTapGestureRecognizer * tap4 = [[MyTapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToSee:)];
        photo4.userInteractionEnabled = YES;
        tap4.tag = 4;
        [photo4 addGestureRecognizer:tap4];
    }
    if (self.photoArray.count == 4) {
        photo1.hidden = NO;
        photo2.hidden = NO;
        photo3.hidden = NO;
        photo4.hidden = NO;
        [photo1 sd_setImageWithURL:[NSURL URLWithString:self.photoArray[0]] placeholderImage:[UIImage imageNamed:@"evaluateDefault"]];
        [photo2 sd_setImageWithURL:[NSURL URLWithString:self.photoArray[1]] placeholderImage:[UIImage imageNamed:@"evaluateDefault"]];
        [photo3 sd_setImageWithURL:[NSURL URLWithString:self.photoArray[2]] placeholderImage:[UIImage imageNamed:@"evaluateDefault"]];
        [photo4 sd_setImageWithURL:[NSURL URLWithString:self.photoArray[3]] placeholderImage:[UIImage imageNamed:@"evaluateDefault"]];
    }else if (self.photoArray.count == 3){
        photo1.hidden = NO;
        photo2.hidden = NO;
        photo3.hidden = NO;
        photo4.hidden = YES;
        [photo1 sd_setImageWithURL:[NSURL URLWithString:self.photoArray[0]] placeholderImage:[UIImage imageNamed:@"evaluateDefault"]];
        [photo2 sd_setImageWithURL:[NSURL URLWithString:self.photoArray[1]] placeholderImage:[UIImage imageNamed:@"evaluateDefault"]];
        [photo3 sd_setImageWithURL:[NSURL URLWithString:self.photoArray[2]] placeholderImage:[UIImage imageNamed:@"evaluateDefault"]];
        
    }else if (self.photoArray.count == 2){
        photo1.hidden = NO;
        photo2.hidden = NO;
        photo3.hidden = YES;
        photo4.hidden = YES;
        [photo1 sd_setImageWithURL:[NSURL URLWithString:self.photoArray[0]] placeholderImage:[UIImage imageNamed:@"evaluateDefault"]];
        [photo2 sd_setImageWithURL:[NSURL URLWithString:self.photoArray[1]] placeholderImage:[UIImage imageNamed:@"evaluateDefault"]];
        
    }else if (self.photoArray.count == 1){
        photo1.hidden = NO;
        photo2.hidden = YES;
        photo3.hidden = YES;
        photo4.hidden = YES;
        [photo1 sd_setImageWithURL:[NSURL URLWithString:self.photoArray[0]] placeholderImage:[UIImage imageNamed:@"evaluateDefault"]];
    }else{
        photo1.hidden = YES;
        photo2.hidden = YES;
        photo3.hidden = YES;
        photo4.hidden = YES;
    }
    if (label_evaluateTime) {
        [label_evaluateTime removeFromSuperview];
        label_evaluateTime = nil;
    }
    //创建显示评论的时间的label
    if(label_evaluateTime == nil){
        label_evaluateTime = [[UILabel alloc]init];
        if (self.photoArray.count > 0) {
            label_evaluateTime.frame = FRAME(10, 75+(WIDTH - 50)/4+5+self.height, 150, 20);
        }else{
            label_evaluateTime.frame = FRAME(10, 75+self.height, 150, 20);
        }
        label_evaluateTime.text = [HZQChangeDateLine dateLineExchangeWithTime:self.dateline];
        label_evaluateTime.textColor = [UIColor colorWithWhite:0.6 alpha:1];
        label_evaluateTime.font = [UIFont systemFontOfSize:12];
        [bj_view addSubview:label_evaluateTime];
    }
}
#pragma mark - 这是点击查看大图的方法
-(void)clickToSee:(MyTapGestureRecognizer *)sender{
        //传已经拼接好的图片url
        if (displayView == nil) {
            displayView = [[DisplayImageInView alloc]init];
            [displayView showInViewWithImageUrlArray:self.photoArray withIndex:sender.tag withBlock:^{
                [displayView removeFromSuperview];
                displayView = nil;
            }];
        }
    
}
@end
