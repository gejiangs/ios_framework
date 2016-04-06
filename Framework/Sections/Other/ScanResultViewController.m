//
//  ScanResultViewController.m
//  Framework
//
//  Created by gejiangs on 15/6/10.
//  Copyright (c) 2015年 guojiang. All rights reserved.
//

#import "ScanResultViewController.h"

@interface ScanResultViewController ()

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation ScanResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"扫描结果";
    
    [self initUI];
    
    if ([self isURL]) {
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.scanString]];
        [self.webView loadRequest:request];
    }else{
        [self.webView loadHTMLString:self.scanString baseURL:nil];
    }
}

-(void)initUI
{
    self.webView = [[UIWebView alloc] init];
    [self.view addSubview:_webView];
    [_webView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}


-(BOOL)isURL
{
    NSMutableString *resultString = [[NSMutableString alloc] initWithString:self.scanString];
    NSError *error;
    NSString *regulaStr = @"\\bhttps?://[a-zA-Z0-9\\-.]+(?::(\\d+))?(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:resultString options:0 range:NSMakeRange(0, [resultString length])];
    
    BOOL isurl = NO;
    
    if ([arrayOfAllMatches count] == 1) {
        NSTextCheckingResult *match = [arrayOfAllMatches objectAtIndex:0];
        NSString *matchString = [resultString substringWithRange:match.range];
        
        isurl = [resultString isEqualToString:matchString];
        
    }
    
    return isurl;
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
