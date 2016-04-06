//
//  PlayVideoView.m
//  ZiYueiM
//
//  Created by gejiangs on 15/7/14.
//  Copyright (c) 2015年 DC. All rights reserved.
//

#import "PlayVideoView.h"
#import <AVFoundation/AVFoundation.h>

@interface PlayVideoView ()


@property (strong, nonatomic) NSURL *videoFileURL;
@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) AVPlayerLayer *playerLayer;
@property (strong, nonatomic) AVPlayerItem *playerItem;

@end

@implementation PlayVideoView


-(id)initWithFrame:(CGRect)frame videoUrl:(NSURL *)videoUrl
{
    if (self = [super initWithFrame:frame]) {
        
        self.videoFileURL = videoUrl;
        
        [self initPlayLayer];
    }
    return self;
}


- (void)initPlayLayer
{
    if (!_videoFileURL) {
        return;
    }
    
    self.backgroundColor = [UIColor clearColor];
    
    UIButton *handlerView = [UIButton buttonWithType:UIButtonTypeCustom];
    handlerView.frame = self.bounds;
    handlerView.backgroundColor = [UIColor colorWithHue:0 saturation:0 brightness:0 alpha:0.9];
    [handlerView addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    handlerView.userInteractionEnabled = YES;
    [self addSubview:handlerView];
    
    CGFloat w = self.frame.size.width;
    CGFloat h = w/(4.f/3.f);
    CGFloat y = (self.frame.size.height - h)/2.f;
    
    self.playerItem = [AVPlayerItem playerItemWithURL:self.videoFileURL];
    self.player = [AVPlayer playerWithPlayerItem:_playerItem];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    _playerLayer.frame = CGRectMake(0, y, w, h);
    _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [handlerView.layer addSublayer:_playerLayer];
    
    [self play];
    [self addNotification];
}

-(void)play
{
    [_playerItem seekToTime:kCMTimeZero];
    [_player play];
    
}

-(void)addNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(avPlayerItemDidPlayToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

#pragma mark - PlayEndNotification
- (void)avPlayerItemDidPlayToEnd:(NSNotification *)notification
{
    if ((AVPlayerItem *)notification.object != _playerItem) {
        return;
    }
    [self play];
}

-(void)closeAction:(UIButton *)sender
{
    [_player pause];
    [self removeFromSuperview];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

@end
