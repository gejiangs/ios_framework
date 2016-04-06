//
//  AppDelegate.m
//  Framework
//
//  Created by guojiang on 19/9/14.
//  Copyright (c) 2014年 guojiang. All rights reserved.
//

#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>

#import "UMSocialYixinHandler.h"
#import "UMSocialFacebookHandler.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialRenrenHandler.h"

#import "UMSocialInstagramHandler.h"
#import "UMSocialWhatsappHandler.h"
#import "UMSocialLineHandler.h"
#import "UMSocialTumblrHandler.h"


@interface AppDelegate ()

@property (nonatomic, unsafe_unretained) UIBackgroundTaskIdentifier bgTask;
@property (nonatomic, strong) NSTimer *myTimer;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    NSLog(@"document:%@",[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]);
    
    //设置友盟社会化组件appkey
    [UMSocialData setAppKey:UmengAppkey];
    
    //设置微信AppId，设置分享url，默认使用友盟的网址
    [UMSocialWechatHandler setWXAppId:@"wxd930ea5d5a258f4f" appSecret:@"db426a9829e4b49a0dcac7b4162da6b6" url:@"http://www.umeng.com/social"];
    
    //设置分享到QQ空间的应用Id，和分享url 链接
    [UMSocialQQHandler setQQWithAppId:@"100424468" appKey:@"c7394704798a158208a74ab60104f0ba" url:@"http://www.umeng.com/social"];
    
    //设置易信Appkey和分享url地址
    [UMSocialYixinHandler setYixinAppKey:@"yx35664bdff4db42c2b7be1e29390c1a06" url:@"http://www.umeng.com/social"];
    
    //打开人人网SSO开关
    [UMSocialRenrenHandler openSSO];
    
    //设置facebook应用ID，和分享纯文字用到的url地址
    [UMSocialFacebookHandler setFacebookAppID:@"91136964205" shareFacebookWithURL:@"http://www.umeng.com/social"];
    
    //下面打开Instagram的开关
    [UMSocialInstagramHandler openInstagramWithScale:NO paddingColor:[UIColor blackColor]];
    
    //打开whatsapp
    [UMSocialWhatsappHandler openWhatsapp:UMSocialWhatsappMessageTypeImage];
    
    //打开Tumblr
    [UMSocialTumblrHandler openTumblr];
    
    //打开line
    [UMSocialLineHandler openLineShare:UMSocialLineMessageTypeImage];
    
    
    NSLog(@"didFinishLaunchingWithOptions");
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    //应用退到后台
    
    //一个后台任务标识符（向程序借用一点时间，统计后得出借用时间为：3分钟）
    self.bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //3分钟后，这里的block会调用
            NSLog(@"beginBackgroundTaskWithExpirationHandler");
        });
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"1秒后开始后台运行");
            
            //设置定时器
            self.myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(runTimer) userInfo:nil repeats:YES];
        });
    });
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    //应用切换回前台
    [application endBackgroundTask:self.bgTask];
    self.bgTask = UIBackgroundTaskInvalid;
    
    if (self.myTimer) {
        [self.myTimer invalidate];
        self.myTimer = nil;
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if (!self.isFull) {
        return UIInterfaceOrientationMaskPortrait;
    }
    
    return UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskPortrait;
}

-(void)runTimer
{
    NSLog(@"run timer ");
}

@end
