//
//  ToastView.h
//  WIFI_LED
//
//  Created by gejiangs on 15/4/8.
//  Copyright (c) 2015年 gejiangs. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DEFAULT_DISPLAY_DURATION 2.0f 

@interface ToastView : NSObject

+ (void)showWithText:(NSString *)text inView:(UIView *)view;
+ (void)showWithText:(NSString *)text inView:(UIView *)view duration:(CGFloat)duration;

+ (void)showWithText:(NSString *)text inView:(UIView *)view topOffset:(CGFloat) topOffset;
+ (void)showWithText:(NSString *)text inView:(UIView *)view topOffset:(CGFloat) topOffset duration:(CGFloat) duration;

+ (void)showWithText:(NSString *)text inView:(UIView *)view bottomOffset:(CGFloat) bottomOffset;
+ (void)showWithText:(NSString *)text inView:(UIView *)view bottomOffset:(CGFloat) bottomOffset duration:(CGFloat) duration;

@end
