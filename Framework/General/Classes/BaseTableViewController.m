//
//  BaseTableViewController.m
//  ZhongLianWuLiu
//
//  Created by gejiangs on 15/6/23.
//  Copyright (c) 2015年 gejiangs. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController ()

@end

@implementation BaseTableViewController

-(id)init
{
    if (self = [super init]) {
        self.contentList = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTableViewStyle:UITableViewStylePlain];
}

-(void)setTableViewStyle:(UITableViewStyle)tableViewStyle
{
    if (self.tableView != nil) {
        [self.tableView removeFromSuperview];
        self.tableView = nil;
    }
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:tableViewStyle];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    [_tableView remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark UITableView Delegate
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
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    self.contentList = nil;
    self.tableView = nil;
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
