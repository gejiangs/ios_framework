//
//  UIScrollViewController.m
//  Framework
//
//  Created by gejiangs on 15/5/6.
//  Copyright (c) 2015年 guojiang. All rights reserved.
//

#import "UIScrollViewController.h"
#import "BannerScrollView.h"

@interface UIScrollViewController ()

@end

@implementation UIScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"自动滚动UIScrollView";
    
    self.view.backgroundColor = [UIColor grayColor];
    
    NSArray *urls = @[
                      @"https://ss1.baidu.com/9vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=7844b6536559252da3424e4452a63709/4b90f603738da97798afd262b551f8198718e3f3.jpg",
                      @"https://ss1.baidu.com/9vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=2fbe89b579d98d1076815f7147028c3c/f603918fa0ec08fa505e0cee5cee3d6d55fbda18.jpg",
                      @"https://ss1.baidu.com/9vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=e5d0477f18950a7b75601d846cec56eb/0ff41bd5ad6eddc4f802a8b23cdbb6fd53663395.jpg",
                      @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=88b9154b8244ebf86d24377fbfc4e318/42a98226cffc1e17695ba0794f90f603728de996.jpg"];
    
    BannerScrollView *banner = [[BannerScrollView alloc] initWithImageUrls:urls autoTimerInterval:3.f clickBlock:^(NSInteger index) {
        NSLog(@"image Click index:%ld", index);
    }];
    [self.view addSubview:banner];
    
    CGFloat s = 425/260.f;
    CGFloat h = self.view.frame.size.width/s;
    
    [banner makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.offset(0);
        make.height.offset(h);
    }];
    
    
    NSArray *names = @[@"1",@"2",@"3",@"4"];
    
    BannerScrollView *bannerImageName = [[BannerScrollView alloc] initWithImageNames:names clickBlock:^(NSInteger index) {
        NSLog(@"image Click index:%ld", index);
    }];
    [self.view addSubview:bannerImageName];
    
    CGFloat s2 = 665/362.f;
    CGFloat h2 = self.view.frame.size.width/s2;
    
    [bannerImageName makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(banner.mas_bottom).offset(50);
        make.left.right.offset(0);
        make.height.offset(h2);
    }];
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
