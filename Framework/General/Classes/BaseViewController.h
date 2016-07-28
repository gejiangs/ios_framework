//
//  BaseViewController.h
//  wook
//
//  Created by guojiang on 5/8/14.
//  Copyright (c) 2014年 guojiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

-(void)viewWillBack;
-(void)pushViewControllerName:(NSString *)VCName;
-(void)pushViewControllerName:(NSString *)VCName animated:(BOOL)animated;

-(void)addLeftBarTitle:(NSString *)title target:(id)target action:(SEL)action;
-(void)addRightBarTitle:(NSString *)title target:(id)target action:(SEL)action;

-(void)addLeftBarImageName:(NSString *)imageName target:(id)target action:(SEL)action;
-(void)addRightBarImageName:(NSString *)imageName target:(id)target action:(SEL)action;

#pragma mark 键盘通知
-(void)enableKeyboardNotification;
-(void)keyboardWillShowKeyHeight:(CGFloat)keyHeight;
-(void)keyboardWillHide;
-(void)setKeyboardUpShowView:(UIView *)showView keyboardHeight:(CGFloat)keyHeight;

@end
