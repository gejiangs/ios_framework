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

@end
