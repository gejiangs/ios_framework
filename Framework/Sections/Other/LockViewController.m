//
//  LockViewController.m
//  Framework
//
//  Created by guojiang on 23/10/14.
//  Copyright (c) 2014年 guojiang. All rights reserved.
//

#import "LockViewController.h"
#import "LockView.h"

@interface LockViewController ()<LockViewDelegate>

@property (nonatomic, strong) UILabel *pwdLabel;

@end

@implementation LockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"九宫格解锁";
    
    UIImageView *bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gesture_background"]];
    bgView.frame = self.view.bounds;
    [self.view addSubview:bgView];
    
    self.pwdLabel = [self.view addLabelWithText:@""];
    [_pwdLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(50);
        make.centerX.equalTo(self.view);
    }];
    
    LockView *lockView = [[LockView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.width)];
    lockView.delegate = self;
    lockView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:lockView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)LockViewDidClick:(LockView *)lockView andPwd:(NSString *)pwd
{
    self.pwdLabel.text = [NSString stringWithFormat:@"密码是:%@", pwd];
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
