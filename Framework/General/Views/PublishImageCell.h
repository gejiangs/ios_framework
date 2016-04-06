//
//  PublishImageCell.h
//  ZiYueiM
//
//  Created by gejiangs on 15/7/1.
//  Copyright (c) 2015年 DC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectedBlock)();

@interface PublishImageCell : UITableViewCell

@property (nonatomic, strong)   NSMutableArray *images;             //图片列表
@property (nonatomic, strong)   NSMutableArray *thumbImage;         //缩略图
@property (nonatomic, assign)   NSInteger maxImageNumber;           //最大选择图片
@property (nonatomic, copy)     SelectedBlock selectedBlock;

+(CGFloat)getCellHeightWithImages:(NSArray *)images;

@end
