//
//  RequestViewController.m
//  Framework
//
//  Created by gejiangs on 15/3/31.
//  Copyright (c) 2015年 guojiang. All rights reserved.
//

#import "RequestViewController.h"
#import "AdHelper.h"
#import "UIImageView+WebCache.h"

@interface RequestViewController ()

@property (nonatomic, strong) AdHelper *adHelper;
@property (weak, nonatomic) IBOutlet UIImageView *adImageView;

@end

@implementation RequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"单一网络请求";
    self.adHelper = [[AdHelper alloc] init];
}

- (IBAction)loadAD:(UIButton *)sender
{
    [self.view showActivityView:@"loading..."];
    [self.adHelper getADInfoWithSuccess:^(BOOL success, AdModel *adModel) {
        [self.adImageView sd_setImageWithURL:[NSURL URLWithString:adModel.ad_img_url] placeholderImage:nil];
        
        [self.view hiddenActivityView];
    } failure:^(NSError *error) {
        [self.view showActivityView:@"网络异常" hideAfterDelay:3.f];
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
