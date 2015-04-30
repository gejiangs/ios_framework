//
//  BaseRequestOperator.h
//  wook
//
//  Created by guojiang on 11/8/14.
//  Copyright (c) 2014年 guojiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestManager.h"

typedef void(^requestCompletionSuccessHandler)(BOOL succ, id responseObject);
typedef void(^requestCompletionFailureHandler)(NSError *error);
typedef void(^requestCompletionHandler)();
typedef void(^uploadProgress)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite);


@class AFHTTPRequestOperation;

@interface BaseRequestOperator : NSObject

@property (nonatomic, strong) AFHTTPRequestOperation *afRequest;

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
                 failure:(requestCompletionFailureHandler)failure;

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
                  failure:(requestCompletionFailureHandler)failure;

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
                 fileData:(NSData *)fileData
                  fileKey:(NSString *)fileKey
                  success:(requestCompletionSuccessHandler)success
                  failure:(requestCompletionFailureHandler)failure;

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
                 fileData:(NSData *)fileData
                  fileKey:(NSString *)fileKey
                 progress:(uploadProgress)progress
                  success:(requestCompletionSuccessHandler)success
                  failure:(requestCompletionFailureHandler)failure;

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
                                  failure:(requestCompletionFailureHandler)failure;

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
                                   failure:(requestCompletionFailureHandler)failure;

/**
 *  队列请求
 *
 *  @param managers   请求对象数组
 *  @param completion 所有请求完成block
 *  @return HTTP 队列请求
 */
-(void)requestGroupWithManagers:(NSArray *)managers
                     completion:(requestCompletionHandler)completion;


@end
