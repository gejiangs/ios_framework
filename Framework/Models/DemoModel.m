//
//  DemoModel.m
//  Framework
//
//  Created by gejiangs on 16/2/17.
//  Copyright © 2016年 guojiang. All rights reserved.
//

#import "DemoModel.h"

@implementation DemoModel

//实现NSCode
MJCodingImplementation

//返回数据与属性值不一样处理
//{@"model属性":@"返回数据key"}
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID":@"id", @"nowName" : @"name.newName",};
}


/**
 *  这个数组中的属性名将会被忽略：不进行归档
 */
+ (NSArray *)ignoredCodingPropertyNames
{
    return @[@"nowName"];
}

//返回值转换处理
- (id)newValueFromOldValue:(id)oldValue property:(MJProperty *)property
{
    if ([property.name isEqualToString:@"nickName"])
    {
        if ([oldValue isEqualToString:@""])
        {
            return @"匿名";
        }
        
    }
    return oldValue;
}

// 数组中的类(model自动转换)
+ (NSDictionary *)objectClassInArray
{
    return @{@"comments" : @"CommentModel"};
}

@end
