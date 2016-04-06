//
//  AddressContactManager.h
//  TKContactPicker
//
//  Created by gejiangs on 15/6/24.
//  Copyright (c) 2015年 TABKO Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactModel : NSObject

@property (nonatomic, assign)   NSInteger sectionNumber;
@property (nonatomic, assign)   BOOL rowSelected;
@property (nonatomic, copy)     NSString *name;
@property (nonatomic, copy)     NSString *email;
@property (nonatomic, copy)     NSString *tel;
@property (nonatomic, strong)   UIImage *thumbnail;
@property (nonatomic, copy)     NSString *lastName;
@property (nonatomic, copy)     NSString *firstName;

@property (nonatomic, copy)     NSString *firstNamePhonetic;
@property (nonatomic, copy)     NSString *lastNamePhonetic;

@property (nonatomic, strong)   NSArray *telArray;      //所有电话[{key:工作,value:13838389438},......]
@property (nonatomic, strong)   NSArray *emailArray;    //所有Email[{key:email,value:131213@qq.com},......]

- (NSString *)sorterFirstName;
- (NSString *)sorterLastName;

@end

typedef enum{
    AddressBookAuthStatusNotDetermined = 0,
    AddressBookAuthStatusRestricted,
    AddressBookAuthStatusDenied,
    AddressBookAuthStatusAuthorized,
}AddressBookAuthStatus;

@interface AddressBookManager : NSObject

+ (id)sharedManager;

- (void)fetchOnceContacts:(void (^)(NSArray *contacts, NSArray *sectionTitles))success failure:(void (^)(AddressBookAuthStatus status))failure;
- (void)fetchContacts:(void (^)(NSArray *contacts, NSArray *sectionTitles))success failure:(void (^)(AddressBookAuthStatus status))failure;

@end
