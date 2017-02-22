//
//  RootManager.h
//  Community
//
//  Created by gejiangs on 16/1/22.
//  Copyright © 2016年 gejiangs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RootManager : NSObject

@property (nonatomic, readonly, copy)   NSString *name;

+ (instancetype)sharedManager;

-(NSDateFormatter *)dateFormatter;

@end
