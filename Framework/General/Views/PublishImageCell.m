//
//  PublishImageCell.m
//  ZiYueiM
//
//  Created by gejiangs on 15/7/1.
//  Copyright (c) 2015年 DC. All rights reserved.
//

#import "PublishImageCell.h"
#import "QBImagePickerController.h"
#import "BaseNavigationViewController.h"
#import "QBPreviewViewController.h"

#define  MAX_UPLOAD_PHOTO_NUM 4

@interface PublishImageCell ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, QBImagePickerControllerDelegate, QBPreviewViewControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIViewController *rootViewController;

@end

@implementation PublishImageCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)initUI
{
    self.images = [NSMutableArray array];
    self.thumbImage = [NSMutableArray array];
    
    self.maxImageNumber = MAX_UPLOAD_PHOTO_NUM;
    
    [self.contentView addSubview:self.collectionView];
    [_collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.offset(0);
        make.left.offset(15);
        make.right.offset(-15);
    }];
}

-(UIViewController *)rootViewController
{
    if (_rootViewController) {
        return _rootViewController;
    }
    
    for (UIView* next = [self superview]; next; next = next.superview) {
        
        UIResponder* nextResponder = [next nextResponder];
        
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            self.rootViewController = (UIViewController *)nextResponder;
            break;
        }
    }
    
    return _rootViewController;
}

#pragma mark - CollectionView
-(UICollectionView *)collectionView
{
    if (_collectionView) {
        return _collectionView;
    }
    
    //初始化
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    //注册
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.scrollEnabled = NO;
    
    return _collectionView;
}

#pragma mark - collectionView delegate
//设置分区
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

//每个分区上的元素个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([self.thumbImage count] == self.maxImageNumber) {
        return [self.thumbImage count];
    }
    return [self.thumbImage count]+1;
}

//设置元素内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    [cell sizeToFit];
    if (!cell) {
        
    }
    
    if ([self.thumbImage count] != self.maxImageNumber && indexPath.row == ([self.thumbImage count])) {
        UIImage *image = [UIImage imageNamed:@"complaints_icon_image"];
        cell.backgroundView = [[UIImageView alloc] initWithImage:image];
    }
    else{
        cell.backgroundView = [[UIImageView alloc] initWithImage:[self.thumbImage objectAtIndex:indexPath.row]];
    }
    
    
    return cell;
}

//设置元素大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //根据屏幕大小，自适应宽高
    CGFloat w = 60;//(self.collectionView.frame.size.width - 50)/4;
    CGFloat h = w;
    
    return CGSizeMake(w, h);
}

//点击元素触发事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectedBlock) {
        self.selectedBlock();
    }
    [self imageViewSelectedWithIndex:indexPath.row];
}

#pragma mark Cell Info

+(CGFloat)getCellHeightWithImages:(NSArray *)images
{
    CGFloat h = 0.f;
    NSInteger row = [images count]/4 + 1;
    
    CGFloat item_h = ([UIScreen mainScreen].bounds.size.width - 50)/4;
    
    h += (row * item_h);
    
    h += (row-1)*10;
    
    return h;
}

-(void)imageViewSelectedWithIndex:(NSInteger)imageIndex;
{
    //添加照片
    if ([self.images count] != self.maxImageNumber && imageIndex == ([self.images count])) {
        
        UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil
                                                            delegate:nil
                                                   cancelButtonTitle:@"取消"
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:@"拍照", @"从手机相册选择", nil];
        [action showInView:self.rootViewController.view completeBlock:^(NSInteger btnIndex) {
            [self actionSheetAtIndex:btnIndex];
        }];
        
        return;
    }
    
    //照片预览
    QBPreviewViewController* viewController = [[QBPreviewViewController alloc] init];
    [viewController.images addObjectsFromArray:self.images];
    [viewController setPage:imageIndex];
    viewController.showDelButton = YES;
    viewController.delegate = self;
    [self.rootViewController.navigationController pushViewController:viewController animated:YES];
}

#pragma mark UIActionSheet Delegate

-(void)actionSheetAtIndex:(NSInteger)buttonIndex{
    //拍照
    if (buttonIndex == 0) {
        if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            //[self.view showToastText:@"不支持相机" bottomOffset:60];
            return;
        }
        
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
        picker.delegate = self;
        picker.sourceType = sourceType;
        picker.allowsEditing = NO;
        [self.rootViewController.navigationController presentViewController:picker animated:YES completion:^{
            
        }];//进入照相界面
    }
    //手机相册
    else if (buttonIndex == 1){
        
        QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsMultipleSelection = YES;
        imagePickerController.maximumNumberOfSelection = self.maxImageNumber - [self.images count];
        
        BaseNavigationViewController *navigationController = [[BaseNavigationViewController alloc] initWithRootViewController:imagePickerController];
        
        [self.rootViewController presentViewController:navigationController animated:YES completion:NULL];
    }
}

#pragma mark - QBImagePickerControllerDelegate -


- (void)imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingMediaWithInfo:(id)info{
    
    if ([[imagePickerController class] isSubclassOfClass:[UIImagePickerController class]]) {
        
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        //照片保存至相册，成功后更新照片assetURL
        ALAssetsLibraryWriteImageCompletionBlock completeBlock = ^(NSURL *assetURL, NSError *error){
            if (!error) {
                //获取缩略图
                ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
                [library assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                    
                    [self.images addObject:image];
                    [self.thumbImage addObject:[UIImage imageWithCGImage:[asset thumbnail]]];
                    [self.collectionView reloadData];
                    
                } failureBlock:nil];
            }
        };
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library writeImageToSavedPhotosAlbum:[image CGImage]
                                  orientation:(ALAssetOrientation)[image imageOrientation]
                              completionBlock:completeBlock];
        
        
    }else if(imagePickerController.allowsMultipleSelection) {
        NSArray *mediaInfoArray = (NSArray *)info;
        
        for (NSDictionary *item in mediaInfoArray) {
            
            UIImage *image = [item objectForKey:UIImagePickerControllerOriginalImage];
            UIImage *thumbImage = [item objectForKey:@"UIImagePickerControllerThumbImage"];
            
            [self.images addObject:image];
            [self.thumbImage addObject:thumbImage];
        }
        [self.collectionView reloadData];
    } else {
        
    }
    
    [self.rootViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController{
    [self.rootViewController dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark ViewImageViewControllerDelegate
-(void)onImageDeletedAtIndex:(NSInteger)index{
    [self.images removeObjectAtIndex:index];
    [self.thumbImage removeObjectAtIndex:index];
    [self.collectionView reloadData];
}

@end
