//
//  NSObject+Utils.m
//  Framework
//
//  Created by gejiangs on 15/4/7.
//  Copyright (c) 2015年 guojiang. All rights reserved.
//

#import "NSObject+Utils.h"

@implementation NSObject (Utils)

-(void)dispatchTimerWithTime:(CGFloat)time block:(void (^)(void))block
{
    dispatch_time_t time_t = dispatch_time(DISPATCH_TIME_NOW,(int64_t)(time * NSEC_PER_SEC));
    
    dispatch_after(time_t, dispatch_get_main_queue(), ^{ block(); });
}

@end
