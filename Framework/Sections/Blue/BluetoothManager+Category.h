//
//  BluetoothManager+Category.h
//  ThermoTimer
//
//  Created by gejiangs on 15/8/11.
//  Copyright (c) 2015年 gejiangs. All rights reserved.
//

#import "BluetoothManager.h"

@interface BluetoothManager (Category)


//接收消息
-(void)receiveWithPeripheral:(CBPeripheral *)peripheral characteristic:(CBCharacteristic *)characteristic error:(NSError *)error;

//发送消息
-(void)sendWithPeripheral:(CBPeripheral *)peripheral characteristic:(CBCharacteristic *)characteristic error:(NSError *)error;


@end
