//
//  PictureCollectionCell.m
//  Framework
//
//  Created by jiang on 15/6/2.
//  Copyright (c) 2015年 jiang. All rights reserved.
//

#import "PictureCollectionCell.h"

@interface PictureCollectionCell ()


@end

@implementation PictureCollectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initUI];
    }
    return self;
}

-(void)initUI
{
    self.backgroundColor = [UIColor clearColor];
    
    self.layer.masksToBounds = YES;
    
    self.imageView = [[UIImageView alloc] init];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_imageView];
    [_imageView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.offset(0);
    }];
    
    
}

- (void)awakeFromNib {
    // Initialization code
}

@end
