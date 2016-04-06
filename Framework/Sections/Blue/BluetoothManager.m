//
//  BluetoothManager.m
//  ThermoTimer
//
//  Created by gejiangs on 15/8/10.
//  Copyright (c) 2015年 gejiangs. All rights reserved.
//

#import "BluetoothManager.h"
#import "BluetoothManager+Category.h"

#define BLE_SERVICE_NAME @"ECO_Balance"
#define UUIDSTR_ISSC_PROPRIETARY_SERVICE @"FFF0"

@interface BluetoothManager ()<CBCentralManagerDelegate, CBPeripheralDelegate>

@property (nonatomic, strong)   CBCentralManager *manager;

@property (nonatomic, strong)   NSMutableArray *peripheralArray;            //扫描设备列表

@property (nonatomic, copy)     void(^scanResultBlock)(NSArray *Array);     //扫描返回设备列表
@property (nonatomic, copy)     void(^scanFinallyBlock)();                  //扫描结束

@end

@implementation BluetoothManager

+ (BluetoothManager *)shareManager
{
    static BluetoothManager *share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
      share = [[self alloc] init];
    });
    return share;
}

-(void)initCentral
{
    self.manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
}


//开始扫描
-(void)startScan
{
    //先暂停扫描，再开始扫描
    [self.manager stopScan];
    
    //开始扫描，清空之前扫描结果
    self.peripheralArray = [NSMutableArray array];
    
    NSDictionary * dic = @{CBCentralManagerScanOptionAllowDuplicatesKey:@YES};
    
    [self.manager scanForPeripheralsWithServices:nil options:dic];
    
    //扫描超时
    [self dispatchTimerWithTime:5.f block:^{
        if (self.scanFinallyBlock) {
            self.scanFinallyBlock();
        }
        [self stopScan];
    }];
}

//开始扫描
-(void)startScanBlock:(void (^)(NSArray *))block finally:(void (^)())finally
{
    self.scanResultBlock = block;
    self.scanFinallyBlock = finally;
    [self startScan];
}

//停止扫描
-(void)stopScan
{
    [self.manager stopScan];
}

//判断系统是否支持蓝牙
- (BOOL)supportHardware
{
    BOOL v = NO;
    switch ([self.manager state])
    {
        case CBCentralManagerStateUnsupported:  //  系统不支持蓝牙
        case CBCentralManagerStateUnauthorized: //  设备未授权状态
        case CBCentralManagerStatePoweredOff:   //  设备关闭状态
        case CBCentralManagerStateUnknown:      //  初始的时候是未知的
        case CBCentralManagerStateResetting:    //  正在重置状态
            v = NO;
            break;
        case CBCentralManagerStatePoweredOn:    // 设备开启状态 -- 可用状态
            v = YES;
            break;
    }
    return v;
}


//开始查看服务，蓝牙开启
-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state) {
        case CBCentralManagerStatePoweredOn:
            NSLog(@"蓝牙已打开,请扫描外设");
            break;
        default:
            break;
    }
}

//查到外设后，停止扫描，连接设备
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary *)advertisementData
                  RSSI:(NSNumber *)RSSI
{
    //此处判断设备名（可自动连接）
    //if([peripheral.name isEqualToString:BLE_SERVICE_NAME]){
        //扫描到设备，添加到列表(去重)
        if (![self.peripheralArray containsObject:peripheral]) {
            [self.peripheralArray addObject:peripheral];
            
            //返回扫描设备列表
            if (self.scanResultBlock) {
                self.scanResultBlock(self.peripheralArray);
            }
        }
    //}
    NSLog(@"peripheral:%@", peripheral);
}

//连接蓝牙设备
-(void)connect:(CBPeripheral *)peripheral block:(void (^)(BOOL))block
{
    self.blueConnectBlock = block;
    
    self.manager.delegate = self;
    
    NSDictionary *options = @{CBConnectPeripheralOptionNotifyOnDisconnectionKey:@YES};
    
    [self.manager connectPeripheral:peripheral options:options];
}

#pragma mark  CBCentralManagerDelegate
//蓝牙设备连接成功，开始发现服务
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    self.peripheral = peripheral;    //蓝牙连接成功
    
    [peripheral setDelegate:self]; //查找服务
    [peripheral discoverServices:nil];
    
    //蓝牙设备连接成功
    if (self.blueConnectBlock) {
        self.blueConnectBlock(YES);
    }
}

//连接外设失败
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    if (self.blueConnectBlock) {
        self.blueConnectBlock(NO);
    }
}

-(void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
{
    //NSLog(@"%s,%@",__PRETTY_FUNCTION__,peripheral);
    int rssi = abs([peripheral.RSSI intValue]);
    CGFloat ci = (rssi - 59) / (10 * 2.);
    NSString *length = [NSString stringWithFormat:@"发现BLT4.0热点:%@,距离:%.1fm==rssi:%d",_peripheral,pow(10,ci), rssi];
    NSLog(@"距离：%@",length);
}

#pragma mark CBPeripheralDelegate

//已发现服务
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error)
    {
        NSLog(@"Discovered services for %@ with error: %@", peripheral.name, [error localizedDescription]);
        return;
    }
    
    for (CBService *service in peripheral.services)
    {
        //发现服务
        if ([service.UUID isEqual:[CBUUID UUIDWithString:UUIDSTR_ISSC_PROPRIETARY_SERVICE]])
        {
            NSLog(@"Service found with UUID: %@", service.UUID);  //查找特征
            [peripheral discoverCharacteristics:nil forService:service];
            break;
        }
    }
}

//已搜索到Characteristics
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if (error)
    {
        NSLog(@"Discovered characteristics for %@ with error: %@", service.UUID, [error localizedDescription]);
        return;
    }
    
    NSLog(@"服务：%@",service.UUID);
    for (CBCharacteristic *characteristic in service.characteristics)
    {
        if (characteristic.properties == CBCharacteristicPropertyNotify) {
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
        }
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFF1"]]) {
            [peripheral readRSSI];
        }
    }
}

//获取外设发来的数据，不论是read和notify,获取数据都是从这个方法中读取。
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    [self receiveWithPeripheral:peripheral characteristic:characteristic error:error];
}

//中心读取外设实时数据
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        NSLog(@"Error changing notification state: %@", error.localizedDescription);
    }
    // Notification has started
    if (characteristic.isNotifying) {
        [peripheral readValueForCharacteristic:characteristic];
        
    } else { // Notification has stopped
        // so disconnect from the peripheral
        NSLog(@"Notification stopped on %@.  Disconnecting", characteristic);
        [self.manager cancelPeripheralConnection:peripheral];
    }
}
//用于检测中心向外设写数据是否成功
-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    [self sendWithPeripheral:peripheral characteristic:characteristic error:error];
}


@end
