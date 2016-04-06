/*
 Copyright (c) 2013 Katsuma Tanaka
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "QBImagePickerController.h"

// Views
#import "QBImagePickerGroupCell.h"

// Controllers
#import "QBAssetCollectionViewController.h"


@interface QBImagePickerController ()

@property (nonatomic, retain) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, retain) NSMutableArray *assetsGroups;

@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic, assign) UIBarStyle previousBarStyle;
@property (nonatomic, assign) BOOL previousBarTranslucent;
@property (nonatomic, assign) UIStatusBarStyle previousStatusBarStyle;

- (NSDictionary *)mediaInfoFromAsset:(ALAsset *)asset;

@end

@implementation QBImagePickerController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self) {
        /* Check sources */
        [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
        [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary];
        [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
        
        /* Initialization */
        self.title = @"Photos";
        self.filterType = QBImagePickerFilterTypeAllPhotos;
        
        self.defaultShowSavedPhotos = YES;
        self.allowsMultipleSelection = NO;
        self.minimumNumberOfSelection = 0;
        self.maximumNumberOfSelection = 0;
        
        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
        self.assetsLibrary = assetsLibrary;
        
        self.assetsGroups = [NSMutableArray array];
        
        // Table View
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self.view addSubview:tableView];
        self.tableView = tableView;
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setRightBarButtonItem];
    
    //默认显示相机胶卷
    if (self.defaultShowSavedPhotos) {
        [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            if (group) {
                switch(self.filterType) {
                    case QBImagePickerFilterTypeAllAssets:
                        [group setAssetsFilter:[ALAssetsFilter allAssets]];
                        break;
                    case QBImagePickerFilterTypeAllPhotos:
                        [group setAssetsFilter:[ALAssetsFilter allPhotos]];
                        break;
                    case QBImagePickerFilterTypeAllVideos:
                        [group setAssetsFilter:[ALAssetsFilter allVideos]];
                        break;
                }
                [self pushQBAssetCollectionViewController:group animated:NO];
                
            }
        } failureBlock:nil];
    }
    
    void (^assetsGroupsEnumerationBlock)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *assetsGroup, BOOL *stop) {
        if(assetsGroup) {
            switch(self.filterType) {
                case QBImagePickerFilterTypeAllAssets:
                    [assetsGroup setAssetsFilter:[ALAssetsFilter allAssets]];
                    break;
                case QBImagePickerFilterTypeAllPhotos:
                    [assetsGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
                    break;
                case QBImagePickerFilterTypeAllVideos:
                    [assetsGroup setAssetsFilter:[ALAssetsFilter allVideos]];
                    break;
            }
            
            if(assetsGroup.numberOfAssets > 0) {
                [self.assetsGroups addObject:assetsGroup];
                [self.tableView reloadData];
            }
        }
    };
    
    void (^assetsGroupsFailureBlock)(NSError *) = ^(NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);
    };
    
    // Enumerate Camera Roll
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:assetsGroupsEnumerationBlock failureBlock:assetsGroupsFailureBlock];
    
    // Photo Stream
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupPhotoStream usingBlock:assetsGroupsEnumerationBlock failureBlock:assetsGroupsFailureBlock];
    
    // Album
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:assetsGroupsEnumerationBlock failureBlock:assetsGroupsFailureBlock];
    
    // Event
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupEvent usingBlock:assetsGroupsEnumerationBlock failureBlock:assetsGroupsFailureBlock];
    
    // Faces
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupFaces usingBlock:assetsGroupsEnumerationBlock failureBlock:assetsGroupsFailureBlock];
    
}

- (void)setRightBarButtonItem
{
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                  target:self
                                                                                  action:@selector(cancel:)];
    
    [self.navigationItem setRightBarButtonItem:cancelButton animated:NO];
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Flash scroll indicators
    [self.tableView flashScrollIndicators];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - Instance Methods

-(void)cancel:(id)sender
{
    if([self.delegate respondsToSelector:@selector(imagePickerControllerDidCancel:)]) {
        [self.delegate imagePickerControllerDidCancel:self];
    }
}
- (NSDictionary *)mediaInfoFromAsset:(ALAsset *)asset
{
    NSMutableDictionary *mediaInfo = [NSMutableDictionary dictionary];
    
    [mediaInfo setObject:[UIImage imageWithCGImage:[asset aspectRatioThumbnail]] forKey:@"UIImagePickerControllerThumbImage"];
    [mediaInfo setObject:[UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]] forKey:@"UIImagePickerControllerOriginalImage"];
    
    return mediaInfo;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.assetsGroups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    QBImagePickerGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[QBImagePickerGroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    ALAssetsGroup *assetsGroup = [self.assetsGroups objectAtIndex:indexPath.row];
    
    cell.imageView.image = [UIImage imageWithCGImage:assetsGroup.posterImage];
    cell.titleLabel.text = [NSString stringWithFormat:@"%@", [assetsGroup valueForProperty:ALAssetsGroupPropertyName]];
    cell.countLabel.text = [NSString stringWithFormat:@"(%ld)", (long)assetsGroup.numberOfAssets];
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ALAssetsGroup *assetsGroup = [self.assetsGroups objectAtIndex:indexPath.row];
    
    BOOL showsFooterDescription = NO;
    
    switch(self.filterType) {
        case QBImagePickerFilterTypeAllAssets:
            showsFooterDescription = ([self.delegate respondsToSelector:@selector(imagePickerController:descriptionForNumberOfPhotos:numberOfVideos:)]);
            break;
        case QBImagePickerFilterTypeAllPhotos:
            showsFooterDescription = ([self.delegate respondsToSelector:@selector(imagePickerController:descriptionForNumberOfPhotos:)]);
            break;
        case QBImagePickerFilterTypeAllVideos:
            showsFooterDescription = ([self.delegate respondsToSelector:@selector(imagePickerController:descriptionForNumberOfVideos:)]);
            break;
    }
    
    [self pushQBAssetCollectionViewController:assetsGroup animated:YES];
}

-(void)pushQBAssetCollectionViewController:(ALAssetsGroup *)assetsGroup animated:(BOOL)animated
{
    // Show assets collection view
    QBAssetCollectionViewController *assetCollectionViewController = [[QBAssetCollectionViewController alloc] init];
    assetCollectionViewController.title = [assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    assetCollectionViewController.delegate = self;
    assetCollectionViewController.assetsGroup = assetsGroup;
    assetCollectionViewController.filterType = self.filterType;
    
    assetCollectionViewController.allowsMultipleSelection = self.allowsMultipleSelection;
    assetCollectionViewController.minimumNumberOfSelection = self.minimumNumberOfSelection;
    assetCollectionViewController.maximumNumberOfSelection = self.maximumNumberOfSelection;
    
    if (!animated) {
        UIViewController *root = [[self.navigationController viewControllers] objectAtIndex:0];
        [self.navigationController setViewControllers:@[root, assetCollectionViewController] animated:NO];
    }else{
        [self.navigationController pushViewController:assetCollectionViewController animated:YES];
    }
}


#pragma mark - QBAssetCollectionViewControllerDelegate

- (void)assetCollectionViewController:(QBAssetCollectionViewController *)assetCollectionViewController didFinishPickingAsset:(ALAsset *)asset
{
    if([self.delegate respondsToSelector:@selector(imagePickerControllerWillFinishPickingMedia:)]) {
        [self.delegate imagePickerControllerWillFinishPickingMedia:self];
    }
    
    if([self.delegate respondsToSelector:@selector(imagePickerController:didFinishPickingMediaWithInfo:)]) {
        [self.delegate imagePickerController:self didFinishPickingMediaWithInfo:[self mediaInfoFromAsset:asset]];
    }
}

- (void)assetCollectionViewController:(QBAssetCollectionViewController *)assetCollectionViewController didFinishPickingAssets:(NSArray *)assets
{
    if([self.delegate respondsToSelector:@selector(imagePickerControllerWillFinishPickingMedia:)]) {
        [self.delegate imagePickerControllerWillFinishPickingMedia:self];
    }
    
    if([self.delegate respondsToSelector:@selector(imagePickerController:didFinishPickingMediaWithInfo:)]) {
        NSMutableArray *info = [NSMutableArray array];
        
        for(ALAsset *asset in assets) {
            [info addObject:[self mediaInfoFromAsset:asset]];
        }
        
        [self.delegate imagePickerController:self didFinishPickingMediaWithInfo:info];
    }
}

- (void)assetCollectionViewControllerDidCancel:(QBAssetCollectionViewController *)assetCollectionViewController
{
    if([self.delegate respondsToSelector:@selector(imagePickerControllerDidCancel:)]) {
        [self.delegate imagePickerControllerDidCancel:self];
    }
}

- (NSString *)descriptionForSelectingAllAssets:(QBAssetCollectionViewController *)assetCollectionViewController
{
    NSString *description = nil;
    
    if([self.delegate respondsToSelector:@selector(descriptionForSelectingAllAssets:)]) {
        description = [self.delegate descriptionForSelectingAllAssets:self];
    }
    
    return description;
}

- (NSString *)descriptionForDeselectingAllAssets:(QBAssetCollectionViewController *)assetCollectionViewController
{
    NSString *description = nil;
    
    if([self.delegate respondsToSelector:@selector(descriptionForDeselectingAllAssets:)]) {
        description = [self.delegate descriptionForDeselectingAllAssets:self];
    }
    
    return description;
}

- (NSString *)assetCollectionViewController:(QBAssetCollectionViewController *)assetCollectionViewController descriptionForNumberOfPhotos:(NSUInteger)numberOfPhotos
{
    NSString *description = nil;
    
    if([self.delegate respondsToSelector:@selector(imagePickerController:descriptionForNumberOfPhotos:)]) {
        description = [self.delegate imagePickerController:self descriptionForNumberOfPhotos:numberOfPhotos];
    }
    
    return description;
}

- (NSString *)assetCollectionViewController:(QBAssetCollectionViewController *)assetCollectionViewController descriptionForNumberOfVideos:(NSUInteger)numberOfVideos
{
    NSString *description = nil;
    
    if([self.delegate respondsToSelector:@selector(imagePickerController:descriptionForNumberOfVideos:)]) {
        description = [self.delegate imagePickerController:self descriptionForNumberOfVideos:numberOfVideos];
    }
    
    return description;
}

- (NSString *)assetCollectionViewController:(QBAssetCollectionViewController *)assetCollectionViewController descriptionForNumberOfPhotos:(NSUInteger)numberOfPhotos numberOfVideos:(NSUInteger)numberOfVideos
{
    NSString *description = nil;
    
    if([self.delegate respondsToSelector:@selector(imagePickerController:descriptionForNumberOfPhotos:numberOfVideos:)]) {
        description = [self.delegate imagePickerController:self descriptionForNumberOfPhotos:numberOfPhotos numberOfVideos:numberOfVideos];
    }
    
    return description;
}

@end
