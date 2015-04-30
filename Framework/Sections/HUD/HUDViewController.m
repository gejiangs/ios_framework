//
//  HUDViewController.m
//  Framework
//
//  Created by gejiangs on 15/4/8.
//  Copyright (c) 2015年 guojiang. All rights reserved.
//

#import "HUDViewController.h"

@interface HUDViewController ()

@end

@implementation HUDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)toastTop:(UIButton *)sender
{
    [self.view showToastText:sender.currentTitle topOffset:40];
}

- (IBAction)toastCenter:(UIButton *)sender
{
    [self.view showToastText:sender.currentTitle];
}

- (IBAction)showHUD:(UIButton *)sender
{
    [self.view showActivityView:sender.currentTitle hideAfterDelay:2];
}

- (IBAction)toastBottom:(UIButton *)sender
{
    [self.view showToastText:sender.currentTitle bottomOffset:40];
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
