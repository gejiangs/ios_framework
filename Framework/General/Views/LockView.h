//
//  YYLockView.h
//  Framework
//
//  Created by guojiang on 23/10/14.
//  Copyright (c) 2014年 guojiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LockView;

@protocol LockViewDelegate <NSObject>


//
-(void)LockViewDidClick:(LockView *)lockView andPwd:(NSString *)pwd;

@end

@interface LockView : UIView

@property (nonatomic, strong) id<LockViewDelegate> delegate;

@end
