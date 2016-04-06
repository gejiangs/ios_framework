//
//  BluetoothManager+Category.m
//  ThermoTimer
//
//  Created by gejiangs on 15/8/11.
//  Copyright (c) 2015年 gejiangs. All rights reserved.
//

#import "BluetoothManager+Category.h"



@implementation BluetoothManager (Category)



-(void)receiveWithPeripheral:(CBPeripheral *)peripheral characteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    CBService *services = [peripheral.services firstObject];
    
    NSLog(@"servers:%@", peripheral.services);
    NSLog(@"servers.uuid:%@", services.UUID);

    if (error) {
        NSLog(@"receive error:%@", error);
        return;
    }
    
    NSLog(@"收到的数据：%@",characteristic.value);
    
    Byte data[255];
    [characteristic.value getBytes:data range:NSMakeRange(0, characteristic.value.length)];
    
    
}


-(void)sendWithPeripheral:(CBPeripheral *)peripheral characteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"=======%@",error.userInfo);
    }else{
        NSLog(@"发送数据成功");
    }
}


@end
