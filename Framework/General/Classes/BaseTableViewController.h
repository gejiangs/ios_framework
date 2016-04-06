//
//  BaseTableViewController.h
//  ZhongLianWuLiu
//
//  Created by gejiangs on 15/6/23.
//  Copyright (c) 2015年 gejiangs. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseTableViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *contentList;

-(void)setTableViewStyle:(UITableViewStyle)tableViewStyle;

@end
