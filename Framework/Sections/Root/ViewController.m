//
//  ViewController.m
//  Framework
//
//  Created by gejiangs on 15/3/31.
//  Copyright (c) 2015年 guojiang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)   UIButton *handlerView;
@property (nonatomic, strong)   UILabel *timerLabel;
@property (retain,nonatomic)    NSString *rStr;
@property (copy, nonatomic)     NSString *cStr;
@property (strong, nonatomic)   NSString *sStr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"框架demo";
    
    [self addRightBarTitle:@"手动截屏" target:self action:@selector(rightCliked:)];
    
    NSDate *date = [NSDate date];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = -1;
    date = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:date options:0];
    
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd";
    
    NSString *string = [df stringFromDate:date];
    
    NSLog(@"Shop for Valentine's Day by %@", string);
    
    NSArray *array = @[@{@"title":@"网络请求", @"class":@"RequestViewController"},
                         @{@"title":@"多图合并视频",@"class":@"ImageConvertVedioViewController"},
                         @{@"title":@"多任务请求",@"class":@"MultiTaskRequestViewController"},
                         @{@"title":@"AutoLayout 动画", @"class":@"AnimateViewController"},
                         @{@"title":@"指示器", @"class":@"HUDViewController"},
                         @{@"title":@"发布朋友圈消息", @"class":@"PublishTopicViewController"},
                         @{@"title":@"省市区级联", @"class":@"AddressViewController"},
                         @{@"title":@"友盟分享", @"class":@"ShareViewController"},
                         @{@"title":@"照片选择", @"class":@"PictureViewController"},
                         @{@"title":@"九宫格解锁", @"class":@"LockViewController"},
                         @{@"title":@"扫一扫", @"class":@"ScanViewController"},
                         @{@"title":@"通讯录", @"class":@"AddressBookViewController"},
                         @{@"title":@"自定义拍照", @"class":@"PhotoViewController"},
                         @{@"title":@"录制短视频", @"class":@"VideoViewController"},
                         @{@"title":@"MJExtension示例",@"class":@"MJExtensionViewController"},
                         @{@"title":@"蓝牙连接",@"class":@"BluetoothViewController"},
                         @{@"title":@"系统设置页面跳转",@"class":@"SystemSettingViewController"},
                       @{@"title":@"资讯",@"class":@"GFInfoViewController"},
                    ];
    
    self.contentList = [NSMutableArray arrayWithArray:array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userDidTakeScreenshot)
                                                 name:UIApplicationUserDidTakeScreenshotNotification object:nil];
    
    NSLog(@"root.name:%@", [RootManager sharedManager].name);
    
//    NSMutableString *mStr = [NSMutableString stringWithFormat:@"abc"];
    NSString *mStr = @"abc";
    
    self.rStr   = mStr;
    self.cStr     = mStr;
    self.sStr     = mStr;
    NSLog(@"mStr:%p,%p",  mStr,&mStr);
    NSLog(@"retainStr:%p,%p", _rStr, &_rStr);
    NSLog(@"copyStr:%p,%p",   _cStr, &_cStr);
    NSLog(@"strongStr:%p,%p",   _sStr, &_sStr);
    
//    mStr = [@"de" mutableCopy];
//    [mStr appendString:@"de"];
    mStr = @"abcde";
    NSLog(@"retainStr:%@",  _rStr);
    NSLog(@"copyStr:%@",    _cStr);
    NSLog(@"strongStr:%@",    _cStr);
    
    NSLog(@"mStr:%p,%p",  mStr,&mStr);
    NSLog(@"retainStr:%p,%p", _rStr, &_rStr);
    NSLog(@"copyStr:%p,%p",   _cStr, &_cStr);
    NSLog(@"strongStr:%p,%p",   _sStr, &_sStr);
}

-(void)cancelAction:(UIButton *)sender
{
    if (self.handlerView != nil) {
        [self.handlerView removeFromSuperview];
        self.handlerView = nil;
    }
}

//截屏响应
- (void)userDidTakeScreenshot
{
    NSLog(@"检测到截屏");
    
    self.handlerView = [UIButton buttonWithType:UIButtonTypeCustom];
    _handlerView.frame = self.navigationController.view.bounds;
    _handlerView.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0.3];
    [_handlerView addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.view addSubview:_handlerView];
    
    //添加显示
    UIImageView *imgvPhoto = [[UIImageView alloc]initWithImage:[UIImage imageWithScreenShot]];
    
    //添加边框
    CALayer * layer = [imgvPhoto layer];
    layer.borderColor = [
                         [UIColor whiteColor] CGColor];
    layer.borderWidth = 5.0f;
    //添加四个边阴影
    imgvPhoto.layer.shadowColor = [UIColor blackColor].CGColor;
    imgvPhoto.layer.shadowOffset = CGSizeMake(0, 0);
    imgvPhoto.layer.shadowOpacity = 0.5;
    imgvPhoto.layer.shadowRadius = 10.0;
    //添加两个边阴影
    imgvPhoto.layer.shadowColor = [UIColor blackColor].CGColor;
    imgvPhoto.layer.shadowOffset = CGSizeMake(4, 4);
    imgvPhoto.layer.shadowOpacity = 0.5;
    imgvPhoto.layer.shadowRadius = 2.0;
    
    [_handlerView addSubview:imgvPhoto];
    [imgvPhoto makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_handlerView);
        make.width.equalTo(_handlerView.width).multipliedBy(0.5);
        make.height.equalTo(_handlerView.height).multipliedBy(0.5);
    }];
}

-(void)rightCliked:(UIButton *)sender
{
    [self userDidTakeScreenshot];
}

#pragma mark UITableView dataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.contentList count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ident = @"cell";
    if (indexPath.row == 5) {
        ident = @"cell_timer";
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ident];
    }
    
    cell.textLabel.text = [[self.contentList objectAtIndex:indexPath.row] objectForKey:@"title"];
    if (indexPath.row == 5 && self.timerLabel == nil) {
        self.timerLabel = [cell.contentView addLabelWithText:@"--"];
        [_timerLabel makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-20);
            make.centerY.equalTo(cell.contentView);
        }];
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(runTimer) userInfo:nil repeats:YES];
        //NSRunLoopCommonModes,UITrackingRunLoopMode 滚动时，也会更新UI
//        [[NSRunLoop currentRunLoop] addTimer:timer forMode:UITrackingRunLoopMode];
    }
    return cell;
}

-(void)runTimer
{
    [self dispatchAsyncMainQueue:^{
        int v = [self.timerLabel.text intValue];
        v ++;
        
        self.timerLabel.text = [NSString stringWithFormat:@"%d", v];
    }];
}

#pragma mark UITableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *className = [[self.contentList objectAtIndex:indexPath.row] objectForKey:@"class"];
    
    id objClass = [[NSClassFromString(className) alloc] init];
    
    [self.navigationController pushViewController:objClass animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
