//
//  Student.m
//  MJExtensionExample
//
//  Created by MJ Lee on 15/1/5.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "Student.h"

@implementation Student

//此方法用于配置数据key与model属性不相同问题
//{@"model属性":@"返回数据key"}
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID" : @"id",
             @"desc" : @"desciption",
             @"oldName" : @"name.oldName",
             @"nowName" : @"name.newName",
             @"nameChangedTime" : @"name.info.nameChangedTime",
             @"bag" : @"other.bag"
             };
}
@end
