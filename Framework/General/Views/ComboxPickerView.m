//
//  ComboxPickerView.m
//  Framework
//
//  Created by gejiangs on 15/5/28.
//  Copyright (c) 2015年 guojiang. All rights reserved.
//

#import "ComboxPickerView.h"

@interface ComboxPickerView ()<UIPickerViewDataSource, UIPickerViewDelegate>
{
    BOOL isShow;
}

@property (nonatomic, strong) UIView *pickBoxView;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIImage *cellImage;

@end

@implementation ComboxPickerView

-(id)init
{
    if (self = [super init]) {
        [self initUI];
    }
    return self;
}

-(void)initUI
{
    self.backgroundColor = [UIColor clearColor];
    
    UIButton *handlerView = [UIButton buttonWithType:UIButtonTypeCustom];
    handlerView.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0.3];
    [handlerView addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:handlerView];
    
    [handlerView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self).offset(0);
    }];
    
    self.pickBoxView = [[UIView alloc] init];
    _pickBoxView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_pickBoxView];
    
    
    UIButton *cancelButton = [_pickBoxView addButtonWithTitle:@"取消" target:self action:@selector(cancelAction:)];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelButton.layer.cornerRadius = 15.f;
    cancelButton.layer.masksToBounds = YES;
    [cancelButton setBackgroundImage:[UIImage imageWithColor:RGB(204, 204, 204)] forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:[UIImage imageWithColor:RGB(165, 165, 165)] forState:UIControlStateHighlighted];
    [cancelButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.size.mas_equalTo(Size(70, 30));
        make.left.offset(15);
    }];
    
    
    UIButton *sureButton = [_pickBoxView addButtonWithTitle:@"确定" target:self action:@selector(sureAction:)];
    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sureButton.layer.cornerRadius = 15.f;
    sureButton.layer.masksToBounds = YES;
    [sureButton setBackgroundImage:[UIImage imageWithColor:RGB(140, 198, 63)] forState:UIControlStateNormal];
    [sureButton setBackgroundImage:[UIImage imageWithColor:RGB(117, 158, 53)] forState:UIControlStateHighlighted];
    [sureButton makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.size.mas_equalTo(Size(70, 30));
        make.right.offset(-15);
    }];
    
    
    self.pickerView = [[UIPickerView alloc] init];
    _pickerView.backgroundColor = [UIColor whiteColor];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    [_pickBoxView addSubview:_pickerView];
    [_pickerView makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.offset(0);
    }];
    
}

-(void)cancelAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(pickerViewCancel:)]) {
        [_delegate pickerViewCancel:self];
    }
    [self show:NO];
}

-(void)sureAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(pickerViewConfirm:)]) {
        [_delegate pickerViewConfirm:self];
    }
    [self show:NO];
}


-(void)show:(BOOL)show
{
    isShow = show;
    
    // tell constraints they need updating
    [self setNeedsUpdateConstraints];
    
    // update constraints now so we can animate the change
    [self updateConstraintsIfNeeded];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (isShow == NO) {
            [self removeFromSuperview];
        }
    }];
}


- (void)updateConstraints
{
    CGFloat tableHeight = 265;
    
    [self.pickBoxView remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self).offset(0);
        make.height.offset(tableHeight);
        if (isShow) {
            make.bottom.equalTo(self).offset(0);
        }else{
            make.bottom.equalTo(self).offset(tableHeight);
        }
    }];
    
    [super updateConstraints];
}

-(void)showInView:(UIView *)view
{
    [view addSubview:self];
    [self makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.offset(0);
    }];
    [self dispatchTimerWithTime:0.1 block:^{
        [self show:YES];
    }];
}

-(void)reloadAllComponents
{
    [_pickerView reloadAllComponents];
}

-(void)reloadComponent:(NSInteger)component
{
    [_pickerView reloadComponent:component];
}

-(void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated
{
    [_pickerView selectRow:row inComponent:component animated:animated];
}

- (NSInteger)selectedRowInComponent:(NSInteger)component
{
    return [_pickerView selectedRowInComponent:component];
}

#pragma mark --pickerView 代理
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (_delegate && [_delegate respondsToSelector:@selector(numberOfComponentsInPickerView:)]) {
        return [_delegate numberOfComponentsInPickerView:self];
    }
    return 0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (_delegate && [_delegate respondsToSelector:@selector(pickerView:numberOfRowsInComponent:)]) {
        return [_delegate pickerView:self numberOfRowsInComponent:component];
    }
    return 0;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}


-(NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (_delegate && [_delegate respondsToSelector:@selector(pickerView:titleForRow:forComponent:)]) {
        return [_delegate pickerView:self titleForRow:row forComponent:component];
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (_delegate && [_delegate respondsToSelector:@selector(pickerView:didSelectRow:inComponent:)]) {
        [_delegate pickerView:self didSelectRow:row inComponent:component];
    }
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    if (_showIcon) {
        if (_delegate && [_delegate respondsToSelector:@selector(pickerView:viewForRow:forComponent:reusingView:)]) {
        }
        return [_delegate pickerView:self viewForRow:row forComponent:component reusingView:view];
        
    }
    else {
        UILabel* titleLabel = (UILabel*)view;
        if (!titleLabel){
            titleLabel = [[UILabel alloc] init];
            titleLabel.minimumScaleFactor = 8.;
            titleLabel.adjustsFontSizeToFitWidth = YES;
            titleLabel.textAlignment=NSTextAlignmentCenter;
            titleLabel.textColor=RGB(69, 69, 69);
            titleLabel.font=[UIFont systemFontOfSize:15];
        }
        titleLabel.text = [self pickerView:(UIPickerView*)self titleForRow:row forComponent:component];
        
        
        return titleLabel;
    }
}
@end
