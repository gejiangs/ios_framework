//
//  GFFirstButton.m
//  Golf
//
//  Created by ztx on 16/7/25.
//  Copyright © 2016年 MiFan. All rights reserved.
//

#import "GFFirstButton.h"
#import "GFInfoModel.h"
#import "UIImageView+WebCache.h"

@interface GFFirstButton ()
@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UIView *contentBackView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *line;
@end

@implementation GFFirstButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

/// 高度120

- (instancetype) init
{
    self = [super init];
    if (self)
    {
        [self initUI];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initUI];
    }
    return self;
}


- (void)initUI
{
    [self setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateHighlighted];
    [self setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateSelected];
    
    _bgView = [[UIImageView alloc] init];
    _bgView.contentMode = UIViewContentModeScaleAspectFill;
    _bgView.clipsToBounds = YES;
    [self addSubview:_bgView];
    _bgView.backgroundColor = [UIColor redColor];
    
    
    _contentBackView = [UIView new];
    _contentBackView.backgroundColor = [UIColor blackColor];
    _contentBackView.alpha = 0.6;
    [self.bgView addSubview:_contentBackView];
    
    UIFont *contentFont = [UIFont systemFontOfSize:14.0f];
    _contentLabel = [self.bgView addLabelWithText:@"" font:contentFont];
    _contentLabel.textColor = [UIColor whiteColor];
    _contentLabel.backgroundColor = [UIColor clearColor];
    _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _contentLabel.numberOfLines = 2;
    
    _line = [self addLabelWithText:@""];
    _line.backgroundColor = [UIColor lightGrayColor];
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat padding = 10;

    _bgView.frame = CGRectMake(padding, padding, CGRectGetMaxX(self.frame) - 2 *padding, 100);

    
    _contentBackView.frame = CGRectMake(0, 60,CGRectGetWidth(self.bgView.frame),  40);
    
    _contentLabel.frame = CGRectMake(5, 60,CGRectGetWidth(self.bgView.frame) - padding,  40);
    
    _line.frame = CGRectMake(0, CGRectGetMaxY(self.frame) - .5, CGRectGetMaxX(self.frame), 0.5);
}

- (void)setInfoModel:(GFInfoModel *)infoModel
{
    _infoModel = infoModel;

    [_bgView sd_setImageWithURL:[NSURL URLWithString:infoModel.imageURL] placeholderImage:[UIImage imageNamed:@"1"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        NSLog(@"imageURL:%@",imageURL);

    } ];
    
    _contentLabel.text = infoModel.content;
}

@end
