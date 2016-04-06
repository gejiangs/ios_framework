//
//  ScanViewController.m
//  Framework
//
//  Created by gejiangs on 15/6/9.
//  Copyright (c) 2015年 guojiang. All rights reserved.
//

#import "ScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ScanResultViewController.h"

@interface ScanViewController ()<AVCaptureMetadataOutputObjectsDelegate>
{
    int num;
    BOOL upOrdown;
    NSTimer * timer;
}

@property (strong,nonatomic) AVCaptureDevice * device;
@property (strong,nonatomic) AVCaptureDeviceInput * input;
@property (strong,nonatomic) AVCaptureMetadataOutput * output;
@property (strong,nonatomic) AVCaptureSession * session;
@property (strong,nonatomic) AVCaptureVideoPreviewLayer * preview;

@property (nonatomic,strong) UIImageView * line;

@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"扫一扫";
    
    [self initUI];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupCamera];
}

-(void)initUI
{
    UIImageView *boxImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ScanPickBg.png"]];
    [self.view addSubview:boxImage];
    [boxImage makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(Size(260, 260));
        make.top.offset(100);
        make.centerX.equalTo(self.view);
    }];
    
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 240, 2)];
    _line.image = [UIImage imageNamed:@"ScanLine.png"];
    [boxImage addSubview:_line];
    
    UILabel *tipLabel = [self.view addLabelWithText:@"将二维码至于框内,即可自动扫描" color:[UIColor whiteColor]];
    [tipLabel makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(boxImage.bottom).offset(40);
        make.centerX.equalTo(self.view);
    }];
    
    
    //定时器，设定时间过1.5秒，
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
}

-(CGRect)convertToOutputRect:(CGRect)rect
{
    CGRect v;
    
    v.origin.x = rect.origin.y/self.view.frame.size.height;
    v.origin.y = ((self.view.frame.size.width-rect.size.width)/2)/self.view.frame.size.width;
    v.size.width = rect.size.height/self.view.frame.size.height;
    v.size.height = rect.size.width/self.view.frame.size.width;
    
    return v;
}

-(void)setupCamera
{
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    CGFloat x = (self.view.frame.size.width-260)/2.f;
    
    CGRect rect = [self convertToOutputRect:Rect(x, 100, 260, 260)];
    
    [_output setRectOfInterest:rect];
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    // 条码类型 AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeCode39Code,AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeCode39Mod43Code,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeCode93Code];
    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:_session];
    _preview.videoGravity =AVLayerVideoGravityResizeAspectFill;
    _preview.frame =self.view.layer.bounds;
    [self.view.layer insertSublayer:_preview atIndex:0];
    
    // Start
    [_session startRunning];
}


//感应线条（上/下）动画
-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(10, 10+2*num, 240, 2);
        if (2*num == 240) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectMake(10, 10+2*num, 240, 2);
        if (num == 0) {
            upOrdown = NO;
        }
    }
}

#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSString *scanString = nil;
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        scanString = metadataObject.stringValue;
    }
    
    [_output setMetadataObjectsDelegate:nil queue:nil];
    [_session stopRunning];
    
    [timer invalidate];
    
    ScanResultViewController  *resultVC = [[ScanResultViewController alloc] init];
    resultVC.scanString = scanString;
    
    NSMutableArray *vcs = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
    [vcs removeLastObject];
    [vcs addObject:resultVC];
    
    [self.navigationController setViewControllers:vcs animated:YES];
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
