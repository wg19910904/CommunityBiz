//
//  BlueToothModel.h
//  JHCommunityBiz
//
//  Created by ijianghu on 16/8/9.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
typedef void (^SwitchBlock)(BOOL on);
typedef void(^RefreshBlock)(NSMutableArray * dataSource);
typedef void(^ConnectBlock)(BOOL connect);
@interface BlueToothModel : NSObject<CBPeripheralDelegate,CBCentralManagerDelegate>
@property(nonatomic,strong)CBCentralManager * manager;//管理蓝牙的中央管理者
@property(nonatomic,strong)CBPeripheral * peripheral;//连接的外设
@property(nonatomic,strong)NSMutableArray <CBPeripheral *> * allPeripheralArray;//当前搜索到的全部外设
@property(nonatomic,strong)CBCharacteristic * writeCharacteristic;//写入属性
@property (nonatomic,assign)BOOL autoPrint;//是否自动打印
@property (nonatomic,assign)NSInteger printType;
@property (nonatomic,copy)SwitchBlock switchBlock;
@property (nonatomic,copy)RefreshBlock refreshBlock;
@property (nonatomic,copy)ConnnectBlock connectBlock;
@property(nonatomic,copy)void(^(powerOffBlock))(void);
//外部调用打印订单
-(void)printOrder:(NSDictionary *)dataDic;
-(void)handleStatus;
-(void)stopScan;
@end
