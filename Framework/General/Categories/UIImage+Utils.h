//
//  UIImage+Utils.h
//  SanLianOrdering
//
//  Created by guojiang on 14-10-21.
//  Copyright (c) 2014年 DaCheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Utils)

// 生成指定大小的图片
- (UIImage *)scaleToSize:(CGSize)newsize;

// 给图片重新绘制一个颜色
- (UIImage *)imageWithOverlayColor:(UIColor *)color;

// 生成一张指定颜色的图片
+ (UIImage *)imageWithColor:(UIColor*)color;

-(UIImage *)rotateImage;

// 获取某一点的RGB 和alpha
- (UIColor *)colorAtpoint:(CGPoint )point;

// 获取屏幕截图
+ (UIImage *)imageWithScreenShot;

@end
