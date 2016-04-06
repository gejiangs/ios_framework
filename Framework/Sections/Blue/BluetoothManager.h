//
//  BluetoothManager.h
//  ThermoTimer
//
//  Created by gejiangs on 15/8/10.
//  Copyright (c) 2015年 gejiangs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

typedef enum : NSUInteger {
    DeviceTypeUnknow = 0,
    DeviceTypeOne,
    DeviceTypeFour
} DeviceType;

@interface BluetoothManager : NSObject

@property (nonatomic, strong)   CBPeripheral *peripheral;    //当前连接蓝牙设备
@property (nonatomic, copy)     void(^blueConnectBlock)(BOOL success);      //蓝牙连接block


+(BluetoothManager *)shareManager;

-(void)initCentral;

/**
 *  系统是否支持蓝牙
 *
 *  @return 返回系统是否支持蓝牙
 */
-(BOOL)supportHardware;


/**
 *  开始扫描蓝牙设备
 */
-(void)startScan;

/**
 *  开始扫描蓝牙设备
 *
 *  @param block 扫描到的设备列表
 */
-(void)startScanBlock:(void (^)(NSArray *peripheralArray))block finally:(void(^)())finally;

/**
 *  停止扫描蓝牙设备
 */
-(void)stopScan;


/**
 *  连接蓝牙设备
 *
 *  @param peripheral 蓝牙设备对象
 *  @param block 蓝牙连接是否成功
 */
-(void)connect:(CBPeripheral *)peripheral block:(void(^)(BOOL success))block;

@end
