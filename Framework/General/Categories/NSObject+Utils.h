//
//  NSObject+Utils.h
//  Framework
//
//  Created by gejiangs on 15/4/7.
//  Copyright (c) 2015年 guojiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Utils)

//延迟GCD
-(void)dispatchTimerWithTime:(CGFloat)time block:(void(^)(void))block;

-(void)dispatchAsyncMainQueue:(void (^)(void))block;

-(void)dispatchAsyncGlobalQueue:(void (^)(void))block;

//语言文件
-(NSString *)languageKey:(NSString *)key;

-(void)showAlertView:(NSString *)title message:(NSString *)message;

-(void)showAlertView:(NSString *)title
             message:(NSString *)message
        buttonTitles:(NSArray *)titles
               block:(void(^)(NSInteger buttonIndex))block;

//获取手机mac地址
- (NSString *)macaddress;

@end
