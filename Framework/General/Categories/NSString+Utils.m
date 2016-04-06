//
//  NSString+Utils.m
//  SanLianOrdering
//
//  Created by guojiang on 14-10-10.
//  Copyright (c) 2014年 DaCheng. All rights reserved.
//

#import "NSString+Utils.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Utils)

//字符串去空格
-(NSString *)stringTrimWhitespace{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


- (BOOL)checkEmpty{
    return [[self stringTrimWhitespace] isEqualToString:@""];
}

#pragma mark --长度宽度相关方法

//方法功能：根据字体大小与限宽，计算高度
-(CGFloat)getHeightWithFontSize:(CGFloat)fontSize maxWidth:(CGFloat)maxWidth
{
    return [self getHeightWithFont:[UIFont systemFontOfSize:fontSize] maxWidth:maxWidth];
}

-(CGFloat)getHeightWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth
{
    return [self getSizeWithFont:font size:CGSizeMake(maxWidth, MAXFLOAT)].height;
}

//方法功能：根据字体大小与限高，计算宽度
-(CGFloat)getWidthWithFontSize:(CGFloat)fontSize maxHeight:(CGFloat)maxHeight
{
    return [self getWidthWithFont:[UIFont systemFontOfSize:fontSize] maxHeight:maxHeight];
}

-(CGFloat)getWidthWithFont:(UIFont *)font maxHeight:(CGFloat)maxHeight
{
    return [self getSizeWithFont:font size:CGSizeMake(MAXFLOAT, maxHeight)].width;
}

-(CGSize)getSizeWithFont:(UIFont *)font size:(CGSize)size
{
    NSDictionary *attribute = @{NSFontAttributeName: font};
    return [self boundingRectWithSize:size
                              options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin
                           attributes:attribute context:nil].size;
}


#pragma mark --时间相关方法
// 方法功能：时间戳
+ (NSString *)getTimeStamp{
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    return timeSp;
}
// 获取格式化时间时间戳
- (NSString *)getTimeStampString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[dateFormatter dateFromString:self];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    return timeSp;
}
//取得格式化时间
-(NSString *)getDateTimeString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:self.longLongValue];
    //用[NSDate date]可以获取系统当前时间
    NSString *dateTimeStr = [dateFormatter stringFromDate:date];
    return dateTimeStr;
}
//取得日期
-(NSString *)getDateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:self.longLongValue];
    //用[NSDate date]可以获取系统当前时间
    NSString *dateStr = [dateFormatter stringFromDate:date];
    return dateStr;
}

// 手机号码隐藏处理(加星号处理)
-(NSString *)securePhoneNumber{
    
    NSString *regular=@"(?<=\\d{3})\\d(?=\\d{4})";
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:regular options:0 error:nil];
    
    NSString *content=self;
    content  = [regularExpression stringByReplacingMatchesInString:content options:0 range:NSMakeRange(0, content.length) withTemplate:@"*"];
    
    return content;
}

// Dictionary 转 Json String
+(NSString *)dictionaryToJsonString:(NSDictionary *)dic;
{
    if (dic==nil) {
        return nil;
    }
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    //NSLog(@"JSON String = %@", jsonString);
    return jsonString;
}

// 十六进制转换为普通字符串的。
- (NSString *)stringFromHexString
{
    NSString *hexString = self;
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    
    return unicodeString;
}

//普通字符串转换为十六进制的。
- (NSString *)hexStringFromString
{
    NSData *myD = [self dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        if([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}


+ (NSString *)fullPinyinWithSystemMethodFromChiniseString:(NSString *)string
{
    if(!string || ![string length]) return nil;
    
    ///
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    CFStringRef aCFString = (__bridge_retained CFStringRef) string ;
    CFMutableStringRef stringRef = CFStringCreateMutableCopy(NULL, 0, aCFString);
    CFRelease(aCFString);
    /// 转成带拼音的 有音调哦
    CFStringTransform(stringRef, NULL, kCFStringTransformToLatin, false);

    /// 去掉音调
    CFStringTransform(stringRef, NULL, kCFStringTransformStripCombiningMarks, false);
    return [[NSString stringWithFormat:@"%@",stringRef] uppercaseString]; /// 这是大写输出  业务需要
}



- (NSString *)md5String{
    
    if(self == nil || [self length] == 0)
        return nil;
    
    const char *value = [self UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (int)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString;
}


//判断是否手机号码
- (BOOL)isTelephone
{
    NSString *MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSString *CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    NSString *CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    NSString *CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    NSString *PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextestphs = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    
    return  [regextestmobile evaluateWithObject:self]   ||
    [regextestcm evaluateWithObject:self]       ||
    [regextestcu evaluateWithObject:self]       ||
    [regextestct evaluateWithObject:self]       ||
    [regextestphs evaluateWithObject:self];
}
@end
