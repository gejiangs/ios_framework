//
//  ViewController.m
//  Framework
//
//  Created by gejiangs on 15/3/31.
//  Copyright (c) 2015年 guojiang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *contentList;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"框架demo";
    
    [self.view addSubview:self.tableView];
    [self.tableView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.contentList = @[@{@"title":@"网络请求", @"class":@"RequestViewController"},
                         @{@"title":@"多图合并视频",@"class":@"ImageConvertVedioViewController"},
                         @{@"title":@"多任务请求",@"class":@"MultiTaskRequestViewController"},
                         @{@"title":@"AutoLayout 动画", @"class":@"AnimateViewController"},
                         @{@"title":@"指示器", @"class":@"HUDViewController"},
                         @{@"title":@"发布朋友圈消息", @"class":@"PublishTopicViewController"},
                         @{@"title":@"省市区级联", @"class":@"AddressViewController"},
                         @{@"title":@"友盟分享", @"class":@"ShareViewController"},
                         @{@"title":@"照片选择", @"class":@"PictureViewController"},
                         @{@"title":@"九宫格解锁", @"class":@"LockViewController"},
                         @{@"title":@"扫一扫", @"class":@"ScanViewController"},
                         @{@"title":@"通讯录", @"class":@"AddressBookViewController"},
                         @{@"title":@"自定义拍照", @"class":@"PhotoViewController"},
                         @{@"title":@"录制短视频", @"class":@"VideoViewController"},
                         @{@"title":@"MJExtension示例",@"class":@"MJExtensionViewController"},
                         @{@"title":@"蓝牙连接",@"class":@"BluetoothViewController"},
                         @{@"title":@"系统设置页面跳转",@"class":@"SystemSettingViewController"}];
}

-(UITableView *)tableView
{
    if (_tableView) {
        return _tableView;
    }
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    return _tableView;
}

#pragma mark UITableView dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.contentList count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ident = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
    }
    
    cell.textLabel.text = [[self.contentList objectAtIndex:indexPath.row] objectForKey:@"title"];
    
    return cell;
}


#pragma mark UITableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *className = [[self.contentList objectAtIndex:indexPath.row] objectForKey:@"class"];
    
    id objClass = [[NSClassFromString(className) alloc] init];
    
    [self.navigationController pushViewController:objClass animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
