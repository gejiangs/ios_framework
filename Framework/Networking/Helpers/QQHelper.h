//
//  QQHelper.h
//  Framework
//
//  Created by gejiangs on 15/3/31.
//  Copyright (c) 2015年 guojiang. All rights reserved.
//

#import "BaseHelper.h"
#import "QQModel.h"

@interface QQHelper : BaseHelper

-(RequestManager *)getQQInfoWithQQ:(NSString *)qq
                           success:(void (^)(BOOL success, QQModel *model))success
                           failure:(void (^)(NSError *error))failure;



@end
