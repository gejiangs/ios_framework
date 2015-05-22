//
//  BannerView.m
//  TabDemo
//
//  Created by gejiangs on 14/12/8.
//  Copyright (c) 2014年 gejiangs. All rights reserved.
//

#import "BannerView.h"
#import "UIImageView+WebCache.h"

#define IMG_URL_KEY @"advImgUrl"
#define BANNER_WIDTH_SCALE 2.4f //(banner最适合宽高比例)

@interface BannerScroll()

@end

@implementation BannerScroll

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.dragging) {
        [[self nextResponder] touchesBegan:touches withEvent:event];
    }
    [super touchesBegan:touches withEvent:event];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!self.dragging) {
        [[self nextResponder] touchesEnded:touches withEvent:event];
    }
    [super touchesEnded:touches withEvent:event];
}

@end

@interface BannerView ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *imageNameArray;
@property (nonatomic, strong) BannerScroll *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic)         PageAlign pageControlAlign;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation BannerView

-(id)initWithImageNames:(NSArray *)imageNames
{
    if (self = [super init]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.imageNameArray = [NSMutableArray arrayWithArray:imageNames];
        self.pageControlAlign = PageAlignCenter;
        
        [self initUI];
    }
    
    return self;
}

-(id)initWithImageNames:(NSArray *)imageNames pageAlign:(PageAlign)pageAlign
{
    if (self = [super init]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.imageNameArray = [NSMutableArray arrayWithArray:imageNames];
        self.pageControlAlign = pageAlign;
        
        [self initUI];
    }
    
    return self;
}

-(id)initWithFrame:(CGRect)frame imageNames:(NSArray *)imageNames
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.imageNameArray = [NSMutableArray arrayWithArray:imageNames];
        self.pageControlAlign = PageAlignCenter;
        
        [self initUI];
    }
    
    return self;
}

-(id)initWithFrame:(CGRect)frame imageNames:(NSArray *)imageNames pageAlign:(PageAlign)pageAlign
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.imageNameArray = [NSMutableArray arrayWithArray:imageNames];
        self.pageControlAlign = pageAlign;
        
        [self initUI];
    }
    
    return self;
}

-(void)initUI
{
    [self addSubview:self.scrollView];
    [self addImageViews];
    [self addSubview:self.pageControl];
    
    [_pageControl remakeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(30);
        make.bottom.equalTo(self).offset(0);
        if (self.pageControlAlign == PageAlignCenter) {
            make.centerX.equalTo(self);
        }else if (self.pageControlAlign == PageAlignRight){
            make.right.equalTo(self).offset(-20);
        }
    }];
    
    if ([self.imageNameArray count] > 1) {
        //默认显示第二页(第一页为最后一张，主要为了可以循环滚动)
        [self.scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width * 1, 0) animated:NO];
        //分页view显示第一页
        self.pageControl.currentPage = 0;
    }
    
    [self beginAutoChange];
}

-(UIScrollView *)scrollView
{
    if (_scrollView != nil) {
        return _scrollView;
    }
    
    self.scrollView = [[BannerScroll alloc] initWithFrame:self.bounds];
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.bounces = NO;
    _scrollView.alwaysBounceHorizontal = NO;
    _scrollView.alwaysBounceVertical = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    
    return _scrollView;
}

-(void)addImageViews
{
    UIView* contentView = UIView.new;
    [self.scrollView addSubview:contentView];
    [contentView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.height.equalTo(self.scrollView);
    }];
    
    //显示逻辑：3,1,2,3,1
    //第一屏显示最后一张
    UIImageView *lastImageView = [self addImageViewIndex:(int)[_imageNameArray count]-1 contentView:contentView lastView:nil];
    
    //其余正常顺序显示
    for (int i=0; i<[_imageNameArray count]; i++) {
        lastImageView = [self addImageViewIndex:i contentView:contentView lastView:lastImageView];
    }
    
    //最后一屏显示第一张
    lastImageView = [self addImageViewIndex:0 contentView:contentView lastView:lastImageView];
    
    [contentView makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lastImageView.right);
    }];
}

-(UIImageView *)addImageViewIndex:(int)i contentView:(UIView *)contentView lastView:(UIImageView *)lastImageView
{
    CGFloat h = SCREEN_WIDTH / BANNER_WIDTH_SCALE;
    
    NSDictionary *item = [self.imageNameArray objectAtIndex:i];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[item objectForKey:IMG_URL_KEY]] placeholderImage:nil];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [contentView addSubview:imageView];
    [imageView makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lastImageView ? lastImageView.mas_right : @0);
        make.centerY.equalTo(contentView);
        make.height.offset(h);
        make.width.equalTo(self.scrollView.width);
    }];
    
    return imageView;
}

-(UIPageControl *)pageControl
{
    if (_pageControl != nil) {
        return _pageControl;
    }
    
    self.pageControl = [[UIPageControl alloc] init];
    _pageControl.pageIndicatorTintColor = RGB(153, 153, 153);
    _pageControl.currentPageIndicatorTintColor = COLOR_LIGHTBLUE;
    _pageControl.numberOfPages = [self.imageNameArray count];
    _pageControl.hidden = [self.imageNameArray count] <= 1;
//    [_pageControl addTarget:self action:@selector(pageChange:) forControlEvents:UIControlEventValueChanged];
    return _pageControl;
}


//滚动视图滑动
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self endAutoChange];
}


//滚动视图释放滚动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int currentIndex = (int)scrollView.contentOffset.x/self.scrollView.frame.size.width;
    
    if (currentIndex==0)
    {
        currentIndex = (int)[_imageNameArray count] - 1;
        [self.scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width * [_imageNameArray count], 0) animated:NO];// 序号0 最后1页
    }
    else if (currentIndex==([_imageNameArray count]+1))
    {
        currentIndex = 0;
        [self.scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0) animated:NO]; // 最后+1,循环第1页
    }else{
        currentIndex --;
    }
    
    self.pageControl.currentPage = currentIndex;
    
    [self beginAutoChange];
}

//UIPageControl 索引改变
-(void)pageChange:(UIPageControl *)pageControl
{
//    NSInteger page = pageControl.currentPage;
//    
//    [self.scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width * page, 0) animated:YES];
//    
//    [self endAutoChange];
//    [self beginAutoChange];
}

-(void)beginAutoChange
{
    if ([self.imageNameArray count] <= 1) {
        return;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:3.f target:self selector:@selector(changeScrollPage) userInfo:nil repeats:YES];
}

-(void)changeScrollPage
{
    int currentIndex = (int)_scrollView.contentOffset.x/_scrollView.frame.size.width;
    
    if (currentIndex < [_imageNameArray count] + 1) {
        currentIndex ++;
    }
    
    [UIView animateWithDuration:0.3f animations:^{
        [self.scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width * currentIndex, 0)];
    } completion:^(BOOL finished) {
        if (currentIndex == [_imageNameArray count] + 1) {
            [self.scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
        }
    }];
    
    if (currentIndex==0)
    {
        currentIndex = (int)[_imageNameArray count] - 1;
    }
    else if (currentIndex==([_imageNameArray count]+1))
    {
        currentIndex = 0;
    }else{
        currentIndex --;
    }
    
    self.pageControl.currentPage = currentIndex;
}

-(void)endAutoChange
{
    if (self.timer != nil) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

//点击
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    int currentIndex = (int)self.scrollView.contentOffset.x/self.scrollView.frame.size.width;
    
    if (currentIndex==0)
    {
        currentIndex = (int)[_imageNameArray count] - 1;
    }
    else if (currentIndex==([_imageNameArray count]+1))
    {
        currentIndex = 0;
    }else{
        currentIndex --;
    }
    
    if (self.selectWithIndex) {
        self.selectWithIndex(currentIndex);
    }
}


-(void)buttonClicked:(UIButton *)sender
{
    if (self.selectWithIndex) {
        self.selectWithIndex((int)sender.tag);
    }
}

+(CGFloat)getHeightWithWidth:(CGFloat)width
{
    return width/BANNER_WIDTH_SCALE;
}

@end
