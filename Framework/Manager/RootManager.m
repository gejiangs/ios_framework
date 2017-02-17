//
//  RootManager.m
//  Community
//
//  Created by gejiangs on 16/1/22.
//  Copyright © 2016年 gejiangs. All rights reserved.
//

#import "RootManager.h"
#import "AppDelegate.h"

@interface RootManager ()

@property (nonatomic, strong)   NSDateFormatter *dateFormatter;

@end

@implementation RootManager

+ (instancetype)sharedManager {
    static id _sharedInstance = nil;
    static dispatch_once_t dispatch_one;
    dispatch_once(&dispatch_one, ^{
        
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
    
}

-(NSDateFormatter *)dateFormatter
{
    if (_dateFormatter != nil) {
        return _dateFormatter;
    }
    self.dateFormatter = [[NSDateFormatter alloc] init];
    return _dateFormatter;
}

@end
