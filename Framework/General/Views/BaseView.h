//
//  BaseView.h
//  WIFI_LED
//
//  Created by gejiangs on 15/3/11.
//  Copyright (c) 2015年 gejiangs. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface BaseView : UIView
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;
@property (nonatomic, strong) IBInspectable UIColor *borderColor;
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
@end