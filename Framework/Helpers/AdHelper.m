//
//  AdHelper.m
//  WIFI_LED
//
//  Created by gejiangs on 15/3/11.
//  Copyright (c) 2015年 gejiangs. All rights reserved.
//

#import "AdHelper.h"

@implementation AdHelper

-(void)getADInfoWithSuccess:(void (^)(BOOL, AdModel *))success failure:(void (^)(NSError *))failure
{
    [self.requestOperator requestGetWithURL:@"http://m2.qiushibaike.com/ad?AdID=14260582945040F4E3A48F"
                                     params:nil
                                    success:^(BOOL succ, id responseObject) {
                                        
                                        AdModel *adModel = [[AdModel alloc] initWithDictionary:responseObject error:nil];
                                        success(YES, adModel);
                                        
                                    } failure:^(NSError *error) {
                                        failure(error);
                                    }];
}

@end
