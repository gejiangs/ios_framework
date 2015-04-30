//
//  QQHelper.m
//  Framework
//
//  Created by gejiangs on 15/3/31.
//  Copyright (c) 2015年 guojiang. All rights reserved.
//

#import "QQHelper.h"

@implementation QQHelper

-(RequestManager *)getQQInfoWithQQ:(NSString *)qq
                           success:(void (^)(BOOL, QQModel *))success
                           failure:(void (^)(NSError *))failure
{
    NSString *url = [NSString stringWithFormat:@"http://nearby.qiushibaike.com/user/%@/detail", qq];
    
    //此处self.requestOperator 可直接使用（对象在BaseHelper.m文件的init已经实例化）
    
    return [self.requestOperator getOperationGetWithUrl:url params:nil success:^(BOOL succ, id responseObject) {
        NSDictionary *userdata = [responseObject objectForKey:@"userdata"];
        
        QQModel *model = [[QQModel alloc] initWithDictionary:userdata error:nil];
        success(YES, model);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

@end
