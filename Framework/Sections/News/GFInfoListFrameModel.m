//
//  GFInfoListFrameModel.m
//  Golf
//
//  Created by ztx on 16/7/25.
//  Copyright © 2016年 MiFan. All rights reserved.
//

#import "GFInfoListFrameModel.h"

@implementation GFInfoListFrameModel
- (void)setInfoListModel:(GFInfoListModel *)infoListModel
{
    _infoListModel = infoListModel;
    
    CGFloat height = 120 + ([infoListModel.infoList count] - 1) * 50 + 20;
    self.cellHeight = height;
}
@end
