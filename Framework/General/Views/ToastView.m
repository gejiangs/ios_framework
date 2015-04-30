//
//  ToastView.m
//  WIFI_LED
//
//  Created by gejiangs on 15/4/8.
//  Copyright (c) 2015年 gejiangs. All rights reserved.
//

#import "ToastView.h"
#import <QuartzCore/QuartzCore.h>

@interface ToastContentView : UIButton

@end

@implementation ToastContentView


@end

@interface ToastView()
{
    ToastContentView *contentView;
    NSString *text;
    CGFloat  duration;
    UIView *superView;
}

- (id)initWithText:(NSString *)text inView:(UIView *)view;
- (void)setDuration:(CGFloat) duration;

- (void)dismissToast;
- (void)toastTaped:(UIButton *)sender;

- (void)showAnimation;
- (void)hideAnimation;

- (void)show;
- (void)showFromTopOffset:(CGFloat) topOffset;
- (void)showFromBottomOffset:(CGFloat) bottomOffset;

@end

@implementation ToastView

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIDeviceOrientationDidChangeNotification
                                                  object:[UIDevice currentDevice]];
    
    contentView = nil;
    text = nil;
}


- (id)initWithText:(NSString *)text_ inView:(UIView *)view{
    if (self = [super init]) {
        
        text = [text_ copy];
        superView = view;
        
        [self removeToastView];
        
        UIFont *font = [UIFont boldSystemFontOfSize:14];
        
        CGSize textSize = [text getSizeWithFont:font size:CGSizeMake(view.frame.size.width-40, MAXFLOAT)];
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, textSize.width + 12, textSize.height + 12)];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.textColor = [UIColor whiteColor];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.font = font;
        textLabel.text = text;
        textLabel.numberOfLines = 0;
        
        contentView = [[ToastContentView alloc] initWithFrame:CGRectMake(0, 0, textLabel.frame.size.width, textLabel.frame.size.height)];
        contentView.layer.cornerRadius = 5.0f;
        contentView.layer.borderWidth = 1.0f;
        contentView.layer.borderColor = [[UIColor grayColor] colorWithAlphaComponent:0.5].CGColor;
        contentView.backgroundColor = [UIColor colorWithRed:0.2f
                                                      green:0.2f
                                                       blue:0.2f
                                                      alpha:0.75f];
        [contentView addSubview:textLabel];
        contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [contentView addTarget:self
                        action:@selector(toastTaped:)
              forControlEvents:UIControlEventTouchDown];
        contentView.alpha = 0.0f;
        
        duration = DEFAULT_DISPLAY_DURATION;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(deviceOrientationDidChanged:)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:[UIDevice currentDevice]];
    }
    return self;
}

-(void)removeToastView
{
    for (UIView *v in superView.subviews) {
        if ([v isKindOfClass:[ToastContentView class]]) {
            [v removeFromSuperview];
        }
    }
}

- (void)deviceOrientationDidChanged:(NSNotification *)notify_{
    [self hideAnimation];
}

-(void)dismissToast{
    [contentView removeFromSuperview];
}

-(void)toastTaped:(UIButton *)sender_{
    [self hideAnimation];
}

- (void)setDuration:(CGFloat) duration_{
    duration = duration_;
}

-(void)showAnimation{
    [UIView beginAnimations:@"show" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.3];
    contentView.alpha = 1.0f;
    [UIView commitAnimations];
}

-(void)hideAnimation{
    [UIView beginAnimations:@"hide" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(dismissToast)];
    [UIView setAnimationDuration:0.3];
    contentView.alpha = 0.0f;
    [UIView commitAnimations];
}

- (void)show{
    contentView.center = superView.center;NSLog(@"center:%@", NSStringFromCGPoint(superView.center));
    [superView  addSubview:contentView];
    [self showAnimation];
    [self performSelector:@selector(hideAnimation) withObject:nil afterDelay:duration];
}

- (void)showFromTopOffset:(CGFloat) top_{
    contentView.center = CGPointMake(superView.center.x, top_ + contentView.frame.size.height/2);
    [superView  addSubview:contentView];
    [self showAnimation];
    [self performSelector:@selector(hideAnimation) withObject:nil afterDelay:duration];
}

- (void)showFromBottomOffset:(CGFloat) bottom_{
    contentView.center = CGPointMake(superView.center.x, superView.frame.size.height-(bottom_ + contentView.frame.size.height/2));
    [superView  addSubview:contentView];
    [self showAnimation];
    [self performSelector:@selector(hideAnimation) withObject:nil afterDelay:duration];
}


+ (void)showWithText:(NSString *)text inView:(UIView *)view
{
    [self showWithText:text inView:view duration:DEFAULT_DISPLAY_DURATION];
}

+ (void)showWithText:(NSString *)text inView:(UIView *)view duration:(CGFloat)duration
{
    ToastView *toast = [[ToastView alloc] initWithText:text inView:view];
    [toast setDuration:duration];
    [toast show];
}

+ (void)showWithText:(NSString *)text inView:(UIView *)view topOffset:(CGFloat)topOffset
{
    [self showWithText:text  inView:view topOffset:topOffset duration:DEFAULT_DISPLAY_DURATION];
}

+ (void)showWithText:(NSString *)text inView:(UIView *)view topOffset:(CGFloat)topOffset duration:(CGFloat)duration
{
    ToastView *toast = [[ToastView alloc] initWithText:text inView:view];
    [toast setDuration:duration];
    [toast showFromTopOffset:topOffset];
}

+ (void)showWithText:(NSString *)text inView:(UIView *)view bottomOffset:(CGFloat)bottomOffset
{
    [self showWithText:text inView:view bottomOffset:bottomOffset duration:DEFAULT_DISPLAY_DURATION];
}

+ (void)showWithText:(NSString *)text inView:(UIView *)view bottomOffset:(CGFloat)bottomOffset duration:(CGFloat)duration
{
    ToastView *toast = [[ToastView alloc] initWithText:text inView:view];
    [toast setDuration:duration];
    [toast showFromBottomOffset:bottomOffset];
}

@end
