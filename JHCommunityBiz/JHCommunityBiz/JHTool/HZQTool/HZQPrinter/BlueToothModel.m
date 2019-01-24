//
//  BlueToothModel.m
//  JHCommunityBiz
//
//  Created by ijianghu on 16/8/9.
//  Copyright © 2016年 com.jianghu. All rights reserved.
//

#import "BlueToothModel.h"
#import "HZQPrinter.h"
#import "HZQChangeDateLine.h"
#import "JHShowAlert.h"
typedef void (^BLOCK)(size_t);
@implementation BlueToothModel
-(instancetype)init{
    self = [super init];
    if (self) {
        self.allPeripheralArray = @[].mutableCopy;
    }
    return self;
}
-(void)handleStatus{
    if (!self.manager) {
        self.manager = [[CBCentralManager alloc]initWithDelegate:self queue:nil];
    }
    if (self.manager.state == 4) {
        [JHShowAlert showAlertWithMsg: NSLocalizedString(@"蓝牙未打开\n请先打开蓝牙", NSStringFromClass([self class]))];
        if (_switchBlock) {
            _switchBlock(NO);
        }
    }else{
        [_manager scanForPeripheralsWithServices:nil options:nil];
    }
}
-(void)centralManagerDidUpdateState:(CBCentralManager *)central{
    switch (central.state) {
        case CBCentralManagerStatePoweredOn:
        {
            //开始搜索外部设备
            [_manager scanForPeripheralsWithServices:nil options:nil];
        }
            break;
            
        default:
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
//搜索到外部设备,发现一个调用一次
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *,id> *)advertisementData RSSI:(NSNumber *)RSSI{
    //判断数组中是否包含这个外设或者如果名字不存在,也暂时不放入数组
    if (![_allPeripheralArray containsObject:peripheral] && peripheral.name) {
        [_allPeripheralArray addObject:peripheral];
    }
    if (_refreshBlock) {
        _refreshBlock(_allPeripheralArray);
    }
}
-(void)stopScan{
    [_manager stopScan];
}
//当连接外部设备成功后回调
-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    NSLog(@"已经成功连接上外部设备>>>>%@",peripheral.name);
    _peripheral = peripheral;
    //当连接上外部设备后停止蓝牙的扫描
    [_manager stopScan];
    //需要从外设蓝牙那边再获取信息,并与之通讯,这些过程会有一些事件可能要处理,所以给这个外设设置代理
    [peripheral setDelegate:self];
    //查询蓝牙服务
    [peripheral discoverServices:nil];
    if (self.connectBlock) {
        self.connectBlock(YES);
    }
}
-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    NSLog(@"和设备断开连接");
}
//发现服务和特征的回调
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    if (error) {
        NSLog(@"Discovered services for %@ with error: %@", peripheral.name, [error localizedDescription]);
    }
    int i = 0;
    for (CBService * service  in peripheral.services) {
        NSLog(@"%@",[NSString stringWithFormat: NSLocalizedString(@"%d :服务 UUID: %@(%@)", NSStringFromClass([self class])),++i,service.UUID.data,service.UUID]);
        //查找特征
        [peripheral discoverCharacteristics:nil forService:service];
    }
}
//蓝牙已经发现服务特征
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    if (error) {
        NSLog(@"didDiscoverCharacteristicsForService error : %@", [error localizedDescription]);
        return;
    }
    for (CBCharacteristic * characteristic  in service.characteristics) {
        NSLog(@"%@",[NSString stringWithFormat:NSLocalizedString(@"特征 UUID: %@", nil),characteristic.UUID]);
        //查找到写入属性时,保存
        if (characteristic.properties & CBCharacteristicPropertyWrite) {
            [_peripheral readValueForCharacteristic:characteristic];
            [_peripheral setNotifyValue:YES forCharacteristic:characteristic];
        }
    }
}
-(void)printOrder:(NSDictionary *)dataDic{
    //获取打印次数
    NSInteger num;
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"print_num"] == 0 ||
        [[NSUserDefaults standardUserDefaults] integerForKey:@"print_num"] == 1) {
        num = 1;
    }else{
        num = [[NSUserDefaults standardUserDefaults] integerForKey:@"print_num"];
    }
    BLOCK myBlock = ^(size_t size){
        [self printOrderUsingFirstType:dataDic];
    };
    dispatch_apply(num, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),myBlock);

}
- (void)printOrderUsingFirstType:(NSDictionary *)dataDic
{   NSString * pay_type = nil;
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
            pay_type =  NSLocalizedString(@"支付方式:微信支付(已支付)", NSStringFromClass([self class]));
        }else if ([dataDic[@"pay_code"] isEqualToString:@"alipay"]){
            pay_type =  NSLocalizedString(@"支付方式:支付宝支付(已支付)", NSStringFromClass([self class]));
        }else{
            pay_type =  NSLocalizedString(@"支付方式:余额支付(已支付)", NSStringFromClass([self class]));
        }
        
    }else{
        pay_type =  NSLocalizedString(@"支付方式:货到付款", NSStringFromClass([self class]));
    }
    HZQPrinter * printer = [[HZQPrinter alloc]init];
    NSString * app_title = [[NSBundle mainBundle]infoDictionary][@"CFBundleDisplayName"];
    [printer appendText:app_title alignment:HZQTextAlignmentCenter fontSize:HZQFontSizeTitleSmalle];
    [printer appendText:dataDic[@"shop_title"] alignment:HZQTextAlignmentCenter fontSize:HZQFontSizeTitleMiddle];
    [printer appendSeperatorLine];
    [printer appendText:[NSString stringWithFormat:@"%@:%@", NSLocalizedString(@"订单号", NSStringFromClass([self class])),dataDic[@"order_id"]] alignment:HZQTextAlignmentLeft fontSize:HZQFontSizeTitleSmalle];
    [printer appendText:[NSString stringWithFormat:@"%@:%@", NSLocalizedString(@"订单时间", NSStringFromClass([self class])),[HZQChangeDateLine ExchangeWithDateLine:dataDic[@"dateline"]]] alignment:HZQTextAlignmentLeft fontSize:HZQFontSizeTitleSmalle];
    [printer appendText:pay_type alignment:HZQTextAlignmentLeft fontSize:HZQFontSizeTitleSmalle];
    [printer appendSeperatorLine];
    for (NSDictionary * dic  in dataDic[@"products"]) {
        [printer appendLeftText:dic[@"product_name"] middleText:@"" rightText:[NSString stringWithFormat:@"%@%@  %@",@"x",dic[@"product_number"],dic[@"product_price"]]  isTitle:YES];
    }
    if (total_package_price > 0 ||[dataDic[@"pei_amount"] floatValue] > 0 || [dataDic[@"first_youhui"] floatValue] > 0
        || [dataDic[@"hongbao"] floatValue] > 0 ||[dataDic[@"order_youhui"] floatValue] > 0 ) {
        [printer appendSeperatorLineWithTitle];
    }
    if (total_package_price > 0) {
        [printer appendLeftText: NSLocalizedString(@"打包费", NSStringFromClass([self class])) middleText:[@"x" stringByAppendingString:@(number).stringValue] rightText:@(total_package_price).stringValue isTitle:YES];
    }
    if ([dataDic[@"pei_amount"] floatValue] > 0) {
        [printer appendLeftText: NSLocalizedString(@"配送费", NSStringFromClass([self class])) middleText:@"" rightText:dataDic[@"pei_amount"] isTitle:YES];
    }
    if ([dataDic[@"first_youhui"] floatValue] > 0) {
        [printer appendLeftText: NSLocalizedString(@"首单优惠", NSStringFromClass([self class])) middleText:@"" rightText:dataDic[@"first_youhui"] isTitle:YES];
    }
    if ([dataDic[@"hongbao"] floatValue] > 0) {
        [printer appendLeftText: NSLocalizedString(@"红包抵扣", NSStringFromClass([self class])) middleText:@"" rightText:dataDic[@"hongbao"] isTitle:YES];
    }
    if ([dataDic[@"order_youhui"] floatValue] > 0) {
        [printer appendLeftText: NSLocalizedString(@"满减优惠", NSStringFromClass([self class])) middleText:@"" rightText:dataDic[@"order_youhui"] isTitle:YES];
    }
    [printer appendSeperatorLine];
    [printer appendText:[NSString stringWithFormat:@"%@   %@", NSLocalizedString(@"总计", NSStringFromClass([self class])),dataDic[@"total_price"]] alignment:HZQTextAlignmentLeft fontSize:HZQFontSizeTitleMiddle];
    [printer appendText:dataDic[@"addr"] alignment:HZQTextAlignmentLeft fontSize:HZQFontSizeTitleMiddle];
    [printer appendText:dataDic[@"contact"] alignment:HZQTextAlignmentLeft fontSize:HZQFontSizeTitleMiddle];
    [printer appendText:dataDic[@"mobile"] alignment:HZQTextAlignmentLeft fontSize:HZQFontSizeTitleMiddle];
    [printer appendNewLine];
    [printer appendNewLine];
    [printer appendNewLine];
    NSData *data = [printer getFinalData];
    if(!self.writeCharacteristic) {
        [JHShowAlert showAlertWithMsg: NSLocalizedString(@"未能成功写入\n请检查蓝牙是否打开或连接", NSStringFromClass([self class]))
                         withBtnTitle: NSLocalizedString(@"知道了", NSStringFromClass([self class]))
                         withBtnBlock:^{
                             //获取选择打印机的控制器
                             Class class = NSClassFromString(@"JHChoosePrinterVC");
                             UINavigationController *nav = (UINavigationController *)[UIApplication sharedApplication].delegate.window.rootViewController;
                             [nav pushViewController:[class new] animated:YES];
                         }];
        return;
    }
    [self.peripheral writeValue:data forCharacteristic:self.writeCharacteristic type:CBCharacteristicWriteWithoutResponse];
}

@end
