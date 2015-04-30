//
//  AnimateViewController.m
//  Framework
//
//  Created by gejiangs on 15/4/1.
//  Copyright (c) 2015年 guojiang. All rights reserved.
//

#import "AnimateViewController.h"
#import "CustomPickView.h"

@interface AnimateViewController ()

@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation AnimateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"pickview 动画显示";
    
    [self initUI];
}

-(void)initUI
{
    self.textLabel = [self.view addLabelWithText:@""];
    [_textLabel makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view).offset(50);
        make.height.offset(20);
    }];
    
    UIButton *showButton = [self.view addButtonWithTitle:@"点击显示PickView" target:self action:@selector(showPickView:)];
    [showButton makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(_textLabel.mas_bottom).offset(50);
        make.size.mas_equalTo(CGSizeMake(150, 50));
    }];
}

-(void)showPickView:(UIButton *)sender
{
    CustomPickView *datePick = [[CustomPickView alloc] init];
    [datePick setTimeString:self.textLabel.text];
    [self.view addSubview:datePick];
    [datePick makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view).offset(0);
    }];
    datePick.sureAction = ^(NSString *dataString){
        self.textLabel.text = dataString;
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
