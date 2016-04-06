//
//  BaseHelper.h
//  Framework
//
//  Created by gejiangs on 15/2/9.
//  Copyright (c) 2015年 guojiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequestOperator.h"

@interface BaseHelper : NSObject

@property (nonatomic, strong) BaseRequestOperator *requestOperator;

-(void)requestGroupWithManagers:(NSArray *)managers
                     completion:(void(^)())completion;


- (void)cancelAllRequest;
@end
