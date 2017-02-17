//
//  NSDate+Utils.m
//  Framework
//
//  Created by 郭江 on 2017/2/10.
//  Copyright © 2017年 guojiang. All rights reserved.
//

#import "NSDate+Utils.h"

@implementation NSDate (Utils)

-(NSString *)stringDate
{
    [DateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [DateFormatter stringFromDate:self];
    return dateString;
}

-(NSString *)stringDateTime
{
    [DateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [DateFormatter stringFromDate:self];
    return dateString;
}

-(NSString *)stringYM
{
    [DateFormatter setDateFormat:@"yyyy-MM"];
    NSString *dateString = [DateFormatter stringFromDate:self];
    return dateString;
}

-(NSString *)stringHMS
{
    [DateFormatter setDateFormat:@"HH:mm:ss"];
    NSString *dateString = [DateFormatter stringFromDate:self];
    return dateString;
}

@end
