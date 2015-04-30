//
//  BaseServerDataHelper.h
//  Framework
//
//  Created by guojiang on 23/9/14.
//  Copyright (c) 2014年 guojiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseRequestOperator.h"
#import "AFHTTPRequestOperation.h"


@interface RequestOperation : NSObject

@property (nonatomic, strong) AFHTTPRequestOperation *operation;

@end


@implementation RequestOperation

@end


@interface BaseServerDataHelper : NSObject

-(RequestOperation *)getOperationGetUrl:(NSString *)url
                                 params:(NSDictionary *)params
                                success:(requestCompletionSuccessHandler)success
                                failure:(requestCompletionFailureHandler)failure;
-(RequestOperation *)getOperationPostUrl:(NSString *)url
                                  params:(NSDictionary *)params
                                 success:(requestCompletionSuccessHandler)success
                                 failure:(requestCompletionFailureHandler)failure;

-(void)requestGroupWithOperations:(NSArray *)operations
                       completion:(requestCompletionHandler)completion;

@end





