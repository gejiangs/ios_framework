//
//  PublishTopicViewController.m
//  Community
//
//  Created by gejiangs on 16/1/29.
//  Copyright © 2016年 gejiangs. All rights reserved.
//

#import "PublishTopicViewController.h"
#import "PlaceholderTextView.h"
#import "PublishImageCell.h"
#import "MBProgressHUD.h"

#define  MAX_UPLOAD_PHOTO_NUM 4

@interface PublishTopicViewController ()<UITextViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong)    PlaceholderTextView *textView;
@property (nonatomic, strong)   NSMutableArray *images;             //图片列表
@property (nonatomic, strong)   UIView *currentEditView;
@property (nonatomic, strong)   PublishImageCell *publishImageCell; //图片cell

@property (nonatomic, strong)   MBProgressHUD *hud;

@end

@implementation PublishTopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"发贴";
    
    [self initUI];
    [self initValues];
}

-(void)initValues
{
    self.images = [NSMutableArray array];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void)initUI
{
//    [self addLeftBarButton:@"取消" target:self action:@selector(leftClicked:)];
    [self addRightBarTitle:@"发送" target:self action:@selector(rightClicked:)];
}

#pragma mark - UIButton Clicked
-(void)leftClicked:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)rightClicked:(UIButton *)sender
{
    [self hideKeyboard];
//    if ([self.textView.text length] <= 0) {
//        [self.view showToastText:@"请输入内容"];
//        return;
//    }
//    if (self.hud == nil) {
//        self.hud = [self.view showActivityView:@""];
//        self.hud.mode = MBProgressHUDModeDeterminate;
//    }
//    
//    self.hud = [self.view showActivityView:@"正在发送..."];
//    self.hud.mode = MBProgressHUDModeDeterminate;
//    
}


#pragma mark - TableView UI -
-(PlaceholderTextView *)textView
{
    if (_textView != nil) {
        return _textView;
    }
    self.textView = [[PlaceholderTextView alloc] init];
    _textView.placeholder = @"写下来跟我们分享吧";
    _textView.layer.borderColor = RGB(213, 213, 213).CGColor;
    _textView.layer.borderWidth = 0.5;
    _textView.layer.cornerRadius = 5.f;
    _textView.layer.masksToBounds = YES;
    _textView.delegate = self;
    _textView.font = [UIFont systemFontOfSize:13.0f];
    
    return _textView;
}

#pragma mark - UITableView Delegate -
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *ident = @"edit_cell";
    if (indexPath.row == 1){
        ident = @"image_cell";
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    if (cell == nil) {
        if (indexPath.row == 0){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ident];
            
            for (UIView *view in cell.contentView.subviews) {
                if ([view isKindOfClass:[PlaceholderTextView class]]) {
                    [view removeFromSuperview];
                }
            }
            
        }else if (indexPath.row == 1){
            cell = [[PublishImageCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ident];
            self.publishImageCell = (PublishImageCell *)cell;
        }
    }
    
    if (indexPath.row == 0){
        
        [cell.contentView addSubview:self.textView];
        
        [_textView makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(10);
            make.left.offset(15);
            make.bottom.offset(-10);
            make.right.offset(-15);
        }];
        
        
    }else if (indexPath.row == 1){
        ((PublishImageCell *)cell).selectedBlock = ^(){
            [self hideKeyboard];
        };
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat h = 60.f;
    if (indexPath.row == 0) {
        h = 170.f;
    }
    return h;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self hideKeyboard];
}


#pragma mark - UITextViewDelegate -
-(void)textViewDidChange:(UITextView *)textView
{
    [self.textView textViewDidChange];
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self hideKeyboard];
}

#pragma mark - KeyBoard Show and Hide
-(void)hideKeyboard
{
    if (self.textView != nil) {
        [self.textView resignFirstResponder];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
