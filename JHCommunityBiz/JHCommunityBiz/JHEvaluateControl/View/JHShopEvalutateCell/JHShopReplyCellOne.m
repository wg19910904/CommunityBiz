//
//  JHShopReplyCellOne.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/25.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHShopReplyCellOne.h"

@implementation JHShopReplyCellOne{
    UIImageView * imageView_header;//显示用户头像的
    UILabel * label_name;//创建显示用户名的label
    UIView * label_line;//创建分割线
    UIView * star;//创建显示星星的
    UILabel * label_evaluate;//显示评论内容的
    UIImageView * photo1;//照片1
    UIImageView * photo2;//照片2
    UIImageView * photo3;//照片3
    UIImageView * photo4;//照片4
    UILabel * label_evaluateTime;//显示评价时间的
    DisplayImageInView * displayView;//这是展示大图
}
-(void)setHeight:(float)height{
    _height = height;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    //创建显示用户头像的
    if (imageView_header == nil) {
        imageView_header = [[UIImageView alloc]init];
        imageView_header.frame = FRAME(10, 5, 30, 30);
        imageView_header.layer.cornerRadius = 15;
        imageView_header.clipsToBounds = YES;
        [self addSubview:imageView_header];
        [imageView_header sd_setImageWithURL:[NSURL URLWithString:self.headUrl] placeholderImage:[UIImage imageNamed:@"evaluateHead"]];
    }
    //创建显示用户名的label
    if (label_name == nil) {
        label_name = [[UILabel alloc]init];
        label_name.frame = FRAME(50, 10, WIDTH - 60, 20);
        label_name.text = self.name;
        label_name.textColor = [UIColor colorWithWhite:0.3 alpha:1];
        label_name.font = [UIFont systemFontOfSize:14];
        [self addSubview:label_name];
    }
    //创建显示的分割线
    if(label_line == nil){
        label_line = [[UIView alloc]init];
        label_line.frame = FRAME(0, 39.5, WIDTH, 0.5);
        label_line.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        [self addSubview:label_line];
    }
    //创建显示用户评价的星级的
    if (star == nil) {
        star = [StarView addEvaluateViewWithStarNO:[self.score integerValue] withStarSize:13 withBackViewFrame:FRAME(10, 40, 80, 13)];
        [self addSubview:star];
    }
    //创建显示评价内容的
    if (label_evaluate == nil) {
        label_evaluate = [[UILabel alloc]init];
        label_evaluate.frame = FRAME(10, 60, WIDTH - 20,self.height);
        label_evaluate.font = [UIFont systemFontOfSize:13];
        label_evaluate.textColor = [UIColor colorWithWhite:0.4 alpha:1];
        label_evaluate.text = self.evaluate;
        label_evaluate.numberOfLines = 0;
        [self addSubview:label_evaluate];
    }
    //创建照片的
    if(self.photoArray.count > 0){
        photo1 = [[UIImageView alloc]init];
        photo1.frame = FRAME(10, 65 +self.height, (WIDTH - 50)/4, (WIDTH - 50)/4);
        [self addSubview:photo1];
        MyTapGestureRecognizer * tap1 = [[MyTapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToSee:)];
        photo1.userInteractionEnabled = YES;
        tap1.tag = 1;
        [photo1 addGestureRecognizer:tap1];
        photo2 = [[UIImageView alloc]init];
        photo2.frame = FRAME(20 + (WIDTH - 50)/4, 65 +self.height, (WIDTH - 50)/4, (WIDTH - 50)/4);
        [self addSubview:photo2];
        MyTapGestureRecognizer * tap2 = [[MyTapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToSee:)];
        photo2.userInteractionEnabled = YES;
        [photo2 addGestureRecognizer:tap2];
        tap2.tag = 2;
        photo3 = [[UIImageView alloc]init];
        photo3.frame = FRAME(30 + (WIDTH - 50)/4*2, 65 +self.height, (WIDTH - 50)/4, (WIDTH - 50)/4);
        [self addSubview:photo3];
        MyTapGestureRecognizer * tap3 = [[MyTapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToSee:)];
        photo3.userInteractionEnabled = YES;
        tap3.tag = 3;
        [photo3 addGestureRecognizer:tap3];
        photo4 = [[UIImageView alloc]init];
        photo4.frame = FRAME(40 + (WIDTH - 50)/4*3, 65 +self.height, (WIDTH - 50)/4, (WIDTH - 50)/4);
        [self addSubview:photo4];
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

    //显示评价时间的
    if (label_evaluateTime == nil) {
        label_evaluateTime = [[UILabel alloc]init];
        if (self.photoArray.count > 0) {
            label_evaluateTime.frame = FRAME(10, 65 + (WIDTH - 50)/4 + 5 +self.height, 150, 20);
        }else{
            label_evaluateTime.frame = FRAME(10, 65+self.height, 150, 20);
        }
        label_evaluateTime.text = [HZQChangeDateLine dateLineExchangeWithTime:self.evaluate_time];
        label_evaluateTime.textColor = [UIColor colorWithWhite:0.6 alpha:1];
        label_evaluateTime.font = [UIFont systemFontOfSize:12];
        [self addSubview:label_evaluateTime];
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
