//
//  GFInfoTableViewCellWithTableView.m
//  Framework
//
//  Created by MiFan on 16/7/28.
//  Copyright © 2016年 guojiang. All rights reserved.
//

#import "GFInfoTableViewCellWithTableView.h"
#import "GFFirstTableViewCell.h"
#import "GFOtherTableViewCell.h"




@interface GFInfoTableViewCellWithTableView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end


@implementation GFInfoTableViewCellWithTableView

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self.contentView addSubview:self.tableView];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    self.tableView.frame = CGRectMake(10, 10, ScreenWidth - 20, self.infoListFrameModel.cellHeight - 20);
}


- (void)setInfoListFrameModel:(GFInfoListFrameModel *)infoListFrameModel
{
    _infoListFrameModel = infoListFrameModel;
    [_tableView reloadData];
}




- (UITableView *)tableView
{
    if (_tableView == nil)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.layer.cornerRadius = 5.0f;
        _tableView.layer.masksToBounds = YES;
        _tableView.layer.borderWidth = 1.0f;
        _tableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[GFFirstTableViewCell class] forCellReuseIdentifier:@"GFFirstTableViewCell"];
        [_tableView registerClass:[GFOtherTableViewCell class] forCellReuseIdentifier:@"GFOtherTableViewCell"];

        
    }
    return _tableView;

}


#pragma mark -
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.infoListFrameModel.infoListModel.infoList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        GFFirstTableViewCell *cell = (GFFirstTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"GFFirstTableViewCell" forIndexPath:indexPath];
        cell.infoModel = self.infoListFrameModel.infoListModel.infoList[indexPath.row];
        return cell;

    }
    else{
        GFOtherTableViewCell *cell = (GFOtherTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"GFOtherTableViewCell" forIndexPath:indexPath];
        cell.infoModel = self.infoListFrameModel.infoListModel.infoList[indexPath.row];
        return cell;
 
    }
}



#pragma mark -
#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 120;
    }

    else{
        return 50;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
