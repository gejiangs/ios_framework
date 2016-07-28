//
//  GFInfoListFrameModel.h
//  Golf
//
//  Created by ztx on 16/7/25.
//  Copyright © 2016年 MiFan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GFInfoListModel.h"
@interface GFInfoListFrameModel : NSObject
@property (nonatomic, strong) GFInfoListModel *infoListModel;
@property (nonatomic, assign) CGFloat cellHeight;
@end
