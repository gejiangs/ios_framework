//
//  AddressContactManager.m
//  TKContactPicker
//
//  Created by gejiangs on 15/6/24.
//  Copyright (c) 2015年 TABKO Inc. All rights reserved.
//

#import "AddressBookManager.h"
#import <AddressBook/AddressBook.h>


@implementation ContactModel
MJCodingImplementation

-(id)init
{
    if (self = [super init]) {
        self.telArray = [NSArray array];
        self.emailArray = [NSArray array];
    }
    return self;
}

- (NSString *)sorterFirstName {
    
    if (nil != _firstName && ![_firstName isEqualToString:@""]) {
        return _firstName;
    }
    if (nil != _lastName && ![_lastName isEqualToString:@""]) {
        return _lastName;
    }
    if (nil != _name && ![_name isEqualToString:@""]) {
        return _name;
    }
    return nil;
}

- (NSString *)sorterLastName {
    
    if (nil != _lastName && ![_lastName isEqualToString:@""]) {
        return _lastName;
    }
    if (nil != _firstName && ![_firstName isEqualToString:@""]) {
        return _firstName;
    }
    if (nil != _name && ![_name isEqualToString:@""]) {
        return _name;
    }
    return nil;
}

@end

@interface AddressBookManager ()

@property (nonatomic, strong) NSMutableArray *contactArray;
@property (nonatomic, strong) NSMutableArray *sectionTitles;

@end

@implementation AddressBookManager

+(id)sharedManager
{
    static id _sharedInstance = nil;
    static dispatch_once_t dispatch_one;
    dispatch_once(&dispatch_one, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}

- (void)fetchOnceContacts:(void (^)(NSArray *contacts, NSArray *sectionTitles))success failure:(void (^)(AddressBookAuthStatus status))failure
{
    if (self.contactArray != nil && self.sectionTitles != nil) {
        success(self.contactArray, self.sectionTitles);
    }else{
        [self fetchContacts:success failure:failure];
    }
}

- (void)fetchContacts:(void (^)(NSArray *, NSArray *))success failure:(void (^)(AddressBookAuthStatus))failure
{
    
    CFErrorRef err;

    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &err);

    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined)
    {
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
            
            if (granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self readAddressBookWithBlock:success];
                });
            }else{
                failure((int)ABAddressBookGetAuthorizationStatus());
            }
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self readAddressBookWithBlock:success];
        });
    }
    else
    {
        failure((int)ABAddressBookGetAuthorizationStatus());
    }
    
}

-(void)readAddressBookWithBlock:(void (^)(NSArray *,NSArray *))block
{
    self.sectionTitles = [NSMutableArray array];
    self.contactArray = [NSMutableArray array];
    
    NSMutableArray *contactsTemp = [NSMutableArray array];
    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, nil);
    
    CFArrayRef results = ABAddressBookCopyArrayOfAllPeople(addressBook);
    
    for(int i = 0; i < CFArrayGetCount(results); i++)
    {
        ABRecordRef person = CFArrayGetValueAtIndex(results, i);
        
        if (!person) continue;
        
        
        //获取通讯录名称
        NSString *firstName   = (__bridge NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
        NSString *lastName    = (__bridge NSString*)ABRecordCopyValue(person, kABPersonLastNameProperty);
        NSString *fullName    = (__bridge NSString*)ABRecordCopyCompositeName(person);
        if (fullName == nil) {
            if (lastName != nil) {
                fullName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
            }else{
                fullName = firstName;
            }
        }
        
        //读取firstname拼音音标
        NSString *firstnamePhonetic = (__bridge NSString*)ABRecordCopyValue(person, kABPersonFirstNamePhoneticProperty);
        
        //读取lastname拼音音标
        NSString *lastnamePhonetic = (__bridge NSString*)ABRecordCopyValue(person, kABPersonLastNamePhoneticProperty);
        
        //电话
        NSString *tel = nil;
        
        //邮箱
        NSString *email = nil;
        
        ABPropertyID multiProperties[] = {
            kABPersonPhoneProperty,
            kABPersonEmailProperty
        };
        NSInteger multiPropertiesTotal = sizeof(multiProperties) / sizeof(ABPropertyID);
        for (NSInteger j = 0; j < multiPropertiesTotal; j++) {
            ABPropertyID property = multiProperties[j];
            ABMultiValueRef valuesRef = ABRecordCopyValue(person, property);
            NSInteger valuesCount = 0;
            if (valuesRef != nil) valuesCount = ABMultiValueGetCount(valuesRef);
            
            if (valuesCount == 0) {
                CFRelease(valuesRef);
                continue;
            }
            
            for (NSInteger k = 0; k < valuesCount; k++) {
                CFStringRef value = ABMultiValueCopyValueAtIndex(valuesRef, k);
                switch (j) {
                    case 0: {// Phone number
                        tel = [self telephoneFormatWithTel:(__bridge NSString*)value];
                        break;
                    }
                    case 1: {// Email
                        email = (__bridge NSString*)value;
                        break;
                    }
                }
                CFRelease(value);
            }
            CFRelease(valuesRef);
        }
        
        //获取email多值
        NSMutableArray *emailArray = [NSMutableArray array];
        ABMultiValueRef emailRef = ABRecordCopyValue(person, kABPersonEmailProperty);
        for (int x = 0; x < ABMultiValueGetCount(emailRef); x++)
        {
            //获取email Label
            NSString* emailLabel = (__bridge NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(emailRef, x));
            //获取email值
            NSString* emailContent = (__bridge NSString*)ABMultiValueCopyValueAtIndex(emailRef, x);
            
            [emailArray addObject:@{@"key":emailLabel, @"value":emailContent}];
        }
        
        //读取地址多值
        //ABMultiValueRef address = ABRecordCopyValue(person, kABPersonAddressProperty);
        //int count = ABMultiValueGetCount(address);
        
        
        //读取电话多值
        NSMutableArray *telArray = [NSMutableArray array];
        ABMultiValueRef phoneRef = ABRecordCopyValue(person, kABPersonPhoneProperty);
        for (int k = 0; k<ABMultiValueGetCount(phoneRef); k++)
        {
            //获取电话Label
            NSString * personPhoneLabel = (__bridge NSString*)ABAddressBookCopyLocalizedLabel(ABMultiValueCopyLabelAtIndex(phoneRef, k));
            //获取該Label下的电话值
            NSString * personPhone = (__bridge NSString*)ABMultiValueCopyValueAtIndex(phoneRef, k);
            
            [telArray addObject:@{@"key":personPhoneLabel, @"value":personPhone}];
        }
        
        
        //读取照片
        NSData *image = (__bridge NSData *)ABPersonCopyImageData(person);
        
        ContactModel *model = [[ContactModel alloc] init];
        model.name = fullName;
        model.firstName = firstName;
        model.lastName = lastName;
        model.email = email;
        model.tel = tel;
        model.telArray = [NSArray arrayWithArray:telArray];
        model.emailArray = [NSArray arrayWithArray:emailArray];
        model.thumbnail = [UIImage imageWithData:image];
        model.firstNamePhonetic = firstnamePhonetic;
        model.lastNamePhonetic = lastnamePhonetic;
        
        
        [contactsTemp addObject:model];
        
    }
    
    CFRelease(results);
    CFRelease(addressBook);
    
    //排序
    UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
    
    // Thanks Steph-Fongo!
    
    for (ContactModel *contact in contactsTemp) {
        NSInteger sect = [theCollation sectionForObject:contact
                                collationStringSelector:@selector(name)];
        contact.sectionNumber = sect;
    }
    
    NSInteger highSection = [[theCollation sectionTitles] count];
    NSMutableArray *sectionArrays = [NSMutableArray arrayWithCapacity:highSection];
    for (int i=0; i<=highSection; i++) {
        NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:1];
        [sectionArrays addObject:sectionArray];
    }
    
    for (ContactModel *contact in contactsTemp) {
        [(NSMutableArray *)[sectionArrays objectAtIndex:contact.sectionNumber] addObject:contact];
    }
    
    int  isNilCount = 0;
    for (int i=0; i<[sectionArrays count]; i++) {
        NSMutableArray *sectionArray = [sectionArrays objectAtIndex:i];
        if ([sectionArray count] == 0) {
            continue;
        }
        
        for (ContactModel *addressBook2 in sectionArray) {
            if (addressBook2.name) {
                isNilCount +=0;
            } else {
                isNilCount +=1;
            }
        }
        
        //分组标题
        [self.sectionTitles addObject:[[theCollation sectionTitles] objectAtIndex:i]];
        
        //通讯录
        if (isNilCount >0) {
            [self.contactArray addObject:sectionArray];
        }
        else {
            NSArray *sortedSection = [theCollation sortedArrayFromArray:sectionArray collationStringSelector:@selector(name)];
            [self.contactArray addObject:sortedSection];
        }
    }
    
    block(self.contactArray, self.sectionTitles);
}


- (BOOL)containsStringWithTel:(NSString *)tel str:(NSString *)str
{
    NSRange range = [[tel lowercaseString] rangeOfString:[str lowercaseString]];
    return range.location != NSNotFound;
}

- (NSString *)telephoneFormatWithTel:(NSString *)tel
{
    if ([self containsStringWithTel:tel str:@"-"])
    {
        tel = [tel stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    
    if ([self containsStringWithTel:tel str:@" "])
    {
        tel = [tel stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    
    if ([self containsStringWithTel:tel str:@"("])
    {
        tel = [tel stringByReplacingOccurrencesOfString:@"(" withString:@""];
    }
    
    if ([self containsStringWithTel:tel str:@")"])
    {
        tel = [tel stringByReplacingOccurrencesOfString:@")" withString:@""];
    }
    
    return tel;
}

@end
