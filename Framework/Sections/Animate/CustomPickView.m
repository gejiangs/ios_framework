//
//  CoustomDatePickView.m
//  WIFI_LED
//
//  Created by gejiangs on 15/3/24.
//  Copyright (c) 2015年 gejiangs. All rights reserved.
//

#import "CustomPickView.h"

@interface CustomPickView ()<UIPickerViewDataSource, UIPickerViewDelegate>
{
    BOOL isShow;
}

@property (nonatomic, strong) UIView *pickBoxView;
@property (nonatomic, strong) UIPickerView *picker;

@end

@implementation CustomPickView

-(id)init
{
    if (self = [super init]) {
        [self initUI];
    }
    return self;
}

-(void)initUI
{
    isShow = NO;
    
    self.backgroundColor = [UIColor clearColor];
    
    UIButton *handlerView = [UIButton buttonWithType:UIButtonTypeCustom];
    handlerView.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0.4];
    [handlerView addTarget:self action:@selector(hideView) forControlEvents:UIControlEventTouchUpInside];
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
    
    
    self.picker = [[UIPickerView alloc] init];
    _picker.backgroundColor = [UIColor whiteColor];
    _picker.delegate = self;
    _picker.dataSource = self;
    [_pickBoxView addSubview:_picker];
    [_picker makeConstraints:^(MASConstraintMaker *make) {
//        make.top.offset(40);
        make.left.bottom.right.offset(0);
    }];
    
    
    [self dispatchTimerWithTime:0.1 block:^{
        [self showView];
    }];
}

-(void)setTimeString:(NSString *)timeString
{
    NSArray *times = [timeString componentsSeparatedByString:@":"];
    if (times.count == 2) {
        NSInteger row1 = [times[0] integerValue];
        NSInteger row2 = [times[1] integerValue];
        
        [self.picker selectRow:row1 inComponent:0 animated:NO];
        [self.picker selectRow:row2 inComponent:1 animated:NO];
    }
}

-(void)cancelAction:(id)sender
{
    [self hideView];
}

-(void)sureAction:(id)sender
{
    if (self.sureAction) {
        
        NSInteger hour = [self getSelectedRowInComponent:0] % 24;
        NSInteger min = [self getSelectedRowInComponent:1] % 60;
        
        NSString *timeString = [NSString stringWithFormat:@"%@%ld:%@%ld", (hour<10?@"0":@""), hour, (min<10?@"0":@""), min];
        
        self.sureAction(timeString);
    }
    [self hideView];
}


-(void)hideView
{
    [self show:NO];
}

- (void)showView
{
    [self show:YES];
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

#pragma mark - UIPickView Delegate

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 60.f;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //设置循环滚动
    return 16384;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSMutableArray *hours = [NSMutableArray array];
    for (int i=0; i<24; i++) {
        [hours addObject:[NSString stringWithFormat:@"%@%d",(i>=10?@"":@"0"), i]];
    }
    
    NSMutableArray *mins = [NSMutableArray array];
    for (int i=0; i<60; i++) {
        [mins addObject:[NSString stringWithFormat:@"%@%d",(i>=10?@"":@"0"), i]];
    }
    
    if (component == 0) {
        return [hours objectAtIndex:(row%24)];
    }
    
    return [mins objectAtIndex:(row%60)];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self pickerViewLoaded:row component:component];
}

-(void)pickerViewLoaded:(NSInteger)row component:(NSInteger)component
{
    [_picker selectRow:[self getSelectedRowInComponent:component] inComponent:component animated:NO];
}

-(NSInteger)getSelectedRowInComponent:(NSInteger)component
{
    NSInteger count = (component == 0 ? 24 : 60);
    NSUInteger max = 16384;
    NSUInteger base10 = (max/2) - (max/2)%count;
    NSInteger row = [_picker selectedRowInComponent:component]%count+base10;
    
    return row;
}

@end
