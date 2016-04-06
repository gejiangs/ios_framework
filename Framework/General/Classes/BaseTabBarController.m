//
//  BaseTabBarController.m
//  ScopeCamera
//
//  Created by gejiangs on 15/11/26.
//  Copyright © 2015年 gejiangs. All rights reserved.
//

#import "BaseTabBarController.h"

@interface BaseTabBarController ()

@end

@implementation BaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *titleArray     = @[[self languageKey:@"Cameras"], [self languageKey:@"Files"], [self languageKey:@"About"]];
    NSArray *normalArray    = @[@"tab_cameras", @"files", @"tab_about"];
    NSArray *selectedArray  = @[@"cameras_pre",@"files_pre",@"tab_about_pre"];
    
    for (int i=0; i<[self.viewControllers count]; i++)
    {
        UIViewController *vc  = [self.viewControllers objectAtIndex:i];
        
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:[titleArray objectAtIndex:i]
                                                           image:[UIImage imageNamed:[normalArray objectAtIndex:i]]
                                                   selectedImage:[UIImage imageNamed:[selectedArray objectAtIndex:i]]];
        vc.tabBarItem = item;
    }
    
    
    self.tabBar.backgroundColor = RGB(13, 13, 13);
    self.tabBar.tintColor = [UIColor grayColor];
    self.tabBar.selectedImageTintColor = [UIColor grayColor];
    self.tabBar.backgroundImage=[UIImage imageWithColor:RGB(13, 13, 13)];
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
