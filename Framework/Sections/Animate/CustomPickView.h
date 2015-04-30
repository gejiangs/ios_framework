//
//  CoustomDatePickView.h
//  WIFI_LED
//
//  Created by gejiangs on 15/3/24.
//  Copyright (c) 2015年 gejiangs. All rights reserved.
//

#import "BaseView.h"

@interface CustomPickView : BaseView

@property (nonatomic, copy) void (^sureAction)(NSString *timeString);

-(void)setTimeString:(NSString *)timeString;

@end
