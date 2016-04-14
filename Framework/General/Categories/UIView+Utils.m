//
//  UIView+Utils.m
//  SanLianOrdering
//
//  Created by guojiang on 14-10-10.
//  Copyright (c) 2014年 DaCheng. All rights reserved.
//

#import "UIView+Utils.h"
#import "MBProgressHUD.h"
#import "ToastView.h"


@implementation UIView (Utils)

#pragma mark - 添加 UILabel

//当前view添加label,系统字体，系统颜色
-(UILabel *)addLabelWithText:(NSString *)text
{
    return [self addLabelWithText:text font:nil color:nil];
}

//当前view添加label,指定字体，系统颜色
-(UILabel *)addLabelWithText:(NSString *)text font:(UIFont *)font
{
    return [self addLabelWithText:text font:font color:nil];
}

//当前view添加label,系统字体，指定颜色
-(UILabel *)addLabelWithText:(NSString *)text color:(UIColor *)color
{
    return [self addLabelWithText:text font:nil color:color];
}

//当前view添加label,指定字体，指定颜色
-(UILabel *)addLabelWithText:(NSString *)text font:(UIFont *)font color:(UIColor *)color
{
    UILabel *label=[[UILabel alloc] init];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.backgroundColor = [UIColor clearColor];
    
    if (color) {
        label.textColor = color;
    }
    if (font) {
        label.font = font;
    }
    
    label.text = text;
    [self addSubview:label];
    
    return label;
}



#pragma mark - UITextField

//当前view添加UITextField,指定delegate,指定字体大小
-(UITextField *)addTextFieldWithDelegate:(id)delegate fontSize:(CGFloat)fontSize
{
    return [self addTextFieldWithDelegate:delegate font:[UIFont systemFontOfSize:fontSize]];
}

//当前view添加UITextField,指定delegate,指定字体
-(UITextField *)addTextFieldWithDelegate:(id)delegate font:(UIFont *)font
{
    UITextField *textField = [[UITextField alloc]init];
    textField.translatesAutoresizingMaskIntoConstraints = NO;
    textField.delegate = delegate;
    textField.borderStyle = UITextBorderStyleNone;
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    textField.font = font;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.backgroundColor = [UIColor whiteColor];
    [self addSubview:textField];
    
    return textField;
}

#pragma mark - UIButton

//当前view添加UIButton,指定target,指定action
-(UIButton *)addButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.translatesAutoresizingMaskIntoConstraints = NO;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
    return btn;
}

#pragma mark - UITextView

//当前view添加UITextView,指定delegate,指定字体大小
-(UITextView *)addTextViewWithDelegate:(id)delegate fontSize:(CGFloat)fontSize
{
    return [self addTextViewWithDelegate:delegate font:[UIFont systemFontOfSize:fontSize]];
}

//当前view添加UITextView,指定delegate,指定字体
-(UITextView *)addTextViewWithDelegate:(id)delegate font:(UIFont *)font
{
    UITextView *textView = [[UITextView alloc]init];
    textView.translatesAutoresizingMaskIntoConstraints = NO;
    textView.delegate = delegate;
    textView.font = font;
    textView.clearsContextBeforeDrawing = YES;
    textView.backgroundColor = [UIColor whiteColor];
    [self addSubview:textView];
    
    return textView;
}

//当前view添加UIScrollView,指定delegate
-(UIScrollView *)addScrollViewWithDelegate:(id)delegate
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    scrollView.pagingEnabled = YES;
    scrollView.delegate = delegate;
    scrollView.bounces = YES;
    scrollView.alwaysBounceHorizontal = YES;
    scrollView.alwaysBounceVertical = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:scrollView];
    
    return scrollView;
}

#pragma mark - 多view水平分布
- (void) distributeSpacingHorizontallyWith:(NSArray*)views
{
    NSMutableArray *spaces = [NSMutableArray arrayWithCapacity:views.count+1];
    
    for ( int i = 0 ; i < views.count+1 ; ++i )
    {
        UIView *v = [UIView new];
        [spaces addObject:v];
        [self addSubview:v];
        
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(v.mas_height);
        }];
    }
    
    UIView *v0 = spaces[0];
    
    __weak __typeof(&*self)ws = self;
    
    [v0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.mas_left);
        make.centerY.equalTo(((UIView*)views[0]).mas_centerY);
    }];
    
    UIView *lastSpace = v0;
    for ( int i = 0 ; i < views.count; ++i )
    {
        UIView *obj = views[i];
        UIView *space = spaces[i+1];
        
        [obj mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lastSpace.mas_right);
        }];
        
        [space mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(obj.mas_right);
            make.centerY.equalTo(obj.mas_centerY);
            make.width.equalTo(v0);
        }];
        
        lastSpace = space;
    }
    
    [lastSpace mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ws.mas_right);
    }];
    
}

#pragma mark - 多view垂直分布
- (void) distributeSpacingVerticallyWith:(NSArray*)views
{
    NSMutableArray *spaces = [NSMutableArray arrayWithCapacity:views.count+1];
    
    for ( int i = 0 ; i < views.count+1 ; ++i )
    {
        UIView *v = [UIView new];
        [spaces addObject:v];
        [self addSubview:v];
        
        [v mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(v.mas_height);
        }];
    }
    
    
    UIView *v0 = spaces[0];
    
    __weak __typeof(&*self)ws = self;
    
    [v0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.mas_top);
        make.centerX.equalTo(((UIView*)views[0]).mas_centerX);
    }];
    
    UIView *lastSpace = v0;
    for ( int i = 0 ; i < views.count; ++i )
    {
        UIView *obj = views[i];
        UIView *space = spaces[i+1];
        
        [obj mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastSpace.mas_bottom);
        }];
        
        [space mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(obj.mas_bottom);
            make.centerX.equalTo(obj.mas_centerX);
            make.height.equalTo(v0);
        }];
        
        lastSpace = space;
    }
    
    [lastSpace mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(ws.mas_bottom);
    }];
}

#pragma mark - 显示加载

//显示加载提示
- (MBProgressHUD *)showActivityView:(NSString *)labelText
{
    [self hiddenActivityView];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self];
    hud.labelText = labelText;
    [self addSubview:hud];
    [hud show:YES];
    return hud;
}

//显示加载提示,指定时间(秒数)自动消失
- (void)showActivityView:(NSString *)labelText hideAfterDelay:(NSTimeInterval)delay
{
    [self hiddenActivityView];
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self];
    hud.labelText = labelText;
    hud.mode = MBProgressHUDModeText;
    [self addSubview:hud];
    [hud show:YES];
    [hud hide:YES afterDelay:delay];
    
}

//显示成功提示
- (void)showSuccessActivityView:(NSString *)text
{
    UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self showSuccessActivityView:text image:image];
}

//显示成功提示、指定图片
- (void)showSuccessActivityView:(NSString *)text image:(UIImage *)image
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self];
    if (hud == nil) {
        hud = [[MBProgressHUD alloc] initWithView:self];
    }
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    hud.customView = imageView;
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = text;
    [hud hide:YES afterDelay:2.f];
}

//隐藏加载提示
- (void)hiddenActivityView
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self];
    if (hud != nil) {
        [hud hide:YES];
    }
    
}

#pragma mark - 显示Toast
//显示toast文字
- (void)showToastText:(NSString *)text
{
    [self showToastText:text duration:DEFAULT_DISPLAY_DURATION];
}

//显示toast文字与指定时间消失
- (void)showToastText:(NSString *)text duration:(CGFloat)duration
{
    [ToastView showWithText:text inView:self duration:duration];
}

//显示toast文字，指定向上偏移
- (void)showToastText:(NSString *)text topOffset:(CGFloat) topOffset
{
    [self showToastText:text topOffset:topOffset duration:DEFAULT_DISPLAY_DURATION];
}

//显示toast文字，指定向上偏移与定时消失
- (void)showToastText:(NSString *)text topOffset:(CGFloat) topOffset duration:(CGFloat) duration
{
    [ToastView showWithText:text inView:self topOffset:topOffset duration:duration];
}

//显示toast文字，指定向下偏移
- (void)showToastText:(NSString *)text bottomOffset:(CGFloat) bottomOffset
{
    [self showToastText:text bottomOffset:bottomOffset duration:DEFAULT_DISPLAY_DURATION];
}

//显示toast文字，指定向下偏移与定时消失
- (void)showToastText:(NSString *)text bottomOffset:(CGFloat) bottomOffset duration:(CGFloat) duration
{
    [ToastView showWithText:text inView:self bottomOffset:bottomOffset duration:duration];
}

//设置view圆角
-(instancetype)cornerRadius:(CGFloat)radius
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:radius];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    
    return self;
}

@end
