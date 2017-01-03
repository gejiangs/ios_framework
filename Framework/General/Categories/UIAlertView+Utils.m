//
//  UIAlertView+Block.m
//  FenQiBao
//
//  Created by guojiang on 15/1/6.
//  Copyright (c) 2015年 DaChengSoftware. All rights reserved.
//

#import "UIAlertView+Utils.h"
#import <objc/runtime.h>

@implementation UIAlertView (Utils)

static char key;

// 用Block的方式回调，这时候会默认用self作为Delegate
- (void)showAlertViewWithCompleteBlock:(CompleteBlock)block
{
    if (block) {
        ////移除所有关联
        objc_removeAssociatedObjects(self);
        /**
         1 创建关联（源对象，关键字，关联的对象和一个关联策略。)
         2 关键字是一个void类型的指针。每一个关联的关键字必须是唯一的。通常都是会采用静态变量来作为关键字。
         3 关联策略表明了相关的对象是通过赋值，保留引用还是复制的方式进行关联的；关联是原子的还是非原子的。这里的关联策略和声明属性时的很类似。
         */
        objc_setAssociatedObject(self, &key, block, OBJC_ASSOCIATION_COPY);
        ////设置delegate
        self.delegate = self;
    }
    ////show
    [self show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    ///获取关联的对象，通过关键字。
    CompleteBlock block = objc_getAssociatedObject(self, &key);
    if (block) {
        ///block传值
        block(buttonIndex);
    }
}


/**
 OC中的关联就是在已有类的基础上添加对象参数。来扩展原有的类，需要引入#import <objc/runtime.h>头文件。关联是基于一个key来区分不同的关联。
 常用函数: objc_setAssociatedObject     设置关联
 objc_getAssociatedObject     获取关联
 objc_removeAssociatedObjects 移除关联
 */

+(void)showTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle otherTitles:(NSArray *)otherTitles block:(CompleteBlock)block
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelTitle otherButtonTitles:nil, nil];
    if (otherTitles != nil) {
        for (NSString *otitle in otherTitles) {
            [alert addButtonWithTitle:otitle];
        }
    }
    [alert showAlertViewWithCompleteBlock:block];
}

+(void)showTitle:(NSString *)title message:(NSString *)message block:(CompleteBlock)block buttonTitles:(NSString *)buttonTitles,...
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
    
    va_list args;
    va_start(args, buttonTitles);
    if (buttonTitles)
    {
        [alert addButtonWithTitle:buttonTitles];
        NSString *otherString;
        while ((otherString = va_arg(args, NSString *)))
        {
            [alert addButtonWithTitle:otherString];
        }
    }
    
    va_end(args);
    
    [alert showAlertViewWithCompleteBlock:block];
}

@end
