/*
 Copyright (c) 2013 Katsuma Tanaka
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "QBImagePickerAssetCell.h"
#import "QBImagePickerVideoInfoView.h"

@interface QBImagePickerAssetCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, retain) QBImagePickerVideoInfoView *videoInfoView;
@property (nonatomic, retain) UIImageView *overlayImageView;

@end

@implementation QBImagePickerAssetCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initUI];
    }
    return self;
}

- (id)init
{
    self = [super init];
    
    if(self) {
        [self initUI];
    }
    
    return self;
}

-(void)initUI
{
    // Image View
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.contentView addSubview:imageView];
    self.imageView = imageView;
    
    // Video Info View
    QBImagePickerVideoInfoView *videoInfoView = [[QBImagePickerVideoInfoView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 17, self.bounds.size.width, 17)];
    videoInfoView.hidden = YES;
    videoInfoView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    
    [self.contentView addSubview:videoInfoView];
    self.videoInfoView = videoInfoView;
    
    // Overlay Image View
    UIImageView *overlayImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    overlayImageView.contentMode = UIViewContentModeScaleAspectFill;
    overlayImageView.clipsToBounds = YES;
    overlayImageView.image = [UIImage imageNamed:@"QBImagePickerController.bundle/overlay.png"];
    overlayImageView.hidden = YES;
    overlayImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.contentView addSubview:overlayImageView];
    self.overlayImageView = overlayImageView;
}

- (void)setAsset:(ALAsset *)asset
{
    _asset = asset;
    // Set thumbnail image
    self.imageView.image = [UIImage imageWithCGImage:[asset thumbnail]];
    
    if([self.asset valueForProperty:ALAssetPropertyType] == ALAssetTypeVideo) {
        double duration = [[asset valueForProperty:ALAssetPropertyDuration] doubleValue];
        
        self.videoInfoView.hidden = NO;
        self.videoInfoView.duration = round(duration);
    } else {
        self.videoInfoView.hidden = YES;
    }
}

-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    self.overlayImageView.hidden = !selected;
}


@end
