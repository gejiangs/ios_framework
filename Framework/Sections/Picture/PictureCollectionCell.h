//
//  PictureCollectionCell.h
//  Framework
//
//  Created by jiang on 15/6/2.
//  Copyright (c) 2015年 jiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PictureCollectionCell : UICollectionViewCell

@property (nonatomic, strong)  UIImageView *imageView;
@property(nonatomic, copy) void(^countChange)();


@end
