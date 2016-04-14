//
//  AddressViewController.m
//  Framework
//
//  Created by gejiangs on 15/5/29.
//  Copyright (c) 2015年 guojiang. All rights reserved.
//

#import "AddressViewController.h"
#import "ComboxPickerView.h"
#import "CJSONDeserializer.h"
#import "JamPickerView.h"

@interface AddressViewController ()<ComboxPickerViewDelegate, JamPickerViewDelegate>

@property (nonatomic, strong) NSMutableArray *addressList;
//@property (nonatomic, strong) ComboxPickerView *pickerView;
@property (nonatomic, strong) JamPickerView *pickerView;

@property (nonatomic, strong) NSString *proCode;
@property (nonatomic, strong) NSString *cityCode;
@property (nonatomic, strong) NSString *areaCode;

@property (nonatomic, strong) UIButton *showComboxButton;

@end

@implementation AddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    [self loadData];
}


-(void)initUI
{
    self.showComboxButton = [self.view addButtonWithTitle:@"选择省、市、区" target:self action:@selector(showComboxPickView:)];
    [_showComboxButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(50);
    }];
}

-(void)loadData
{
    NSBundle *bundle = [NSBundle mainBundle];
    
    NSString *addressPath = [bundle pathForResource:@"address" ofType:@"txt"];
    NSData *data = [NSData dataWithContentsOfFile:addressPath];
    self.addressList = [[CJSONDeserializer deserializer] deserializeAsArray:data error:nil];
    
    
}

-(void)showComboxPickView:(id)sender
{
    self.pickerView = [JamPickerView showInView:self.view];
    _pickerView.delegate = self;
    
    NSInteger proSelectedRow = -1;
    NSInteger citySelectedRow = -1;
    NSInteger areaSelectedRow = -1;
    
    //获取选中省份index
    for (int i=0; i<[self.addressList count]; i++) {
        NSDictionary *proDict = [self.addressList objectAtIndex:i];
        if ([[proDict objectForKey:@"code"] isEqualToString:self.proCode]) {
            proSelectedRow = i;
            break;
        }
    }
    //设置选中省份
    if (proSelectedRow >= 0) {
        [_pickerView selectRow:proSelectedRow inComponent:0 animated:NO];
        
        //选中省份后，再加载省份下的城市列表
        [_pickerView reloadComponent:1];
        
        NSDictionary *proDict = [self.addressList objectAtIndex:proSelectedRow];
        NSArray *cities = [proDict objectForKey:@"sub"];
        for (int i=0; i<[cities count]; i++) {
            NSDictionary *cityDict = [cities objectAtIndex:i];
            if ([[cityDict objectForKey:@"code"] isEqualToString:self.cityCode]) {
                citySelectedRow = i;
                break;
            }
        }
        //设置选中城市
        if (citySelectedRow >= 0) {
            [_pickerView selectRow:citySelectedRow inComponent:1 animated:NO];
            
            //选中城市后，再加载区县列表
            [_pickerView reloadComponent:2];
            
            NSDictionary *cityDict = [cities objectAtIndex:citySelectedRow];
            NSArray *areas = [cityDict objectForKey:@"sub"];
            for (int i=0; i<[areas count]; i++) {
                NSDictionary *areaDict = [areas objectAtIndex:i];
                if ([[areaDict objectForKey:@"code"] isEqualToString:self.areaCode]) {
                    areaSelectedRow = i;
                    break;
                }
            }
            
            //设置选中区域
            if (areaSelectedRow >= 0) {
                [_pickerView selectRow:areaSelectedRow inComponent:2 animated:NO];
            }
            
        }
        
    }
    
}


- (NSInteger)numberOfComponentsInPickerView:(ComboxPickerView *)comboBoxView
{
    return 3;
}
- (NSInteger)pickerView:(ComboxPickerView *)comboBoxView numberOfRowsInComponent:(NSInteger)component
{
    //省份数量
    if (component == 0) {
        return [self.addressList count];
    }else if (component == 1){
        //对应城市数量
        NSInteger proSelectRow = [comboBoxView selectedRowInComponent:0];
        NSDictionary *proDict = [self.addressList objectAtIndex:proSelectRow];
        return [[proDict objectForKey:@"sub"] count];
    }
    
    //对应区、县数量
    //先得到省份选择对应的index
    NSInteger proSelectRow = [comboBoxView selectedRowInComponent:0];
    //取出省份信息
    NSDictionary *proDict = [self.addressList objectAtIndex:proSelectRow];
    //再取出省份下城市列表
    NSArray *cities = [proDict objectForKey:@"sub"];
    //判断城市列表是否有数据
    if ([cities count] > 0) {
        //取出城市选择对应index
        NSInteger citySelectRow = [comboBoxView selectedRowInComponent:1];
        if (citySelectRow > [cities count]-1) {
            return 0;
        }
        //得到城市信息
        NSDictionary *cityDict = [cities objectAtIndex:citySelectRow];
        //根据选择城市index，得到区、县列表
        NSArray *areas = [cityDict objectForKey:@"sub"];
        //判断是否有区、县数据
        if ([areas count] > 0) {
            return [[cityDict objectForKey:@"sub"] count];
        }
        
        return 0;
    }
    
    return 0;
}
- (NSString *)pickerView:(ComboxPickerView *)comboBoxView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        NSDictionary *proDict = [self.addressList objectAtIndex:row];
        
        return [proDict objectForKey:@"name"];
    }else if (component == 1){
        
        NSInteger proSelectRow = [comboBoxView selectedRowInComponent:0];
        
        NSDictionary *proDict = [self.addressList objectAtIndex:proSelectRow];
        NSArray *cities = [proDict objectForKey:@"sub"];
        if (row <= [cities count]-1) {
            NSDictionary *cityDict = [cities objectAtIndex:row];
            return [cityDict objectForKey:@"name"];
        }
        return @"";
    }
    //先得到省份选择对应的index
    NSInteger proSelectRow = [comboBoxView selectedRowInComponent:0];
    //取出省份信息
    NSDictionary *proDict = [self.addressList objectAtIndex:proSelectRow];
    //取出城市选择对应index
    NSInteger citySelectRow = [comboBoxView selectedRowInComponent:1];
    //得到城市信息
    NSDictionary *cityDict = [[proDict objectForKey:@"sub"] objectAtIndex:citySelectRow];
    //根据选择城市index，得到区、县列表
    NSArray *areas = [cityDict objectForKey:@"sub"];
    //判断是否有区、县数据
    if ([areas count] > 0) {
        //返回区、县名称
        if (row <= [areas count]-1) {
            NSDictionary *areaDict = [areas objectAtIndex:row];
            return [areaDict objectForKey:@"name"];
        }
        return @"";
    }
    return @"";
}
- (void)pickerView:(ComboxPickerView *)comboBoxView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        [self.pickerView reloadComponent:1];
        [self.pickerView reloadComponent:2];
    }else if (component == 1){
        [self.pickerView reloadComponent:2];
    }
}

- (void)pickerViewConfirm:(ComboxPickerView*)comboBoxView
{
    NSMutableString *content = [[NSMutableString alloc] init];
    
    //先得到省份选择对应的index
    NSInteger proSelectRow = [comboBoxView selectedRowInComponent:0];
    //取出省份信息
    NSDictionary *proDict = [self.addressList objectAtIndex:proSelectRow];
    //取出城市选择对应index
    NSInteger citySelectRow = [comboBoxView selectedRowInComponent:1];
    //得到城市信息
    NSDictionary *cityDict = [[proDict objectForKey:@"sub"] objectAtIndex:citySelectRow];
    
    NSString *prcName = [proDict objectForKey:@"name"];
    self.proCode = [proDict objectForKey:@"code"];
    NSString *city = [cityDict objectForKey:@"name"];
    self.cityCode = [cityDict objectForKey:@"code"];
    NSString *area = @"";
    
    //根据选择城市index，得到区、县列表
    NSArray *areas = [cityDict objectForKey:@"sub"];
    //判断是否有区、县数据
    if ([areas count] > 0) {
        //取出城市选择对应index
        NSInteger areaSelectRow = [comboBoxView selectedRowInComponent:2];
        NSDictionary *areaDict = [areas objectAtIndex:areaSelectRow];
        area = [areaDict objectForKey:@"name"];
        self.areaCode = [areaDict objectForKey:@"code"];
    }else{
        area = @"";
        self.areaCode = @"";
    }
    
    [content appendString:prcName];
    [content appendString:city];
    [content appendString:area];
    
    [self.showComboxButton setTitle:content forState:UIControlStateNormal];
    
}
- (void)pickerViewCancel:(ComboxPickerView*)comboBoxView
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
