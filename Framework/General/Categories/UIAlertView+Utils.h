//
//  UIAlertView+Block.h
//  FenQiBao
//
//  Created by guojiang on 15/1/6.
//  Copyright (c) 2015年 DaChengSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^CompleteBlock) (NSInteger buttonIndex);

@interface UIAlertView (Utils)

// 用Block的方式回调，这时候会默认用self作为Delegate
- (void)showAlertViewWithCompleteBlock:(CompleteBlock) block;

+(void)showTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle otherTitles:(NSArray *)otherTitles block:(CompleteBlock)block;

@end
