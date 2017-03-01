//
//  PlacehodlerTextViewController.m
//  Framework
//
//  Created by gejiangs on 15/8/26.
//  Copyright (c) 2015年 guojiang. All rights reserved.
//

#import "PlacehodlerTextViewController.h"
#import "PlaceholderTextView.h"

@interface PlacehodlerTextViewController ()<UITextViewDelegate>

@property (nonatomic, strong)   PlaceholderTextView *textView;
@property (weak, nonatomic) IBOutlet PlaceholderTextView *textView2;

@end

@implementation PlacehodlerTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textView = [[PlaceholderTextView alloc] init];
    _textView.backgroundColor = [UIColor grayColor];
    _textView.delegate = self;
    _textView.placeholder = @"写点什么好呢写点什么好呢写点什么好呢写点什么好呢写点什么好呢写点什么好呢写点什么好呢写点什么好呢写点什么好呢写点什么好呢写点什么好呢写点什么好呢写点什么好呢写点什么好呢写点什么好呢写点什么好呢写点什么好呢写点什么好呢。。。";
    [self.view addSubview:_textView];
    
    [_textView makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.offset(0);
        make.height.offset(100);
    }];
    
    
    _textView2.backgroundColor = [UIColor grayColor];
    _textView2.delegate = self;
    _textView2.placeholder = @"写点什么好呢写点什么好呢写点什么好呢写点什么好呢写点什么好呢写点什么好呢写点什么好呢写点什么好呢写点什么好呢写点什么好呢写点什么好呢写点什么好呢写点什么好呢写点什么好呢写点什么好呢写点什么好呢写点什么好呢写点什么好呢。。。";
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
