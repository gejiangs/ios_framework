//
//  QQModel.h
//  Framework
//
//  Created by gejiangs on 15/3/31.
//  Copyright (c) 2015年 guojiang. All rights reserved.
//

#import "BaseModel.h"

@interface QQModel : BaseModel

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *mobile_brand;
@property (nonatomic, copy) NSString *hometown;
@property (nonatomic, copy) NSString *faceName;      //此处faceName对应数据字段icon（可参考.m实现）
@property (nonatomic, copy) NSString *faceUrl;


@end
