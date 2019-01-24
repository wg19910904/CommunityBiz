//
//  JHBlueToothObject.m
//  WaimaiShop
//
//  Created by xixixi on 16/1/14.
//  Copyright © 2016年 ijianghu. All rights reserved.
//

#import "XHBlueToothModel.h"
#import "HZQPrinter.h"
#import "HZQChangeDateLine.h"
@implementation XHBlueToothModel
{
    HZQPrinter * printer;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
       
        self.allPeripheralArray = @[].mutableCopy;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(connectInActive) name:UIApplicationWillEnterForegroundNotification object:nil];
        if (!self.manager) {
            self.manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        }
    }
    return self;
}
//后台进入前台后调用的方法
-(void)connectInActive{
    if (_peripheral) {
        [self connectPeripheral:_peripheral];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"connectInActive" object:nil];
    }else{
        [_allPeripheralArray removeAllObjects];
        [_manager scanForPeripheralsWithServices:nil options:nil];
    }
}
- (void)handleStatus
{
   
    if (_manager.state == 4 ){
        [self performSelectorOnMainThread:@selector(showAlertWithMsg:)
                               withObject:NSLocalizedString(@"蓝牙未打开\n请先打开蓝牙", nil)
                            waitUntilDone:YES];
        if (_switchBlock) {
            _switchBlock(NO);
        }
    }else {
          [_manager scanForPeripheralsWithServices:nil options:nil];
    }
}
/**
 *  蓝牙状态
 *
 *  @param central 当前状态
 */
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state) {
        case CBCentralManagerStatePoweredOn:
        {
            [_manager scanForPeripheralsWithServices:nil options:nil];
            NSLog(@"开始搜索外部设备");
        }
            break;
        default:
            NSLog(@"蓝牙状态---未连接");
            if (self.powerOffBlock) {
                self.powerOffBlock();
                [JHShareModel shareModel].printType = nil;
            }
            if (self.writeCharacteristic) {
                self.writeCharacteristic = nil;
            }
            break;
    }
}

//发现外部设备后调用,发现一个调用一次
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI
{
    //先判断数组中是否包含这个外设
    if (![_allPeripheralArray containsObject:peripheral] && peripheral.name) {
        NSString *uuid = peripheral.identifier.description;
        NSString *oldUuid = [[NSUserDefaults standardUserDefaults]objectForKey:@"peripheral"];
        if ([uuid isEqualToString:oldUuid]) {
            [self connectPeripheral:peripheral];
        }
        [_allPeripheralArray addObject:peripheral];
    }
    NSLog(@"发现的设备%@",peripheral);
    if (_refreshBlock) {
        _refreshBlock(_allPeripheralArray);
    }
}
-(void)stopScan{
    [_manager stopScan];
}
/**
 程序启动后尝试连接上次退出后连接的蓝牙设备
 */
-(void)applicationActiveAutoConnectPeripheral{
    [_manager scanForPeripheralsWithServices:nil options:nil];
}
//当连接外部设备成功后回调
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"已经连接上设备---%@",peripheral.name);
    _peripheral = peripheral;
     [JHShareModel shareModel].printType = @"blueTooth";
    [[NSUserDefaults standardUserDefaults]setObject:peripheral.identifier.description forKey:@"peripheral"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //当连接上外部设备后取消蓝牙扫描
    [_manager stopScan];
    //需要从外设蓝牙那边再获取信息，并与之通讯，这些过程会有一些事件可能要处理，所以要给这个外设设置代理
    [peripheral setDelegate:self];
    //查询蓝牙服务
    [peripheral discoverServices:nil];
    if (self.connectBlock) {
        self.connectBlock(YES);
    }
}
//连接外设失败
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error{
    _peripheral = nil;
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"peripheral"];
}
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    if (!_isDisConnect_myself) {
        [self connectPeripheral:_peripheral];
    }else{
        _peripheral = nil;
       [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"peripheral"];
    }
}
/**
 断开已经连接的蓝牙设备
 */
-(void)cancelPeripheralConnection{
    if (_peripheral) {
        _isDisConnect_myself = YES;
        [_manager cancelPeripheralConnection:_peripheral];
    }
}
/**
 连接蓝牙
 */
-(void)connectPeripheral:(CBPeripheral *)peripheral{
    [_manager connectPeripheral:peripheral options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey]];
}
//发现服务和特征的回调
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if(error) {
        NSLog(@"Discovered services for %@ with error: %@", peripheral.name, [error localizedDescription]);
    }
    int i = 0;
    for(CBService * service in peripheral.services){
        NSLog(@"%@",[NSString stringWithFormat:NSLocalizedString(@"%d :服务 UUID: %@(%@)", nil),++i,service.UUID.data,service.UUID]);
        //查找特征
        [peripheral discoverCharacteristics:nil forService:service];
    }
}
//蓝牙已经发现到服务特征
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (error)
    {
        NSLog(@"didDiscoverCharacteristicsForService error : %@", [error localizedDescription]);
        return;
    }
    for (CBCharacteristic *characteristic in service.characteristics) {
        NSLog(@"%@",[NSString stringWithFormat:NSLocalizedString(@"特征 UUID: %@", nil),characteristic.UUID]);
        //查询到写入属性时,保存
        if (characteristic.properties & CBCharacteristicPropertyWrite) {
            _writeCharacteristic = characteristic;
            [_peripheral readValueForCharacteristic:characteristic];
            [_peripheral setNotifyValue:YES forCharacteristic:characteristic];
        }
    }
}
- (void)printOrder:(NSDictionary *)dataDic;
{
    //判断小票样式
    self.printType = 0;
    if (self.printType == 0) { //使用第一种样式
        //获取打印次数
        NSInteger num;
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"print_num"] == 0 ||
            [[NSUserDefaults standardUserDefaults] integerForKey:@"print_num"] == 1) {
            num = 1;
        }else{
            num = [[NSUserDefaults standardUserDefaults] integerForKey:@"print_num"];
        }
        for (int i = 0; i<num; i ++) {
            [self printOrderUsingFirstType:dataDic];
            sleep(1);
        }
    }else{
        //使用第二种样式
        [self printOrderusingSecondType:dataDic];
    }
}
#pragma mark - 使用第一种样式打印小票
- (void)printOrderUsingFirstType:(NSDictionary *)dataDic
{
    if(!self.writeCharacteristic) {
        [JHShowAlert showAlertWithMsg:NSLocalizedString(@"未能成功写入\n请检查蓝牙是否打开或连接", nil)
                         withBtnTitle:NSLocalizedString(@"知道了", nil)
                         withBtnBlock:^{
                             //获取选择打印机的控制器
                             Class class = NSClassFromString(@"JHChoosePrinterVC");
                             UINavigationController *nav = (UINavigationController *)[UIApplication sharedApplication].delegate.window.rootViewController;
                             [nav pushViewController:[class new] animated:YES];
                         }];
        return;
    }

    NSString * pay_type = nil;
    float total_package_price = 0;
    NSInteger number = 0;
    for (NSDictionary * dic  in dataDic[@"products"]) {
        if ([dic[@"package_price"]floatValue] > 0) {
            total_package_price +=  [dic[@"product_number"]integerValue] * [dic[@"package_price"]floatValue];
            number ++;
        }
    }
    if([dataDic[@"online_pay"] isEqualToString:@"1"]){
        if ([dataDic[@"pay_code"] isEqualToString:@"wxpay"]) {
            pay_type = NSLocalizedString(@"支付方式:微信支付(已支付)", nil);
        }else if ([dataDic[@"pay_code"] isEqualToString:@"alipay"]){
            pay_type = NSLocalizedString(@"支付方式:支付宝支付(已支付)", nil);
        }else{
            pay_type = NSLocalizedString(@"支付方式:余额支付(已支付)", nil);
        }
 
    }else{
            pay_type = NSLocalizedString(@"支付方式:货到付款", nil);
    }
    printer = [[HZQPrinter alloc]init];
    NSString * app_title = [[NSBundle mainBundle]infoDictionary][@"CFBundleDisplayName"];
    [printer appendText:app_title alignment:HZQTextAlignmentCenter fontSize:HZQFontSizeTitleSmalle];
    [self printWithData:printer.printerData];
    [printer appendText:dataDic[@"shop_title"] alignment:HZQTextAlignmentCenter fontSize:HZQFontSizeTitleMiddle];
    [self printWithData:printer.printerData];
    [printer appendSeperatorLine];
    [self printWithData:printer.printerData];
    [printer appendText:[NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"订单号", nil),dataDic[@"order_id"]] alignment:HZQTextAlignmentLeft fontSize:HZQFontSizeTitleSmalle];
    [self printWithData:printer.printerData];
    [printer appendText:[NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"订单时间", nil),[HZQChangeDateLine ExchangeWithDateLine:dataDic[@"dateline"]]] alignment:
     HZQTextAlignmentLeft fontSize:HZQFontSizeTitleSmalle];
    [self printWithData:printer.printerData];
    
    [printer appendText:[NSString stringWithFormat:@"%@",dataDic[@"pei_time"]] alignment:HZQTextAlignmentLeft fontSize:HZQFontSizeTitleMiddle];
    [self printWithData:printer.printerData];
    
    [printer appendText:pay_type alignment:HZQTextAlignmentLeft fontSize:HZQFontSizeTitleSmalle];
    [self printWithData:printer.printerData];
    [printer appendSeperatorLine];
    [self printWithData:printer.printerData];
    for (NSDictionary * dic  in dataDic[@"products"]) {
        CGFloat all = [dic[@"product_price"] doubleValue];
        [printer appendLeftText:dic[@"product_name"] middleText:@"" rightText:[NSString stringWithFormat:@"%@%@  %.2f",@"x",dic[@"product_number"],all]  isTitle:YES];
        [self printWithData:printer.printerData];
    }
    if (total_package_price > 0 ||[dataDic[@"pei_amount"] floatValue] > 0 || [dataDic[@"first_youhui"] floatValue] > 0
        || [dataDic[@"hongbao"] floatValue] > 0 ||[dataDic[@"order_youhui"] floatValue] > 0 ) {
        [printer appendSeperatorLineWithTitle];
        [self printWithData:printer.printerData];
    }
    if (total_package_price > 0) {
        [printer appendLeftText:NSLocalizedString(@"打包费", nil) middleText:[@"x" stringByAppendingString:@(number).stringValue] rightText:@(total_package_price).stringValue isTitle:YES];
        [self printWithData:printer.printerData];
    }
    if ([dataDic[@"pei_amount"] floatValue] > 0) {
        [printer appendLeftText:NSLocalizedString(@"配送费", nil) middleText:@"" rightText:dataDic[@"pei_amount"] isTitle:YES];
        [self printWithData:printer.printerData];
    }
    if ([dataDic[@"first_youhui"] floatValue] > 0) {
        [printer appendLeftText:NSLocalizedString(@"首单优惠", nil) middleText:@"" rightText:dataDic[@"first_youhui"] isTitle:YES];
        [self printWithData:printer.printerData];
    }
    if ([dataDic[@"hongbao"] floatValue] > 0) {
        [printer appendLeftText:NSLocalizedString(@"红包抵扣", nil) middleText:@"" rightText:dataDic[@"hongbao"] isTitle:YES];
        [self printWithData:printer.printerData];
    }
    if ([dataDic[@"order_youhui"] floatValue] > 0) {
        [printer appendLeftText:NSLocalizedString(@"满减优惠", nil) middleText:@"" rightText:dataDic[@"order_youhui"] isTitle:YES];
        [self printWithData:printer.printerData];
    }
    [printer appendSeperatorLine];
    [self printWithData:printer.printerData];
    [printer appendText:[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"总计:", nil),dataDic[@"total_price"]] alignment:HZQTextAlignmentLeft fontSize:HZQFontSizeTitleMiddle];
    [self printWithData:printer.printerData];
    [printer appendText:[NSString stringWithFormat:@"%@%@",NSLocalizedString(@"备注:", nil),dataDic[@"intro"]] alignment:HZQTextAlignmentLeft fontSize:HZQFontSizeTitleMiddle];
    [self printWithData:printer.printerData];
    
    NSString *addr = [dataDic[@"addr"] stringByAppendingString:dataDic[@"house"] ? dataDic[@"house"] : @""];
    [printer appendText:addr alignment:HZQTextAlignmentLeft fontSize:HZQFontSizeTitleMiddle];
    [self printWithData:printer.printerData];
    [printer appendText:dataDic[@"contact"] alignment:HZQTextAlignmentLeft fontSize:HZQFontSizeTitleMiddle];
    [self printWithData:printer.printerData];
    [printer appendText:dataDic[@"mobile"] alignment:HZQTextAlignmentLeft fontSize:HZQFontSizeTitleMiddle];
    [self printWithData:printer.printerData];
    [printer appendNewLine];
    [self printWithData:printer.printerData];
    [printer appendNewLine];
    [self printWithData:printer.printerData];
    [printer appendNewLine];
    [self printWithData:printer.printerData];
}
#pragma mark - 使用第二种样式打印小票
- (void)printOrderusingSecondType:(NSDictionary *)dataDic
{
    
}
- (void)printWithData:(NSData *)data
{
    sleep(0.1);
    [self.peripheral writeValue:data forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithResponse];
    printer.printerData = [NSMutableData data];
    
}
//写数据代理,写入数据之后就会自动调用这个函数
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    NSLog(@"======%@",characteristic.UUID);
    if (error) {
        NSLog(@"Error changing notification state: %@",[error localizedDescription]);
    }
    //其实这里貌似不用些什么（我是没有写只是判断了连接状态）
}
#pragma mark - 提醒弹窗
- (void)showAlertWithMsg:(NSString *)msg
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提醒", nil)
                                                     message:msg
                                                    delegate:self
                                           cancelButtonTitle:NSLocalizedString(@"知道了", nil)
                                           otherButtonTitles:nil];
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.message isEqualToString:NSLocalizedString(@"蓝牙未打开", nil)]) {
        //发送通知,改变蓝牙列表界面的switch开关为no
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BlueTooth_PowerOff"
                                                            object:nil];
    }
}
@end
