//
//  NSObject+Utils.m
//  Framework
//
//  Created by gejiangs on 15/4/7.
//  Copyright (c) 2015年 guojiang. All rights reserved.
//

#import "NSObject+Utils.h"
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

@implementation NSObject (Utils)

-(void)dispatchTimerWithTime:(CGFloat)time block:(void (^)(void))block
{
    dispatch_time_t time_t = dispatch_time(DISPATCH_TIME_NOW,(int64_t)(time * NSEC_PER_SEC));
    
    dispatch_after(time_t, dispatch_get_main_queue(), ^{ block(); });
}

-(void)dispatchAsyncMainQueue:(void (^)(void))block
{
    dispatch_async(dispatch_get_main_queue(), block);
}


-(void)dispatchAsyncGlobalQueue:(void (^)(void))block
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), block);
}


-(NSString *)languageKey:(NSString *)key
{
    return NSLocalizedString(key, nil);
}


-(void)showAlertView:(NSString *)title message:(NSString *)message
{
    [self showAlertView:title message:message buttonTitles:@[@"确定"] block:nil];
}

-(void)showAlertView:(NSString *)title
             message:(NSString *)message
        buttonTitles:(NSArray *)titles
               block:(void (^)(NSInteger))block
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:nil, nil];
    for (NSString *buttonTitle in titles) {
        [alert addButtonWithTitle:buttonTitle];
    }
    
    [alert showAlertViewWithCompleteBlock:block];
}


- (NSString *) macaddress
{
    
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1/n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!/n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    
    //    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x", *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    
    NSLog(@"outString:%@", outstring);
    
    free(buf);
    
    return [outstring uppercaseString];
}

@end
