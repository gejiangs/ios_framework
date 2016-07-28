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
@property (nonatomic, strong) UIImageView *backgroundView;
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
    
    self.backgroundView = [UIImageView new];
    self.backgroundView.contentMode = UIViewContentModeScaleAspectFill;
    self.backgroundView.clipsToBounds = YES;
    [self addSubview:self.backgroundView];
    self.backgroundView.backgroundColor = [UIColor redColor];
    
    
    self.contentBackView = [UIView new];
    self.contentBackView.backgroundColor = [UIColor blackColor];
    self.contentBackView.alpha = 0.6;
    [self.backgroundView addSubview:self.contentBackView];
    
    UIFont *contentFont = [UIFont systemFontOfSize:14.0f];
    self.contentLabel = [self.backgroundView addLabelWithText:@"" font:contentFont];
    self.contentLabel.textColor = [UIColor whiteColor];
    self.contentLabel.backgroundColor = [UIColor clearColor];
    self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.contentLabel.numberOfLines = 2;
    
    self.line = [self addLabelWithText:@""];
    self.line.backgroundColor = [UIColor lightGrayColor];
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat padding = 10;

    self.backgroundView.frame = CGRectMake(padding, padding, CGRectGetMaxX(self.frame) - 2 *padding, 100);

    
    self.contentBackView.frame = CGRectMake(0, 60,CGRectGetWidth(self.backgroundView.frame),  40);
    
    self.contentLabel.frame = CGRectMake(5, 60,CGRectGetWidth(self.backgroundView.frame) - padding,  40);
    
    self.line.frame = CGRectMake(0, CGRectGetMaxY(self.frame) - .5, CGRectGetMaxX(self.frame), 0.5);
}

- (void)setInfoModel:(GFInfoModel *)infoModel
{
    _infoModel = infoModel;

    [self.backgroundView sd_setImageWithURL:[NSURL URLWithString:infoModel.imageURL] placeholderImage:[UIImage imageNamed:@"1"]];
    
    self.contentLabel.text = infoModel.content;
}

@end
