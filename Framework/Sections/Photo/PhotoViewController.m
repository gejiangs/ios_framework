//
//  PhotoViewController.m
//  Framework
//
//  Created by gejiangs on 15/7/9.
//  Copyright (c) 2015年 guojiang. All rights reserved.
//

#import "PhotoViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface PhotoViewController ()

@property (strong,nonatomic) AVCaptureSession *captureSession;//负责输入和输出设备之间的数据传递
@property (strong,nonatomic) AVCaptureDeviceInput *captureDeviceInput;//负责从AVCaptureDevice获得输入数据
@property (strong,nonatomic) AVCaptureStillImageOutput *captureStillImageOutput;//照片输出流
@property (strong,nonatomic) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;//相机拍摄预览图层
@property (strong, nonatomic) UIView *containerView;

typedef void(^PropertyChangeBlock)(AVCaptureDevice *captureDevice);


@property (strong, nonatomic) UIView *focusCursorView; //聚焦光标

@end

@implementation PhotoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.title = @"拍摄";
    
    [self addRightBarTitle:@"切换摄像头" target:self action:@selector(toggleButtonClick)];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self initView];
    
    [self initCapture];
    
    [self addGenstureRecognizer];
}
-(void)initView
{
    
    CGFloat h = self.view.frame.size.height - 80;
    
    self.containerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, h)];
    [self.view addSubview:self.containerView];
    
    UIButton *takePhotoBtn = [self.view addButtonWithTitle:@"" target:self action:@selector(takePhotoBtnClick)];
    takePhotoBtn.layer.cornerRadius = 30.f;
    takePhotoBtn.backgroundColor = [UIColor grayColor];
    [takePhotoBtn makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(Size(60, 60));
        make.centerX.equalTo(self.view);
        make.bottom.offset(-10);
    }];
    
}


-(void)initCapture
{
    //初始化会话
    _captureSession=[[AVCaptureSession alloc]init];
    [_captureSession startRunning];
    
    //设置拍摄质量
    [_captureSession setSessionPreset:AVCaptureSessionPresetPhoto];
    
//    if ([_captureSession canSetSessionPreset:AVCaptureSessionPreset1280x720])
//    {//设置分辨率
//        _captureSession.sessionPreset=AVCaptureSessionPreset1280x720;
//    }
    
    //获得输入设备
    //取得后置摄像头
    AVCaptureDevice *captureDevice=[self getCameraDeviceWithPosition:AVCaptureDevicePositionBack];
    if (!captureDevice)
    {
        NSLog(@"取得后置摄像头时出现问题.");
        return;
    }
    NSError *error=nil;
    
    //根据输入设备初始化设备输入对象，用于获得输入数据
    self.captureDeviceInput=[[AVCaptureDeviceInput alloc]initWithDevice:captureDevice error:&error];
    
    if (error)
    {
        NSLog(@"取得设备输入对象时出错，错误原因：%@",error.localizedDescription);
        return;
    }
    
    //初始化设备输出对象，用于获得输出数据
    _captureStillImageOutput=[[AVCaptureStillImageOutput alloc]init];
    NSDictionary *outputSettings = @{AVVideoCodecKey:AVVideoCodecJPEG};
    
    [_captureStillImageOutput setOutputSettings:outputSettings];
    
    //输出设置        //将设备输入添加到会话中
    if ([_captureSession canAddInput:_captureDeviceInput])
    {
        [_captureSession addInput:_captureDeviceInput];
    }
    
    //将设备输出添加到会话中
    if ([_captureSession canAddOutput:_captureStillImageOutput])
    {
        [_captureSession addOutput:_captureStillImageOutput];
    }
    
    //创建视频预览层，用于实时展示摄像头状态
    _captureVideoPreviewLayer=[[AVCaptureVideoPreviewLayer alloc]initWithSession:self.captureSession];
    
    CALayer *layer=self.containerView.layer;
    layer.masksToBounds=YES;
    _captureVideoPreviewLayer.frame= layer.bounds;
    _captureVideoPreviewLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    
    //填充模式
    //将视频预览层添加到界面中
    [layer addSublayer:_captureVideoPreviewLayer];
    
    
    self.focusCursorView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.focusCursorView.layer.borderColor=[UIColor whiteColor].CGColor;
    self.focusCursorView.layer.borderWidth=2;
    self.focusCursorView.alpha=0;
    [self.containerView addSubview:self.focusCursorView];
    
}

-(void)start
{
    if (_captureSession)
    {
        [_captureSession startRunning];
        
    }
}

-(void)stop
{
    if (_captureSession)
    {
        [_captureSession stopRunning];
        
    }
}

//拍照
-(void)takePhotoBtnClick
{
    //根据设备输出获得连接
    AVCaptureConnection *videoConnection=[self.captureStillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    
    [self.captureStillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error)
     {
         [self stop];
         
         if (imageDataSampleBuffer)
         {
             NSData *imageData=[AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
             UIImage *image=[[UIImage imageWithData:imageData] rotateImage];
             
             //  [self.captureSession stopRunning];
             UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 44, 320, 320)];
             imgView.contentMode=UIViewContentModeScaleAspectFill;
             imgView.userInteractionEnabled=YES;
             [self.view addSubview:imgView];
             imgView.image=image;
             
             UITapGestureRecognizer *tapGR=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImgView)];
             [imgView addGestureRecognizer:tapGR];
             
             
             //保存图片
             UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
             
             
         }
     }];
    
    
    
}

-(void)tapImgView
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//添加点击手势操作，点按预览视图时进行聚焦、白平衡设置。
/** *  设置聚焦点 * *  @param point 聚焦点 */
-(void)focusWithMode:(AVCaptureFocusMode)focusMode exposureMode:(AVCaptureExposureMode)exposureMode atPoint:(CGPoint)point
{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice)
     {
         if ([captureDevice isFocusModeSupported:focusMode])
         {
             [captureDevice setFocusMode:AVCaptureFocusModeAutoFocus];
         }
         if ([captureDevice isFocusPointOfInterestSupported])
         {
             [captureDevice setFocusPointOfInterest:point];
         }
         if ([captureDevice isExposureModeSupported:exposureMode])
         {
             [captureDevice setExposureMode:AVCaptureExposureModeAutoExpose];
         }
         if ([captureDevice isExposurePointOfInterestSupported])
         {
             [captureDevice setExposurePointOfInterest:point];
         }
     }];
}

/** *  改变设备属性的统一操作方法 * *  @param propertyChange 属性改变操作 */
-(void)changeDeviceProperty:(PropertyChangeBlock)propertyChange
{
    AVCaptureDevice *captureDevice= [self.captureDeviceInput device];
    NSError *error;
    //注意改变设备属性前一定要首先调用lockForConfiguration:调用完之后使用unlockForConfiguration方法解锁
    if ([captureDevice lockForConfiguration:&error])
    {
        propertyChange(captureDevice);
        [captureDevice unlockForConfiguration];
    }
    else
    {
        NSLog(@"设置设备属性过程发生错误，错误信息：%@",error.localizedDescription);
    }
}
/** *  设置闪光灯模式 * *  @param flashMode 闪光灯模式 */
-(void)setFlashMode:(AVCaptureFlashMode )flashMode
{
    
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice)
     {
         if ([captureDevice isFlashModeSupported:flashMode])
         {
             [captureDevice setFlashMode:flashMode];
         }
     }];
}
/** *  设置闪光灯按钮状态 */
//-(void)setFlashModeButtonStatus
//{
//    AVCaptureDevice *captureDevice=[self.captureDeviceInput device];
//    AVCaptureFlashMode flashMode=captureDevice.flashMode;
//    if([captureDevice isFlashAvailable])
//    {
//        self.flashAutoButton.hidden=NO;
//        self.flashOnButton.hidden=NO;
//        self.flashOffButton.hidden=NO;
//        self.flashAutoButton.enabled=YES;
//        self.flashOnButton.enabled=YES;
//        self.flashOffButton.enabled=YES;
//        switch (flashMode) {
//            case AVCaptureFlashModeAuto:
//            self.flashAutoButton.enabled=NO;
//            break;
//            case AVCaptureFlashModeOn:
//            self.flashOnButton.enabled=NO;
//            break;
//            case AVCaptureFlashModeOff:
//            self.flashOffButton.enabled=NO;
//            break;
//
//            default:
//            break;
//        }
//    }else
//    {
//        self.flashAutoButton.hidden=YES;
//        self.flashOnButton.hidden=YES;
//        self.flashOffButton.hidden=YES;
//    }
//}
/** *  添加点按手势，点按时聚焦 */
-(void)addGenstureRecognizer
{
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapScreen:)];
    [self.containerView addGestureRecognizer:tapGesture];
}
-(void)tapScreen:(UITapGestureRecognizer *)tapGesture
{
    CGPoint point= [tapGesture locationInView:self.containerView];
    //将UI坐标转化为摄像头坐标
    CGPoint cameraPoint= [self.captureVideoPreviewLayer captureDevicePointOfInterestForPoint:point];
    [self setFocusCursorWithPoint:point];
    [self focusWithMode:AVCaptureFocusModeAutoFocus exposureMode:AVCaptureExposureModeAutoExpose atPoint:cameraPoint];
}

/** *  设置聚焦光标位置 * *  @param point 光标位置 */
-(void)setFocusCursorWithPoint:(CGPoint)point
{
    self.focusCursorView.center=point;
    self.focusCursorView.transform=CGAffineTransformMakeScale(1.5, 1.5);
    self.focusCursorView.alpha=1.0;
    [UIView animateWithDuration:1.0 animations:^{
        self.focusCursorView.transform=CGAffineTransformIdentity;
    } completion:^(BOOL finished)
     {
         self.focusCursorView.alpha=0;
     }];
}
/**
 *  取得指定位置的摄像头 * *@param position 摄像头位置 * * @return 摄像头设备
 */
-(AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition )position
{
    NSArray *cameras= [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in cameras)
    {
        if ([camera position]==position)
        {
            return camera;
        }
    }
    return nil;
}


- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
}


#pragma mark - 切换前后摄像头

- (void)toggleButtonClick
{
    AVCaptureDevice *currentDevice=[self.captureDeviceInput device];
    AVCaptureDevicePosition currentPosition=[currentDevice position];
    
    AVCaptureDevice *toChangeDevice;
    AVCaptureDevicePosition toChangePosition=AVCaptureDevicePositionFront;
    if (currentPosition==AVCaptureDevicePositionUnspecified||currentPosition==AVCaptureDevicePositionFront)
    {
        toChangePosition=AVCaptureDevicePositionBack;
    }
    toChangeDevice=[self getCameraDeviceWithPosition:toChangePosition];
    //获得要调整的设备输入对象
    AVCaptureDeviceInput *toChangeDeviceInput=[[AVCaptureDeviceInput alloc]initWithDevice:toChangeDevice error:nil];
    //改变会话的配置前一定要先开启配置，配置完成后提交配置改变
    [self.captureSession beginConfiguration];
    //移除原有输入对象
    [self.captureSession removeInput:self.captureDeviceInput];
    //添加新的输入对象
    if ([self.captureSession canAddInput:toChangeDeviceInput])
    {
        [self.captureSession addInput:toChangeDeviceInput];
        self.captureDeviceInput=toChangeDeviceInput;
    }
    //提交会话配置
    [self.captureSession commitConfiguration];
}

@end
