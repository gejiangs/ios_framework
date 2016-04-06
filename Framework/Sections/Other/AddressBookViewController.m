//
//  AddressBookViewController.m
//  Framework
//
//  Created by gejiangs on 15/6/24.
//  Copyright (c) 2015年 guojiang. All rights reserved.
//

#import "AddressBookViewController.h"
#import "AddressBookManager.h"

@interface AddressBookViewController ()

@property (nonatomic, strong)   NSArray *sectionTitles;

@end

@implementation AddressBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"通讯录";
    
    [self showAddressBook:nil];
}

-(void)showAddressBook:(id)sender
{
    [self.view showActivityView:@"正在加载通讯录..."];
    
    [[AddressBookManager sharedManager] fetchOnceContacts:^(NSArray *contacts, NSArray *sectionTitles) {
        
        [self.view hiddenActivityView];
        
        self.contentList = [NSMutableArray arrayWithArray:contacts];
        self.sectionTitles = [NSArray arrayWithArray:sectionTitles];
        
        [self.tableView reloadData];
        
    } failure:^(AddressBookAuthStatus status) {
        [self.view hiddenActivityView];
        NSLog(@"status:%d", status);
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sectionTitles count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.contentList objectAtIndex:section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ident = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ident];
    }
    
    ContactModel *model = [[self.contentList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    cell.textLabel.text = model.name;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.sectionTitles objectAtIndex:section];
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.sectionTitles;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    self.sectionTitles = nil;
    self.contentList = nil;
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
