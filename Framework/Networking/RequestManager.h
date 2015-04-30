//
//  RequestManager.h
//  Framework
//
//  Created by gejiangs on 15/1/20.
//  Copyright (c) 2015年 guojiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AFHTTPRequestOperation;

@interface RequestManager : NSObject

@property (nonatomic, strong) AFHTTPRequestOperation *operation;

@end
