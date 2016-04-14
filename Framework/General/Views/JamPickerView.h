//
//  JamPickerView.h
//  Framework
//
//  Created by gejiangs on 16/3/16.
//  Copyright © 2016年 guojiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JamPickerView;

@protocol JamPickerViewDelegate<NSObject>

@optional

- (NSInteger)numberOfComponentsInPickerView:(JamPickerView *)comboBoxView;
- (NSInteger)pickerView:(JamPickerView *)comboBoxView numberOfRowsInComponent:(NSInteger)component;
- (NSString *)pickerView:(JamPickerView *)comboBoxView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
- (UIView *)pickerView:(JamPickerView *)comboBoxView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view;
- (void)pickerView:(JamPickerView *)comboBoxView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
- (void)pickerViewConfirm:(JamPickerView *)comboBoxView;//点击确认按钮
- (void)pickerViewCancel:(JamPickerView *)comboBoxView;//点击取消按钮

@end

@interface JamPickerView : UIView

@property(nonatomic,weak) id<JamPickerViewDelegate> delegate;

+ (instancetype)showInView:(UIView *)view;

- (void)reloadAllComponents;
- (void)reloadComponent:(NSInteger)component;
- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated;
- (NSInteger)selectedRowInComponent:(NSInteger)component;

@end
