//
//  QQModel.h
//  Framework
//
//  Created by gejiangs on 15/3/31.
//  Copyright (c) 2015年 guojiang. All rights reserved.
//

#import "BaseModel.h"

@interface QQModel : BaseModel

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *mobile_brand;
@property (nonatomic, copy) NSString *hometown;
@property (nonatomic, copy) NSString *faceName;      //此处faceName对应数据字段icon（可参考.m实现）
@property (nonatomic, copy) NSString *faceUrl;

//http://nearby.qiushibaike.com/user/21470301/detail
//{
//    "err" : 0,
//    "userdata" : {
//        "introduce" : "",
//        "location" : "",
//        "login_eday" : 0,
//        "qb_age" : 303,
//        "icon" : "20141008111446.jpg",
//        "astrology" : "",
//        "haunt" : "",
//        "mobile_brand" : "三星 S5830i",
//        "big_cover_eday" : 0,
//        "qs_cnt" : 0,
//        "relationship" : "no_rel",
//        "signature" : "",
//        "job" : "",
//        "bg" : "1",
//        "gender" : "U",
//        "icon_eday" : 0,
//        "uid" : 21470301,
//        "smile_cnt" : 0,
//        "login" : "！男人本色！",
//        "big_cover" : "",
//        "hobby" : "",
//        "age" : 0,
//        "created_at" : 1412709286,
//        "emotion" : "single",
//        "hometown" : ""
//    }
//}
@end
