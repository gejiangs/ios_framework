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
//{
//    "ad_size" : [
//                 612,
//                 300
//                 ],
//    "ad_img_url" : "http:\/\/static.qiushibaike.com\/images\/ads\/mimi_04.png",
//    "ad_name" : "秘密",
//    "ad_download_url" : "https:\/\/itunes.apple.com\/cn\/app\/mi-mi-wu-ye-qiao-qiao-hua\/id455614116?mt=8",
//    "ad_provider" : "本广告由糗事百科提供",
//    "ad_icon_url" : "http:\/\/static.qiushibaike.com\/images\/ads\/mimi_icon.png",
//    "ad_content" : "发现比电视剧更精彩的真实人生，邂逅比你想象更温暖的陌生人。",
//    "ad_star" : 5
//}
@end
