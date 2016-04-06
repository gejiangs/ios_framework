//
//  ShareView.m
//  Framework
//
//  Created by gejiangs on 15/5/29.
//  Copyright (c) 2015年 guojiang. All rights reserved.
//

#import "ShareView.h"
#import "QQModel.h"

@implementation ShareView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)joinShopCar:(QQModel *)model
{
    NSString *fileName = [self getDocumentPathWithFileName:@"shopCarList"];
    
    //先获取本地购物车数据
    NSMutableArray *shopCarList = [NSMutableArray arrayWithArray:[self getShopCarList]];
    //将最新加入的放上最上面
    [shopCarList insertObject:model atIndex:0];
    
    //归档
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:shopCarList forKey:@"shopCarList"];
    [archiver finishEncoding];
    
    //写入文件
    [data writeToFile:fileName atomically:YES];
}

-(NSArray *)getShopCarList
{
    NSArray *v = [NSArray array];
    
    NSString *fileName = [self getDocumentPathWithFileName:@"shopCarList"];
    
    NSData *data = [[NSMutableData alloc] initWithContentsOfFile:fileName];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    
    v = [unarchiver decodeObjectForKey:@"shopCarList"];
    [unarchiver finishDecoding];
    
    return v;
}

-(NSString *)getDocumentPathWithFileName:(NSString *)fileName
{
    NSArray *arr = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [arr objectAtIndex:0];
    return  [path stringByAppendingString:fileName];
}

@end
