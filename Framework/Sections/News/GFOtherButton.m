//
//  GFOtherButton.m
//  Golf
//
//  Created by ztx on 16/7/25.
//  Copyright © 2016年 MiFan. All rights reserved.
//

#import "GFOtherButton.h"
#import "GFInfoModel.h"
#import "UIImageView+WebCache.h"

@interface GFOtherButton ()
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *line;

@end

@implementation GFOtherButton

/// 高度 50

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
    
    self.rightImageView = [UIImageView new];
    self.rightImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.rightImageView.clipsToBounds = YES;
    [self addSubview:self.rightImageView];
    self.rightImageView.backgroundColor = [UIColor redColor];
    
    UIFont *contentFont = [UIFont systemFontOfSize:14.0f];
    
    self.contentLabel = [self addLabelWithText:@"" font:contentFont];
    self.contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.contentLabel.numberOfLines = 2;
    self.contentLabel.textColor = [UIColor blackColor];
    
    self.line = [self addLabelWithText:@""];
    self.line.backgroundColor = [UIColor lightGrayColor];

    
    
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat VerticalPadding = 5;

    CGFloat HorizontalPadding = 10;

    self.rightImageView.frame = CGRectMake(CGRectGetMaxX(self.frame) - HorizontalPadding - 40, VerticalPadding, 40,40);
    
    
    self.contentLabel.frame = CGRectMake(HorizontalPadding, VerticalPadding,CGRectGetMaxX(self.frame) - 2 *HorizontalPadding - VerticalPadding - 40,  40);
    
    
    NSLog(@"CGRectGetMaxY(self.frame) :%f",CGRectGetMaxY(self.frame));
    self.line.frame = CGRectMake(0, CGRectGetHeight(self.frame) - 0.5, CGRectGetMaxX(self.frame), 0.5);
}



- (void)setInfoModel:(GFInfoModel *)infoModel
{
    _infoModel = infoModel;
    
    [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:infoModel.imageURL] placeholderImage:[UIImage imageNamed:@"1"]];
    
    self.contentLabel.text = infoModel.content;
}


@end
