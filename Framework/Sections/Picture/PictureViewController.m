//
//  PictureViewController.m
//  Framework
//
//  Created by jiang on 15/6/2.
//  Copyright (c) 2015年 jiang. All rights reserved.
//

#import "PictureViewController.h"
#import "PictureCollectionCell.h"
#import "QBImagePickerController.h"
#import "BaseNavigationViewController.h"

@interface PictureViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate, QBImagePickerControllerDelegate, UIGestureRecognizerDelegate>
{
    BOOL isEditing;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *contentList;

@end

@implementation PictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择照片";
    
    isEditing = NO;
    self.contentList = [NSMutableArray array];
    
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[PictureCollectionCell class] forCellWithReuseIdentifier:@"cell"];

    [self addRightBarButton:@"添加" target:self action:@selector(rightClicked:)];
}

-(void)rightClicked:(UIBarButtonItem *)sender
{
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:@"拍照", @"从手机相册选择", nil];
    [action showInView:self.view];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

//每个section的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.contentList count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    PictureCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    [cell sizeToFit];
    
    cell.tag = indexPath.row;
    cell.imageView.image = [self.contentList objectAtIndex:indexPath.row];
    
    
    //添加长按删除手势
    UILongPressGestureRecognizer *gest = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(longPress:)];
    gest.delegate = self;
    [cell addGestureRecognizer:gest];
    
    return cell;
}

//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat w = (self.view.frame.size.width - 30)/2;
    CGFloat h = (self.collectionView.frame.size.height - 20)/2;
    
    return CGSizeMake(w, h);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                       layout:(UICollectionViewLayout *)collectionViewLayout
       insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 10, 0, 0);
}

#pragma mark --UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


-(void)deletePicture:(UIButton *)sender
{
    [self.contentList removeObjectAtIndex:sender.tag];
    [self.collectionView reloadData];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //拍照
    if (buttonIndex == 0) {
        if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            [self.view showToastText:@"不支持相机" bottomOffset:60];
            return;
        }
        
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
        picker.delegate = self;
        picker.sourceType = sourceType;
        [self.navigationController presentViewController:picker animated:YES completion:^{
            
        }];//进入照相界面
    }
    //手机相册
    else if (buttonIndex == 1){
        
        QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsMultipleSelection = YES;
        
        BaseNavigationViewController *navigationController = [[BaseNavigationViewController alloc] initWithRootViewController:imagePickerController];
        
        [self presentViewController:navigationController animated:YES completion:NULL];
    }
}


#pragma mark - QBImagePickerControllerDelegate


- (void)imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingMediaWithInfo:(id)info
{
    if ([[imagePickerController class] isSubclassOfClass:[UIImagePickerController class]]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        [self.contentList addObject:image];
        [self.collectionView reloadData];
        
    }else if(imagePickerController.allowsMultipleSelection) {
        NSArray *mediaInfoArray = (NSArray *)info;
        
        for (NSDictionary *item in mediaInfoArray) {
            
            UIImage *image = [item objectForKey:@"UIImagePickerControllerThumbImage"];
            
            [self.contentList addObject:image];
            [self.collectionView reloadData];
        }
        
    } else {
        NSDictionary *mediaInfo = (NSDictionary *)info;
        NSLog(@"Selected: %@", mediaInfo);
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    NSLog(@"Cancelled");
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark 长按手势
-(void)longPress:(UILongPressGestureRecognizer *)gest
{
    if (gest.state == UIGestureRecognizerStateBegan) {
        
        UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"确认删除？"
                                                            delegate:self
                                                   cancelButtonTitle:@"取消"
                                              destructiveButtonTitle:@"删除"
                                                   otherButtonTitles:nil, nil];
        
        [action showInView:self.view completeBlock:^(NSInteger btnIndex) {
            if (btnIndex == 0) {
                [self.contentList removeObjectAtIndex:gest.view.tag];
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:gest.view.tag inSection:0];
                [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
            }
        }];
        
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    NSLog(@"here.....");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
