//
//  DemoModel.h
//  Framework
//
//  Created by gejiangs on 16/2/17.
//  Copyright © 2016年 guojiang. All rights reserved.
//

#import "BaseModel.h"

@interface DemoModel : BaseModel

@property (nonatomic, copy)     NSString *ID;
@property (nonatomic, copy)     NSString *nowName;
@property (nonatomic, strong)   NSArray *comments;

@end
