//
//  JHPreferentiaDetailCellFour.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/27.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHPreferentiaDetailCellFour.h"
#import "StarView.h"
#import "DisplayImageInView.h"
#import "MyTapGestureRecognizer.h"
#import <UIImageView+WebCache.h>
#import "HZQChangeDateLine.h"
#import <Masonry.h>
@implementation JHPreferentiaDetailCellFour{
    UIView * bj_view;//白色的背景
    UIImageView * imageView;//显示imageView的
    UILabel * label_name;//显示用户姓名的
    UIView * star;//创建星星
    UILabel * label_evaluate;//显示评论内容的
    UIImageView * photo1;//照片1
    UIImageView * photo2;//照片2
    UIImageView * photo3;//照片3
    UIImageView * photo4;//照片4
    DisplayImageInView * displayView;//这是展示大图
    UILabel * label_evaluateTime;//显示评价时间的
    UIView * view_replay;//回复内容的View
    UILabel * label_reply;//回复内容的
    UILabel * label_replyTime;//显示回复时间的
    UIImageView * replayImageView;//回复的小三角形
}
-(void)setModel:(JHPreferentiaDetailModel *)model{
    _model = model;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    if (bj_view == nil) {
        bj_view = [[UIView alloc]init];
         [self addSubview:bj_view];
        [bj_view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.left.offset(0);
            make.top.offset(0);
            make.bottom.offset(-10);
        }];
        //bj_view.frame = FRAME(0, 0, WIDTH, self.frame.size.height - 10);
        bj_view.backgroundColor = [UIColor whiteColor];
        bj_view.layer.borderColor = [UIColor colorWithWhite:0.95 alpha:1].CGColor;
        bj_view.layer.borderWidth = 1;
       
        UIView * label = [[UIView alloc]init];
        label.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        label.frame = FRAME(0, 39.5, WIDTH, 0.5);
        [bj_view addSubview:label];
    }
    //显示头像的
    if (imageView == nil) {
        imageView = [[UIImageView alloc]init];
        imageView.frame = FRAME(10, 5, 30, 30);
        imageView.layer.cornerRadius = 15;
        imageView.clipsToBounds = YES;
        [bj_view addSubview:imageView];
    }
    [imageView sd_setImageWithURL:[NSURL URLWithString:model.headUrl] placeholderImage:[UIImage imageNamed:@"evaluateHead"]];
    //显示用户姓名的
    if (label_name == nil) {
        label_name = [[UILabel alloc]init];
        label_name.frame = FRAME(50, 10, WIDTH/2, 20);
        label_name.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        label_name.font = [UIFont systemFontOfSize:12];
        [bj_view addSubview:label_name];
    }
     label_name.text = model.mobile;
    //创建显示用户评价的星级的
    if(star){
        [star removeFromSuperview];
        star = nil;
    }
    if (star == nil) {
        star = [StarView addEvaluateViewWithStarNO:[model.score integerValue] withStarSize:13 withBackViewFrame:FRAME(10, 40, 80, 13)];
        [bj_view addSubview:star];
    }
    //创建显示评价内容的
    if(label_evaluate){
        [label_evaluate removeFromSuperview];
        label_evaluate = nil;
    }
    if (label_evaluate == nil) {
        label_evaluate = [[UILabel alloc]init];
        label_evaluate.frame = FRAME(10, 60, WIDTH - 20,self.height_evaluate);
        label_evaluate.font = [UIFont systemFontOfSize:13];
        label_evaluate.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        label_evaluate.text = model.content;
        label_evaluate.numberOfLines = 0;
        [bj_view addSubview:label_evaluate];
    }
    //创建照片的
//    if (photo1) {
//        [photo1 removeFromSuperview];
//        photo1 = nil;
//    }
//    if (photo2) {
//        [photo2 removeFromSuperview];
//        photo2 = nil;
//    }
//    if (photo3) {
//        [photo3 removeFromSuperview];
//        photo3 = nil;
//    }
//    if (photo4) {
//        [photo4 removeFromSuperview];
//        photo4 = nil;
//    }
    if (model.photoArray.count > 0) {
        photo1 = [[UIImageView alloc]init];
        photo1.frame = FRAME(10, 65 +self.height_evaluate, (WIDTH - 50)/4, (WIDTH - 50)/4);
//        photo1.image = [UIImage imageNamed:@"pic"];
        [bj_view addSubview:photo1];
        MyTapGestureRecognizer * tap1 = [[MyTapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToSee:)];
        photo1.userInteractionEnabled = YES;
        tap1.tag = 1;
        [photo1 addGestureRecognizer:tap1];
        photo2 = [[UIImageView alloc]init];
        photo2.frame = FRAME(20+(WIDTH - 50)/4, 65 +self.height_evaluate, (WIDTH - 50)/4, (WIDTH - 50)/4);
//        photo2.image = [UIImage imageNamed:@"pic"];
        [bj_view addSubview:photo2];
        MyTapGestureRecognizer * tap2 = [[MyTapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToSee:)];
        photo2.userInteractionEnabled = YES;
        [photo2 addGestureRecognizer:tap2];
        tap2.tag = 2;
        photo3 = [[UIImageView alloc]init];
        photo3.frame = FRAME(30+(WIDTH - 50)/4*2, 65 +self.height_evaluate, (WIDTH - 50)/4, (WIDTH - 50)/4);
//        photo3.image = [UIImage imageNamed:@"pic"];
        [bj_view addSubview:photo3];
        MyTapGestureRecognizer * tap3 = [[MyTapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToSee:)];
        photo3.userInteractionEnabled = YES;
        tap3.tag = 3;
        [photo3 addGestureRecognizer:tap3];
        photo4 = [[UIImageView alloc]init];
        photo4.frame = FRAME(40+(WIDTH - 50)/4*3, 65 +self.height_evaluate, (WIDTH - 50)/4, (WIDTH - 50)/4);
//        photo4.image = [UIImage imageNamed:@"pic"];
        [bj_view addSubview:photo4];
        MyTapGestureRecognizer * tap4 = [[MyTapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToSee:)];
        photo4.userInteractionEnabled = YES;
        tap4.tag = 4;
        [photo4 addGestureRecognizer:tap4];
    }
    if (model.photoArray.count == 4) {
        photo1.hidden = NO;
        photo2.hidden = NO;
        photo3.hidden = NO;
        photo4.hidden = NO;
        [photo1 sd_setImageWithURL:[NSURL URLWithString:model.photoArray[0]] placeholderImage:[UIImage imageNamed:@"evaluateDefault"]];
        [photo2 sd_setImageWithURL:[NSURL URLWithString:model.photoArray[1]] placeholderImage:[UIImage imageNamed:@"evaluateDefault"]];
        [photo3 sd_setImageWithURL:[NSURL URLWithString:model.photoArray[2]] placeholderImage:[UIImage imageNamed:@"evaluateDefault"]];
        [photo4 sd_setImageWithURL:[NSURL URLWithString:model.photoArray[3]] placeholderImage:[UIImage imageNamed:@"evaluateDefault"]];
    }else if (model.photoArray.count == 3){
        photo1.hidden = NO;
        photo2.hidden = NO;
        photo3.hidden = NO;
        photo4.hidden = YES;
        [photo1 sd_setImageWithURL:[NSURL URLWithString:model.photoArray[0]] placeholderImage:[UIImage imageNamed:@"evaluateDefault"]];
        [photo2 sd_setImageWithURL:[NSURL URLWithString:model.photoArray[1]] placeholderImage:[UIImage imageNamed:@"evaluateDefault"]];
        [photo3 sd_setImageWithURL:[NSURL URLWithString:model.photoArray[2]] placeholderImage:[UIImage imageNamed:@"evaluateDefault"]];

    }else if (model.photoArray.count == 2){
        photo1.hidden = NO;
        photo2.hidden = NO;
        photo3.hidden = YES;
        photo4.hidden = YES;
        [photo1 sd_setImageWithURL:[NSURL URLWithString:model.photoArray[0]] placeholderImage:[UIImage imageNamed:@"evaluateDefault"]];
        [photo2 sd_setImageWithURL:[NSURL URLWithString:model.photoArray[1]] placeholderImage:[UIImage imageNamed:@"evaluateDefault"]];

    }else if (model.photoArray.count == 1){
        photo1.hidden = NO;
        photo2.hidden = YES;
        photo3.hidden = YES;
        photo4.hidden = YES;
        [photo1 sd_setImageWithURL:[NSURL URLWithString:model.photoArray[0]] placeholderImage:[UIImage imageNamed:@"evaluateDefault"]];
    }else{
        photo1.hidden = YES;
        photo2.hidden = YES;
        photo3.hidden = YES;
        photo4.hidden = YES;
    }
    //显示评价时间的
    if(label_evaluateTime){
        [label_evaluateTime removeFromSuperview];
        label_evaluateTime = nil;
    }
    if (label_evaluateTime == nil) {
        label_evaluateTime = [[UILabel alloc]init];
        if (model.isPhoto) {
            label_evaluateTime.frame = FRAME(10, 65+ self.height_evaluate + (WIDTH - 50)/4 +10,150, 20);
        }else{
            label_evaluateTime.frame = FRAME(10, 65+ self.height_evaluate,150, 20);

        }
        label_evaluateTime.textColor = [UIColor colorWithWhite:0.6 alpha:1];
        label_evaluateTime.font = [UIFont systemFontOfSize:13];
        label_evaluateTime.text = [HZQChangeDateLine dateLineExchangeWithTime:model.time_evaluate];
        [bj_view addSubview:label_evaluateTime];
    }
    //创建显示有关回复内容的控件
    if (view_replay) {
        [view_replay removeFromSuperview];
        view_replay = nil;
    }
    if (view_replay == nil && [model.state isEqualToString: NSLocalizedString(@"已回复", NSStringFromClass([self class]))]) {
        view_replay = [[UIView alloc]init];
        if (model.isPhoto) {
            view_replay.frame = FRAME(10, 65+ self.height_evaluate + (WIDTH - 50)/4 +10 + 25, WIDTH - 20, 10+self.height_reply + 15);
        }else{
            view_replay.frame = FRAME(10, 65+ self.height_evaluate + 25, WIDTH - 20, 10+self.height_reply + 15);
        }
        view_replay.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        view_replay.layer.cornerRadius = 3;
        view_replay.clipsToBounds = YES;
        [bj_view addSubview:view_replay];
    }
    //显示回复框框的倒三角的
    if (replayImageView) {
        [replayImageView removeFromSuperview];
        replayImageView = nil;
    }
    if (replayImageView == nil && [model.state isEqualToString: NSLocalizedString(@"已回复", NSStringFromClass([self class]))]) {
        replayImageView = [[UIImageView alloc]init];
        if (model.isPhoto) {
            replayImageView.frame = FRAME(20, 65+ self.height_evaluate + (WIDTH - 50)/4 +10 + 18, 8, 8);
        }else{
            replayImageView.frame = FRAME(20, 65+ self.height_evaluate + 18, 8, 8);
        }
        replayImageView.image = [UIImage imageNamed:@"boxarrowTop"];
        [bj_view addSubview:replayImageView];
    }
    //显示回复内容的
    if (label_reply) {
        [label_reply removeFromSuperview];
        label_reply = nil;
    }
    if (label_reply == nil&& [model.state isEqualToString: NSLocalizedString(@"已回复", NSStringFromClass([self class]))]) {
        label_reply = [[UILabel alloc]init];
        label_reply.frame = FRAME(5, 5, WIDTH - 30, self.height_reply);
        label_reply.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        label_reply.text = model.reply;
        label_reply.font = [UIFont systemFontOfSize:13];
        label_reply.numberOfLines = 0;
        [view_replay addSubview:label_reply];
    }
    //显示回复时间的
    if (label_replyTime) {
        [label_replyTime removeFromSuperview];
        label_replyTime = nil;
    }
    if (label_replyTime == nil&& [model.state isEqualToString:NSLocalizedString(@"已回复", NSStringFromClass([self class]))]) {
        label_replyTime = [[UILabel alloc]init];
        label_replyTime.frame = FRAME(5, self.height_reply + 3, 200, 20);
        label_replyTime.text = model.time_reply;
        label_replyTime.textColor = [UIColor colorWithWhite:0.5 alpha:1];
        label_replyTime.font = [UIFont systemFontOfSize:11];
        [view_replay addSubview:label_replyTime];
    }

}
#pragma mark - 这是点击查看大图的方法
-(void)clickToSee:(MyTapGestureRecognizer *)sender{
//    if (displayView == nil) {
//        displayView = [[DisplayImageInView alloc]init];
//        NSArray * array = @[[UIImage imageNamed:@"pic"],[UIImage imageNamed:@"pic"],[UIImage imageNamed:@"pic"],[UIImage imageNamed:@"pic"]];
//        [displayView showInViewWithImageArray:array withIndex:sender.tag withBlock:^{
//            [displayView removeFromSuperview];
//            displayView = nil;
//        }];
//        
//    }
        //传已经拼接好的图片url
        if (displayView == nil) {
            displayView = [[DisplayImageInView alloc]init];
            [displayView showInViewWithImageUrlArray:_model.photoArray withIndex:sender.tag withBlock:^{
                [displayView removeFromSuperview];
                displayView = nil;
            }];
        }
    
}

@end
