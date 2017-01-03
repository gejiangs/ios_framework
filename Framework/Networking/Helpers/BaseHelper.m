//
//  BaseHelper.m
//  Framework
//
//  Created by gejiangs on 15/2/9.
//  Copyright (c) 2015年 guojiang. All rights reserved.
//

#import "BaseHelper.h"


@implementation BaseHelper

-(id)init
{
    if (self = [super init]) {
        
    }
    return self;
}

-(BaseRequestOperator *)requestOperator
{
    if (_requestOperator == nil) {
        self.requestOperator = [[BaseRequestOperator alloc] init];
    }
    return _requestOperator;
}

-(void)requestGroupWithManagers:(NSArray *)managers completion:(void (^)())completion
{
    [self.requestOperator requestGroupWithManagers:managers completion:completion];
}


- (void)cancelAllRequest
{
    [self.requestOperator cancelAllRequest];
}
@end
