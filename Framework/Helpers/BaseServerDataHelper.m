//
//  BaseServerDataHelper.m
//  Framework
//
//  Created by guojiang on 23/9/14.
//  Copyright (c) 2014年 guojiang. All rights reserved.
//

#import "BaseServerDataHelper.h"


@interface BaseServerDataHelper()

@property (nonatomic, strong) BaseRequestOperator *baseOper;

@end

@implementation BaseServerDataHelper

-(id)init
{
    if (self = [super init]) {
        self.baseOper = [[BaseRequestOperator alloc] init];
    }
    
    return self;
}

-(RequestOperation *)getOperationGetUrl:(NSString *)url
                                 params:(NSDictionary *)params
                                success:(requestCompletionSuccessHandler)success
                                failure:(requestCompletionFailureHandler)failure
{
    AFHTTPRequestOperation *operation = [self.baseOper getRequestWithGETByURL:url
                                                                       params:params
                                                                      success:success
                                                                      failure:failure];
    RequestOperation *request = [[RequestOperation alloc] init];
    request.operation = operation;
    
    return request;
}

-(RequestOperation *)getOperationPostUrl:(NSString *)url
                                  params:(NSDictionary *)params
                                 success:(requestCompletionSuccessHandler)success
                                 failure:(requestCompletionFailureHandler)failure
{
    AFHTTPRequestOperation *operation = [self.baseOper getRequestWithPOSTByURL:url
                                                                       params:params
                                                                      success:success
                                                                      failure:failure];
    RequestOperation *request = [[RequestOperation alloc] init];
    request.operation = operation;
    
    return request;
}

-(void)requestGroupWithOperations:(NSArray *)operations completion:(requestCompletionHandler)completion
{
    
}

@end
