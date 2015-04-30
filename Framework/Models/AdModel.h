//
//  AdModel.h
//  WIFI_LED
//
//  Created by gejiangs on 15/3/11.
//  Copyright (c) 2015年 gejiangs. All rights reserved.
//

#import "BaseModel.h"

@interface AdModel : BaseModel

@property (nonatomic, copy) NSString *ad_provider;
@property (nonatomic, copy) NSString *ad_img_url;
@property (nonatomic, copy) NSString *ad_name;
@property (nonatomic, copy) NSString *ad_content;

//http://m2.qiushibaike.com/ad?AdID=14260582945040F4E3A48F

@end
