//
//  XHBlueToothModel.h
//  JHCommunityBiz
//
//  Created by xixixi on 16/6/25.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
typedef void(^SwitchBlock)(BOOL on);
typedef void(^RefreshBlock)(NSMutableArray *dataSource);
typedef void(^ConnnectBlock)(BOOL connect);
@interface XHBlueToothModel : NSObject<CBPeripheralDelegate,CBCentralManagerDelegate,UIAlertViewDelegate>
@property (nonatomic,strong)CBCentralManager * manager; //管理蓝牙
@property (nonatomic,strong)CBPeripheral * peripheral;  //连接的外设
@property(nonatomic,assign)BOOL isDisConnect_myself;//是否是主动断开的
@property (nonatomic,strong)NSMutableArray <CBPeripheral *> * allPeripheralArray;//当前搜索到得全部外设
@property (nonatomic,strong)CBCharacteristic * writeCharacteristic; //写入属性
@property (nonatomic,assign)BOOL autoPrint;//是否自动打印
@property (nonatomic,assign)NSInteger printType;
@property (nonatomic,copy)SwitchBlock switchBlock;
@property (nonatomic,copy)RefreshBlock refreshBlock;
@property (nonatomic,copy)ConnnectBlock connectBlock;
@property(nonatomic,copy)void(^(powerOffBlock))(void);
//外部调用打印订单
- (void)printOrder:(NSDictionary *)dataDic;
- (void)handleStatus;
-(void)stopScan;
/**
 断开已经连接的蓝牙设备
 */
-(void)cancelPeripheralConnection;
/**
 连接蓝牙
 */
-(void)connectPeripheral:(CBPeripheral *)peripheral;
/**
 程序启动后尝试连接上次退出后连接的蓝牙设备
 */
-(void)applicationActiveAutoConnectPeripheral;
@end
