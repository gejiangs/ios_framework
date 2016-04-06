//
//  RecordVideoViewController.m
//  ZiYueiM
//
//  Created by gejiangs on 15/7/2.
//  Copyright (c) 2015年 DC. All rights reserved.
//

#import "RecordVideoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "VideoViewController.h"

#define VIDEO_SCALE     1.33f             //视频录制比例

typedef void(^PropertyChangeBlock)(AVCaptureDevice *captureDevice);

@interface RecordVideoViewController ()<AVCaptureFileOutputRecordingDelegate, UIAlertViewDelegate>

@property (strong,nonatomic) AVCaptureSession *captureSession;                      //负责输入和输出设置之间的数据传递
@property (strong,nonatomic) AVCaptureDeviceInput *captureDeviceInput;              //负责从AVCaptureDevice获得输入数据
@property (strong,nonatomic) AVCaptureMovieFileOutput *captureMovieFileOutput;      //视频输出流
@property (strong,nonatomic) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;  //相机拍摄预览图层
@property (assign,nonatomic) UIBackgroundTaskIdentifier backgroundTaskIdentifier;   //后台任务标识

@property (weak, nonatomic) IBOutlet UIView *videoPreviewView;                      //视频预览区域
@property (weak, nonatomic) IBOutlet UIImageView *focusCursor;                      //聚焦光标
@property (weak, nonatomic) IBOutlet UIView *bottomView;                            //底部view
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeLineConstrain;         //时间线宽度约束
@property (weak, nonatomic) IBOutlet UIView *recordLineView;                        //时间线
@property (weak, nonatomic) IBOutlet UILabel *recordTipLabel;                       //提示文字
@property (weak, nonatomic) IBOutlet UIButton *takeButton;                          //录制按钮

@property (nonatomic, assign)   BOOL isCancelRecord;                                //是否取消录制

@property (nonatomic, strong)   NSTimer *recordTimer;                               //录制视频时间

@property (nonatomic, assign)   BOOL isRepeatTouch;                                 //是否重复触摸

@end

@implementation RecordVideoViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.title = @"拍摄小视频";
    
    [self clearRecordCache];
    
    [self addLeftBarButton:@"取消" target:self action:@selector(leftMenuPressed:)];
    
    self.timeLineConstrain.constant = self.view.frame.size.width;
    
    //初始化会话
    _captureSession=[[AVCaptureSession alloc]init];
    [_captureSession setSessionPreset:AVCaptureSessionPreset352x288];
    //    if ([_captureSession canSetSessionPreset:AVCaptureSessionPreset1280x720]) {//设置分辨率
    //        _captureSession.sessionPreset=AVCaptureSessionPreset1280x720;
    //    }
    //获得输入设备
    AVCaptureDevice *captureDevice=[self getCameraDeviceWithPosition:AVCaptureDevicePositionBack];//取得后置摄像头
    if (!captureDevice) {
        NSLog(@"取得后置摄像头时出现问题.");
        return;
    }
    
    //添加一个音频输入设备
    AVCaptureDevice *audioCaptureDevice=[[AVCaptureDevice devicesWithMediaType:AVMediaTypeAudio] firstObject];
    
    
    NSError *error=nil;
    //根据输入设备初始化设备输入对象，用于获得输入数据
    _captureDeviceInput=[[AVCaptureDeviceInput alloc]initWithDevice:captureDevice error:&error];
    if (error) {
        NSLog(@"取得设备输入对象时出错，错误原因：%@",error.localizedDescription);
        return;
    }
    AVCaptureDeviceInput *audioCaptureDeviceInput=[[AVCaptureDeviceInput alloc]initWithDevice:audioCaptureDevice error:&error];
    if (error) {
        NSLog(@"取得设备输入对象时出错，错误原因：%@",error.localizedDescription);
        return;
    }
    //初始化设备输出对象，用于获得输出数据
    _captureMovieFileOutput=[[AVCaptureMovieFileOutput alloc]init];
    
    //将设备输入添加到会话中
    if ([_captureSession canAddInput:_captureDeviceInput]) {
        [_captureSession addInput:_captureDeviceInput];
        [_captureSession addInput:audioCaptureDeviceInput];
        AVCaptureConnection *captureConnection=[_captureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
        if ([captureConnection isVideoStabilizationSupported ]) {
            captureConnection.preferredVideoStabilizationMode=AVCaptureVideoStabilizationModeAuto;
        }
    }
    
    //将设备输出添加到会话中
    if ([_captureSession canAddOutput:_captureMovieFileOutput]) {
        [_captureSession addOutput:_captureMovieFileOutput];
    }
    
    //创建视频预览层，用于实时展示摄像头状态
    _captureVideoPreviewLayer=[[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    self.videoPreviewView.clipsToBounds = YES;
    CALayer *layer=self.videoPreviewView.layer;
    layer.masksToBounds=YES;
    
    _captureVideoPreviewLayer.frame= self.videoPreviewView.frame;
    _captureVideoPreviewLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;//填充模式
    
    //将视频预览层添加到界面中
    [layer insertSublayer:_captureVideoPreviewLayer below:self.focusCursor.layer];
    
    [self addNotificationToCaptureDevice:captureDevice];
    [self addGenstureRecognizer];
}

-(void)clearRecordCache
{
    NSString *outputFielPath=[NSTemporaryDirectory() stringByAppendingString:@"tmp_video_file.mov"];
    
    NSFileManager *manager  = [NSFileManager defaultManager];
    NSError *error;
    [manager removeItemAtPath:outputFielPath error:&error];
}

-(void)leftMenuPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.captureSession startRunning];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.captureSession stopRunning];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self leftMenuPressed:nil];
}


#pragma mark - UI方法
#pragma mark 视频录制

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self.captureMovieFileOutput isRecording]) {
        self.isRepeatTouch = YES;
        return;
    }
    if ([self takeButtonRectContainsPoint:touches]) {
        [self startRecording];
        
        self.isCancelRecord = NO;
        
        self.recordLineView.hidden = NO;
        self.recordTipLabel.hidden = NO;
        
        [self.takeButton setImage:[UIImage imageNamed:@"record_ing_btn"] forState:UIControlStateNormal];
        
        self.recordTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(setTimeLineLength) userInfo:nil repeats:YES];
    }
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.isRepeatTouch) {
        return;
    }
    if (![self.captureMovieFileOutput isRecording]) {
        return;
    }
    
    [self setTipTextInRect:[self takeButtonRectContainsPoint:touches]];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.isRepeatTouch) {
        self.isRepeatTouch = NO;
        return;
    }
    //未开始录制或者不在takeButton按钮区域，取消录制
    if ([self.captureMovieFileOutput isRecording] || ![self takeButtonRectContainsPoint:touches]) {
        self.isCancelRecord = YES;
        [self.captureMovieFileOutput stopRecording];
        [self.takeButton setImage:[UIImage imageNamed:@"record_btn"] forState:UIControlStateNormal];
        [self setTipTextInRect:YES];
        
        [self stopRecordTimer];
        self.timeLineConstrain.constant = self.view.frame.size.width;
        self.recordLineView.hidden = YES;
        self.recordTipLabel.hidden = YES;
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.isRepeatTouch) {
        self.isRepeatTouch = NO;
        return;
    }
    //未开始录制或者不在takeButton按钮区域，取消录制
    if (![self.captureMovieFileOutput isRecording] || ![self takeButtonRectContainsPoint:touches]) {
        self.isCancelRecord = YES;
    }else if ([self.captureMovieFileOutput isRecording] && [self takeButtonRectContainsPoint:touches]){
        self.isCancelRecord = NO;
        
        [self.view showActivityView:@"正在处理..."];
    }
    
    //此处可以需要判断录制最短时间
    //.......................
    
    [self.captureMovieFileOutput stopRecording];
    [self.takeButton setImage:[UIImage imageNamed:@"record_btn"] forState:UIControlStateNormal];
    [self setTipTextInRect:YES];
    
    [self stopRecordTimer];
    self.timeLineConstrain.constant = self.view.frame.size.width;
    self.recordLineView.hidden = YES;
    self.recordTipLabel.hidden = YES;
}

//设置录制时间线剩余长度
-(void)setTimeLineLength
{
    CGFloat len = self.view.frame.size.width/1000.f;
    self.timeLineConstrain.constant -= len;
    [self.recordLineView layoutIfNeeded];
    
    if (self.timeLineConstrain.constant <= 0) {
        [self stopRecordTimer];
        [self.captureSession stopRunning];
        
        [self.view showActivityView:@"正在处理..."];
    }
}

-(void)stopRecordTimer
{
    [self.recordTimer invalidate];
    self.recordTimer = nil;
}

//手势是否在takeButton区域
-(BOOL)takeButtonRectContainsPoint:(NSSet *)touches
{
    UITouch *touch = [touches anyObject];
    
    if ([touch view] == self.videoPreviewView) {
        return NO;
    }
    
    CGPoint point = [touch locationInView:[touch view]];
    CGRect takeRect = self.takeButton.frame;
    
    return CGRectContainsPoint(takeRect, point);
}

//设置文字录制状态
-(void)setTipTextInRect:(BOOL)inRect
{
    if (inRect) {
        self.recordLineView.backgroundColor = RGB(119, 912, 96);
        self.recordTipLabel.backgroundColor = [UIColor clearColor];
        self.recordTipLabel.textColor = RGB(119, 191, 95);
    }else{
        self.recordLineView.backgroundColor = [UIColor redColor];
        self.recordTipLabel.backgroundColor = [UIColor redColor];
        self.recordTipLabel.textColor = [UIColor whiteColor];
    }
}

-(void)startRecording
{
    //根据设备输出获得连接
    AVCaptureConnection *captureConnection=[self.captureMovieFileOutput connectionWithMediaType:AVMediaTypeVideo];
    //根据连接取得设备输出的数据
    if (![self.captureMovieFileOutput isRecording]) {
        
        //预览图层和视频方向保持一致
        captureConnection.videoOrientation=[self.captureVideoPreviewLayer connection].videoOrientation;
        NSString *outputFielPath=[NSTemporaryDirectory() stringByAppendingString:@"tmp_video_file.mov"];
        NSLog(@"save path is :%@",outputFielPath);
        NSURL *fileUrl=[NSURL fileURLWithPath:outputFielPath];
        NSLog(@"fileUrl:%@",fileUrl);
        [self.captureMovieFileOutput startRecordingToOutputFileURL:fileUrl recordingDelegate:self];
    }
}

#pragma mark - 视频输出代理
-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections
{
    NSLog(@"开始录制...");
}
-(void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error{
    NSLog(@"视频录制完成.");
    
    //中途取消录制
    if (self.isCancelRecord) {
        //删除本地缓存视频文件
        [[NSFileManager defaultManager] removeItemAtURL:outputFileURL error:nil];
        return;
    }
    
    //清除缓存
    [self clearMergeCacheFile];
    
    //裁剪视频录制区域
    [self mergeAndExportVideosAtFileURLs:@[outputFileURL]];
    
}

#pragma mark - 通知
/**
 *  给输入设备添加通知
 */
-(void)addNotificationToCaptureDevice:(AVCaptureDevice *)captureDevice{
    //注意添加区域改变捕获通知必须首先设置设备允许捕获
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        captureDevice.subjectAreaChangeMonitoringEnabled=YES;
    }];
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    //捕获区域发生改变
    [notificationCenter addObserver:self selector:@selector(areaChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:captureDevice];
}
-(void)removeNotificationFromCaptureDevice:(AVCaptureDevice *)captureDevice{
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:captureDevice];
}
/**
 *  移除所有通知
 */
-(void)removeNotification{
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    [notificationCenter removeObserver:self];
}

-(void)addNotificationToCaptureSession:(AVCaptureSession *)captureSession{
    NSNotificationCenter *notificationCenter= [NSNotificationCenter defaultCenter];
    //会话出错
    [notificationCenter addObserver:self selector:@selector(sessionRuntimeError:) name:AVCaptureSessionRuntimeErrorNotification object:captureSession];
}

/**
 *  设备连接成功
 *
 *  @param notification 通知对象
 */
-(void)deviceConnected:(NSNotification *)notification{
    NSLog(@"设备已连接...");
}
/**
 *  设备连接断开
 *
 *  @param notification 通知对象
 */
-(void)deviceDisconnected:(NSNotification *)notification{
    NSLog(@"设备已断开.");
}
/**
 *  捕获区域改变
 *
 *  @param notification 通知对象
 */
-(void)areaChange:(NSNotification *)notification{
    NSLog(@"捕获区域改变...");
}

/**
 *  会话出错
 *
 *  @param notification 通知对象
 */
-(void)sessionRuntimeError:(NSNotification *)notification{
    NSLog(@"会话发生错误.");
}

#pragma mark - 私有方法

/**
 *  取得指定位置的摄像头
 *
 *  @param position 摄像头位置
 *
 *  @return 摄像头设备
 */
-(AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition )position{
    NSArray *cameras= [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in cameras) {
        if ([camera position]==position) {
            return camera;
        }
    }
    return nil;
}

/**
 *  改变设备属性的统一操作方法
 *
 *  @param propertyChange 属性改变操作
 */
-(void)changeDeviceProperty:(PropertyChangeBlock)propertyChange{
    AVCaptureDevice *captureDevice= [self.captureDeviceInput device];
    NSError *error;
    //注意改变设备属性前一定要首先调用lockForConfiguration:调用完之后使用unlockForConfiguration方法解锁
    if ([captureDevice lockForConfiguration:&error]) {
        propertyChange(captureDevice);
        [captureDevice unlockForConfiguration];
    }else{
        NSLog(@"设置设备属性过程发生错误，错误信息：%@",error.localizedDescription);
    }
}

/**
 *  设置闪光灯模式
 *
 *  @param flashMode 闪光灯模式
 */
-(void)setFlashMode:(AVCaptureFlashMode )flashMode{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFlashModeSupported:flashMode]) {
            [captureDevice setFlashMode:flashMode];
        }
    }];
}
/**
 *  设置聚焦模式
 *
 *  @param focusMode 聚焦模式
 */
-(void)setFocusMode:(AVCaptureFocusMode )focusMode{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFocusModeSupported:focusMode]) {
            [captureDevice setFocusMode:focusMode];
        }
    }];
}
/**
 *  设置曝光模式
 *
 *  @param exposureMode 曝光模式
 */
-(void)setExposureMode:(AVCaptureExposureMode)exposureMode{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isExposureModeSupported:exposureMode]) {
            [captureDevice setExposureMode:exposureMode];
        }
    }];
}
/**
 *  设置聚焦点
 *
 *  @param point 聚焦点
 */
-(void)focusWithMode:(AVCaptureFocusMode)focusMode exposureMode:(AVCaptureExposureMode)exposureMode atPoint:(CGPoint)point{
    [self changeDeviceProperty:^(AVCaptureDevice *captureDevice) {
        if ([captureDevice isFocusModeSupported:focusMode]) {
            [captureDevice setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        if ([captureDevice isFocusPointOfInterestSupported]) {
            [captureDevice setFocusPointOfInterest:point];
        }
        if ([captureDevice isExposureModeSupported:exposureMode]) {
            [captureDevice setExposureMode:AVCaptureExposureModeAutoExpose];
        }
        if ([captureDevice isExposurePointOfInterestSupported]) {
            [captureDevice setExposurePointOfInterest:point];
        }
    }];
}

/**
 *  添加点按手势，点按时聚焦
 */
-(void)addGenstureRecognizer{
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapScreen:)];
    [self.videoPreviewView addGestureRecognizer:tapGesture];
}

-(void)tapScreen:(UITapGestureRecognizer *)tapGesture{
    CGPoint point= [tapGesture locationInView:self.videoPreviewView];
    //将UI坐标转化为摄像头坐标
    CGPoint cameraPoint= [self.captureVideoPreviewLayer captureDevicePointOfInterestForPoint:point];
    [self setFocusCursorWithPoint:point];
    [self focusWithMode:AVCaptureFocusModeAutoFocus exposureMode:AVCaptureExposureModeAutoExpose atPoint:cameraPoint];
}

/**
 *  设置聚焦光标位置
 *
 *  @param point 光标位置
 */
-(void)setFocusCursorWithPoint:(CGPoint)point{
    self.focusCursor.center=point;
    self.focusCursor.transform=CGAffineTransformMakeScale(1.5, 1.5);
    self.focusCursor.alpha=1.0;
    [UIView animateWithDuration:1.0 animations:^{
        self.focusCursor.transform=CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.focusCursor.alpha=0;
        
    }];
}


#pragma mark - 合成文件
- (void)mergeAndExportVideosAtFileURLs:(NSArray *)fileURLArray
{
    NSError *error = nil;
    
    CGSize renderSize = CGSizeMake(0, 0);
    
    NSMutableArray *layerInstructionArray = [[NSMutableArray alloc] init];
    
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
    
    CMTime totalDuration = kCMTimeZero;
    
    //先去assetTrack 也为了取renderSize
    NSMutableArray *assetTrackArray = [[NSMutableArray alloc] init];
    NSMutableArray *assetArray = [[NSMutableArray alloc] init];
    
    
    for (NSURL *fileURL in fileURLArray)
    {
        
        AVAsset *asset = [AVAsset assetWithURL:fileURL];
        
        if (!asset) {
            continue;
        }
        NSLog(@"%@---%@",asset.tracks,[asset tracksWithMediaType:@"vide"]);
        
        [assetArray addObject:asset];
        
        
        AVAssetTrack *assetTrack = [[asset tracksWithMediaType:@"vide"] objectAtIndex:0];
        
        [assetTrackArray addObject:assetTrack];
        
        renderSize.width = MAX(renderSize.width, assetTrack.naturalSize.height);
        renderSize.height = MAX(renderSize.height, assetTrack.naturalSize.width);
    }
    
    
    CGFloat renderW = MIN(renderSize.width, renderSize.height);
    
    for (int i = 0; i < [assetArray count] && i < [assetTrackArray count]; i++) {
        
        AVAsset *asset = [assetArray objectAtIndex:i];
        AVAssetTrack *assetTrack = [assetTrackArray objectAtIndex:i];
        
        AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                            ofTrack:[[asset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0]
                             atTime:totalDuration
                              error:nil];
        
        AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        
        [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, asset.duration)
                            ofTrack:assetTrack
                             atTime:totalDuration
                              error:&error];
        
        //fix orientationissue
        AVMutableVideoCompositionLayerInstruction *layerInstruciton = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
        
        totalDuration = CMTimeAdd(totalDuration, asset.duration);
        
        CGFloat rate = renderW / MIN(assetTrack.naturalSize.width, assetTrack.naturalSize.height);
        
        CGAffineTransform layerTransform = CGAffineTransformMake(assetTrack.preferredTransform.a, assetTrack.preferredTransform.b, assetTrack.preferredTransform.c, assetTrack.preferredTransform.d, assetTrack.preferredTransform.tx * rate, assetTrack.preferredTransform.ty * rate);
        layerTransform = CGAffineTransformConcat(layerTransform, CGAffineTransformMake(1, 0, 0, 1, 0, -(assetTrack.naturalSize.width - assetTrack.naturalSize.height) / 2.0));//向上移动取中部影响
        layerTransform = CGAffineTransformScale(layerTransform, rate, rate);//放缩，解决前后摄像结果大小不对称
        
        [layerInstruciton setTransform:layerTransform atTime:kCMTimeZero];
        [layerInstruciton setOpacity:0.0 atTime:totalDuration];
        
        //data
        [layerInstructionArray addObject:layerInstruciton];
    }
    
    //get save path
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingString:@"merge_video_file.mov"];
    
    NSURL *mergeFileURL = [NSURL fileURLWithPath:filePath];
    
    //export
    AVMutableVideoCompositionInstruction *mainInstruciton = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    mainInstruciton.timeRange = CMTimeRangeMake(kCMTimeZero, totalDuration);
    mainInstruciton.layerInstructions = layerInstructionArray;
    AVMutableVideoComposition *mainCompositionInst = [AVMutableVideoComposition videoComposition];
    mainCompositionInst.instructions = @[mainInstruciton];
    mainCompositionInst.frameDuration = CMTimeMake(1, 30);
    mainCompositionInst.renderSize = CGSizeMake(renderW, renderW/VIDEO_SCALE);
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetMediumQuality];
    exporter.videoComposition = mainCompositionInst;
    exporter.outputURL = mergeFileURL;
    exporter.outputFileType = AVFileTypeMPEG4;
    exporter.shouldOptimizeForNetworkUse = YES;
    
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            UIImage *thumbImage = [self getImage:mergeFileURL];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.delegate.originVideoUrl = mergeFileURL;
                self.delegate.thumbImage = thumbImage;
                
                [self dismissViewControllerAnimated:YES completion:nil];
                
            });
            
        });
        
    }];
}

-(void)clearMergeCacheFile
{
    NSString *outputFielPath=[NSTemporaryDirectory() stringByAppendingString:@"merge_video_file.mov"];
    
    NSFileManager *manager  = [NSFileManager defaultManager];
    NSError *error;
    [manager removeItemAtPath:outputFielPath error:&error];
}

-(UIImage *)getImage:(NSURL *)videoURL
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    
    return thumb;
    
}

#pragma mark System dealloc
-(void)dealloc{
    [self removeNotification];
}

@end
