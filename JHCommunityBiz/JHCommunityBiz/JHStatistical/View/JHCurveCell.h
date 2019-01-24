//
//  JHCurveCell.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/5/12.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BEMSimpleLineGraphView.h"
@interface JHCurveCell : UITableViewCell<BEMSimpleLineGraphDataSource,BEMSimpleLineGraphDelegate>{
    int previousStepperValue;
    int totalNumber;
    NSMutableArray * myInfoArray;

}
-(void)creatNSMutableArray:(NSMutableArray *)infoArray withNSMutableArray:(NSMutableArray *)dateArray;
@property(nonatomic,retain)UILabel * label_title;
@property(nonatomic,retain)BEMSimpleLineGraphView * view_bj;
@property(nonatomic,retain)UILabel * labelDates;
@property (strong, nonatomic) NSMutableArray *arrayOfValues;
@property (strong, nonatomic) NSMutableArray *arrayOfDates;
@end
