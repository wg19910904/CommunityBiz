//
//  JHPickerView.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/20.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "JHPickerView.h"

@implementation JHPickerView{
    NSMutableArray * array;
    NSMutableArray * totalArray;
    NSInteger selecter_father;
    NSInteger selecter_son;
    NSInteger selecter;
    NSString * str_father;
    NSString * str_son;
    NSInteger  num;
    UIView * view;
    UIPickerView * picker;
}
//二列联动的情况
-(void)showPickerViewWithArray1:(NSMutableArray *)array1 withArray2:(NSMutableArray *)array2 withSelectedRow1:(NSInteger )Row1 withSelectedRow2:(NSInteger )Row2 withBlock:(void(^)(NSInteger selected1,NSInteger selected2,NSString * result))myBlock{
    num = 2;
    array = array1;
    totalArray = array2;
    [self creatUISubView];
    picker = [[UIPickerView alloc]initWithFrame:CGRectZero];
    picker.autoresizingMask =  UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    selecter_father = Row1;
    picker.delegate = self;
    picker.dataSource = self;
    picker.frame = FRAME(30, 40, WIDTH - 60, 130);
    picker.showsSelectionIndicator = YES;
    [picker selectRow:Row1 inComponent:0 animated:YES];
    [picker selectRow:Row2 inComponent:1 animated:YES];
    selecter_father = Row1;
    selecter_son = Row2;
    [view addSubview:picker];
    [self setBlock:^(NSInteger selecter1,NSInteger selecter2,NSString * result) {
        myBlock(selecter1,selecter2,result);
    }];
}
//两列不联动的情况
-(void)showPickerViewWithArray1:(NSMutableArray *)array1 withArray2:(NSMutableArray *)array2  withBlock:(void (^)( NSString * result))myBlock{
    array = array1;
    totalArray = array2;
    num = 4;
    [self creatUISubView];
    picker = [[UIPickerView alloc]initWithFrame:CGRectZero];
    picker.autoresizingMask =  UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    picker.delegate = self;
    picker.dataSource = self;
    picker.frame = FRAME(30, 40, WIDTH - 60, 130);
    picker.showsSelectionIndicator = YES;
    [view addSubview:picker];
    [self setBlock1:^(NSString * result) {
        myBlock(result);
    }];
}
//一列的情况
-(void)showpickerViewWithArray:(NSMutableArray *)data_array withBlock:(void(^)(NSString * result))myBlock{
    array = data_array;
    num = 1;
    [self creatUISubView];
    picker = [[UIPickerView alloc]initWithFrame:CGRectZero];
    picker.autoresizingMask =  UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    picker.delegate = self;
    picker.dataSource = self;
    picker.frame = FRAME(30, 40, WIDTH - 60, 130);
    picker.showsSelectionIndicator = YES;
    [view addSubview:picker];
    [self setBlock1:^(NSString * result) {
        myBlock(result);
    }];
}
-(void)showpickerViewWithArray:(NSMutableArray *)data_array withSelectedText:(NSString *)text withBlock:(void(^)(NSString * result))myBlock{
    array = data_array;
    num = 1;
    [self creatUISubView];
    picker = [[UIPickerView alloc]initWithFrame:CGRectZero];
    picker.autoresizingMask =  UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    picker = [[UIPickerView alloc]initWithFrame:CGRectZero];
    picker.autoresizingMask =  UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    picker.delegate = self;
    picker.dataSource = self;
    picker.frame = FRAME(30, 40, WIDTH - 60, 130);
    picker.showsSelectionIndicator = YES;
    NSInteger row = [data_array containsObject:text]? [data_array indexOfObject:text] : 0;
    [picker selectRow:row inComponent:0 animated:YES];
    selecter_father = row;
    [view addSubview:picker];
    [self setBlock1:^(NSString *result) {
        myBlock(result);
    }];
}
//三列的情况
-(void)showpickerViewWithDataArray:(NSMutableArray *)data_array withBlock:(void (^)(NSString *))myBlock{
    array = data_array;
    num = 3;
    [self creatUISubView];
    picker = [[UIPickerView alloc]initWithFrame:CGRectZero];
    picker.autoresizingMask =  UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    picker.delegate = self;
    picker.dataSource = self;
    picker.frame = FRAME(30, 40, WIDTH - 60, 130);
    picker.showsSelectionIndicator = YES;
    [view addSubview:picker];
    [self setBlock1:^(NSString * result) {
        myBlock(result);
    }];
}
#pragma mark - 这是创建一些子视图
-(void)creatUISubView{
    self.frame = FRAME(0, 0, WIDTH, HEIGHT);
    self.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.3];
    [self addTarget:self action:@selector(Cancel) forControlEvents:UIControlEventTouchUpInside];
    UIWindow * window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self];
    //创建承载pickerView的view
    view = [[UIView alloc]init];
    view.frame = FRAME(0, HEIGHT - 200, WIDTH, 200);
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 4;
    view.clipsToBounds = YES;
    [self addSubview:view];
    //创建一个label
    UILabel * bj_label = [[UILabel alloc]init];
    bj_label.frame = FRAME(0, 0, WIDTH, 40);
    bj_label.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    [view addSubview:bj_label];
    //创建UIButton(取消,确定)
    for(int i = 0;i < 2;i ++){
        UIButton * btn = [[UIButton alloc]init];
        btn.tag = i;
        btn.frame = FRAME((WIDTH - 60)*i, 0, 60, 40);
        btn.layer.cornerRadius = 3;
        btn.layer.masksToBounds = YES;
        if (i == 0) {
            [btn setTitle: NSLocalizedString(@"取消", NSStringFromClass([self class])) forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithWhite:0.6 alpha:1] forState:UIControlStateNormal];
        }else{
            [btn setTitle: NSLocalizedString(@"确定", NSStringFromClass([self class])) forState:UIControlStateNormal];
            [btn setTitleColor:THEME_COLOR forState:UIControlStateNormal];
        }
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
    }
 
}
#pragma mark - 这是pickerView的代理和数据源方法
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (num == 1) {
        return 1;
    }else if (num == 2||num == 4){
        return 2;
    }else{
        return 3;
    }
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (num) {
        case 1:
        {
            return array.count;
        }
            break;
         case 2:
        {
            if (component == 0) {
                return array.count;
            }else{
                NSArray * arra = totalArray[selecter_father];
                return arra.count;
            }
 
        }
            break;
        case 3:{
            NSMutableArray * a;
            if (component == 0) {
                a = array[0];
               
            }else if (component == 1){
                a = array[1];
                
            }else{
                a = array[2];
            }
             return a.count;
        }
        case 4:{
            if (component == 0) {
                return array.count;
            }else{
                return totalArray.count;
            }
        }
            break;
        default:
            return 0;
            break;
    }
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (num == 2) {
        if (component == 0) {
            selecter_father = row;
            [pickerView reloadComponent:1];
            [pickerView selectRow:0 inComponent:1 animated:NO];
        }else{
            selecter_son = row;
        }

    }else if(num == 1){
        selecter_father = row;
    }else if(num == 3){
        if (component == 0) {
            selecter_father = row;
        }else if (component == 1){
            selecter_son = row;
        }else{
            selecter = row;
        }
    }else{
        if (component == 0) {
            selecter_father = row;
        }else{
            selecter_son = row;
        }
    }
   
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view

{
    CGRect rect1 = [pickerView.subviews objectAtIndex:1].frame;
    rect1.origin.x = 0;
    rect1.size.width = pickerView.frame.size.width ;
    [[pickerView.subviews objectAtIndex:1] setFrame:rect1];
    [[pickerView.subviews objectAtIndex:1] setBackgroundColor:THEME_COLOR];
    CGRect rect2 = [pickerView.subviews objectAtIndex:2].frame;
    rect2.origin.x = 0;
    rect2.size.width = pickerView.frame.size.width ;
    [[pickerView.subviews objectAtIndex:2] setFrame:rect2];
    [[pickerView.subviews objectAtIndex:2] setBackgroundColor:THEME_COLOR];
    UILabel *myView = nil;
    if (num == 3) {
        NSMutableArray * a ;
        if (component == 0) {
            a = array[0];
        }else if(component == 1){
            a = array[1];
            
        }else{
            a = array[2];
        }
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, (WIDTH - 60)/3, 30)];
        myView.textAlignment = NSTextAlignmentCenter;
        myView.text = a[row];
        myView.font = [UIFont systemFontOfSize:14];         //用label来设置字体大小
        myView.backgroundColor = [UIColor clearColor];

    }else if (num == 4){
        if (component == 0) {
            myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 100, 30)];
            myView.textAlignment = NSTextAlignmentCenter;
            myView.text = array[row];
            myView.font = [UIFont systemFontOfSize:14];         //用label来设置字体大小
            myView.backgroundColor = [UIColor clearColor];
        }else {
            
            myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 180, 30)];
            myView.text = totalArray[row];
            myView.textAlignment = NSTextAlignmentCenter;
            myView.font = [UIFont systemFontOfSize:14];
            myView.backgroundColor = [UIColor clearColor];
        }

    }
    else{
    if (component == 0) {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 100, 30)];
        myView.textAlignment = NSTextAlignmentCenter;
        myView.text = array[row];
        myView.font = [UIFont systemFontOfSize:14];         //用label来设置字体大小
        myView.backgroundColor = [UIColor clearColor];
        
        
    }else {
        
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 180, 30)];
        NSArray * arra = totalArray[selecter_father];
        myView.text = arra[row];
        myView.textAlignment = NSTextAlignmentCenter;
        myView.font = [UIFont systemFontOfSize:14];
        myView.backgroundColor = [UIColor clearColor];
    }
  }
    return myView;
}
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40;
}
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    if (num == 1) {
        return WIDTH - 60;
    }else if(num == 2){
        if (component == 0) {
            return (WIDTH -60)/3;
        }else{
            return (WIDTH -60)/3*2;
        }
 
    }else if (num == 4){
        return (WIDTH - 60)/2;
    }
    else{
        return (WIDTH - 60)/3;
    }
}
#pragma mark - 这是点击按钮的方法
-(void)clickBtn:(UIButton *)sender{
    if (sender.tag == 0) {
        if (num == 1||num == 3||num == 4) {
            self.block1(nil);
        }else{
            self.block(0,0,nil);
        }
    }else{
        //如果正在滚动
        if ([self anySubViewScrolling:picker]) {
            return;
        }
        if (num == 1) {
            self.block1(array[selecter_father]);
        }else if(num == 2){
            NSArray * temp_array = totalArray[selecter_father];
            NSString * result = nil;
            if (temp_array.count != 0) {
              result  = [NSString stringWithFormat:@"%@-%@",array[selecter_father],totalArray[selecter_father][selecter_son]];
            }else{
               result = [NSString stringWithFormat:@"%@",array[selecter_father]];
            }
            
            self.block(selecter_father,selecter_son,result);
  
        }else if (num == 4){
            NSString * result = [NSString stringWithFormat:@"%@:%@",array[selecter_father],totalArray[selecter_son]];
            self.block1(result);
        }
        else{
            NSMutableArray * a = array[0];
            NSMutableArray * b = array[1];
            NSMutableArray * c = array[2];
            NSString * result = [NSString stringWithFormat:@"%@-%@-%@",a[selecter_father],b[selecter_son],c[selecter]];
            self.block1(result);
        }
    }
}

#pragma mark - 这是点击背景的点击方法
-(void)Cancel{
    if (num == 1 || num == 3 || num == 4) {
        self.block1(nil);
    }else{
        self.block(0,0,nil);
    }
}
#pragma mark - 判断是否正在滚动
- (BOOL)anySubViewScrolling:(UIView *)view{
    if ([view isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)view;
        if (scrollView.dragging || scrollView.decelerating) {
            return YES;
        }
    }
    for (UIView *theSubView in view.subviews) {
        
        if ([self anySubViewScrolling:theSubView]) {
            return YES;
        }
    }
    return NO;
}
@end
