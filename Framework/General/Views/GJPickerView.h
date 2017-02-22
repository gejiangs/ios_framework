//
//  JamPickerView.h
//  Framework
//
//  Created by gejiangs on 16/3/16.
//  Copyright © 2016年 guojiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GJPickerView;

@protocol GJPickerViewDelegate<NSObject>

@optional

- (NSInteger)numberOfComponentsInPickerView:(GJPickerView *)comboBoxView;
- (NSInteger)pickerView:(GJPickerView *)comboBoxView numberOfRowsInComponent:(NSInteger)component;
- (NSString *)pickerView:(GJPickerView *)comboBoxView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
- (void)pickerView:(GJPickerView *)comboBoxView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
- (void)pickerViewConfirm:(GJPickerView *)comboBoxView;//点击确认按钮
- (void)pickerViewCancel:(GJPickerView *)comboBoxView;//点击取消按钮

@end

@interface GJPickerView : UIView

@property(nonatomic,weak) id<GJPickerViewDelegate> delegate;

@property (nonatomic, strong)   UILabel *titleLabel;
@property (nonatomic, strong)   UIButton *cancelButton;
@property (nonatomic, strong)   UIButton *sureButton;


+ (instancetype)showInView:(UIView *)view;

- (void)reloadAllComponents;
- (void)reloadComponent:(NSInteger)component;
- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated;
- (NSInteger)selectedRowInComponent:(NSInteger)component;

@end
