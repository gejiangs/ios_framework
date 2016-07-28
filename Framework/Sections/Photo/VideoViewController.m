//
//  VideoViewController.m
//  Framework
//
//  Created by gejiangs on 15/7/16.
//  Copyright (c) 2015年 guojiang. All rights reserved.
//

#import "VideoViewController.h"
#import "RecordVideoViewController.h"
#import "PlayVideoView.h"
#import "BaseNavigationViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "AppDelegate.h"

@interface VideoViewController ()

@property (strong, nonatomic) UISegmentedControl *segmentControl;

@property (weak, nonatomic) IBOutlet UIView *playPreviewView;
@property (weak, nonatomic) IBOutlet UIButton *smallPlayButton;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;

@property (nonatomic, strong)   UIImageView *videoView;

@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) AVPlayerLayer *playerLayer;
@property (strong, nonatomic) AVPlayerItem *playerItem;


@property (nonatomic, strong)   NSURL *audioVideoUrl;   //合成音乐视频地址
@property (nonatomic, strong)   NSURL *bothVideoUrl;    //两者混合视频地址（原音频+音乐音频+视频）

@property (nonatomic, assign)   BOOL isMergerSuccess;   //合并成功、合并完成

@property (nonatomic, strong)   NSURL *mergeUrl;

@property (nonatomic, strong)   NSURL *mixURL;
@property (nonatomic, strong)   NSMutableArray *audioMixParams;

@end

@implementation VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.originVideoUrl == nil) {
        return;
    }
    
    self.isMergerSuccess = NO;
    
    self.playerItem = [AVPlayerItem playerItemWithURL:self.originVideoUrl];
    self.player = [AVPlayer playerWithPlayerItem:_playerItem];
    [self.playerLayer setPlayer:self.player];
    
    self.smallPlayButton.hidden = NO;
    self.actionButton.hidden = NO;
    
    self.audioVideoUrl = nil;
    self.bothVideoUrl = nil;
}


-(void)initUI
{
    self.segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"原声", @"音频", @"混合"]];
    _segmentControl.selectedSegmentIndex = 0;
    self.navigationItem.titleView = self.segmentControl;
    
    self.playerItem = [AVPlayerItem playerItemWithURL:self.originVideoUrl];
    self.player = [AVPlayer playerWithPlayerItem:_playerItem];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    _playerLayer.frame = CGRectMake(0, 0, ScreenWidth, ScreenWidth*0.75f);
    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.playPreviewView.layer addSublayer:_playerLayer];
    
    self.smallPlayButton.backgroundColor = [UIColor grayColor];
    self.smallPlayButton.hidden = YES;
    self.actionButton.hidden = YES;
    
    [self addRightBarTitle:@"录制" target:self action:@selector(recordVideo)];
}

//区域内播放视频
- (IBAction)smallButtonClicked:(UIButton *)sender
{
    [_playerItem seekToTime:kCMTimeZero];
    [_player play];
    
    self.smallPlayButton.hidden = YES;
    
    [self addNotification];
}

-(void)addNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(avPlayerItemDidPlayToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)avPlayerItemDidPlayToEnd:(NSNotification *)notification
{
    if ((AVPlayerItem *)notification.object != _playerItem) {
        return;
    }
    self.smallPlayButton.hidden = NO;
}


//动作按钮（视频合成、视频播放）功能
- (IBAction)actionButtonClicked:(UIButton *)sender
{
    if (self.isMergerSuccess) {
        PlayVideoView *playView = [[PlayVideoView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)
                                                              videoUrl:[self currentVideoUrl]];
        [WINDOW addSubview:playView];
        return;
    }
    
    
    //需要合并的音频文件
    NSString *bundleDirectory =[[NSBundle mainBundle] bundlePath];
    NSString *path = [bundleDirectory stringByAppendingPathComponent:@"海阔天空.m4a"];
    NSURL *audioUrl =[NSURL fileURLWithPath:path];
    
    [self.view showActivityView:@"正在合成音频模式视频..."];
    //转换音频（原声音不保留）
    [self mergeAudioAndVideoWithAudioURL:audioUrl videoURL:self.originVideoUrl block:^(BOOL success, NSURL *mergeVedioUrl) {
        self.audioVideoUrl = mergeVedioUrl;
        
        [self dispatchAsyncMainQueue:^{
            [self.view showActivityView:@"正在合成混合模式视频..."];
        }];
        //混合音频 (原声音保留)
        [self mergeAudioWithAudioUrl:audioUrl videoUrl:self.originVideoUrl block:^(BOOL success, NSURL *mergeAudioUrl) {
            [self mergeAudioAndVideoWithAudioURL:mergeAudioUrl videoURL:self.originVideoUrl block:^(BOOL success, NSURL *mergeVideoUrl) {
                self.bothVideoUrl = mergeVideoUrl;
                
                self.isMergerSuccess = YES;
                
                [self dispatchAsyncMainQueue:^{
                    [self.view hiddenActivityView];
                    [self.view showActivityView:@"合成成功" hideAfterDelay:1.5];
                    [sender setTitle:@"全屏播放" forState:UIControlStateNormal];
                }];
                
            }];
        }];
    }];
    
    
}

//录制视频
- (void)recordVideo
{
    RecordVideoViewController *record = [[RecordVideoViewController alloc] init];
    record.delegate = self;
    
    BaseNavigationViewController *navi = [[BaseNavigationViewController alloc] initWithRootViewController:record];
    
    [self presentViewController:navi animated:YES completion:nil];
}

-(NSURL *)currentVideoUrl
{
    if (self.segmentControl.selectedSegmentIndex == 0) {
        return self.originVideoUrl;
    }else if (self.segmentControl.selectedSegmentIndex == 1){
        return self.audioVideoUrl;
    }
    return self.bothVideoUrl;
}




//抽取原视频的音频与需要的音乐混合
-(void)mergeAudioWithAudioUrl:(NSURL *)audioUrl videoUrl:(NSURL *)videoUrl block:(void(^)(BOOL success, NSURL *mergeAudioUrl))block
{
    AVMutableComposition *composition =[AVMutableComposition composition];
    self.audioMixParams =[[NSMutableArray alloc]initWithObjects:nil];
    
    //录制的视频
    NSURL *video_inputFileUrl = videoUrl;
    AVURLAsset *songAsset =[AVURLAsset URLAssetWithURL:video_inputFileUrl options:nil];
    CMTime startTime =CMTimeMakeWithSeconds(0,songAsset.duration.timescale);
    CMTime trackDuration =songAsset.duration;
    
    //获取视频中的音频素材
    [self setUpAndAddAudioAtPath:video_inputFileUrl toComposition:composition start:startTime dura:trackDuration offset:CMTimeMake(14*44100,44100)];

    //获取设置完的本地音乐素材
    [self setUpAndAddAudioAtPath:audioUrl toComposition:composition start:startTime dura:trackDuration offset:CMTimeMake(0,44100)];
    
    //创建一个可变的音频混合
    AVMutableAudioMix *audioMix =[AVMutableAudioMix audioMix];
    audioMix.inputParameters =[NSArray arrayWithArray:self.audioMixParams];//从数组里取出处理后的音频轨道参数
    
    //创建一个输出
    AVAssetExportSession *exporter =[[AVAssetExportSession alloc] initWithAsset:composition presetName:AVAssetExportPresetAppleM4A];
    exporter.audioMix = audioMix;
    exporter.outputFileType= AVFileTypeAppleM4A;
    NSString* fileName =[NSString stringWithFormat:@"%@.mov",@"overMix"];
    //输出路径
    NSString *exportFile =[NSString stringWithFormat:@"%@/%@",[self getLibarayPath], fileName];
    
    if([[NSFileManager defaultManager]fileExistsAtPath:exportFile]) {
        [[NSFileManager defaultManager]removeItemAtPath:exportFile error:nil];
    }
    NSLog(@"是否在主线程1%d",[NSThread isMainThread]);
    NSLog(@"输出路径===%@",exportFile);
    
    NSURL *exportURL =[NSURL fileURLWithPath:exportFile];
    exporter.outputURL = exportURL;
    
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        
        BOOL success = exporter.status == AVAssetExportSessionStatusCompleted;
        block(success, exportURL);
        
    }];
    
}

//最终音频和视频混合
-(void)mergeAudioAndVideoWithAudioURL:(NSURL *)audioURL videoURL:(NSURL *)videoURL block:(void(^)(BOOL success, NSURL *mergeVideoUrl))block
{

    NSString *fileName = @"audio_video.mp4";
    if (self.audioVideoUrl != nil) {
        fileName = @"final_video.mp4";
    }
    
    NSString *documentsDirectory =[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    //最终合成输出路径
    NSString *outputFilePath =[documentsDirectory stringByAppendingPathComponent:fileName];
    NSURL   *outputFileUrl = [NSURL fileURLWithPath:outputFilePath];
    
    if([[NSFileManager defaultManager]fileExistsAtPath:outputFilePath])
        [[NSFileManager defaultManager]removeItemAtPath:outputFilePath error:nil];
    
    CMTime nextClipStartTime =kCMTimeZero;
    
    //创建可变的音频视频组合
    AVMutableComposition* mixComposition =[AVMutableComposition composition];
    
    //视频采集
    AVURLAsset* videoAsset =[[AVURLAsset alloc]initWithURL:videoURL options:nil];
    CMTimeRange videoRange =CMTimeRangeMake(kCMTimeZero,videoAsset.duration);
    AVMutableCompositionTrack *videoTrack =  [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    [videoTrack insertTimeRange:videoRange ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo]objectAtIndex:0] atTime:nextClipStartTime error:nil];
    
    //声音采集
    AVURLAsset* audioAsset =[[AVURLAsset alloc]initWithURL:audioURL options:nil];
    CMTimeRange audioRange =CMTimeRangeMake(kCMTimeZero,videoAsset.duration);//声音长度截取范围==视频长度
    AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    [audioTrack insertTimeRange:audioRange ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio]objectAtIndex:0] atTime:nextClipStartTime error:nil];
    
    //创建一个输出
    AVAssetExportSession* _assetExport =[[AVAssetExportSession alloc]initWithAsset:mixComposition presetName:AVAssetExportPresetMediumQuality];
    _assetExport.outputFileType =AVFileTypeQuickTimeMovie;
    _assetExport.outputURL =outputFileUrl;
    _assetExport.shouldOptimizeForNetworkUse=YES;
    
    [_assetExport exportAsynchronouslyWithCompletionHandler:^(void ) {
         
         BOOL success = _assetExport.status == AVAssetExportSessionStatusCompleted;
         block(success, outputFileUrl);
    }];
}

//通过文件路径建立和添加音频素材
- (void)setUpAndAddAudioAtPath:(NSURL*)assetURL toComposition:(AVMutableComposition*)composition start:(CMTime)start dura:(CMTime)dura offset:(CMTime)offset{
    
    AVURLAsset *songAsset =[AVURLAsset URLAssetWithURL:assetURL options:nil];
    
    AVMutableCompositionTrack *track =[composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    AVAssetTrack *sourceAudioTrack =[[songAsset tracksWithMediaType:AVMediaTypeAudio]objectAtIndex:0];
    
    NSError *error =nil;
    BOOL ok =NO;
    
    CMTime startTime = start;
    CMTime trackDuration = dura;
    CMTimeRange tRange =CMTimeRangeMake(startTime,trackDuration);
    
    //设置音量
    //AVMutableAudioMixInputParameters（输入参数可变的音频混合）
    //audioMixInputParametersWithTrack（音频混音输入参数与轨道）
    AVMutableAudioMixInputParameters *trackMix =[AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:track];
    [trackMix setVolume:0.8f atTime:startTime];
    
    //素材加入数组
    [self.audioMixParams addObject:trackMix];
    
    //Insert audio into track  //offsetCMTimeMake(0, 44100)
    ok = [track insertTimeRange:tRange ofTrack:sourceAudioTrack atTime:kCMTimeInvalid error:&error];
}

#pragma mark - 保存路径
-(NSString*)getLibarayPath
{
    NSFileManager *fileManager =[NSFileManager defaultManager];
    
    NSArray* paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString* path = [paths objectAtIndex:0];
    
    NSString *movDirectory = [path stringByAppendingPathComponent:@"tmpMovMix"];
    
    [fileManager createDirectoryAtPath:movDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    
    return movDirectory;  
    
}




-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
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
