//
//  UIView+Utils.h
//  SanLianOrdering
//
//  Created by guojiang on 14-10-10.
//  Copyright (c) 2014年 DaCheng. All rights reserved.
//


/*
 [view1 remakeConstraints:^(MASConstraintMaker *make) {
     make.top.equalTo(self.mas_bottom).offset(SPACE_Y);
     make.centerY.equalTo(@[view2]);
     make.size.mas_equalTo(CGSizeMake(140, 45));
 }];
 
 [view2 remakeConstraints:^(MASConstraintMaker *make) {
     make.size.mas_equalTo(CGSizeMake(140, 45));
 }];
 
 //多view水平居中对齐
 [self distributeSpacingHorizontallyWith:@[view1, view2]];
 
 //多view垂直居中对齐
 [self distributeSpacingVerticallyWith:@[view1, view2]];
 */



#import <UIKit/UIKit.h>

@class MBProgressHUD;
@interface UIView (Utils)

#pragma mark -- View 添加UILabel,UITextField。。。。。

//当前view添加label,系统字体，系统颜色
-(UILabel *)addLabelWithText:(NSString *)text;

//当前view添加label,指定字体，系统颜色
-(UILabel *)addLabelWithText:(NSString *)text font:(UIFont *)font;

//当前view添加label,系统字体，指定颜色
-(UILabel *)addLabelWithText:(NSString *)text color:(UIColor *)color;

//当前view添加label,指定字体，指定颜色
-(UILabel *)addLabelWithText:(NSString *)text font:(UIFont *)font color:(UIColor *)color;

//当前view添加UITextField,指定delegate,指定字体大小
-(UITextField *)addTextFieldWithDelegate:(id)delegate fontSize:(CGFloat)fontSize;

//当前view添加UITextField,指定delegate,指定字体
-(UITextField *)addTextFieldWithDelegate:(id)delegate font:(UIFont *)font;

//当前view添加UIButton,指定target,指定action
-(UIButton *)addButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action;

//当前view添加UITextView,指定delegate,指定字体大小
-(UITextView *)addTextViewWithDelegate:(id)delegate fontSize:(CGFloat)fontSize;

//当前view添加UITextView,指定delegate,指定字体
-(UITextView *)addTextViewWithDelegate:(id)delegate font:(UIFont *)font;

//当前view添加UIScrollView,指定delegate
-(UIScrollView *)addScrollViewWithDelegate:(id)delegate;

//多view水平居中对齐（参考顶部）
- (void) distributeSpacingHorizontallyWith:(NSArray*)views;

//多view垂直居中对齐（参考顶部）
- (void) distributeSpacingVerticallyWith:(NSArray*)views;

//显示加载提示
- (MBProgressHUD *)showActivityView:(NSString *)labelText;

//显示加载提示,指定时间(秒数)自动消失
- (void)showActivityView:(NSString *)labelText hideAfterDelay:(NSTimeInterval)delay;

//显示成功提示
- (void)showSuccessActivityView:(NSString *)text;

//显示成功提示、指定图片
- (void)showSuccessActivityView:(NSString *)text image:(UIImage *)image;

//隐藏加载提示
- (void)hiddenActivityView;

//显示toast文字
- (void)showToastText:(NSString *)text;

//显示toast文字与指定时间消失
- (void)showToastText:(NSString *)text duration:(CGFloat)duration;

//显示toast文字，指定向上偏移
- (void)showToastText:(NSString *)text topOffset:(CGFloat) topOffset;

//显示toast文字，指定向上偏移与定时消失
- (void)showToastText:(NSString *)text topOffset:(CGFloat) topOffset duration:(CGFloat) duration;

//显示toast文字，指定向下偏移
- (void)showToastText:(NSString *)text bottomOffset:(CGFloat) bottomOffset;

//显示toast文字，指定向下偏移与定时消失
- (void)showToastText:(NSString *)text bottomOffset:(CGFloat) bottomOffset duration:(CGFloat) duration;

//设置view圆角
-(instancetype)cornerRadius:(CGFloat)radius;







@end

