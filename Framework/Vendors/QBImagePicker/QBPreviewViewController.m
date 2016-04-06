//
//  QBPreviewViewController.m
//  Community
//
//  Created by gejiangs on 16/1/25.
//  Copyright © 2016年 gejiangs. All rights reserved.
//

#import "QBPreviewViewController.h"
#import "QBPreviewView.h"

@interface QBPreviewViewController ()

@property (strong, nonatomic) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;

@end

@implementation QBPreviewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.images = [[NSMutableArray alloc] init];
        self.imageViews = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initUI];
    [self reLayout];
}

-(void)initUI
{
    self.scrollView = [self addScrollViewWithDelegate:self];
    _scrollView.alwaysBounceVertical = NO;
    [_scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.offset(0);
    }];
    
    self.contentView = UIView.new;
    [self.scrollView addSubview:_contentView];
    [_contentView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.height.equalTo(self.scrollView);
    }];
}

-(UIScrollView *)addScrollViewWithDelegate:(id)delegate
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.pagingEnabled = YES;
    scrollView.delegate = delegate;
    scrollView.bounces = YES;
    scrollView.alwaysBounceHorizontal = YES;
    scrollView.alwaysBounceVertical = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    
    return scrollView;
}


- (void) reLayout
{
    for(UIView* view in self.imageViews)
    {
        [view removeFromSuperview];
    }
    
    [self.imageViews removeAllObjects];
    
    if(self.images.count == 0)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width*[self.images count], self.scrollView.frame.size.height);
        UIView *lastImageView = nil;
        for(UIImage* image in self.images)
        {
            QBPreviewView *imgView = [[QBPreviewView alloc] initWithFrame:self.view.bounds
                                                             andImage:image];
            [self.contentView addSubview:imgView];
            [imgView remakeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(lastImageView ? lastImageView.mas_right : @0);
                make.top.equalTo(self.contentView).offset(0);
                make.height.equalTo(self.scrollView.height);
                make.width.equalTo(self.scrollView.width);
            }];
            lastImageView = imgView;
            
            [self.imageViews addObject:imgView];
        }
        
        [self.contentView makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(lastImageView.right);
        }];
        
        if(self.showDelButton)
        {
            [self addRightBarButton];
        }
        
        if(_page >= self.images.count)
        {
            _page = self.images.count - 1;
        }
        
        [self setPage:_page];
    }
}

-(void)addRightBarButton
{
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"删除"
                                                               style:UIBarButtonItemStylePlain
                                                              target:self
                                                              action:@selector(rightMenuPressed:)];
    self.navigationItem.rightBarButtonItem = button;
}

- (void)viewDidUnload {
    [self setScrollView:nil];
    [super viewDidUnload];
}

- (NSInteger) page
{
    return _page;
}

- (void) setPage:(NSInteger)page
{
    _page = page;
    
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = page * self.scrollView.frame.size.width;
    self.scrollView.contentOffset = offset;
    
    [self setTitle:[NSString stringWithFormat:@"%ld/%ld", (long)(_page+1), (long)self.images.count]];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint contentOffset = scrollView.contentOffset;
    _page = ((NSInteger)contentOffset.x) / ((NSInteger)self.scrollView.frame.size.width);
    [self setTitle:[NSString stringWithFormat:@"%ld/%ld",(long)(_page+1), (long)self.images.count]];
}

/**
 *  删除图片啊
 *
 *  @param sender
 */
- (void)rightMenuPressed:(id)sender
{
    NSInteger index = _page;
    [self.images removeObjectAtIndex:index];
    [self reLayout];
    
    if(_delegate)
    {
        [_delegate onImageDeletedAtIndex:index];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
