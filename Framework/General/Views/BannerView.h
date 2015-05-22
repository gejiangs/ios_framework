//
//  BannerView.h
//  TabDemo
//
//  Created by gejiangs on 14/12/8.
//  Copyright (c) 2014年 gejiangs. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    PageAlignCenter,
    PageAlignRight
}PageAlign;

typedef void(^SelectWithIndex)(int index);

@interface BannerScroll : UIScrollView

@end

@interface BannerView : UIView

-(id)initWithImageNames:(NSArray *)imageNames;
-(id)initWithImageNames:(NSArray *)imageNames pageAlign:(PageAlign)pageAlign;;

-(id)initWithFrame:(CGRect)frame imageNames:(NSArray *)imageNames;
-(id)initWithFrame:(CGRect)frame imageNames:(NSArray *)imageNames pageAlign:(PageAlign)pageAlign;

@property (nonatomic, copy) SelectWithIndex selectWithIndex;

+(CGFloat)getHeightWithWidth:(CGFloat)width;

@end
