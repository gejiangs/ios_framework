//
//  QBPreviewViewController.h
//  Community
//
//  Created by gejiangs on 16/1/25.
//  Copyright © 2016年 gejiangs. All rights reserved.
//

#import "BaseViewController.h"

@protocol QBPreviewViewControllerDelegate <NSObject>

- (void) onImageDeletedAtIndex:(NSInteger)index;

@end

/**
 *  图片选择的时候预览
 */
@interface QBPreviewViewController : BaseViewController
{
    NSInteger _page;
}

@property (retain, nonatomic) NSMutableArray* images;
@property (retain, nonatomic) NSMutableArray* imageViews;
@property (nonatomic) BOOL showDelButton;



@property (assign, nonatomic) id<QBPreviewViewControllerDelegate> delegate;

- (NSInteger) page;
- (void) setPage:(NSInteger)page;

@end