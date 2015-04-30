//
//  QQModel.m
//  Framework
//
//  Created by gejiangs on 15/3/31.
//  Copyright (c) 2015年 guojiang. All rights reserved.
//

#import "QQModel.h"

@implementation QQModel

//此方法用于配置数据key与model属性不相同问题
//{@"返回数据key":@"model属性"}
+(JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"icon":@"faceName"
                                                       }];
}

-(NSString *)faceUrl
{
//    NSString *url = @"http://pic.qiushibaike.com/system/avtnew/2456/24566294/medium/20150331155157.jpg";
    
    NSString *sub = [_uid substringWithRange:NSMakeRange(0, 4)];
    NSString *url = [NSString stringWithFormat:@"http://pic.qiushibaike.com/system/avtnew/%@/%@/medium/%@",
                     sub, _uid, _faceName];
    
    return url;
}

@end
