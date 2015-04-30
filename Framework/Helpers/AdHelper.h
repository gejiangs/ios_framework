//
//  AdHelper.h
//  WIFI_LED
//
//  Created by gejiangs on 15/3/11.
//  Copyright (c) 2015年 gejiangs. All rights reserved.
//

#import "BaseHelper.h"
#import "AdModel.h"

@interface AdHelper : BaseHelper

-(void)getADInfoWithSuccess:(void (^)(BOOL success, AdModel *adModel))success
                    failure:(void (^)(NSError *error))failure;

@end
