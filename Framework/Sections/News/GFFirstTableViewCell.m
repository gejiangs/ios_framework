//
//  GFFirstTableViewCell.m
//  Framework
//
//  Created by MiFan on 16/7/28.
//  Copyright © 2016年 guojiang. All rights reserved.
//

#import "GFFirstTableViewCell.h"

@interface GFFirstTableViewCell ()
@property (nonatomic, strong) GFFirstButton *button;
@end

@implementation GFFirstTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self addSubview:self.button];

    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    self.button.frame = CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame));

}

- (void)setInfoModel:(GFInfoModel *)infoModel
{
    _infoModel = infoModel;
    self.button.infoModel = infoModel;
}



- (GFFirstButton *)button
{
    if (_button == nil)
    {
        _button = [[GFFirstButton alloc] init];
    }
    return _button;

}
@end

