//
//  AppMarco.h
//  Eventor
//
//  Created by guojiang on 14-5-13.
//  Copyright (c) 2014年 DaCheng. All rights reserved.
//

#ifndef Eventor_AppMarco_h
#define Eventor_AppMarco_h


#pragma mark - 发布有关的设置




//////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 代码简写

#define AppVersionNumber                        [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define AppName                                 [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey]
#define DeviceName                              [[UIDevice currentDevice] name]
#define DeviceModel                             [[UIDevice currentDevice] systemName]
#define DeviceVersion                           [[UIDevice currentDevice] systemVersion]
#define URLFromString(str)                      [NSURL URLWithString:str]
#define StringFormat(str)                       [NSString stringWithFormat:@"%@",str]


#pragma mark - 界面有关的宏


#define SIZE_TextSmall                          10.0f
#define SIZE_TextContentNormal                  13.0f
#define SIZE_TextTitleMini                      15.0f
#define SIZE_TextTitleNormal                    17.0f
#define SIZE_TextTitleLarge                     20.0f
#define SIZE_TextLarge                          16.0f
#define SIZE_TextHuge                           18.0f


#endif
