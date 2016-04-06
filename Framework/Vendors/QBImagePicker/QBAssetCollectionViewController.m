/*
 Copyright (c) 2013 Katsuma Tanaka
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "QBAssetCollectionViewController.h"

// Views
#import "QBImagePickerAssetCell.h"

@interface QBAssetCollectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>


@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, retain) NSMutableArray *assets;
@property (nonatomic, retain) NSMutableOrderedSet *selectedAssets;

@property (nonatomic, retain) UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UILabel *maxLabel;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@end

@implementation QBAssetCollectionViewController

- (id)init
{
    self = [super init];
    
    if(self) {
        /* Initialization */
        
        self.view.backgroundColor = [UIColor whiteColor];
        
        self.assets = [NSMutableArray array];
        self.selectedAssets = [NSMutableOrderedSet orderedSet];
        
        self.footerView.layer.borderColor = [UIColor colorWithRed:200/255.f green:199/255.f blue:204/255.f alpha:1].CGColor;
        self.footerView.layer.borderWidth = 0.5;
        
        [self.collectionView registerClass:[QBImagePickerAssetCell class] forCellWithReuseIdentifier:@"cell"];
        
        [self setRightBarButtonItem];
    }
    
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //只有最少约束
    if (self.minimumNumberOfSelection > 0 && self.maximumNumberOfSelection == 0) {
        self.maxLabel.text = [NSString stringWithFormat:@"您最少需要选择%d张照片", (int)self.minimumNumberOfSelection];
    }
    //只有最多约束
    else if (self.maximumNumberOfSelection > 0 && self.minimumNumberOfSelection == 0){
        self.maxLabel.text = [NSString stringWithFormat:@"您最多只能选择%d张照片", (int)self.maximumNumberOfSelection];
    }
    //最少和最多同时约束
    else if (self.maximumNumberOfSelection > self.minimumNumberOfSelection){
        self.maxLabel.text = [NSString stringWithFormat:@"您最少选择%d张，最多选择%d张照片",
                              (int)self.minimumNumberOfSelection,
                              (int)self.maximumNumberOfSelection];
    }else{
        self.maxLabel.hidden = YES;
    }
    
    // Reload
    [self reloadData];
    
    dispatch_time_t time_t = dispatch_time(DISPATCH_TIME_NOW,(int64_t)(0.1 * NSEC_PER_SEC));
    dispatch_after(time_t, dispatch_get_main_queue(), ^{
        
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:[self.assets count]-1 inSection:0]
                                    atScrollPosition:UICollectionViewScrollPositionBottom
                                            animated:NO];
        [self.collectionView flashScrollIndicators];
    });
    
}

- (void)setAllowsMultipleSelection:(BOOL)allowsMultipleSelection
{
    _allowsMultipleSelection = allowsMultipleSelection;
    
    self.collectionView.allowsMultipleSelection = _allowsMultipleSelection;
}


#pragma mark - Instance Methods

- (void)reloadData
{
    // Reload assets
    [self.assetsGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if(result) {
            [self.assets addObject:result];
        }
    }];
    
    [self.collectionView reloadData];
}

- (void)setRightBarButtonItem
{
    self.cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    
    [self.navigationItem setRightBarButtonItem:_cancelButton animated:NO];
}



#pragma mark - UITableViewDataSource

#pragma mark - collectionView delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.assets count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    QBImagePickerAssetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell sizeToFit];
    
    cell.asset = [self.assets objectAtIndex:indexPath.row];
    
    return cell;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets top = {0,5,5,0};
    
    return top;
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat w = (self.collectionView.frame.size.width - 35)/4;
    CGFloat h = w;
    
    return CGSizeMake(w, h);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.selectedAssets addObject:[self.assets objectAtIndex:indexPath.row]];
    
    [self setTotalValue];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.selectedAssets removeObject:[self.assets objectAtIndex:indexPath.row]];
    
    [self setTotalValue];
}

-(void)setTotalValue
{
    [self.doneButton setTitle:[NSString stringWithFormat:@"完成(%ld)", [self.selectedAssets count]] forState:UIControlStateNormal];
    
    [self updateDoneButton];
}


- (void)updateDoneButton
{
    //只有最少约束
    if (self.minimumNumberOfSelection > 0 && self.maximumNumberOfSelection == 0) {
        self.doneButton.enabled = (self.selectedAssets.count >= self.minimumNumberOfSelection);
    }
    //只有最多约束
    else if (self.maximumNumberOfSelection > 0 && self.minimumNumberOfSelection == 0){
        self.doneButton.enabled = (self.selectedAssets.count <= self.maximumNumberOfSelection);
    }
    //最少和最多同时约束
    else if (self.maximumNumberOfSelection > self.minimumNumberOfSelection){
        self.doneButton.enabled = (self.selectedAssets.count >= self.minimumNumberOfSelection && self.selectedAssets.count <= self.maximumNumberOfSelection);
    }
    //正常单选或多选
    else{
        self.doneButton.enabled = (self.selectedAssets.count > 0);
    }
}

-(void)cancel:(id)sender
{
    [self.delegate assetCollectionViewControllerDidCancel:self];
}

- (IBAction)done:(UIButton *)sender
{
    [self.delegate assetCollectionViewController:self didFinishPickingAssets:self.selectedAssets.array];
}


@end
