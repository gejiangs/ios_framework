//
//  GFInfoViewController.m
//  Golf
//
//  Created by ztx on 16/7/25.
//  Copyright © 2016年 MiFan. All rights reserved.
//

#import "GFInfoViewController.h"
#import "GFInfoListFrameModel.h"
#import "GFInfoTableViewCellWithButtons.h"
#import "GFInfoModel.h"

#import "GFInfoTableViewCellWithTableView.h"

@interface GFInfoViewController ()

@end

@implementation GFInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    http://e.hiphotos.baidu.com/baike/pic/item/e824b899a9014c08424aed2a087b02087af4f4c8.jpg
//    金泫雅（김현아 ，Kim Hyun A），1992年6月6日出生于韩国首尔，韩国女歌手、主持人、舞者，前女子演唱组合4MINUTE成员
    
    [self setTableViewStyle:UITableViewStyleGrouped];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.contentList = [[NSMutableArray alloc] init];
    for (int  i = 1; i < 10; i++)
    {
        GFInfoListFrameModel *model = [[GFInfoListFrameModel alloc] init];
        
        GFInfoListModel *list = [[GFInfoListModel alloc] init];
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (int j = 0; j< i; j++)
        {
            GFInfoModel *info = [[GFInfoModel alloc] init];
            info.imageURL = @"http://e.hiphotos.baidu.com/baike/pic/item/e824b899a9014c08424aed2a087b02087af4f4c8.jpg";
            info.content = [NSString stringWithFormat:@" %d 金泫雅（김현아 ，Kim Hyun A），1992年6月6日出生于韩国首尔，韩国女歌手、主持人、舞者，前女子演唱组合4MINUTE成员",j];
            [array addObject:info];
        }
        list.infoList = array;
        
        model.infoListModel = list;
        
        [self.contentList addObject:model];
    }
    
    

    

    
    // Do any additional setup after loading the view.
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.contentList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    /// 一个cell 放多个button 有点卡顿
    //    static NSString *cellIdentifier = @"cell";
    //    GFInfoTableViewCell *cell = (GFInfoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    //    if (cell == nil)
    //    {
    //        cell = [[GFInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    //    }
    //
    //    cell.infoListFrameModel = self.contentList[indexPath.row];
    //
    //    [cell setButtonClickBlock:^(GFInfoModel *model) {
    //        NSLog(@"点击了那个model %@",model.content);
    //    }];
    //    return cell;
    //
    
    /// 一个cell 嵌套tableview 比较流畅
    static NSString *cellIdentifier = @"cell";
    GFInfoTableViewCellWithTableView *cell = (GFInfoTableViewCellWithTableView *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[GFInfoTableViewCellWithTableView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.infoListFrameModel = self.contentList[indexPath.row];
    
    
    return cell;
    
    
    
}

#pragma mark -
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GFInfoListFrameModel *frameModel = self.contentList[indexPath.row];
    
    return frameModel.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


@end
