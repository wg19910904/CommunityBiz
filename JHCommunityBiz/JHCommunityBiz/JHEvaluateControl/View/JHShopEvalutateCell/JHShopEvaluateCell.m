//
//  JHShopEvaluateCell.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/25.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHShopEvaluateCell.h"
#import <Masonry.h>
#import "StarView.h"
#import "DisplayImageInView.h"
#import "MyTapGestureRecognizer.h"
#import <UIImageView+WebCache.h>
#import "HZQChangeDateLine.h"
@implementation JHShopEvaluateCell{
    UIView * bj_view;//白色的背景
    UIImageView * imageView_header;//头像
    UILabel * label_name;//展示用户名的label
    UIView * star;//创建显示用户评价的星星数
    UILabel * label_evaluate;//显示评价内容的
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
-(void)setModel:(JHShopEvaluateModel *)model{
    _model = model;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
    if(bj_view == nil){
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
        UIView * label_one = [[UIView alloc]init];
        label_one.frame = FRAME(0, 0, WIDTH, 0.5);
        label_one.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        [bj_view addSubview:label_one];
        //创建第二根分割线
        UIView * label_two = [[UIView alloc]init];
        label_two.frame = FRAME(0, 39.5, WIDTH, 0.5);
        label_two.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        [bj_view addSubview:label_two];
    }
    //创建头像
    if (imageView_header) {
        [imageView_header removeFromSuperview];
        imageView_header = nil;
    }
    if (imageView_header == nil) {
        imageView_header = [[UIImageView alloc]init];
        imageView_header.frame = FRAME(10, 5, 30, 30);
        imageView_header.layer.cornerRadius = 15;
        imageView_header.layer.masksToBounds = YES;
        [imageView_header sd_setImageWithURL:[NSURL URLWithString:model.face] placeholderImage:[UIImage imageNamed:@"evaluateHead"]];
        [bj_view addSubview:imageView_header];
    }
    //展示用户名的
    if(label_name){
        [label_name removeFromSuperview];
        label_name = nil;
    }
    if (label_name == nil) {
        label_name = [[UILabel alloc]init];
        label_name.frame = FRAME(50, 10, WIDTH - 140, 20);
        label_name.text = model.nickname;
        label_name.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        label_name.font = [UIFont systemFontOfSize:14];
        [bj_view addSubview:label_name];
    }
    //回复按钮的
    if(self.btn_reply){
        [self.btn_reply removeFromSuperview];
        self.btn_reply = nil;
    }
    if (self.btn_reply == nil&&model.reply.length == 0) {
        self.btn_reply = [[UIButton alloc]init];
        self.btn_reply.frame = FRAME(WIDTH - 80, 5, 70, 30);
        self.btn_reply.layer.cornerRadius = 3;
        self.btn_reply.clipsToBounds = YES;
        [self.btn_reply setBackgroundColor:[UIColor colorWithRed:250/255.0 green:175/255.0 blue:25/255.0 alpha:1] forState:UIControlStateNormal];
        [self.btn_reply setTitle:NSLocalizedString(@"回复", nil) forState:UIControlStateNormal];
        [bj_view addSubview:self.btn_reply];
    }
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
        label_evaluate.textColor = [UIColor colorWithWhite:0.4 alpha:1];
        label_evaluate.text = model.content;
        label_evaluate.numberOfLines = 0;
        [bj_view addSubview:label_evaluate];
    }
   
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
        if(model.photoArray.count > 0){
        photo1 = [[UIImageView alloc]init];
        photo1.frame = FRAME(10, 65 +self.height_evaluate, (WIDTH - 50)/4, (WIDTH - 50)/4);
        [bj_view addSubview:photo1];
        MyTapGestureRecognizer * tap1 = [[MyTapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToSee:)];
        photo1.userInteractionEnabled = YES;
        tap1.tag = 1;
        [photo1 addGestureRecognizer:tap1];
        photo2 = [[UIImageView alloc]init];
        photo2.frame = FRAME(20+(WIDTH - 50)/4, 65 +self.height_evaluate, (WIDTH - 50)/4,(WIDTH - 50)/4);
        [bj_view addSubview:photo2];
        MyTapGestureRecognizer * tap2 = [[MyTapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToSee:)];
        photo2.userInteractionEnabled = YES;
        [photo2 addGestureRecognizer:tap2];
        tap2.tag = 2;
        photo3 = [[UIImageView alloc]init];
        photo3.frame = FRAME(30+(WIDTH - 50)/4*2, 65 +self.height_evaluate, (WIDTH - 50)/4, (WIDTH - 50)/4);
        [bj_view addSubview:photo3];
        MyTapGestureRecognizer * tap3 = [[MyTapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToSee:)];
        photo3.userInteractionEnabled = YES;
        tap3.tag = 3;
        [photo3 addGestureRecognizer:tap3];
        photo4 = [[UIImageView alloc]init];
        photo4.frame = FRAME(40+(WIDTH - 50)/4*3, 65 +self.height_evaluate, (WIDTH - 50)/4, (WIDTH - 50)/4);
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
    if (label_evaluateTime) {
        [label_evaluateTime removeFromSuperview];
        label_evaluateTime = nil;
    }
    if (label_evaluateTime == nil) {
        label_evaluateTime = [[UILabel alloc]init];
        if (model.photoArray.count > 0) {
            label_evaluateTime.frame = FRAME(10, 70+(WIDTH - 50)/4+self.height_evaluate, 150, 20);
        }else{
            label_evaluateTime.frame = FRAME(10, 65+self.height_evaluate, 150, 20);
        }
        label_evaluateTime.text = [HZQChangeDateLine dateLineExchangeWithTime:model.time_evaluate];
        label_evaluateTime.textColor = [UIColor colorWithWhite:0.6 alpha:1];
        label_evaluateTime.font = [UIFont systemFontOfSize:12];
        [bj_view addSubview:label_evaluateTime];
    }
    //创建显示有关回复内容的控件
    if (view_replay) {
        [view_replay removeFromSuperview];
        view_replay = nil;
    }
    if (view_replay == nil&& model.reply.length > 0) {
        view_replay = [[UIView alloc]init];
        if (model.photoArray.count > 0) {
            view_replay.frame = FRAME(10, 95 + (WIDTH - 50)/4+self.height_evaluate, WIDTH - 20, self.height_reply + 30);
        }else{
            view_replay.frame = FRAME(10, 90+self.height_evaluate, WIDTH - 20, self.height_reply + 30);
        }
        view_replay.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        view_replay.layer.cornerRadius = 3;
        view_replay.clipsToBounds = YES;
        [bj_view addSubview:view_replay];
    }
    if (label_reply) {
        [label_reply removeFromSuperview];
        label_reply = nil;
    }
    if (label_reply == nil) {
        label_reply = [[UILabel alloc]init];
        label_reply.frame = FRAME(5, 5, WIDTH - 30, self.height_reply);
        label_reply.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        label_reply.text = model.reply;
        label_reply.font = [UIFont systemFontOfSize:13];
        label_reply.numberOfLines = 0;
        [view_replay addSubview:label_reply];
    }
    if (label_replyTime) {
        [label_replyTime removeFromSuperview];
        label_replyTime = nil;
    }
    if (label_replyTime == nil) {
        label_replyTime = [[UILabel alloc]init];
        label_replyTime.frame = FRAME(5, self.height_reply+5, 200, 20);
        label_replyTime.text = [HZQChangeDateLine dateLineExchangeWithTime:model.time_reply];
        label_replyTime.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        label_replyTime.font = [UIFont systemFontOfSize:11];
        [view_replay addSubview:label_replyTime];
    }
    if (replayImageView) {
        [replayImageView removeFromSuperview];
        replayImageView = nil;
    }
    if(replayImageView == nil && model.reply.length > 0){
        replayImageView = [[UIImageView alloc]init];
        if (model.photoArray.count > 0) {
            replayImageView.frame = FRAME(20, 87+(WIDTH - 50)/4+self.height_evaluate, 8, 8);
            
        }else {
            replayImageView.frame = FRAME(20, 83+self.height_evaluate, 8, 8);
        }
        replayImageView.image = [UIImage imageNamed:@"boxarrowTop"];
        [bj_view addSubview:replayImageView];
    }

}
#pragma mark - 这是点击查看大图的方法
-(void)clickToSee:(MyTapGestureRecognizer *)sender{
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
