//
//  RecordVideoViewController.h
//  ZiYueiM
//
//  Created by gejiangs on 15/7/2.
//  Copyright (c) 2015年 DC. All rights reserved.
//

#import "BaseViewController.h"

@class VideoViewController;

@interface RecordVideoViewController : BaseViewController

@property (nonatomic, assign)   VideoViewController *delegate;
@property (nonatomic, copy)     NSString *videoSaveName;

@end
