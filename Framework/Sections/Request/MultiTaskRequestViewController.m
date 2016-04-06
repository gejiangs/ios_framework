//
//  MultiTaskRequestViewController.m
//  Framework
//
//  Created by gejiangs on 15/3/31.
//  Copyright (c) 2015年 guojiang. All rights reserved.
//

#import "MultiTaskRequestViewController.h"
#import "QQHelper.h"
#import "UIImageView+WebCache.h"
#import "AFHTTPRequestOperation.h"

@interface MultiTaskRequestViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *contentList;
@property (nonatomic, strong) QQHelper *qqHelper;

@end

@implementation MultiTaskRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"多任务网络请求";
    
    
    self.qqHelper = [[QQHelper alloc] init];
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"开始请求"
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(requestQQInfo)];
    self.navigationItem.rightBarButtonItem = rightBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)requestQQInfo
{
    self.contentList = [NSMutableArray array];
    [self.tableView reloadData];
    
    //10个请求
    NSMutableArray *managers = [NSMutableArray array];
    for (int i=0; i<50; i++) {
        NSString *num = [NSString stringWithFormat:@"%d", 21470301+(i*2)];
        
        NSLog(@"haha i:%d==num:%@", i, num);

        //返回请求对象
        RequestManager *manager =   [self.qqHelper getQQInfoWithQQ:num
                                                           success:^(BOOL success, QQModel *model) {
                                                               [self.contentList addObject:model];
                                                               
                                                               [self.tableView reloadData];
                                                               
                                                               NSLog(@"i:%d==num:%@", i, num);
                                                           } failure:^(NSError *error) {
                                                               NSLog(@"error:%@", error);
                                                           }];
        [managers addObject:manager];
    }
    
    //队列请求
    [self.qqHelper requestGroupWithManagers:managers completion:^{
        NSLog(@"所有请求完成");
        [self.view showActivityView:@"所有请求完成" hideAfterDelay:1];
    }];
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ident];
    }
    
    QQModel *model = [self.contentList objectAtIndex:indexPath.row];
    [cell.imageView sd_setImageWithURL:URLFromString(model.faceUrl) placeholderImage:[UIImage imageNamed:@"face"]];
    
    cell.textLabel.text = model.uid;
    cell.detailTextLabel.text = model.mobile_brand;
    
    return cell;
}


- (void)viewWillDisappear:(BOOL)animated
{

    [super viewWillDisappear:animated];
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
