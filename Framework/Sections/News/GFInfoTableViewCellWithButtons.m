//
//  GFInfoTableViewCell.m
//  Golf
//
//  Created by ztx on 16/7/25.
//  Copyright © 2016年 MiFan. All rights reserved.
//

#import "GFInfoTableViewCellWithButtons.h"
#import "GFFirstButton.h"
#import "GFOtherButton.h"
#import "GFInfoModel.h"

@interface GFInfoTableViewCellWithButtons ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) NSMutableArray *otherInfos;

@property (nonatomic, strong) GFFirstButton *firstButton;
@end

@implementation GFInfoTableViewCellWithButtons

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        self.bgView = [[UIView alloc] init];
        [self.contentView addSubview:self.bgView];
        self.bgView.backgroundColor = [UIColor whiteColor];
        self.bgView.layer.cornerRadius = 5.0f;
        self.bgView.layer.masksToBounds = YES;
        self.bgView.layer.borderWidth = 1.0f;
        self.bgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        
        [self.bgView addSubview:self.firstButton];
        self.firstButton.tag = 0;
        [self.firstButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;

}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}





- (void)setInfoListFrameModel:(GFInfoListFrameModel *)infoListFrameModel
{
    _infoListFrameModel = infoListFrameModel;
    
    [self removeOtherButtons];
    [self settingtData];
    [self settingFrame];


}


- (void)buttonPressed:(UIButton *)button
{
    NSInteger tag = button.tag;
    GFInfoModel *model = self.infoListFrameModel.infoListModel.infoList[tag];
    if (model && self.ButtonClickBlock)
    {
        self.ButtonClickBlock(model);
    }

}


- (void)settingFrame
{
    
    CGFloat height = 120 + ([self.infoListFrameModel.infoListModel.infoList count]-1) * 50;
    self.bgView.frame = CGRectMake(10, 0, ScreenWidth - 20, height);
    
    
    self.firstButton.frame = CGRectMake(0, 0, CGRectGetMaxX(self.bgView.frame) - 10, 120);

    
    GFOtherButton *temp = nil;
    for (int i = 0; i< [self.otherInfos count]; i++)
    {
        GFOtherButton *otherButton = self.otherInfos[i];
        if (temp == nil)
        {
            otherButton.frame = CGRectMake(0, CGRectGetMaxY(self.firstButton.frame), CGRectGetMaxX(self.firstButton.frame), 50);

        }
        else{
            otherButton.frame = CGRectMake(0, CGRectGetMaxY(temp.frame), CGRectGetMaxX(temp.frame), 50);
        }

        temp = otherButton;
    }

}


- (void)settingtData
{
    GFInfoListModel *listModel = self.infoListFrameModel.infoListModel;
    
    
    GFInfoModel *infoModel = listModel.infoList[0];

    [self.firstButton setInfoModel:infoModel];
    
    
    if ([listModel.infoList count] > 1)
    {
        for (int i = 1; i < [listModel.infoList count]; i++ )
        {
            GFInfoModel *model = listModel.infoList[i];
            
            GFOtherButton *otherButton = [[GFOtherButton alloc] init];
            [otherButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
            otherButton.tag = i;
            
            otherButton.infoModel = model;
            
            [self.bgView addSubview:otherButton];
            
            [self.otherInfos addObject:otherButton];
        }

    }

    
    
}

//防止cell重叠
-(void)removeOtherButtons
{
    
    
    
    for (int i = 0; i < [self.otherInfos count]; i++) {
        UIButton *otherButton = [self.otherInfos objectAtIndex:i];
        if (otherButton.superview) {
            [otherButton removeFromSuperview];
        }
    }
    [self.otherInfos removeAllObjects];
}


- (GFFirstButton *)firstButton
{
    if (_firstButton == nil)
    {
        _firstButton = [[GFFirstButton alloc] init];
    }
    return _firstButton;
}


-(NSMutableArray *)otherInfos
{
    if (!_otherInfos) {
        _otherInfos = [[NSMutableArray alloc]init];
    }
    return _otherInfos;
}

@end
