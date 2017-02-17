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

#define AppVersionNumber                    [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define AppName                             [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey]
#define DeviceName                          [[UIDevice currentDevice] name]
#define DeviceModel                         [[UIDevice currentDevice] systemName]
#define DeviceVersion                       [[UIDevice currentDevice] systemVersion]
#define ApplicationDelegate                 ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define WINDOW                              ApplicationDelegate.window
#define UserDefaults                        [NSUserDefaults standardUserDefaults]
#define SharedApplication                   [UIApplication sharedApplication]
#define Bundle                              [NSBundle mainBundle]
#define MainScreen                          [UIScreen mainScreen]
#define ShowNetworkActivityIndicator()      [UIApplication sharedApplication].networkActivityIndicatorVisible = YES
#define HideNetworkActivityIndicator()      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO
#define NetworkActivityIndicatorVisible(x)  [UIApplication sharedApplication].networkActivityIndicatorVisible = x
#define ScreenRect                          [[UIScreen mainScreen] bounds]
#define ScreenWidth                         [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight                        [[UIScreen mainScreen] bounds].size.height
#define FlushPool(p)                        [p drain]; p = [[NSAutoreleasePool alloc] init]
#define RGB(r, g, b)                        [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:1.f]
#define RGBA(r, g, b, a)                    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define IOSVersion                          [[[UIDevice currentDevice] systemVersion] floatValue]
#define IOSVersion7Later                    (IOSVersion >= 7.0)
#define IOSVersion8Later                    (IOSVersion >= 8.0)

#define Rect(x, y, w, h)                    CGRectMake(x, y, w, h)
#define Size(w, h)                          CGSizeMake(w, h)
#define Point(x, y)                         CGPointMake(x, y)
#define IntNumber(i)                        [NSNumber numberWithInt:i]
#define IntegerNumber(i)                    [NSNumber numberWithInteger:i]
#define FloatNumber(f)                      [NSNumber numberWithFloat:f]
#define DoubleNumber(dl)                    [NSNumber numberWithDouble:dl]
#define BoolNumber(b)                       [NSNumber numberWithBool:b]

#define StringNotEmpty(str)                 (str && (str.length > 0))
#define StringIsEmpty(str)                  (!str || (str.length == 0))
#define ArrayNotEmpty(arr)                  (arr && (arr.count > 0))
#define URLFromString(str)                  [NSURL URLWithString:str]

#define WEAKSELF                            __weak      __typeof(self)      weakSelf = self;
#define STRONGSELF                          __strong    __typeof(weakSelf)  strongSelf = weakSelf;

#define DateFormatter                       [[RootManager sharedManager] dateFormatter]

#endif
