//
//  BaseNavigationViewController.m
//  wook
//
//  Created by guojiang on 5/8/14.
//  Copyright (c) 2014年 guojiang. All rights reserved.
//

#import "BaseNavigationViewController.h"

@interface BaseNavigationViewController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@end

@implementation BaseNavigationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self customNavigationBar];
}
-(void)customNavigationBar
{
//    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],
//                                               NSFontAttributeName:[UIFont boldSystemFontOfSize:20.0f]
//                                               };
//    self.navigationBar.barTintColor = COLOR_SET_BLUE;
//    
//    self.navigationBar.tintColor = [UIColor whiteColor];
    
    self.interactivePopGestureRecognizer.delegate = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
