//
//  GFInfoTableViewCell.h
//  Golf
//
//  Created by ztx on 16/7/25.
//  Copyright © 2016年 MiFan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GFInfoListFrameModel.h"
#import "GFInfoModel.h"
@interface GFInfoTableViewCell : UITableViewCell
@property (nonatomic, strong) GFInfoListFrameModel *infoListFrameModel;

@property (nonatomic, copy) void (^ButtonClickBlock)(GFInfoModel *model);
@end
