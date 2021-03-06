//
//  BaseRequestOperator.m
//  wook
//
//  Created by guojiang on 11/8/14.
//  Copyright (c) 2014年 guojiang. All rights reserved.
//

#import "BaseRequestOperator.h"
#import "AFHTTPRequestOperation.h"

@implementation RequestManager

@end

@implementation RequestFileModel

-(id)init
{
    if (self = [super init]) {
        self.mimeType = @"image/png";
        self.name = @"file";
    }
    return self;
}

@end

@interface BaseRequestOperator ()

@property (nonatomic, copy) requestCompletionSuccessHandler successHandler;
@property (nonatomic, copy) requestCompletionFailureHandler failureHandler;
@property (nonatomic, copy) requestCompletionHandler completionHandler;

@end

@implementation BaseRequestOperator


#pragma mark -  请求
/**
 *  http get请求
 *
 *  @param url     url地址
 *  @param params  参数
 *  @param success 成功block
 *  @param failure 失败block
 *  @return HTTP get 请求
 */
-(void)requestGetWithURL:(NSString *)url
                  params:(NSDictionary *)params
                 success:(requestCompletionSuccessHandler)success
                 failure:(requestCompletionFailureHandler)failure
{
    [self requestWithMethod:@"GET" URL:url params:params success:success failure:failure];
}
/**
 *  http post请求
 *
 *  @param url     url地址
 *  @param params  参数
 *  @param success 成功block
 *  @param failure 失败block
 *  @return HTTP post 请求
 */
-(void)requestPostWithURL:(NSString *)url
                   params:(NSDictionary *)params
                  success:(requestCompletionSuccessHandler)success
                  failure:(requestCompletionFailureHandler)failure
{
    [self requestWithMethod:@"POST" URL:url params:params success:success failure:failure];
}

/**
 *  http 网络请求
 *
 *  @param url     url地址
 *  @param params  参数
 *  @param success 成功block
 *  @param failure 失败block
 *  @return HTTP 网络请求
 */
-(void)requestWithMethod:(NSString *)method
                     URL:(NSString *)url
                  params:(NSDictionary *)params
                 success:(requestCompletionSuccessHandler)success
                 failure:(requestCompletionFailureHandler)failure
{
    
    self.afRequest = [self getRequestWithMethod:method url:url params:params success:success failure:failure];
    
    [self.afRequest start];
}


/**
 *  http 上传图片
 *
 *  @param url     url地址
 *  @param params  参数
 *  @param success 成功block
 *  @param failure 失败block
 *  @return HTTP 上传图片
 */
-(void)uploadImageWithURL:(NSString *)url
                   params:(NSDictionary *)params
                fileModel:(RequestFileModel *)model
                  success:(requestCompletionSuccessHandler)success
                  failure:(requestCompletionFailureHandler)failure
{
    [self uploadImageWithURL:url params:params fileModel:model progress:nil success:success failure:failure];
}
/**
 *  http 上传图片
 *
 *  @param url     url地址
 *  @param params  参数
 *  @param progress 上传进度block
 *  @param success 成功block
 *  @param failure 失败block
 *  @return HTTP 上传图片
 */
-(void)uploadImageWithURL:(NSString *)url
                   params:(NSDictionary *)params
                fileModel:(RequestFileModel *)model
                 progress:(uploadProgress)progress
                  success:(requestCompletionSuccessHandler)success
                  failure:(requestCompletionFailureHandler)failure
{
    [self uploadImageWithURL:url params:params fileModels:@[model] progress:progress success:success failure:failure];
}

/**
 *  http 上传图片
 *
 *  @param url     url地址
 *  @param params  参数
 *  @param progress 上传进度block
 *  @param success 成功block
 *  @param failure 失败block
 *  @return HTTP 上传图片
 */
-(void)uploadImageWithURL:(NSString *)url
                   params:(NSDictionary *)params
               fileModels:(NSArray *)models
                  success:(requestCompletionSuccessHandler)success
                  failure:(requestCompletionFailureHandler)failure
{
    [self uploadImageWithURL:url params:params fileModels:models progress:nil success:success failure:failure];
}

/**
 *  http 上传图片
 *
 *  @param url     url地址
 *  @param params  参数
 *  @param progress 上传进度block
 *  @param success 成功block
 *  @param failure 失败block
 *  @return HTTP 上传图片
 */
-(void)uploadImageWithURL:(NSString *)url
                   params:(NSDictionary *)params
               fileModels:(NSArray *)models
                 progress:(uploadProgress)progress
                  success:(requestCompletionSuccessHandler)success
                  failure:(requestCompletionFailureHandler)failure
{
    self.successHandler = success;
    self.failureHandler = failure;
    
    void(^bodyWithBlock)(id<AFMultipartFormData> formData)= ^(id<AFMultipartFormData> formData){
        for (RequestFileModel *model in models) {
            [formData appendPartWithFileData:model.fileData
                                        name:model.name
                                    fileName:model.fileName
                                    mimeType:model.mimeType];
        }
    };
    
    AFHTTPRequestSerializer <AFURLRequestSerialization> * requestSerializer = [AFHTTPRequestSerializer serializer];
    NSMutableURLRequest *request = [requestSerializer multipartFormRequestWithMethod:@"POST"
                                                                           URLString:[[NSURL URLWithString:url] absoluteString]
                                                                          parameters:params
                                                           constructingBodyWithBlock:bodyWithBlock
                                                                               error:nil];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    NSMutableSet *set = [[NSMutableSet alloc] initWithSet:operation.responseSerializer.acceptableContentTypes];
    [set addObject:@"application/json"];
    [set addObject:@"text/json"];
    [set addObject:@"text/javascript"];
    [set addObject:@"text/html"];
    [set addObject:@"text/css"];
    [set addObject:@"text/plain"];
    
    operation.responseSerializer.acceptableContentTypes = set;
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //此处做返回判断YES、NO
         BOOL success = [[responseObject objectForKey:@"code"] intValue] == 0;
         NSString *message = [responseObject objectForKey:@"msg"];
         
         self.successHandler(success, message, responseObject);
     }
     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         self.failureHandler(error);
     }];
    
    if (progress) {
        [operation setUploadProgressBlock:progress];
    }
    
    self.afRequest = operation;
    
    [self.afRequest start];
}


#pragma mark - 返回队列请求对象(主要用于多任务请求)
/**
 *  http get 请求对象
 *
 *  @param url     url地址
 *  @param params  参数
 *  @param success 成功block
 *  @param failure 失败block
 *  @return HTTP get 请求对象
 */
-(RequestManager *)getOperationGetWithUrl:(NSString *)url
                                   params:(NSDictionary *)params
                                  success:(requestCompletionSuccessHandler)success
                                  failure:(requestCompletionFailureHandler)failure
{
    AFHTTPRequestOperation *operation = [self getRequestWithGETByURL:url
                                                              params:params
                                                             success:success
                                                             failure:failure];
    RequestManager *request = [[RequestManager alloc] init];
    request.operation = operation;
    
    return request;
}
/**
 *  http post 请求对象
 *
 *  @param url     url地址
 *  @param params  参数
 *  @param success 成功block
 *  @param failure 失败block
 *  @return HTTP post 请求对象
 */
-(RequestManager *)getOperationPostWithUrl:(NSString *)url
                                    params:(NSDictionary *)params
                                   success:(requestCompletionSuccessHandler)success
                                   failure:(requestCompletionFailureHandler)failure
{
    AFHTTPRequestOperation *operation = [self getRequestWithPOSTByURL:url
                                                               params:params
                                                              success:success
                                                              failure:failure];
    RequestManager *request = [[RequestManager alloc] init];
    request.operation = operation;
    
    return request;
}

-(AFHTTPRequestOperation *)getRequestWithGETByURL:(NSString *)url
                                           params:(NSDictionary *)params
                                          success:(requestCompletionSuccessHandler)success
                                          failure:(requestCompletionFailureHandler)failure
{
    return [self getRequestWithMethod:@"GET" url:url params:params success:success failure:failure];
}

-(AFHTTPRequestOperation *)getRequestWithPOSTByURL:(NSString *)url
                                            params:(NSDictionary *)params
                                           success:(requestCompletionSuccessHandler)success
                                           failure:(requestCompletionFailureHandler)failure
{
    return [self getRequestWithMethod:@"POST" url:url params:params success:success failure:failure];
}

/**
 *  返回 AFHTTPRequestOperation 对象
 *
 *  @param method  请求方法类型(get,post,put,delete)
 *  @param url     url请求地址
 *  @param params  请求参数
 *  @param success 成功block
 *  @param failure 失败block
 *
 *  @return AFHTTPRequestOperation 对象
 */
-(AFHTTPRequestOperation *)getRequestWithMethod:(NSString *)method
                                            url:(NSString *)url
                                         params:(NSDictionary *)params
                                        success:(requestCompletionSuccessHandler)success
                                        failure:(requestCompletionFailureHandler)failure
{
#pragma mark -
#pragma mark -  ztx add start
    
    /// 打印请求数据
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *key in [params allKeys]) {
        NSString *str = [NSString stringWithFormat:@"%@=%@",key,params[key]];
        [array addObject:str];
    }
    NSString *postString = [array componentsJoinedByString:@"&"];
    NSString *urlString = url;
    if (postString.length >0) {
        urlString = [NSString stringWithFormat:@"%@&%@",url,postString];
    }
    NSLog(@"这是请求的url:%@",urlString);
    
#pragma mark -
#pragma mark -  ztx add  end
    
    self.successHandler = success;
    self.failureHandler = failure;
    
    AFHTTPRequestSerializer <AFURLRequestSerialization> * requestSerializer = [AFHTTPRequestSerializer serializer];
    NSMutableURLRequest *request = [requestSerializer requestWithMethod:method
                                                              URLString:[[NSURL URLWithString:url] absoluteString]
                                                             parameters:params
                                                                  error:nil];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    NSMutableSet *set = [[NSMutableSet alloc] initWithSet:operation.responseSerializer.acceptableContentTypes];
    [set addObject:@"application/json"];
    [set addObject:@"text/json"];
    [set addObject:@"text/javascript"];
    [set addObject:@"text/html"];
    [set addObject:@"text/css"];
    [set addObject:@"text/plain"];
    
    operation.responseSerializer.acceptableContentTypes = set;
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"这是%@返回的数据:%@",urlString,responseObject);
         
         BOOL success = [[responseObject objectForKey:@"code"] intValue] == 0;
         NSString *message = [responseObject objectForKey:@"msg"];
         
         self.successHandler(success, message, responseObject);
     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         self.failureHandler(error);
     }];
    
    return operation;
}

#pragma mark - HTTP 队列请求
/**
 *  队列请求
 *
 *  @param managers   请求对象数组
 *  @param completion 所有请求完成block
 *  @return HTTP 队列请求
 */
-(void)requestGroupWithManagers:(NSArray *)managers
                     completion:(requestCompletionHandler)completion
{
    NSMutableArray *operations = [NSMutableArray array];
    for (RequestManager *manager in managers) {
        [operations addObject:manager.operation];
    }
    
    self.completionHandler = completion;
    NSArray *operationsArr = [AFURLConnectionOperation batchOfRequestOperations:operations
                                                                  progressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
                                                                      
                                                                  } completionBlock:^(NSArray *operations) {
                                                                      self.completionHandler();
                                                                  }];
    [[NSOperationQueue mainQueue] addOperations:operationsArr waitUntilFinished:NO];
}




- (NSString *)toJSONData:(id)theData
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if (error) {
        return @"";
    }
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

/**
 *  取消网络请求
 */
- (void)cancelAllRequest
{
    if (_afRequest)
    {
        [_afRequest cancel];
        _afRequest = nil;
    }else{}
}

/**
 *  设置为nil
 *  self.xxxx = nil
 */
-(void)dealloc
{
    //    [self cancelAllRequest];
}

@end
