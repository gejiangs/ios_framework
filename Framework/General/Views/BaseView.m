//
//  BaseView.m
//  WIFI_LED
//
//  Created by gejiangs on 15/3/11.
//  Copyright (c) 2015年 gejiangs. All rights reserved.
//

#import "BaseView.h"

@implementation BaseView

#pragma mark -
#pragma mark   property setters
- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
}


- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    self.layer.borderColor = [borderColor CGColor];
}


- (void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;
    self.layer.borderWidth = borderWidth;
}




@end
