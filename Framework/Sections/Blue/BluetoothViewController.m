//
//  BluetoothViewController.m
//  Framework
//
//  Created by gejiangs on 15/8/27.
//  Copyright (c) 2015年 guojiang. All rights reserved.
//

#import "BluetoothViewController.h"
#import "BluetoothManager.h"
#import "BluetoothManager+Category.h"

@interface BluetoothViewController ()

@end

@implementation BluetoothViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[BluetoothManager shareManager] initCentral];
    
    [self addRightBarTitle:@"扫描" target:self action:@selector(startScan)];
}

-(void)startScan
{
    [[BluetoothManager shareManager] startScanBlock:^(NSArray *peripheralArray) {
        self.contentList = [NSMutableArray arrayWithArray:peripheralArray];
        [self.tableView reloadData];
    } finally:^{
        
    }];
}

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
    
    for (UIView *view in cell.contentView.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    
    CBPeripheral *peripheral = [self.contentList objectAtIndex:indexPath.row];
    
    cell.textLabel.text = peripheral.name;
    cell.detailTextLabel.text = [peripheral.identifier UUIDString];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CBPeripheral *peripheral = [self.contentList objectAtIndex:indexPath.row];
    
    [self.view showActivityView:@"正在连接..."];
    
    [[BluetoothManager shareManager] connect:peripheral block:^(BOOL success) {
        [self.view hiddenActivityView];
        if (success) {
            [self.view showActivityView:@"连接成功" hideAfterDelay:1.5];
        }else{
            [self.view showActivityView:@"连接失败" hideAfterDelay:1.5];
        }
    }];
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
