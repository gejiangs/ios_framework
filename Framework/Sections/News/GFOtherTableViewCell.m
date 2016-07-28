//
//  GFOtherTableViewCell.m
//  Framework
//
//  Created by MiFan on 16/7/28.
//  Copyright © 2016年 guojiang. All rights reserved.
//

#import "GFOtherTableViewCell.h"

@interface GFOtherTableViewCell ()
@property (nonatomic, strong) GFOtherButton *button;
@end

@implementation GFOtherTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self addSubview:self.button];
//        self.button.frame = CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame));

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



- (GFOtherButton *)button
{
    if (_button == nil)
    {
        _button = [[GFOtherButton alloc] init];
    }
    return _button;
}

@end